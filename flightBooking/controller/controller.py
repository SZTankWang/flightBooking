from flightBooking import app
from flask import render_template





@app.route('/eFlight')
def Hello():
    print('Hi')
    return render_template('customerHome.html')

@app.route('/eFlight/login/<type>')
def login(type):
    return render_template('login.html',type=type)

@app.route('/eFlight/register/<type>')
def register(type):
        if type == 'agent':
            ''' 查询系统记录中的airline name, 放入 airline_names 变量中
            ''' 
        return render_template('register.html',type=type, airline_name=None)

@app.route('/eFlight/viewFlight')
def viewFlight():
    return render_template('viewFlight.html')


@app.route('/eFlight/confirmOrder')
def confirmOrder():
    return render_template('confirmOrder.html')