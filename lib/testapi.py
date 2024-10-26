import requests
import json

# Define the API URL
api_url = 'https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/GetPoll'  # Replace with your actual API URL

# Define the JSON body
data = {
  "institution_short_name": "XIE",
  "phone_number": "9583658818"
}

# Send POST request
try:
    response = requests.post(api_url, json=data)

    # Check if the request was successful
    if response.status_code == 200:
        print("Response JSON:", response.json())
    else:
        print(f"Error: {response.status_code}, Response: {response.text}")

except Exception as e:
    print(f"An error occurred: {e}")
