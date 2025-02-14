from flask import Flask, request, render_template_string, jsonify
import json
import webbrowser
from threading import Timer

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Poll Creator</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .section { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; }
        input[type="text"], input[type="url"] { width: 100%; padding: 8px; margin-bottom: 10px; }
        button { background-color: #4CAF50; color: white; padding: 8px 15px; border: none; cursor: pointer; margin: 5px; }
        button.remove-btn { background-color: #ff4444; }
        .poll-section { margin-bottom: 20px; border: 1px solid #ccc; padding: 10px; }
        .option-section { margin-left: 20px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Poll Creator</h1>
        <form method="POST" action="/save">
            <div class="section">
                <h3>Institution</h3>
                <input type="text" name="institution" placeholder="Institution Short Name" required>
            </div>

            <div id="polls-container">
                <div class="poll-section" data-poll-index="0">
                    <h3>Poll #1</h3>
                    <input type="text" name="poll-question-0" placeholder="Poll Question" required>
                    
                    <div class="options-container">
                        <div class="option-section" data-option-index="0">
                            <input type="text" name="poll-option-text-0-0" placeholder="Option Text" required>
                            <input type="url" name="poll-option-image-0-0" placeholder="Image URL" required>
                            <button type="button" class="remove-btn" onclick="removeOption(this)">Remove Option</button>
                        </div>
                    </div>
                    <button type="button" onclick="addOption(this)">Add Option</button>
                </div>
            </div>

            <button type="button" onclick="addPoll()">Add Poll</button>
            <button type="submit">Save JSON</button>
        </form>
    </div>

    <script>
        let pollCount = 1;
        let optionCounts = {0: 1};

        function addPoll() {
            const container = document.getElementById('polls-container');
            const newPoll = document.createElement('div');
            newPoll.className = 'poll-section';
            newPoll.dataset.pollIndex = pollCount;
            newPoll.innerHTML = `
                <h3>Poll #${pollCount + 1}</h3>
                <input type="text" name="poll-question-${pollCount}" placeholder="Poll Question" required>
                
                <div class="options-container">
                    <div class="option-section" data-option-index="0">
                        <input type="text" name="poll-option-text-${pollCount}-0" placeholder="Option Text" required>
                        <input type="url" name="poll-option-image-${pollCount}-0" placeholder="Image URL" required>
                        <button type="button" class="remove-btn" onclick="removeOption(this)">Remove Option</button>
                    </div>
                </div>
                <button type="button" onclick="addOption(this)">Add Option</button>
            `;
            container.appendChild(newPoll);
            optionCounts[pollCount] = 1;
            pollCount++;
        }

        function addOption(button) {
            const pollSection = button.closest('.poll-section');
            const pollIndex = pollSection.dataset.pollIndex;
            const optionsContainer = pollSection.querySelector('.options-container');
            
            const newOption = document.createElement('div');
            newOption.className = 'option-section';
            newOption.dataset.optionIndex = optionCounts[pollIndex];
            newOption.innerHTML = `
                <input type="text" name="poll-option-text-${pollIndex}-${optionCounts[pollIndex]}" placeholder="Option Text" required>
                <input type="url" name="poll-option-image-${pollIndex}-${optionCounts[pollIndex]}" placeholder="Image URL" required>
                <button type="button" class="remove-btn" onclick="removeOption(this)">Remove Option</button>
            `;
            optionsContainer.appendChild(newOption);
            optionCounts[pollIndex]++;
        }

        function removeOption(button) {
            const optionSection = button.closest('.option-section');
            if (optionSection) {
                optionSection.remove();
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
    try:
        data = {
            "institution_short_name": request.form['institution'],
            "poll_data": []
        }

        # Get all poll questions
        poll_questions = [v for k, v in request.form.items() if k.startswith('poll-question-')]
        
        for poll_index, question in enumerate(poll_questions):
            poll = {
                "question": question,
                "options": []
            }

            # Get all options for this poll
            option_texts = [v for k, v in request.form.items() 
                          if k.startswith(f'poll-option-text-{poll_index}-')]
            option_images = [v for k, v in request.form.items() 
                           if k.startswith(f'poll-option-image-{poll_index}-')]

            for text, image in zip(option_texts, option_images):
                poll['options'].append({
                    "text": text,
                    "image": image
                })

            data['poll_data'].append(poll)

        # Save to JSON file
        with open('polls.json', 'w') as f:
            json.dump(data, f, indent=4)

        return jsonify({
            "status": "success",
            "message": "JSON saved successfully!",
            "file": "polls.json"
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

def open_browser():
    webbrowser.open_new('http://localhost:5000/')

if __name__ == '__main__':
    Timer(1, open_browser).start()
    app.run(debug=False)