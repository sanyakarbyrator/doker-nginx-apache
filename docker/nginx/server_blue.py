from flask import Flask

app = Flask(__name__)

@app.route('/balans')
def blue_page():
    return "<html><body style='background-color:blue;'><h1>Blue Page</h1></body></html>"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8081)

