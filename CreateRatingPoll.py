from flask import Flask, request, render_template_string
import json
import webbrowser

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Institution Data Form</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 8px; margin-bottom: 10px; }
        .section { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; }
        button { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; cursor: pointer; margin: 5px; }
        button:hover { background-color: #45a049; }
        .remove-btn { background-color: #ff4444; }
        .remove-btn:hover { background-color: #cc0000; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Institution Data Form</h2>
        <form method="POST" action="/save">
            <div class="section">
                <h3>Institutions</h3>
                <div id="institutions-container">
                    <div class="form-group institution-group">
                        <label>Institution Short Name:</label>
                        <input type="text" name="institution-0" required>
                        <button type="button" class="remove-btn" onclick="removeInstitution(this)">Remove</button>
                    </div>
                </div>
                <button type="button" onclick="addInstitution()">Add Institution</button>
            </div>

            <div class="section">
                <h3>Persons</h3>
                <div id="persons-container">
                    <div class="person-section">
                        <div class="form-group">
                            <label>Person ID:</label>
                            <input type="text" name="person-0-id" required>
                        </div>
                        <div class="form-group">
                            <label>Person Name:</label>
                            <input type="text" name="person-0-name" required>
                        </div>
                        <div class="form-group">
                            <label>Image URL:</label>
                            <input type="url" name="person-0-image" required>
                        </div>
                        <div class="form-group">
                            <label>Total User Ratings:</label>
                            <input type="number" name="person-0-ratings" required>
                        </div>
                        <div class="form-group">
                            <label>Total Score:</label>
                            <input type="number" name="person-0-score" required>
                        </div>
                        <button type="button" class="remove-btn" onclick="removePerson(this)">Remove Person</button>
                    </div>
                </div>
                <button type="button" onclick="addPerson()">Add Person</button>
            </div>

            <button type="submit">Save JSON</button>
        </form>
    </div>

    <script>
        let institutionCount = 1;
        let personCount = 1;

        function addInstitution() {
            const container = document.getElementById('institutions-container');
            const newGroup = document.createElement('div');
            newGroup.className = 'form-group institution-group';
            newGroup.innerHTML = `
                <label>Institution Short Name:</label>
                <input type="text" name="institution-${institutionCount}" required>
                <button type="button" class="remove-btn" onclick="removeInstitution(this)">Remove</button>
            `;
            container.appendChild(newGroup);
            institutionCount++;
        }

        function removeInstitution(button) {
            if(document.querySelectorAll('.institution-group').length > 1) {
                button.parentElement.remove();
            }
        }

        function addPerson() {
            const container = document.getElementById('persons-container');
            const newSection = document.createElement('div');
            newSection.className = 'person-section';
            newSection.innerHTML = `
                <div class="form-group">
                    <label>Person ID:</label>
                    <input type="text" name="person-${personCount}-id" required>
                </div>
                <div class="form-group">
                    <label>Person Name:</label>
                    <input type="text" name="person-${personCount}-name" required>
                </div>
                <div class="form-group">
                    <label>Image URL:</label>
                    <input type="url" name="person-${personCount}-image" required>
                </div>
                <div class="form-group">
                    <label>Total User Ratings:</label>
                    <input type="number" name="person-${personCount}-ratings" required>
                </div>
                <div class="form-group">
                    <label>Total Score:</label>
                    <input type="number" name="person-${personCount}-score" required>
                </div>
                <button type="button" class="remove-btn" onclick="removePerson(this)">Remove Person</button>
            `;
            container.appendChild(newSection);
            personCount++;
        }

        function removePerson(button) {
            if(document.querySelectorAll('.person-section').length > 1) {
                button.parentElement.remove();
            }
        }
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/save', methods=['POST'])
def save():
    data = {
        "body": {
            "institution_short_names": [],
            "persons": []
        }
    }

    # Collect institutions
    index = 0
    while True:
        institution = request.form.get(f'institution-{index}')
        if not institution:
            break
        data['body']['institution_short_names'].append(institution)
        index += 1

    # Collect persons
    index = 0
    while True:
        person_id = request.form.get(f'person-{index}-id')
        if not person_id:
            break
            
        data['body']['persons'].append({
            "PersonID": person_id,
            "PersonName": request.form[f'person-{index}-name'],
            "PersonImage": request.form[f'person-{index}-image'],
            "TotalUserRatings": int(request.form[f'person-{index}-ratings']),
            "TotalScore": int(request.form[f'person-{index}-score'])
        })
        index += 1

    # Save to JSON file
    with open('data.json', 'w') as f:
        json.dump(data, f, indent=4)

    return "Data saved successfully to data.json!"

if __name__ == '__main__':
    webbrowser.open('http://localhost:5000')
    app.run(debug=False)