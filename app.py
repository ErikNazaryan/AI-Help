from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World'

@app.route('/development')
def development():
    return 'development'

if __name__ == '__main__':
    app.run()