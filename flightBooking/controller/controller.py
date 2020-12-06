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
    a = session.get('username')
    try:
        userName = session.get('username')
        return render_template('publicInfo.html',username=userName,pageType="publicView")
    except:
        return render_template('publicInfo.html',pageType="publicView")


@app.route('/eFlight/login/<type>')
def gologin(type):
    # next = request.args.get('next')
    return render_template('login.html',type=type)

@app.route('/eFlight/doLogin',methods=['POST'])
def dologin():
    # next = request.form['next']
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
    departure = request.args.get('departure')
    arrival = request.args.get('arrival')
    departDate = request.args.get('departDate')
    try:
        username = session['username']
        return render_template('viewFlight.html',username=username,pageType="purchaseFlightView",departure=departure,
                               arrival=arrival,departDate=departDate)
    except:
        return render_template('viewFlight.html',pageType="purchaseFlightView",departure=departure,
                               arrival=arrival,departDate=departDate)

@app.route('/eFlight/confirmOrder')
def confirmOrder():
    return render_template('confirmOrder.html')


# home 页 search入口
@app.route('/eFlight/purchaseSearch')
def purchaseSearch():
    pass


#公共搜索页入口
#参数：type 0:按照flightNum搜索 // 1:按照起飞降落地点搜索
# type为0时 会有flightNum参数 指航班号
#type 为1时 会有departure arrival 指出发目的地
#同时两者都有deoartureDate这一参数 出发日期
@app.route('/eFlight/search')
def publicSearch():
    pass

#记录页入口
#type 暂时供给customer / agent
@app.route('/eFlight/record/<type>')
def record(type):
    if type == "customer":
        return render_template('record.html',type=type)
