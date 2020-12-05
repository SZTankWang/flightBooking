from datetime import datetime, timedelta
from inspect import indentsize
from sqlalchemy.sql.schema import ForeignKey
# from sqlalchemy.sql.schema import ForeignKey
from werkzeug.security import check_password_hash, generate_password_hash
from flightBooking import db, login
from flask_login import UserMixin # UserMixin conains four useful login function
								  # [https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-v-user-logins]
import enum
from sqlalchemy import Enum
from flask_sqlalchemy import SQLAlchemy

# @login.user_loader
# def load_user(id):
#     return User.query.get(id)
