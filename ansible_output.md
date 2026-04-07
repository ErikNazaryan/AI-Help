--- Testing connectivity to Backend ---
ai_chatbot_flask-app-1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/local/bin/python3.9"
    },
    "changed": false,
    "ping": "pong"
}

--- Testing connectivity to Database (using raw) ---
ai_chatbot_flask-db-1 | CHANGED | rc=0 >>
5234351d7236


--- Checking Uptime on all containers ---
ai_chatbot_flask-app-1 | FAILED | rc=127 >>
/bin/sh: 1: uptime: not found
non-zero return code
ai_chatbot_flask-db-1 | CHANGED | rc=0 >>
 20:42:26 up 18 min,  0 users,  load average: 0.05, 0.05, 0.01

