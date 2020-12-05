from flask import Flask, render_template, redirect, url_for, request, json, jsonify, session, abort
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_cors import CORS
import os
from sqlalchemy.sql import text
app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['MAX_CONTENT_LENGTH'] = 1024*1024
app.config['UPLOAD_EXTENSIONS'] = ['.jpg','.png','.pdf']
app.config["UPLOAD_FOLDER"] = "LabReport"
app.secret_key = "secretkey"
CORS(app, supports_credentials=True)
login = LoginManager(app)
login.login_view = 'login' # force user to login
login.login_message = "Please login first"
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://SE:mysql@8.129.182.214:3306/eflight"
db = SQLAlchemy(app)
from flightBooking.controller import controller
from flightBooking.models import model
'''
def dologin(type,id,password):
    if type == "customer":
        db.session.execute(text("set @msg = '0'"))
        db.session.execute(text("CALL eflight.login_check(:p1,:p2,:p3,@msg)"),{"p1":type,"p2":id,"p3":password})
        result = db.session.execute(text("select @msg")).fetchone()
        print(result[0])
dologin('customer','123','123')
'''
