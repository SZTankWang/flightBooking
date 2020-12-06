from sqlalchemy import text

from flightBooking import app,db
import collections
from datetime import timedelta
from itertools import count
from time import strftime
from flask import Flask, render_template, redirect, url_for, request, json, jsonify, session, flash, make_response
from flask.signals import appcontext_tearing_down
from flask_login.utils import logout_user
from numpy.core.arrayprint import TimedeltaFormat
from numpy.lib.function_base import select
from sqlalchemy.util.langhelpers import methods_equivalent
from flightBooking.service import customerService


@app.route('/eFlight/home/<type>')
def renderHome(type):
    a = session.get('username')
    try:
        userName = session.get('username')
        if type == 'customer':
            return render_template('customerHome.html',username=userName)
    except:
        return render_template('customerHome.html')

@app.route('/eFlight/publicInfo')
def publicInfo():
    return render_template('publicInfo.html')


@app.route('/eFlight/login/<type>')
def gologin(type):
    return render_template('login.html',type=type)

@app.route('/eFlight/doLogin',methods=['POST'])
def dologin():
    userName = request.form['userName']
    type = request.form['type']
    password = request.form['password']
    result,code = customerService.checkLogin(type,userName,password)
    if code == 0:
        session['username'] = userName
        token = session.get('username')
        session.permanent = True
    return jsonify(response=result,code=code)

@app.route('/eFlight/register/<type>')
def register(type):
        if type == 'agent':
            ''' 查询系统记录中的airline name, 放入 airline_names 变量中
            '''
        return render_template('register.html',type=type, airline_name=None)

@app.route('/eFlight/viewFlight')
def viewFlight():
    username = session['username']
    return render_template('viewFlight.html',username=username)


@app.route('/eFlight/confirmOrder')
def confirmOrder():
    return render_template('confirmOrder.html')
