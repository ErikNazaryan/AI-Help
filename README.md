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

feature/dockerization
   ## Docker Optimization

### Build History
Below is the output of the `docker history` command showing the layer structure:



```text
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
6c628d81a202   25 minutes ago   CMD ["flask" "run" "--host=0.0.0.0" "--port=…   0B        buildkit.dockerfile.v0
<missing>      25 minutes ago   EXPOSE [5000/tcp]                               0B        buildkit.dockerfile.v0
<missing>      25 minutes ago   COPY . . # buildkit                             11.8MB    buildkit.dockerfile.v0
<missing>      27 minutes ago   RUN /bin/sh -c pip install --no-cache-dir -r…   44.2MB    buildkit.dockerfile.v0
<missing>      27 minutes ago   COPY requirements.txt . # buildkit              12.3kB    buildkit.dockerfile.v0
<missing>      24 hours ago     WORKDIR /app                                    8.19kB    buildkit.dockerfile.v0





## 🏗 Production Architecture Summary

This project has been migrated to a professional client-server architecture using Docker Compose. The stack consists of three orchestrated containers:

1.  **Nginx (Reverse Proxy):** Acts as the entry point, listening on port `80` and forwarding traffic to the API.
2.  **Flask API (App):** The core logic of Project Genesis, now optimized using a multi-stage Docker build to reduce image size.
3.  **PostgreSQL (Database):** A persistent relational database engine that replaces the local SQLite file for production-grade data management.

**Traffic Flow:**
`User Request (Port 80)` ➔ `Nginx Proxy` ➔ `Flask Application (Port 5000)` ➔ `PostgreSQL Database (Port 5432)`



## 🚀 Run Instructions

To get the entire production stack up and running locally, follow these steps:

### 1. Clone the Repository
```bash
git clone [https://github.com/ErikNazaryan/AI-Help.git](https://github.com/ErikNazaryan/AI-Help.git)
cd AI-Help



   ## Docker Support

This project is containerized using Docker. You can pull the image from Docker Hub and run it locally.

### Pull the Image
```bash
docker pull eriknazaryan/project-genesis:v1

http://localhost:8080/health
docker run -p 8080:5000 eriknazaryan/project-genesis:v1


