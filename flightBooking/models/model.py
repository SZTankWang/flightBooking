from datetime import datetime, timedelta
from inspect import indentsize
from sqlalchemy.sql.schema import ForeignKey
# from sqlalchemy.sql.schema import ForeignKey
from werkzeug.security import check_password_hash, generate_password_hash
from flightBooking import db,login
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
@login.user_loader
def load_user(id):
    return User.query.get(id)

class User(UserMixin,db.Model):
    id = db.Column(db.String(50), primary_key=True, nullable=False)
    password = db.Column(db.String(50), nullable=False)
    type = db.Column(db.String(50), nullable=False)
