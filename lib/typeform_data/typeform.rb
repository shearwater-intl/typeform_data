# frozen_string_literal: true
require 'typeform_data/version'

module TypeformData

  class Typeform
    include TypeformData::ValueClass
    readable_attributes :id, :name

    # TODO: define comparison methods <=>, etc.

    # See https://www.typeform.com/help/data-api/ under "Filtering Options" for the full list of
    # options.
    #
    # The "Ordering Options" are not yet implemented.
    #
    # In general, this method will make multiple HTTP requests to the API in order to fetch all
    # matching responses.
    #
    # Stats and questions are cached across requests. Responses aren't cached, but we plan to add
    # some form of response caching in the future.
    #
    # @param Hash<[String, Symbol], [String, Symbol]> params
    # @raise TypeformData::ArgumentError
    def responses(params = {})
      # TODO: not sure what the implementation will be here, since responses_request needs to
      # handle the awkwardness of returning multiple kinds of data at the same time.
      response = responses_request(collapse_and_validate_responses_params(params))
      set_stats(response['stats']['responses'])

      # It's important that we set the questions first, since the Answer constructor (called
      # inside the Response constructor) looks up and denormalizes the question text.
      set_questions(response['questions'])

      response['responses'].map { |api_hash|
        Response.new(config, api_hash.dup.tap { |hash| hash[:typeform_id] = id }, fields)
      }
    end

    def fields
      @_fields ||= Field.from_questions(config, questions)
    end

    # In general, Typeform's "question" concept is less useful than the field concept. TODO: add
    # more notes on this.
    def questions
      (@_questions ||= fetch_questions).reject(&:hidden_field?)
    end

    def hidden_fields
      (@_questions ||= fetch_questions).select(&:hidden_field?)
    end

    def stats
      @_stats ||= fetch_stats
    end

    def ==(other)
      other.id == id && other.config == config
    end

    def name
      return name if name
      @name ||= client.all_typeforms.find { |typeform| typeform.id == id }.name
    end

    private

    def fetch_questions
      questions = responses_request(limit: 1)['questions'] || []
      questions.map { |hash| Question.new(config, hash) }
    end

    def fetch_stats
      hash = responses_request(limit: 1)['stats']['responses']
      Stats.new(config, hash)
    end

    MAX_PAGE_SIZE = 1000 # This is documented at https://www.typeform.com/help/data-api/.

    ResponsesRequest = Struct.new(:params, :response) do
      # The inverse of 'do we need at least one more request to get all the data we want?'
      # @return Boolean
      def last_request?
        params['limit'] || responses_count < MAX_PAGE_SIZE
      end

      def responses_count
        response.parsed_json['responses'].length
      end
    end

    # It looks like sometimes the Typeform API will report stats that are out-of-date relative to
    # the responses it actually returns. TODO: look into this more.
    def responses_request(input_params = {})
      params = input_params.dup
      requests = [ResponsesRequest.new(params, client.get('form/' + id, params))]

      loop do
        break if requests.last.last_request?
        next_params = requests.last.params.dup
        next_params['offset'] += requests.last.responses_count
        requests << ResponsesRequest.new(next_params, client.get('form/' + id, next_params))
      end

      requests.map(&:response).map(&:parsed_json).reduce do |combined, next_set|
        next_set.dup.tap { |response|
          response['responses'] = combined['responses'] + next_set['responses']
        }
      end
    end

    # rubocop:disable Style/AccessorMethodName
    def set_questions(questions_hashes = [])
      @_questions = questions_hashes.map { |hash| Question.new(config, hash) }
    end

    # @param Hash stats_hash of the form {"responses"=>{"showing"=>2, "total"=>2, "completed"=>0}}
    def set_stats(hash)
      @_stats = Stats.new(config, hash)
    end
    # rubocop:enable Style/AccessorMethodName

    PERMITTED_KEYS = {
      'completed' => Object,
      'since'     => Object,
      'until'     => Object,
      'offset'    => Fixnum,
      'limit'     => Fixnum,
      'token'     => String,
    }.freeze

    def collapse_and_validate_responses_params(input_params)
      params = input_params.dup

      params.keys.select { |key| key.is_a?(Symbol) }.each do |sym|
        raise ::TypeformData::ArgumentError, 'Duplicate keys' if params.key?(sym.to_s)
        params[sym.to_s] = params[sym]
        params.delete(sym)
      end

      params.keys.each do |key|
        next if PERMITTED_KEYS.key?(key) && params[key].is_a?(PERMITTED_KEYS[key])
        raise ::TypeformData::ArgumentError, "Invalid/unsupported param: #{key}"
      end

      if params['limit'] && params['limit'] > MAX_PAGE_SIZE
        raise ::TypeformData::ArgumentError, "The maximum limit is #{MAX_PAGE_SIZE}. You "\
          "provided: #{params['limit']}"
      end

      params['offset'] ||= 0
      params
    end

  end
end
