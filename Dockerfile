# Stage 1: Build stage
FROM python:3.9-slim AS builder
WORKDIR /app
COPY requirements.txt .
# Install build dependencies to a temporary location
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime stage
FROM python:3.9-slim
WORKDIR /app
# Copy only the necessary dependencies from the builder stage
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure the installed binaries are in the PATH
ENV PATH=/root/.local/bin:$PATH
ENV FLASK_APP=app.py

# Run the Flask application
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]