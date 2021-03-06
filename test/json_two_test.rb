# frozen_string_literal: true
require 'test_helper'

TEST_JSON_TWO = JSON.parse(<<-TEST_JSON_STRING_TWO
{
  "http_status": 200,
  "stats": {
    "responses": {
      "showing": 4,
      "total": 4,
      "completed": 4
    }
  },
  "questions": [
    {
      "id": "list_s9XJ_choice_V0ry",
      "question": "Required: What type of group is your organization?",
      "field_id": 45281507
    },
    {
      "id": "list_s9XJ_choice_asCn",
      "question": "Required: What type of group is your organization?",
      "field_id": 45281507
    },
    {
      "id": "list_s9XJ_choice_aS3W",
      "question": "Required: What type of group is your organization?",
      "field_id": 45281507
    },
    {
      "id": "list_s9XJ_other",
      "question": "Required: What type of group is your organization?",
      "field_id": 45281507
    },
    {
      "id": "list_45281545_choice_57415657",
      "question": "Non-Required: What type of group is your organization?",
      "field_id": 45281545
    },
    {
      "id": "list_45281545_choice_57415658",
      "question": "Non-Required: What type of group is your organization?",
      "field_id": 45281545
    },
    {
      "id": "list_45281545_choice_57415659",
      "question": "Non-Required: What type of group is your organization?",
      "field_id": 45281545
    },
    {
      "id": "list_45281545_other",
      "question": "Non-Required: What type of group is your organization?",
      "field_id": 45281545
    }
  ],
  "responses": [
    {
      "completed": "1",
      "token": "22b6616eac4f3a26a7d4490d879c3cf0",
      "metadata": {
        "browser": "default",
        "platform": "other",
        "date_land": "2017-03-08 20:38:36",
        "date_submit": "2017-03-08 20:39:33",
        "user_agent": "Mozilla\/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/56.0.2924.87 Safari\/537.36",
        "referer": "https:\/\/devteam4.typeform.com\/to\/HEv9qr",
        "network_id": "94c4386d47"
      },
      "hidden": [

      ],
      "answers": {
        "list_s9XJ_choice_V0ry": "RSO",
        "list_s9XJ_choice_asCn": "Student Government"
      }
    },
    {
      "completed": "1",
      "token": "a89344df85f5412275ca23035da95dad",
      "metadata": {
        "browser": "default",
        "platform": "other",
        "date_land": "2017-03-08 20:40:09",
        "date_submit": "2017-03-08 20:40:22",
        "user_agent": "Mozilla\/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/56.0.2924.87 Safari\/537.36",
        "referer": "https:\/\/devteam4.typeform.com\/to\/HEv9qr",
        "network_id": "94c4386d47"
      },
      "hidden": [

      ],
      "answers": {
        "list_s9XJ_choice_V0ry": "RSO",
        "list_s9XJ_choice_aS3W": "University Department or Program",
        "list_s9XJ_other": "Other Test"
      }
    },
    {
      "completed": "1",
      "token": "b508fe9762ab6f93efad190e1e890870",
      "metadata": {
        "browser": "default",
        "platform": "other",
        "date_land": "2017-03-08 20:41:07",
        "date_submit": "2017-03-08 20:41:16",
        "user_agent": "Mozilla\/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/56.0.2924.87 Safari\/537.36",
        "referer": "https:\/\/devteam4.typeform.com\/to\/HEv9qr",
        "network_id": "94c4386d47"
      },
      "hidden": [

      ],
      "answers": {
        "list_s9XJ_other": "Other Test"
      }
    },
    {
      "completed": "1",
      "token": "aac0808e3c9c20edef5efc880ef86db0",
      "metadata": {
        "browser": "default",
        "platform": "other",
        "date_land": "2017-03-08 20:42:02",
        "date_submit": "2017-03-08 20:42:50",
        "user_agent": "Mozilla\/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/56.0.2924.87 Safari\/537.36",
        "referer": "https:\/\/devteam4.typeform.com\/to\/HEv9qr",
        "network_id": "94c4386d47"
      },
      "hidden": [

      ],
      "answers": {
        "list_s9XJ_choice_V0ry": "RSO",
        "list_s9XJ_choice_asCn": "Student Government",
        "list_s9XJ_other": "I chose A and B, but also want other",
        "list_45281545_other": "This one definitely has an other"
      }
    }
  ]
}
TEST_JSON_STRING_TWO
)

class JsonTwoTest < ObjectGraphTest

  def json
    TEST_JSON_TWO
  end

  def test_object_graph
    assert_object_graph
    assert_that_our_api_key_is_not_serialized
  end

end
