from sqlalchemy import text

from flightBooking import db

def checkLogin(type,userName,password):
    db.session.execute(text("CALL eflight.login_check(:p1,:p2,:p3,@msg,@code)"),{"p1":type,"p2":userName,"p3":password})
    result = db.session.execute(text("select @msg")).fetchone()
    code = db.session.execute(text("select @code")).fetchone()
    return result[0],code[0]
