from sqlalchemy import text

from flightBooking import db

def view_my_flights(staffID,startDate="",endDate="",departure_city="",arrival_city="",status=""):
    sql_statement =  'SELECT airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city, departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time, status, price FROM flight NATURAL JOIN airline_staff WHERE username = (:staffID)'
    if startDate == "" and endDate == "" and departure_city =="" and arrival_city == "" and status == "":
        sql_statement += " AND (datediff(DATE(departure_time),DATE(now())) between 0 and 30)"
    elif startDate == "" and endDate != "":
        sql_statement += " AND (DATE(departure_time) <= (:endDate))"
    elif endDate == "" and startDate != "":
        sql_statement += " AND (DATE(departure_time) >= (:startDate))"
    if departure_city != "":
        sql_statement += " AND ((:departure_city) like CONCAT('%',return_city(departure_airport),'%') OR ((:departure_city) like CONCAT('%',departure_airport,'%')))"
    if arrival_city != "":
        sql_statement += " AND ((:arrival_city) like CONCAT('%',return_city(arrival_airport),'%') OR ((:arrival_city) like CONCAT('%',arrival_airport,'%')))"
    if status != "":
        sql_statement += " AND status = (:status)"
    resultproxy = db.session.execute(text(sql_statement),{"staffID":staffID,"startDate":startDate,"endDate":endDate,"departure_city":departure_city,"arrival_city":arrival_city,"status":status})
    return [{column: float(value) if type(value) == decimal.Decimal else value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def create_new_flights(staffID,departure_airport,departure_time,arrival_airport,arrival_time,price,status,airplane_id):
    result = db.session.execute(text("CALL eflight.create_flight(staffID,departure_airport,departure_time,arrival_airport,arrival_time,price,status,airplane_id)"),{"staffID":staffID,"departure_airport":departure_airport,"departure_time":departure_time,"arrival_airport":arrival_airport,"arrival_time":arrival_time,"price":price,"status":status,"airplane_id":airplane_id}).fetchone()
    db.session.commit()
    return result
