from sqlalchemy import text

from flightBooking import db

def checkLogin(type,userName,password):
    db.session.execute(text("set @msg = '0'"))
    db.session.execute(text("set @code = 0"))
    db.session.execute(text("CALL eflight.login_check(:p1,:p2,:p3,@msg,@code)"),{"p1":type,"p2":userName,"p3":password})
    result = db.session.execute(text("select @msg,@code")).fetchone()
    return result
