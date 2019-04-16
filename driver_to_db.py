from datetime import timedelta, datetime, date
from pymongo import MongoClient
from verse_list import *
import random
import time
import schedule

client = MongoClient("mongodb+srv://admin:admin@cluster0-2hqg5.mongodb.net/test?retryWrites=true")
db = client.test
collection = db.verses_collection


def get_verse_of_today():

    cursor = collection.find_one({"today": "yes"})
    verse = cursor['verse']
    reference = cursor['reference']
    version = cursor['version']
    background_number = cursor['background_number']
    json = {
        "verse": verse,
        "reference": reference,
        "version": version,
        "background_number": background_number
    }
    return json


def change_verse_of_day():
    # Original setup
    #
    # today_number = random.randint(1, collection.count_documents({}))
    # collection.update_one(
    #     {"number": today_number},
    #     {"$set": {"today": "yes"}})

    # cursor = collection.find_one({"today": "yes"})
    # print(cursor)

    collection.find_one({"today": "yes"})

    collection.update_one(
        {"today": "yes"},
        {"$set": {"today": "no"}})


    background_number = random.randint(1, 40)
    today_number = random.randint(1, collection.count_documents({}))
    collection.update_one(
        {"number": today_number},
        {"$set": {"today": "yes", "background_number": background_number}})






def get_longest():
    cursor = collection.find_one({"reference": "Haggi 1:5-7"})
    verse = cursor['verse']
    reference = cursor['reference']
    version = cursor['version']
    json = {
        "verse": verse,
        "reference": reference,
        "version": version,
    }
    return json


def get_all_verses():
    print("THis is all data in DB")
    print("Number of verses: ", collection.count_documents({}))
    for x in collection.find():
        print(x)

    print('\n')


def add_verse_of_day():
    verse_1 = {
        "reference": "Romans 1:20",
        "verse": 'For the invisible things of him from the creation of the world are clearly seen,'
                 ' being understood by the things that are made, even his eternal power and Godhead; '
                 'so that they are without excuse:',
        "version": "KJV",
        "date": str(date.today() + timedelta(days=1)),

    }

    # Insert Data
    data = collection.insert_one(verse_1)

    print("Data inserted! Here it is: ", data)

    # Printing the data inserted
    cursor = collection.find()
    for record in cursor:
        print(record)


def add_many_verses(verse_list):
    # Insert Data
    data = collection.insert_many(verse_list)
    print("Data inserted! Here it is: ", data)

    # Printing the data inserted
    cursor = collection.find()
    for record in cursor:
        print(record)


def delete_all():
    collection.delete_many({})

    # print the customers collection after the deletion:
    for x in collection.find():
        print(x)



if __name__ == '__main__':
    print(get_verse_of_today())



