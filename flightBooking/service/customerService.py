from sqlalchemy import text

from flightBooking import db

def checkLogin(type,userName,password):
    db.session.execute(text("set @msg = '0'"))
    db.session.execute(text("set @code = 0"))
    db.session.execute(text("CALL eflight.login_check(:p1,:p2,:p3,@msg,@code)"),{"p1":type,"p2":userName,"p3":password})
    result = db.session.execute(text("select @msg,@code")).fetchone()
    return result

def get_airlines():
    results = db.session.execute(text("SELECT * FROM eflight.airline")).fetchall()
    return [result[0] for result in results]

def search_by_num(flight_num,date):
    resultproxy = db.session.execute(text("CALL eflight.searchby_num(:p1,:p2)"),{"p1":flight_num,"p2":date})
    results = resultproxy.fetchall()
    # return [{'flight_num': result[0],
    #     'departure_airport': result[1],
    #     'departure_time': result[2].strftime("%Y-%m-%d %H:%M:%S"),
    #     'arrival_airport': result[3],
    #     'arrival_time': result[4].strftime("%Y-%m-%d %H:%M:%S"),
    #     'status': result[5]}
    #     for result in results]
    return [{column: value for column, value in rowproxy.items()} for rowproxy in resultproxy]

def search_by_city(depart,arrival,date):
    resultproxy = db.session.execute(text("CALL eflight.searchby_city(:p1,:p2,:p3)"),{"p1":depart,"p2":arrival,"p3":date})
    results = resultproxy.fetchall()
    return [{'flight_num': result[0],
        'departure_airport': result[1],
        'departure_time': result[2].strftime("%Y-%m-%d %H:%M:%S"),
        'arrival_airport': result[3],
        'arrival_time': result[4].strftime("%Y-%m-%d %H:%M:%S"),
        'status': result[5]}
        for result in results]
