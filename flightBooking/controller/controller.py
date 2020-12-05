from flightBooking import app
import collections
from datetime import timedelta
from itertools import count
from time import strftime
from flask import Flask, render_template, redirect, url_for, request, json, jsonify, session, flash, make_response
from flask.signals import appcontext_tearing_down
from flask_login.utils import logout_user
from flask_login import login_user, logout_user, current_user, login_required
from numpy.core.arrayprint import TimedeltaFormat
from numpy.lib.function_base import select
from sqlalchemy.util.langhelpers import methods_equivalent




@app.route('/eFlight')
def Hello():
    print('Hi')
    return render_template('customerHome.html')

@app.route('/eFlight/gologin')
def gologin():
    return render_template('login.html')

@app.route('/eFlight/dologin/<type>')
def dologin(type):
    id = request.form['id']
    password = request.form['password']
    db.session.execute(text("set @msg = '0'"))
    db.session.execute(text("CALL eflight.login_check(:p1,:p2,:p3,@msg)"),{"p1":type,"p2":id,"p3":password})
    result = db.session.execute(text("select @msg")).fetchone()
    return result

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
