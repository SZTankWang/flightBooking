from datetime import datetime, timedelta

from flask import Flask, render_template, redirect, url_for, request, json, jsonify, session, abort
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_cors import CORS
import os
from sqlalchemy.sql import text

app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['MAX_CONTENT_LENGTH'] = 1024*1024
app.secret_key = "secretkey"
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=5)
CORS(app, supports_credentials=True)
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://SE:mysql@8.129.182.214:3306/eflight"
db = SQLAlchemy(app)
from flightBooking.controller import controller
from flightBooking.models import model
def getairlines():
    result = db.session.execute(text("SELECT * FROM eflight.airline")).fetchall()
    return result
print(type(getairlines()[0][0]))
