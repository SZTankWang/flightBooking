from flask import Flask, render_template

app = Flask(__name__)

@app.route('/eFlight')
def Hello():
    return render_template('customerHome.html')

if __name__ == '__main__':
    app.run(debug=True)