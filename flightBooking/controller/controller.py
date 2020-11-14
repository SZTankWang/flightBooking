from flightBooking import app
from flask import render_template


@app.route('/eFlight')
def Hello():
    print('Hi')
    return render_template('customerHome.html')

@app.route('/eFlight/viewFlight')
def viewFlight():
    return render_template('viewFlight.html')
