import os
from sys import argv, exit

if len(argv) <= 1:
    print("Need argument for padding!")
    exit()

monitors = os.popen("herbstclient list_monitors").read()
monitors_lines = monitors.split("\n")[:-1]
monitor_names = [line.split(":")[0] for line in monitors_lines]

for name in monitor_names:
    os.popen("herbstclient pad " + name + " " + argv[1] + " 0 0")
