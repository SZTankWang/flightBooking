from sqlalchemy import text

from flightBooking import db

import decimal
def check_login(type,userName,password):
    db.session.execute(text("set @msg = '0'"))
    db.session.execute(text("set @code = 0"))
    db.session.execute(text("CALL eflight.login_check(:p1,:p2,:p3,@msg,@code)"),{"p1":type,"p2":userName,"p3":password})
    result = db.session.execute(text("select @msg,@code")).fetchone()
    return result

def get_airlines():
    results = db.session.execute(text("SELECT airline_name FROM eflight.airline"))
    return [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def search_by_num(flight_num,date):
    resultproxy = db.session.execute(text("CALL eflight.search_by_num(:p1,:p2)"),{"p1":flight_num,"p2":date})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def search_by_city(depart,arrival,date):
    resultproxy = db.session.execute(text("CALL eflight.search_by_city(:p1,:p2,:p3)"),{"p1":depart,"p2":arrival,"p3":date})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def view_my_flights(id):
    resultproxy = db.session.execute(text("CALL eflight.customer_view_flights(:p1)"),{"p1":id})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def purchase_ticket():
    result = db.session.execute(text("CALL eflight.customer_purchase_ticket(:p1)"),{"p1":id}).fetchone()
    return result

def purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number):
    result = db.session.execute(text("CALL eflight.insert_ticket(:p1,:p2,:p3,:p4,:p5,:p6,:p7)"),
    {"p1":customer_email,"p2":0,"p3":passenger_name_list,"p4":passenger_id_list,"p5":passenger_phone_list,"p6":flight_number,"p7":airline_name}).fetchone()
    return result

def view_record(current_id,purchaseID='',departDate='',arriveDate='',flight_status=''):
    sql_statement = 'SELECT DISTINCT purchase_id,purchase_date,airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price*return_passenger_num(purchase_id) as char(11)) as price,return_passenger_num(purchase_id) as passenger_num, return_passenger_list(purchase_id) as passenger_list FROM purchases NATURAL JOIN ticket NATURAL JOIN flight WHERE customer_email=(:current_id)'
    if purchaseID != "":
        sql_statement += "AND purchase_id = (:purchaseID)"
    if departDate != "":
        sql_statement += "AND DATE(departure_time) >= (:departDate)"
    if arriveDate != "":
        sql_statement += "AND DATE(arrival_time) <= (:arriveDate)"
    if flight_status != "":
        sql_statement += "AND status = (:flight_status)"

    resultproxy = db.session.execute(text(sql_statement),{"current_id":current_id,"purchaseID":purchaseID,"departDate":departDate,"arriveDate":arriveDate,"status":flight_status})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def date_spending(current_id,startDate,endDate):
    result = db.session.execute(text("CALL eflight.get_date_spending(:p1,:p2,:p3)"),{"p1":current_id,"p2":startDate,"p3":endDate}).fetchone()[0]
    return float(result)

def month_spending(current_id,startMonth,endMonth):
    resultproxy = db.session.execute(text("CALL eflight.get_month_spending(:p1,:p2,:p3)"),{"p1":current_id,"p2":startMonth,"p3":endMonth})
    return [{column: value if type(value) == str else float(value) for column, value in rowproxy.items()} for rowproxy in resultproxy]

def view_flight(airline_name,flight_number):
    resultproxy = db.session.execute(text("SELECT airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city, departure_time,arrival_airport,return_city(arrival_airport) as arrival_city, arrival_time, status, price FROM flight WHERE flight_num = (:flight_number)AND airline_name = (:airline_name)"),{"flight_number":flight_number,"airline_name":airline_name})
    return [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy][0]
