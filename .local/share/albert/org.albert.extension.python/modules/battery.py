"""Shows battery status in Albert.
"""

from albertv0 import *
import os

__iid__ = "PythonInterface/v0.1"
__prettyname__ = "Battery Status"
__version__ = "1.0"
__trigger__ = "battery"
__author__ = "Misha Farber Brodsky"

def read_or_none(filename):
    try:
        with open(filename) as f:
            return f.read()
    except:
        return None

def float_or_none(x):
    try:
        return float(x)
    except:
        return None

def handleQuery(query):
    if not query.isTriggered:
        return
    directory = os.path.dirname(os.path.realpath(__file__))
    battery_icon = directory + "/battery_icon.svg"
    items = []
    batteries = []
    for root, dirs, files in sorted(os.walk("/sys/class/power_supply"), key=lambda x: x[1]):
        for dirname in dirs:
            full = float_or_none(read_or_none("/sys/class/power_supply/" + dirname + "/energy_full"))
            now  = float_or_none(read_or_none("/sys/class/power_supply/" + dirname + "/energy_now"))
            status =     read_or_none("/sys/class/power_supply/" + dirname + "/status")
            if status != None and now != None and full != None:
                batteries.append((full, now))
                pct = round(now / full * 100)
                final_text = str(pct) + "% (" + status.strip() + ")"
                items.append(Item(id=__trigger__ + dirname, icon=battery_icon, text=final_text, subtext=dirname))

    # Find overall percentage
    max_capacity =  sum(b[0] for b in batteries)
    current_power = sum(b[1] for b in batteries)
    overall_percentage = str(round(current_power / max_capacity * 100))
    items = [Item(id=__trigger__ + "overall", icon=battery_icon, text=overall_percentage + "%", subtext="Overall")] + items
    return items
