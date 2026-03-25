import os
import requests
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from dotenv import load_dotenv

# 1. Load environment variables
load_dotenv()

app = Flask(__name__)

# 2. Database Configuration
# This creates a 'database.db' file in your project folder
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("DATABASE_URL", "sqlite:///database.db")
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# 3. Database Model (The table structure)
class AdviceLog(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(500), nullable=False)
    timestamp = db.Column(db.String(100), nullable=False)

    def __repr__(self):
        return f'<Advice {self.id}>'

# 4. Create Database Tables (Runs at startup)
with app.app_context():
    db.create_all()

# --- ROUTES ---

# HW6 Requirement: Health Check
@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        "status": "healthy",
        "environment": os.getenv("APP_ENV", "development")
    })

# Step 4: GET Endpoint - Fetch advice from external API and save it
@app.route('/api/v1/bot/think', methods=['GET'])
def ai_think():
    api_url = "https://api.adviceslip.com/advice"
    try:
        response = requests.get(api_url)
        if response.status_code == 200:
            data = response.json()
            advice_content = data['slip']['advice']

            # Save to database
            new_log = AdviceLog(
                content=advice_content, 
                timestamp=str(datetime.now())
            )
            db.session.add(new_log)
            db.session.commit()

            return jsonify({
                "bot_response": advice_content,
                "metadata": {
                    "bot_name": "SmartSupport-GPT-v1",
                    "db_entry_id": new_log.id
                }
            })
        
        return jsonify({"error": "External API error"}), response.status_code

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Step 4: POST Endpoint - Manual entry from user
@app.route('/api/v1/notes', methods=['POST'])
def create_note():
    data = request.get_json()

    if not data or 'content' not in data:
        return jsonify({"error": "Missing 'content' field in JSON"}), 400

    new_note = AdviceLog(
        content=data['content'],
        timestamp=str(datetime.now())
    )
    db.session.add(new_note)
    db.session.commit()

    return jsonify({
        "message": "Note saved successfully!",
        "entry_id": new_note.id
    }), 201

# Step 4: GET Endpoint - View all saved history
@app.route('/api/v1/history', methods=['GET'])
def get_history():
    logs = AdviceLog.query.all()
    output = []
    for log in logs:
        output.append({
            "id": log.id,
            "content": log.content,
            "created_at": log.timestamp
        })
    return jsonify({
        "count": len(output),
        "history": output
    })

# 5. Run the app
if __name__ == '__main__':
    app.run(debug=True, port=5000)