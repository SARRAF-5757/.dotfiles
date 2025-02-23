#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title System Info
# @raycast.mode inline
# @raycast.refreshTime 5s
# @raycast.packageName Dashboard

# Optional parameters:
# @raycast.icon ⚙️

cpu_mem=$(ps -A -o %cpu,%mem | awk '{ cpu += $1; mem += $2} END {print "CPU: "cpu"% MEM: "mem"%"}')

echo "${cpu_mem}"