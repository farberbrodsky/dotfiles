#!/usr/bin/env python3
import os
import subprocess
from time import sleep

try:
    subprocess.check_output(["killall", "polybar"], stderr=subprocess.PIPE)
except subprocess.CalledProcessError as e:
    if e.stderr != b"polybar: no process found\n":
        raise e

monitors = subprocess.check_output(["polybar", "-m"]).decode("utf-8")
monitors = [x for x in monitors.split("\n") if x != ""]
primary = None
for i in range(len(monitors)):
    if "primary" in monitors[i]:
        primary = monitors[i]
        del monitors[i]
        break

primary = primary.split(":")[0]
monitors = [x.split(":")[0] for x in monitors]
print(primary, monitors)

def launch_polybar(mon, is_primary):
    env = os.environ.copy()
    env["MONITOR"] = mon
    pid = os.fork()
    if pid == 0:
        os.setsid()
        # create another child
        pid2 = os.fork()
        if pid2 == 0:
            try:
                os.close(0)
                # os.close(1)
                # os.close(2)
            except:
                pass
            os.execve("/usr/bin/polybar", ["/usr/bin/polybar", "--reload", "main" if is_primary else "secondary"], env)
        elif pid < 0:
            print("Failed to create subprocess")
            exit(1)
        else:
            print(pid2)
        exit(0)
    elif pid < 0:
        print("Failed to create subprocess")
        exit(1)

launch_polybar(primary, True)
for m in monitors:
    launch_polybar(m, False)

