import os
import requests
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from dotenv import load_dotenv

# 1. Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# 2. Database Configuration
# This will create a file named 'database.db' in your project folder
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

# 4. Create Database Tables
# This runs once to ensure the .db file and tables exist
with app.app_context():
    db.create_all()

# 5. ROUTES

@app.route('/health', methods=['GET'])
def health():
    """Basic health check route"""
    return jsonify({
        "status": "healthy",
        "environment": os.getenv("APP_ENV", "development")
    })

@app.route('/api/v1/bot/think', methods=['GET'])
def ai_think():
    """
    Step 4 & 3 combined: 
    1. Fetches data from external API
    2. Checks status code (Research Challenge)
    3. Saves the data into SQLite Database
    4. Returns a custom JSON response
    """
    api_url = "https://api.adviceslip.com/advice"
    
    try:
        # Fetching data from the public API
        response = requests.get(api_url)

        # Research Challenge: Error handling if the external API is down
        if response.status_code != 200:
            return jsonify({
                "error": "The AI model is currently offline.",
                "status_code": response.status_code
            }), 503

        # Parsing the JSON response
        data = response.json()
        advice_content = data['slip']['advice']
        
        # --- DATABASE LOGIC: Saving the result ---
        # Create a new row for our database table
        new_log = AdviceLog(
            content=advice_content, 
            timestamp=str(datetime.now())
        )
        
        # Add to session and commit to save permanently
        db.session.add(new_log)
        db.session.commit()

        # Returning the final customized JSON to the user
        return jsonify({
            "bot_response": advice_content,
            "metadata": {
                "bot_name": "SmartSupport-GPT-v1",
                "status": "success",
                "db_entry_id": new_log.id  # This confirms it's saved in DB
            }
        })

    except Exception as e:
        # General error handling (e.g., no internet or DB issues)
        return jsonify({"error": str(e)}), 500

# 6. Run the Flask application
if __name__ == '__main__':
    app.run(debug=True, port=5000)