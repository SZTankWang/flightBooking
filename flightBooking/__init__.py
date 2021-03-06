from datetime import datetime, timedelta
import decimal
from flask import Flask, render_template, redirect, url_for, request, json, jsonify, session, abort
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_cors import CORS
import os
import datetime
from sqlalchemy.sql import text

app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['MAX_CONTENT_LENGTH'] = 1024*1024
app.secret_key = "eFlight1"
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=365)
CORS(app, supports_credentials=True)
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://SE:mysql@8.129.182.214:3306/eflight"


login = LoginManager(app)
login.login_view = 'bringToLogin' # force user to login
login.login_message = "Please login first"

db = SQLAlchemy(app)
from flightBooking.controller import controller
from flightBooking.models import model
