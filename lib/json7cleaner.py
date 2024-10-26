import json

def visualize_json(data, output_file, indent=0):
    """
    Recursively visualize the structure of JSON data and save to a file.
    This function handles dictionaries, lists, and values to print them in a tree format.
    """
    space = " " * (indent * 4)  # 4 spaces per indent level
    
    with open(output_file, 'a') as f:
        if isinstance(data, dict):
            # For each key in the dictionary, print key and visualize the value
            for key, value in data.items():
                f.write(f"{space}{key}:\n")
                visualize_json(value, output_file, indent + 1)
        elif isinstance(data, list):
            # For each item in the list, recursively visualize it
            for i, item in enumerate(data):
                f.write(f"{space}[{i}]:\n")
                visualize_json(item, output_file, indent + 1)
        else:
            # For primitive values (strings, numbers, etc.), just print them with proper indentation
            f.write(f"{space}{data}\n")

def load_and_visualize_json(input_file, output_file):
    """Load the JSON file and visualize its structure."""
    # Clear the output file if it exists from a previous run
    with open(output_file, 'w') as f:
        pass  # This clears the file contents

    with open(input_file, 'r') as json_file:
        data = json.load(json_file)
        
        # Check if 'body' contains stringified JSON
        if isinstance(data.get("body"), str):
            try:
                # Attempt to parse the stringified JSON within "body"
                data["body"] = json.loads(data["body"])
            except json.JSONDecodeError:
                print("Error: Could not parse the 'body' field.")
        
        visualize_json(data, output_file)

# Example usage
input_file = r'D:\Collegefantasy_flutter-main\lib\unorganized_data.json'
output_file = 'D:/Collegefantasy_flutter-main/lib/cleaned_data.json'  

load_and_visualize_json(input_file, output_file)

print(f"Structured JSON visualization saved to {output_file}")
