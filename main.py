from flask import Flask, jsonify
from flask_restful import Resource, Api
from driver_to_db import *
import json
import schedule
from threading import Thread

app = Flask(__name__)
api = Api(app)


class Verses(Resource):
    def get(self):
        result = get_verse_of_today()
        return result


class Longest(Resource):
    def get(self):
        result = get_longest()
        return result


def run_schedule():
    while 1:
        schedule.run_pending()
        time.sleep(1)


api.add_resource(Verses, '/verse')
api.add_resource(Longest, '/longest')

if __name__ == '__main__':
    schedule.every().day.at("06:00").do(change_verse_of_day)
    t = Thread(target=run_schedule)
    t.start()
    app.run(debug=True)
