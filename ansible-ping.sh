#!/bin/bash

echo "--- Testing connectivity to Backend ---"
ansible ai_chatbot_flask-app-1 -i inventory.yml -m ping

echo -e "\n--- Testing connectivity to Database (using raw) ---"
ansible ai_chatbot_flask-db-1 -i inventory.yml -m raw -a "hostname"

echo -e "\n--- Checking Uptime on all containers ---"
ansible all -i inventory.yml -m raw -a "uptime"