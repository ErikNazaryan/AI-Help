# AI-Help
Ai help

🤖 SmartSupport AI Chatbot API
SmartSupport AI is a backend solution designed for startups aiming to automate customer service. This API serves as a bridge to external "intelligence" sources, processing raw data into actionable insights for client-side applications.

🚀 Setup & Installation (macOS)
Follow these steps to get the project running on your local machine:

1. Project Navigation & Environment Setup

Open your Terminal and run the following commands:

Bash
# Navigate to your project directory
cd ~/Desktop/ai_chatbot_flask

# Create a Python virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate
2. Install Dependencies

Ensure you have all the necessary libraries installed:

Bash
pip install -r requirements.txt
3. Configuration (Environment Variables)

Create a file named .env in the root directory and add your configuration:

Code snippet
APP_ENV=development
4. Run the Application

Start the Flask development server:

Bash
python3 app.py
🛠 API Endpoints
Once the server is running, you can test the following endpoints in your browser or via Postman:

Health Check: http://127.0.0.1:5000/health

Purpose: Monitors system uptime, versioning, and environment status.

AI Thought Engine: http://127.0.0.1:5000/api/v1/bot/think

Purpose: Fetches real-time "wisdom" or advice from an external API and processes it with custom logic.

📂 Project Structure
app.py — The core Flask application logic.

.env — Secure configuration file (not to be shared publicly).

venv/ — Isolated Python environment for dependencies.

requirements.txt — List of all required Python packages.

🛡 Research Challenge: Error Handling
This API implements a robust check for external dependencies. It monitors the status_code of outgoing requests. If the external AI service returns anything other than a 200 OK, our backend intercepts the failure and returns a clean 503 Service Unavailable message to the user, preventing system crashes.