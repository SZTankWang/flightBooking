from sqlalchemy import text

from flightBooking import db

def view_my_flights(staffID,startDate,endDate,departure_city,arrival_city,status):
    sql_statement =  'SELECT airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city, departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time, status, price FROM flight NATURAL JOIN airline_staff WHERE username = staffID'
    resultproxy = db.session.execute(text("CALL eflight.staff_view_flights(:p1)"),{"staffID":staffID,"purchaseID":purchaseID,"startDate":startDate,"endDate":endDate,"status":status})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]
