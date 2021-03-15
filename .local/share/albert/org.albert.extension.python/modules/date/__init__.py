# -*- coding: utf-8 -*-

"""Returns the date in my format"""

from albert import *
import datetime
from time import sleep


__title__ = "My Date"
__version__ = "0.0.1"
__triggers__ = "dt"
__authors__ = "Misha Farber Brodsky"
#__exec_deps__ = ["whatever"]

iconPath = iconLookup("albert")


# Can be omitted
def initialize():
    pass


# Can be omitted
def finalize():
    pass


def get_date():
    now = datetime.datetime.now()
    return f"{now.year}-{str(now.month).zfill(2)}-{str(now.day).zfill(2)}"


def make_item(query_str):
    item = Item()
    date_str = get_date() + ("_"+ query_str if query_str else "")
    item.text = date_str
    item.actions = [ClipAction(text="", clipboardText=date_str)]
    return item


def handleQuery(query):
    if not query.isTriggered:
        return
    items = [make_item(query.string), make_item("homework"), make_item("lesson"), make_item("tirgul")]
    return items
