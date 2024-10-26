import json
from itertools import product

# Sample input data (as provided in the query)
data = {
    "question_1_option_1_text": {"S": "Aarushi"},
    "question_1_option_1_option_score": {"N": "30"},
    "question_1_option_2_text": {"S": "Hiromix"},
    "question_1_option_2_option_score": {"N": "70"},
    
    "question_2_option_1_text": {"S": "Ananya and Sujal"},
    "question_2_option_1_option_score": {"N": "55"},
    "question_2_option_2_text": {"S": "Diya and Gourav"},
    "question_2_option_2_option_score": {"N": "45"},

    "question_3_option_1_text": {"S": "Shivam"},
    "question_3_option_1_option_score": {"N": "50"},
    "question_3_option_2_text": {"S": "Sneha"},
    "question_3_option_2_option_score": {"N": "50"},

    "question_4_option_1_text": {"S": "Sourav"},
    "question_4_option_1_option_score": {"N": "50"},
    "question_4_option_2_text": {"S": "Ayan"},
    "question_4_option_2_option_score": {"N": "50"},

    "question_5_option_1_text": {"S": "Kunal"},
    "question_5_option_1_option_score": {"N": "33"},
    "question_5_option_2_text": {"S": "Parav"},
    "question_5_option_2_option_score": {"N": "67"}
}

# Prepare option texts and scores for each question
questions = []
for i in range(1, 6):
    option_texts = [
        data[f"question_{i}_option_{j}_text"]["S"] for j in range(1, 3)
    ]
    
    option_scores = [
        int(data[f"question_{i}_option_{j}_option_score"]["N"]) for j in range(1, 3)
    ]
    
    questions.append((option_texts, option_scores))

# Generate all combinations of selected options (teams)
teams = []
for choices in product(range(2), repeat=5):  # 0 or 1 for each question
    team_name = []
    total_score = 0
    
    for q_index, choice in enumerate(choices):
        team_name.append(questions[q_index][0][choice])  # Get selected option text
        total_score += questions[q_index][1][choice]   # Add selected option score
    
    teams.append((tuple(team_name), total_score))

# Sort teams by their total scores
sorted_team_scores = sorted(teams, key=lambda x: x[1], reverse=True)

# Rank teams while handling ties
ranked_team_results = []
current_rank = 0
previous_score = None

for idx, (team_name, score) in enumerate(sorted_team_scores):
    if previous_score is None or score < previous_score:
        current_rank += 1  # Increment rank only if score changes
    
    ranked_team_results.append({
        'team': team_name,
        'score': score,
        'rank': current_rank
    })
    
    previous_score = score

# Group teams by their ranks
ranked_output = {}
for result in ranked_team_results:
    rank = result['rank']
    
    if rank not in ranked_output:
        ranked_output[rank] = []
    
    ranked_output[rank].append(result['team'])

# Convert to a list of dictionaries for output
final_ranked_list = [{'rank': rank, 'teams': teams} for rank, teams in ranked_output.items()]

# Limit to top ranks (e.g., top 10 ranks)
top_ranked_results = final_ranked_list[:10]

# Output the rankings
print(json.dumps(top_ranked_results, indent=4))