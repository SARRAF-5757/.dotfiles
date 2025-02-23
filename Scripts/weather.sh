#!/bin/bash

# @raycast.title Weather
# @raycast.author SARRAF
# @raycast.authorURL https://github.com/SARRAF-5757
# @raycast.description Get current weather report from [wttr.in](https://wttr.in/).

# @raycast.icon ⛅
# @raycast.mode inline
# @raycast.packageName Dashboard
# @raycast.schemaVersion 1

## Please be mindful of scalability of wttr.in if adjusting the refresh time:
## currently limited to one million requests per day
## (see https://github.com/chubin/wttr.in/blob/master/share/static/malformed-response.html).
# @raycast.refreshTime 1h

output=$(curl -s https://wttr.in/?format="%c+%f+%w{;}%l")

IFS='{;}' read -ra array <<< "$output"
IFS=',' read -ra location <<< "${array[1]}"

echo "${array[0]} - ${location[0]}"