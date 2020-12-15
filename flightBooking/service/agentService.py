from sqlalchemy import text

from flightBooking import db


def get_id_by_email(email):
    result = db.session.execute(text("SELECT eflight.agent_get_id_by_email(:p1)"),{"p1":email}).fetchone()[0]
    return result
def purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number,agent_id):
    result = db.session.execute(text("CALL eflight.insert_ticket(:p1,:p2,:p3,:p4,:p5,:p6,:p7)"),
    {"p1":customer_email,"p2":agent_id,"p3":passenger_name_list,"p4":passenger_id_list,"p5":passenger_phone_list,"p6":flight_number,"p7":airline_name}).fetchone()
    return result

def view_record(current_id,customerEmail,purchaseID,departDate,arriveDate,flight_status):
    sql_statement = 'SELECT DISTINCT purchase_id,purchase_date,airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price*return_passenger_num(purchase_id) as char(11)) as price,return_passenger_num(purchase_id) as passenger_num, return_passenger_list(purchase_id) as passenger_list FROM purchases NATURAL JOIN ticket NATURAL JOIN flight WHERE booking_agent_id =(:current_id)'
    if customerEmail != "":
        sql_statement += "AND customer_email=(:customerEmail)"
    if purchaseID != "":
        sql_statement += "AND purchase_id = (:purchaseID)"
    if departDate != "":
        sql_statement += "AND DATE(departure_time) = (:departDate)"
    if arriveDate != "":
        sql_statement += "AND DATE(arrival_time) = (:arriveDate)"
    if flight_status != "":
        sql_statement += "AND status = (:flight_status)"

    resultproxy = db.session.execute(text(sql_statement),{"current_id":get_id_by_email(current_id),"customerEmail":customerEmail,"purchaseID":purchaseID,"departDate":departDate,"arriveDate":arriveDate,"flight_status":flight_status})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]

# def view_commission(agentID,startDate,endDate):
#     result = db.session.execute(text("CALL eflight.get_commission(:p1,:p2,:p3)"),{"p1":agentID,"p2":startDate,"p3":endDate}).fetchone()
#     return result

def view_commission(agentID,startDate,endDate):
    sql_statement = 'SELECT sum(0.1*price) as sum,avg(0.1*price) as avg FROM purchases NATURAL JOIN ticket NATURAL JOIN flight WHERE booking_agent_id = (:agentID) AND DATE(purchase_date) <= (:endDate)'
    group_by = 'GROUP BY booking_agent_id'
    if startDate != "":
        sql_statement += "AND DATE(purchase_date) >= (:startDate)"
    resultproxy = db.session.execute(text(sql_statement+group_by),{"agentID":get_id_by_email(agentID),"startDate":startDate,"endDate":endDate})
    result = [{column: value if type(value) == str else float(value) for column, value in rowproxy.items()} for rowproxy in resultproxy]

    return result

def view_top_customer(agentID):
    ticket = db.session.execute(text("CALL eflight.get_top_ticket_customer(:p1)"),{"p1":get_id_by_email(agentID)})
    commission = db.session.execute(text("CALL eflight.get_top_commission_customer(:p1)"),{"p1":get_id_by_email(agentID)})
    result1 = [{column: value for column, value in rowproxy.items()} for rowproxy in ticket]
    result2 = [{column: value if type(value) == str else int(value) for column, value in rowproxy.items()} for rowproxy in commission]
    return result1, result2
