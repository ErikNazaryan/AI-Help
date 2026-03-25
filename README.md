# AI-Help Chatbot API 🤖

This is a Flask-based REST API that provides AI-generated advice and stores interaction history in a SQLite database.

## 🚀 Features

- **Health Check**: Monitor the API status.
- **AI Advice Engine**: Fetches real-time advice from an external API.
- **Database Logging**: Automatically saves every AI response with a timestamp.
- **CRUD Endpoints**: 
  - `POST`: Manually add notes to the database.
  - `GET`: View the entire history of saved advice and notes.

## 🛠 Tech Stack

- **Python 3.9+**
- **Flask** (Web Framework)
- **Flask-SQLAlchemy** (ORM for SQLite)
- **Requests** (External API calls)
- **Dotenv** (Environment variables)

## 📦 Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/ErikNazaryan/AI-Help.git](https://github.com/ErikNazaryan/AI-Help.git)
   cd AI-Help