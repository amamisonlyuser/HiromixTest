import base64
import json
import requests
import os

# 🖼️ Path to your image
image_path = r"D:\hiromixtest\assets\boy2.png"
output_txt_path = r"D:\hiromixtest\assets\image_data_uri.txt"  # Output file

# 🌍 Lambda API URL (Update this with your API Gateway URL)
LAMBDA_URL = "https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/HiromixAIImage"

def get_mime_type(file_path):
    """Returns the correct MIME type based on file extension."""
    ext = file_path.lower().split(".")[-1]
    return {
        "jpg": "image/jpeg",
        "jpeg": "image/jpeg",
        "png": "image/png",
        "webp": "image/webp"
    }.get(ext, "application/octet-stream")  # Default to binary stream

def generate_base64_uri(image_path):
    """Converts an image to a Base64 Data URI."""
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"❌ Image not found: {image_path}")

    mime_type = get_mime_type(image_path)

    with open(image_path, "rb") as file:
        data = base64.b64encode(file.read()).decode("utf-8")

    return f"data:{mime_type};base64,{data}"

def save_data_uri_to_file(data_uri, output_path):
    """Saves the Data URI to a text file."""
    with open(output_path, "w") as text_file:
        text_file.write(data_uri)
    print(f"✅ Data URI saved to: {output_path}")

def test_lambda_request(data_uri):
    """Sends a request to your AWS Lambda function for testing."""
    headers = {"Content-Type": "application/json"}
    payload = json.dumps({"image_data": data_uri})

    try:
        response = requests.post(LAMBDA_URL, headers=headers, data=payload)
        response_data = response.json()

        if response.status_code == 200:
            print(f"✅ Upscaled Image URL: {response_data.get('upscaled_image_url', 'No URL returned')}")
        else:
            print(f"❌ Lambda Error ({response.status_code}): {response_data}")

    except Exception as e:
        print(f"🚨 Request Error: {e}")

if __name__ == "__main__":
    # 🔄 Convert image to Base64 URI
    data_uri = generate_base64_uri(image_path)

    # 💾 Save Data URI to a text file
    save_data_uri_to_file(data_uri, output_txt_path)

    # 🚀 Test sending request to Lambda
    test_lambda_request(data_uri)
