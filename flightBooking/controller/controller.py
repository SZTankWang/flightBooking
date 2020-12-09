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
from flightBooking.service import customerService,agentService
import datetime
from flightBooking.models.model import *


@app.route('/eFlight/home')
def renderHome():
    try:
        userName = current_user.get_id()
        userType = current_user.type
        if current_user.type == 'customer':
            return render_template('customerHome.html',username=userName,userType = userType)
        elif current_user.type == 'staff':
            return render_template('staffHome.html',username=userName)
        elif current_user.type == 'agent':
            return render_template('customerHome.html',username=userName,userType = userType)
    except:
        return render_template('customerHome.html')

@app.route('/eFlight/publicInfo')
def publicInfo():
    try:
        userName = current_user.get_id()
        return render_template('publicInfo.html',username=userName,pageType="publicView")
    except:
        return render_template('publicInfo.html',pageType="publicView")


@app.route('/eFlight/login/<type>')
def gologin(type):
    # next = request.args.get('next')
    return render_template('login.html',type=type)

@app.route('/')
def bringToLogin():
    return render_template('login.html',type="customer")

@app.route('/eFlight/doLogin',methods=['POST'])
def dologin():
    # next = request.form['next']
    userName = request.form['userName']
    type = request.form['type']
    password = request.form['password']
    result,code = customerService.check_login(type,userName,password)
    if code == 0:
        user = User.query.get(userName)
        login_user(user)
    return jsonify(response=result,code=code)

@app.route('/eFlight/logout', methods=['GET'])
def logout():
	logout_user()
	return redirect(url_for('renderHome'))

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
    userName = current_user.get_id()
    try:
        userName = current_user.get_id();
        return render_template('viewFlight.html',username=userName,pageType="purchaseFlightView",departure=departure,
                               arrival=arrival,departDate=departDate)
    except:
        return render_template('viewFlight.html',pageType="purchaseFlightView",departure=departure,
                               arrival=arrival,departDate=departDate)



@app.route('/eFlight/confirmOrder')
@login_required
def confirmOrder():
    username = current_user.get_id()
    airline_name = request.args.get('airline_name')
    flight_num = request.args.get('flight_num')
    return render_template('confirmOrder.html',username=username ,type=current_user.type, airline_name=airline_name , flight_num = flight_num)


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
@app.route('/eFlight/record/<pageType>')
@login_required
def record(pageType):
    if current_user.type == "customer" or current_user.type == "agent":
        userName = current_user.get_id()
        return render_template('record.html',type=current_user.type,pageType=pageType)
    else:
        return redirect(url_for('renderHome'))

##查询purchase记录接口 -- 乘客/agent
##是否有需要区分角色？
@app.route('/eFlight/queryPurchaseRecord')
@login_required
def queryPurchaseRecord():
    userName = request.args.get('userName')




#暂时customer用
@app.route('/eFlight/viewMyFlights')
@login_required
def viewMyFlights():
    id = current_user.get_id()
    results = customerService.view_my_flights(id)
    return jsonify(results)


@app.route('/eFlight/purchaseTicket')
@login_required
def purchaseTicket():
    passenger_name_list = request.args.get('passenger_name_list')
    passenger_id_list = request.args.get('passenger_id_list')
    passgener_phone_list = request.args.get('passenger_phone_list')
    customer_email = request.args.get('customer_email')
    airline_name = request.args.get('airline_name')
    flight_number = request.args.get('flight_number')

    if current_user.type == 'agent':
        result,code = agentService.purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number,agentService.get_id_by_email(current_user.get_id()))
        return jsonify(result = result, code = code)
    elif current_user.type == 'customer':
        result,code = agentService.purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number,0)
        return jsonify(result = result, code = code)


@app.route('/eFlight/viewRecord')
@login_required
def viewRecord():
    purchase_id = request.args.get('purchase_id')
    departDate = request.args.get('departDate')
    arriveDate = request.args.get('arriveDate')
    status = request.args.get('status')
    current_id = current_user.get_id()
    if current_user.type == 'customer':
        results = customerService.view_record(current_id,purchase_id,departDate,arriveDate,status)
        return jsonify(results)
    elif current_user.type == 'agent':
        customer_email = request.args.get('customer_email')
        results = agentService.view_record(current_id,customer_email,purchase_id,departDate,arriveDate,status)
        return jsonify(results)


##staff route : create things template
## <type> : airplane / flight / airport

@app.route('/eFlight/create/<type>')
@login_required
def create(type):
    username = current_user.get_id()
    userType = current_user.type
    if userType == 'staff':
        return render_template('create.html',type=type,username=username)
    else:
        return url_for('renderHome')


##staff route: view information
@app.route('/eFlight/view/<type>')
@login_required
def view(type):
    username = current_user.get_id()
    userType = current_user.type
    return render_template('view.html',username=username,userType=userType,pageType=type)