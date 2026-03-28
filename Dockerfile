
FROM python:3.9-slim

#Creating a working folder inside a container
WORKDIR /app

# Copying requirements.txt and installing the libraries
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project code
COPY . .

# We tell Docker that we will work on port 5000
EXPOSE 5000

# Command to connect the server
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]