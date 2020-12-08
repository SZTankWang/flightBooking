from sqlalchemy import text

from flightBooking import db


def get_id_by_email(email):
    result = db.session.execute(text("SELECT eflight.agent_get_id_by_email(:p1)"),{"p1":email}).fetchone()
    return result
def purchase_ticket(passenger_name_list,passenger_id_list,passenger_phone_list,customer_email,airline_name,flight_number,agent_id):
    result = db.session.execute(text("CALL eflight.insert_ticket(:p1,:p2,:p3,:p4,:p5,:p6,:p7)"),
    {"p1":customer_email,"p2":agent_id,"p3":passenger_name_list,"p4":passenger_id_list,"p5":passenger_phone_list,"p6":flight_number,"p7":airline_name}).fetchone()
    return result

def view_record(current_id,customerEmail,purchaseID,departDate,arriveDate,flight_status):
    sql_statement = 'SELECT purchase_id,purchase_date,airline_name,flight_num,departure_airport,return_city(departure_airport) as departure_city,departure_time,arrival_airport,return_city(arrival_airport) as arrival_city,arrival_time,status,cast(price*return_passenger_num(purchase_id) as char(11)) as price,return_passenger_num(purchase_id) as passenger_num, return_passenger_list(purchase_id) as passenger_list FROM purchases NATURAL JOIN ticket NATURAL JOIN flight WHERE customer_email=(:customerEmail) AND booking_agent_id =(:current_id)'
    if purchaseID != "":
        sql_statement += "AND purchase_id = (:purchaseID)"
    if departDate != "":
        sql_statement += "AND DATE(departure_time) = (:departDate)"
    if arriveDate != "":
        sql_statement += "AND DATE(arrival_time) = (:arriveDate)"
    if flight_status != "":
        sql_statement += "AND status = (:flight_status)"

    resultproxy = db.session.execute(text(sql_statement),{"current_id":current_id,"customerEmail":customerEmail,"purchaseID":purchaseID,"departDate":departDate,"arriveDate":arriveDate,"status":flight_status})
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]
