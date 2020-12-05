from sqlalchemy import text

from flightBooking import app,db
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
from flightBooking.service import customerService



@app.route('/eFlight')
def Hello():
    print('Hi')
    return render_template('customerHome.html')

@app.route('/eFlight/login/<type>')
def gologin(type):
    return render_template('login.html',type=type)

@app.route('/eFlight/doLogin',methods=['POST'])
def dologin():
    userName = request.form['userName']
    type = request.form['type']
    password = request.form['password']
    result,code = customerService.checkLogin(type,userName,password)
    return jsonify(response=result,code=code)

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
