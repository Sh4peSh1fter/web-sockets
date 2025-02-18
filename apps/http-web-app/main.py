from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'this is an http web app (using flask)'

@app.route('/health')
def health():
    return {}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT')))
