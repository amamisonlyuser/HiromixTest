import json

# Sample JSON data
json_data = '''
{
  "PK": {"S": "Poll#a3fc8854-ee8e-4f48-bc2d-5997640ec37c"},
  "SK": {"S": "Institution#XIE"},
  "creation_date": {"S": "2024-09-17T20:31:19.605367"},
  "end_date": {"S": "2024-09-18T20:31:19.605371"},
  "end_time": {"S": "2024-09-18T20:31:19.605343"},
  "poll_id": {"S": "a3fc8854-ee8e-4f48-bc2d-5997640ec37c"},
  "Poll_status": {"S": "live"},
  "question_1": {"S": "Radiates natural confidence?"},
  "question_1_option_1_id": {"S": "8977bcc4-eee0-49bb-8a5a-5c9f171c3962"},
  "question_1_option_1_image": {"S": "assets/girl1.png"},
  "question_1_option_1_option_score": {"N": "30"},
  "question_1_option_1_text": {"S": "Aarushi"},
  "question_1_option_2_id": {"S": "5116ec79-5510-47d5-ab90-4b5be6d7f1a4"},
  "question_1_option_2_image": {"S": "assets/Hiromix.png"},
  "question_1_option_2_option_score": {"N": "70"},
  "question_1_option_2_text": {"S": "Hiromix"},
  "question_2": {"S": "Sweetest couple on campus"},
  "question_2_option_1_id": {"S": "a823c41e-14ac-4fe6-9da6-f4a192d07dcc"},
  "question_2_option_1_image": {"S": "assets/couple1.png"},
  "question_2_option_1_option_score": {"N": "55"},
  "question_2_option_1_text": {"S": "Ananya and Sujal"},
  "question_2_option_2_id": {"S": "0dd32ebf-31c7-4761-820c-213f07d1f655"},
  "question_2_option_2_image": {"S": "assets/couple2.png"},
  "question_2_option_2_option_score": {"N": "45"},
  "question_2_option_2_text": {"S": "Diya and Gourav"},
  "question_3": {"S": "Title of the best person goes to?"},
  "question_3_option_1_id": {"S": "0b2e8113-7c8e-4a3a-a493-0147e7024b5f"},
  "question_3_option_1_image": {"S": "assets/boy1.png"},
  "question_3_option_1_option_score": {"N": "50"},
  "question_3_option_1_text": {"S": "Shivam"},
  "question_3_option_2_id": {"S": "524b45e0-87ad-40da-85b7-f7b35a87f463"},
  "question_3_option_2_image": {"S": "assets/girl10.png"},
  "question_3_option_2_option_score": {"N": "50"},
  "question_3_option_2_text": {"S": "Sneha"},
  "question_4": {"S": "Have a cool vibe?"},
  "question_4_option_1_id": {"S": "f7d408e4-7b75-4ae4-a80b-0adf80ba4ee3"},
  "question_4_option_1_image": {"S": "assets/boy3.png"},
  "question_4_option_1_option_score": {"N": "50"},
  "question_4_option_1_text": {"S": "Sourav"},
  "question_4_option_2_id": {"S": "50881589-d52d-4775-9d56-451f46dd0aeb"},
  "question_4_option_2_image": {"S": "assets/boy4.png"},
  "question_4_option_2_option_score": {"N": "50"},
  "question_4_option_2_text": {"S": "Ayan"},
  "question_5": {"S": "Makes everyone laugh?"},
  "question_5_option_1_id": {"S": "0737337e-c0dd-49a4-9f97-6149961c5c0b"},
  "question_5_option_1_image": {"S": "assets/boy7.png"},
  "question_5_option_1_option_score": {"N": "33"},
  "question_5_option_1_text": {"S": "Kunal"},
  "question_5_option_2_id": {"S": "73b7a925-8811-49e6-ae00-093f3ee7140a"},
  "question_5_option_2_image": {"S": "assets/boy8.png"},
  "question_5_option_2_option_score": {"N": "67"},
  "question_5_option_2_text": {"S": "Parav"}
}
'''

# Load JSON data
data = json.loads(json_data)

def get_option_score(option_id):
    for key, value in data.items():
        if key.endswith('_id') and value['S'] == option_id:
            # Construct the key for the option score
            score_key = key.replace('_id', '_option_score')
            if score_key in data:
                # Extract and return the score
                return int(data[score_key]['N'])
    return None
def extract_option_scores(poll_data):
    option_scores = {}
    for key, value in poll_data.items():
        print(f"Processing key: {key}, value: {value}")
        if key.endswith('_id') and isinstance(value, dict):
            option_id = value.get('S')
            if option_id:
                score = get_option_score(option_id, poll_data)
                if score is not None:
                    option_scores[option_id] = score
    return option_scores
# Example usage
option_id = "73b7a925-8811-49e6-ae00-093f3ee7140a"
score = get_option_score(option_id)
print(f"The score for option ID '{option_id}' is: {score}")
