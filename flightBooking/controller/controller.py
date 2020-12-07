from sqlalchemy import text

from flightBooking import app,db,login
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
import datetime
from flightBooking.models.model import *


@app.route('/eFlight/home/<type>')
def renderHome(type):
    try:
        userName = current_user.get_id()
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
        user = User.query.get(userName)
        login_user(user)
    return jsonify(response=current_user.get_id(),code=code)


@app.route('/eFlight/register/<type>')
def goregister(type):
    return render_template('register.html',type=type)

@app.route("/eFlight/loadAirlineData")
def loadAirlineData():
    return jsonify(customerService.get_airlines())

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
    type = request.args.get('type')
    departure_date = request.args.get('departDate')
    date = datetime.datetime.strptime(departure_date,'%m/%d/%Y')
    '''
    最好能统一成'%Y-%m-%d'，这里date格式和下面不一样
    '''
    departure_city = request.args.get('departure')
    arrival_city = request.args.get('arrival')
    results = customerService.search_by_city(departure_city,arrival_city,date)
    return jsonify(results)


#公共搜索页入口
#参数：type 0:按照flightNum搜索 // 1:按照起飞降落地点搜索
# type为0时 会有flightNum参数 指航班号
#type 为1时 会有departure arrival 指出发目的地
#同时两者都有deoartureDate这一参数 出发日期
@app.route('/eFlight/search')
def publicSearch():
    type = request.args.get('type')
    departure_date = request.args.get('departureDate')
    date = datetime.datetime.strptime(departure_date,'%Y-%m-%d')
    if type == "0":
        flight_number = int(request.args.get('flightNum'))
        results = customerService.search_by_num(flight_number,date)
        return jsonify(results)
        '''
        [{'flight_num': 100,
        'departure_airport': 'PVG',
        'departure_time': "2020-11-22 15:09:48",
        'arrival_airport': 'JFK'
        'arrival_time': "2020-11-13 13:30:34",
        'status': '0'}]
        '''
    elif type == "1":
        departure_city = request.args.get('departure')
        arrival_city = request.args.get('arrival')
        results = customerService.search_by_city(departure_city,arrival_city,date)
        return jsonify(results)


#记录页入口
#type 暂时供给customer / agent
@app.route('/eFlight/record/<type>')
def record(type):
    if type == "customer":
        return render_template('record.html',type=type)
