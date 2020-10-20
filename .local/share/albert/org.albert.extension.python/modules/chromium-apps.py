"""
Open stuff in Chromium
"""
from albertv0 import Item, ProcAction, ClipAction
import json
from shutil import which

__iid__ = "PythonInterface/v0.1"
__prettyname__ = "Web Browser"
__version__ = "1.0"
__trigger__ = "web "
__author__ = "Michael Farber Brodsky"


def handleQuery(query):
    if query.isTriggered:
        stripped = query.string.strip()
        items = []
        url = stripped
        if not (url[:7] in ["http://", "https:/"]):
            url = "https://" + url
        normal_item = Item(
            id="website-"+stripped,
            text=stripped,
            subtext="open in chromium",
            completion=stripped,
            actions=[
                ProcAction(text="Open this", commandline=["/usr/bin/chromium", "--app="+url])
            ]
        )
        items.append(normal_item)
        return items

