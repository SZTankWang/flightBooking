from sqlalchemy import text

from flightBooking import app,db,login
import collections
import decimal
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
from flightBooking.service import customerService,agentService,staffService
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

@app.route('/eFlight/register/<type>')
def register(type):
    return render_template('register.html',type=type)

@app.route('/eFlight/doRegister',methods=['POST'])
def doregister():
    type = request.form["type"]
    if type == "customer":
        email = request.form["email"]
        name = request.form["name"]
        password = request.form["password"]
        building_number = request.form['building_number']
        street = request.form['street']
        city = request.form['city']
        state = request.form['state']
        phone_number = request.form['phone_number']
        passport_number = request.form['passport_number']
        passport_expiration = request.form['passport_expiration']
        passport_country = reuqest.form["passport_country"]
        date_of_birth = reuqest.form["date_of_birth"]
        #email name password building_number street city state phone_number passport_number passport_expiration passport_country date_of_birth
        msg = db.session.execute(text("CALL eflight.create_user(:email,:name,:password,:building_number,:street,:city,:state,:phone_number,:passport_number,:passport_expiration,:passport_country,:date_of_birth)"),
                                        {"email":email, "name":name, "password":password,"building_number":building_number,"street":street,"city":city,"state":state,"phone_number":phone_number,"passport_number":passport_number,"passport_expiration":passport_expiration,"passport_country":passport_country,"date_of_birth":date_of_birth})
    elif type == "agent":
        email = request.form["email"]
        booking_agent_id = request.form["booking_agent_id"]
        password = request.form["password"]
        msg = db.session.execute(text("CALL eflight.create_agent(:email,:password,:id)"),{"email":email,"password":password,"id":booking_agent_id})
    elif type == "staff":
        username = request.form["username"]
        password = request.form["password"]
        first_name = request.form["first_name"]
        last_name = request.form["last_name"]
        date_of_birth = request.form["date_of_birth"]
        airline_name = request.form["airline_name"]
        msg = db.session.execute(text("CALL eflight.create_staff(:username,:password,:first_name,:last_name,:birth,:airline)"),{"username":username,"password":password,"first_name":first_name,"last_name":last_name,"birth":date_of_birth,"airline":airline_name})
    if msg == "registered successfully":
        db.session.commit()
        code = 0
    else:
        db.session.rollback()
        code = -1
    return jsonify(response = msg, code = code)

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
    result = customerService.view_flight(airline_name,flight_num)
    return render_template('confirmOrder.html',username=username ,type=current_user.type,result = result)


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
    type = current_user.type
    if type == 'customer':
        userName = current_user.get_id()
        purchase_id = request.args.get('purchase_id')
        departure_time = request.args.get('departure_time')
        arrival_time = request.args.get('arrival_time')
        status = request.args.get('status')
        result = customerService.view_record(current_id=userName,purchaseID=purchase_id,departDate=departure_time,
                                             arriveDate=arrival_time,flight_status=status)
    elif type == 'agent':
        userName = current_user.get_id()
        customer_email = request.args.get('customer_email')
        purchase_id = request.args.get('purchase_id')
        departure_time = request.args.get('departure_time')
        arrival_time = request.args.get('arrival_time')
        status = request.args.get('status')
        result = agentService.view_record(current_id=userName,customerEmail = customer_email,purchaseID=purchase_id,departDate=departure_time,
                                             arriveDate=arrival_time,flight_status=status)
    return jsonify(result)



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
    passenger_phone_list = request.args.get('passenger_phone_list')
    customer_email = request.args.get('customer_email')
    airline_name = request.args.get('airline_name')
    flight_number = request.args.get('flight_number')

    if current_user.type == 'agent':
        result,code = agentService.purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number,agentService.get_id_by_email(current_user.get_id()))
        db.session.commit()
        return jsonify(result = result, code = code)
    elif current_user.type == 'customer':
        result,code = agentService.purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number,0)
        db.session.commit
        return jsonify(result = result, code = code)

#customer/agent
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

#customer
@app.route('/eFlight/trackSpending')
@login_required
def trackSpending():
    customerID = current_user.get_id()
    startMonth = request.args.get("startMonth")
    endMonth = request.args.get("endMonth")
    result_total = total_spending(customerID)
    result_month = month_spending(customerID,startMonth,endMonth)
    return jsonify(result_total = result_total, result_month = result_month)

#agent
@app.route('/eFlight/viewCommission')
@login_required
def viewCommission():
    #startDate指小日期，默认应该为空
    #endDate指大日期，默认应该为今天
    startDate = request.args.get('startDate')
    endDate = request.args.get('endDate')
    agentID = current_user.get_id()
    if startDate:
        startDate = datetime.datetime.strftime(startDate,"%Y-%m-%d")
    else:
        startDate = datetime.datetime.strftime(endDate,"%Y-%m-%d")-timedelta(days = 30)
    endDate = datetime.datetime.strftime(endDate,"%Y-%m-%d")
    total, average = agentService.view_commission(agentID,startDate,endDate)
    return jsonify(total = float(total), average = float(average))

#agent
@app.route('/eFlight/viewTopCustomer')
@login_required
def viewTopCustomer():
    agentID = current_user.get_id()
    result_ticket,result_commission = agentService.view_top_customer(agentID)
    return jsonify(ticket=result_ticket,commission=result_commission)

#staff
@app.route('/eFlight/viewFrequentCustomer')
@login_required
def viewFrequentCustomer():
    staffID = current_user.get_id()
    resultproxy = db.session.execute(text("CALL eflight.most_frequent_customer(:p1)"),{"p1":staffID})
    result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy][0]
    return jsonify(result)

#staff
@app.route('/eFlight/viewBookingAgent')
@login_required
def viewBookingAgent():
    staffID = current_user.get_id()
    resultproxy1 = db.session.execute(text("CALL eflight.get_top_commission_agent(:p1,365)"),{"p1":staffID})
    year_commission_result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy1]
    resultproxy2 = db.session.execute(text("CALL eflight.get_top_ticket_agent(:p1,30)"),{"p1":staffID})
    month_ticket_result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy2]
    resultproxy3 = db.session.execute(text("CALL eflight.get_top_ticket_agent(:p1,365)"),{"p1":staffID})
    year_ticket_result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy3]
    return jsonify(year_commission_result=year_commission_result,month_ticket_result=month_ticket_result,year_ticket_result=year_ticket_result)

#staff
@app.route('/eFlight/viewMonthReport')
@login_required
def viewMonthReport():
    staffID = current_user.get_id()
    startMonth = request.args.get("startMonth")
    endMonth = request.args.get("endMonth")
    resultproxy = db.session.execute(text("CALL eflight.get_month_report(:p1,:p2,:p3)"),{"p1":staffID,"p2":startMonth,"p3":endMonth})
    result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy]
    return jsonify(result)

#staff
@app.route('/eFlight/viewDateReport')
@login_required
def viewDateReport():
    staffID = current_user.get_id()
    startDate = request.args.get("startDate")
    endDate = request.args.get("endDate")
    resultproxy = db.session.execute(text("CALL eflight.get_date_report(:p1,:p2,:p3)"),{"p1":staffID,"p2":startDate,"p3":endDate})
    result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy][0]
    return jsonify(result)

#staff
@app.route('/eFlight/compareRevenue')
@login_required
def compareRevenue():
    staffID = current_user.get_id()
    resultproxy1 = db.session.execute(text("CALL eflight.revenue(30,:p1)"),{"p1":staffID})
    month_result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy1]
    resultproxy2 = db.session.execute(text("CALL eflight.revenue(365,:p1)"),{"p1":staffID})
    year_result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy2]
    return jsonify(month_result = month_result,year_result = year_result)

#staff
@app.route('/eFlight/viewTopDestinations')
@login_required
def viewTopDestinations():
    if request.args.get('number'):
        number = request.args.get("number")
    else:
        number = 3
    resultproxy = db.session.execute(text("CALL eflight.get_top_destinations(30,:p1)"),{"p1":number})
    result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy]
    return jsonify(result)


#staff
@app.route('/eFlight/create/<type>')
@login_required
def create(type):
    username = current_user.get_id()
    userType = current_user.type
    if userType == 'staff':
        return render_template('create.html',type=type,username=username)
    else:
        return url_for('renderHome')

#staff
@app.route('/eFlight/view/<type>')
@login_required
def view(type):
    userType = current_user.type
    username = current_user.get_id()
    if userType == 'staff':
        return render_template('view.html',pageType=type,username=username)


@app.route('/eFlight/staffViewFlights')
@login_required
def staffViewFlights():
    startDate = request.args.get("startDate")
    endDate = request.args.get("endDate")
    departure = request.args.get("departure")
    arrival = request.args.get("arrival")
    status = request.args.get("status")
    staffID =current_user.get_id()
    result = staffService.view_my_flights(staffID,startDate=startDate,endDate=endDate,departure_city=departure,arrival_city=arrival,status=status)
    return jsonify(result)

@app.route('/eFlight/addNewFlight')
@login_required
def addNewFlight():
    staffID = current_user.get_id()
    departure_airport = request.args.get("departure_airport")
    arrival_airport = request.args.get("arrival_airport")
    departure_time = request.args.get("departure_time")
    arrival_time = request.args.get("arrival_time")
    price = request.args.get("price")
    status = request.args.get("status")
    result = staffService.create_new_flights(staffID,departure_airport,departure_time,arrival_airport,arrival_time,price,status)
    return result

@app.route('/eFlight/returnAirport')
@login_required
def returnAirport():
    resultproxy = db.session.execute(text("SELECT airport_name FROM airport"))
    result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy]
    return result

@app.route('/eFlight/changeStatus')
@login_required
def changeStatus():
    staffID = current_user.get_id()
    new_status = request.args.get("new_status")
    flight_number = request.args.get("flight_number")
    msg,code = db.session.execute(text("CALL eflight.change_status(:p1,:p2,:p3)"),{"p1":staffID,"p2":flight_number,"p3":new_status}).fetchone()
    if code == 0:
        db.session.commit()
    return jsonify(response=msg,code=code)

@app.route('/eFlight/getInfo')
@login_required
def getInfo():
    staffID = current_user.get_id()
    flight_number = request.args.get("flight_number")
    resultproxy = db.session.execute(text("CALL eflight.get_passengers_by_flight(:p1,:p2)"),{"p1":staffID,"p2":flight_number})
    result = [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy]
    return jsonify(result)

@app.route("/eFlight/addNewAirplane")
@login_required
def addNewAirplane():
    seats = request.args.get("seats")
    staffID = current_user.get_id()
    msg,code = db.session.execute(text("CALL eflight.create_airplane(:p1,:p2)"),{"p1":staffID,"p2":seats}).fetchone()
    if code == 0:
        db.session.commit()
    return jsonify(response=msg,code=code)

@app.route("/eFlight/addNewAirport")
@login_required
def addNewAirport():
    airport_name = request.args.get("airport_name")
    airport_city = request.args.get("airport_city")
    msg,code = db.session.execute(text("CALL eflight.create_airport(:p1,:p2)"),{"p1":airport_name,"p2":airport_city}).fetchone()
    if code == 0:
        db.session.commit()
    return jsonify(response=msg,code=code)
