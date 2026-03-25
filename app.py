from flask import Flask, jsonify
import os
import requests

# TODO: Initialize SQLite database for storing user chat history
# This will be implemented in the next phase of the roadmap.

from dotenv import load_dotenv

# 1. Load environment variables from .env
load_dotenv()

app = Flask(__name__)

# 2. Basic config
APP_ENV = os.getenv("APP_ENV", "development")

# 3. First route: Health Check
@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        "status": "healthy",
        "environment": APP_ENV
    })

# 4. SECOND ROUTE: The Data Engine 
@app.route('/api/v1/bot/think', methods=['GET'])
def ai_think():
    api_url = "https://api.adviceslip.com/advice"
    
    # Try to fetch data
    response = requests.get(api_url)

    # Research Challenge: Check if the API is up
    if response.status_code != 200:
        return jsonify({
            "error": "The AI model is currently offline.",
            "status_code": response.status_code
        }), 503

    # Parse JSON
    data = response.json()
    advice_content = data['slip']['advice']
    
    # Return customized JSON
    return jsonify({
        "bot_response": advice_content,
        "metadata": {
            "bot_name": "SmartSupport-GPT-v1",
            "status": "success"
        }
    })

# 5. Run the app
if __name__ == '__main__':
    app.run(debug=True, port=5000)