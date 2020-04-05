#!/usr/bin/env bash

# I wrote this because I was not able to make mdadm default mechanism to work.
# installing postfix was not an option for me, so, I tried using the `PROGRAM` in the
# mdadm configuration file to point to a bash script that would then send a notification
# However, I was not able to test this, either by manually failing one of the drives, or
# physically removing a drive from the array... :S
# There is a monitor that should be able to deal with these things. Look at:
# - /lib/systemd/system/mdmonitor.service
# - /etc/cron.d/mdadm
#
# As an alternative, I use this.

# valid states for the array devices
valid_states=("clean active")
# list raid devices
devices=$(mdadm --query /dev/md/* | sed  -E "s/^(.*):.*$/\\1/")

# loop over list of devices and check state
while IFS= read -r device; do
    echo "Now checking details of $device..."

    details=$(mdadm -vQD "$device")
    state=$(echo "$details" | grep 'State :' | sed -E 's/^\s*State : (\w+)\s*$/\1/')
    json_details=$(echo "$details" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))')


    if [[ ! " ${valid_states[@]} " =~ " ${state} " ]]; then
	    echo "Device $device is not in an expected state!"
	    echo "$details"
	    title="Unexpected status for $device RAID!!"

	    /usr/bin/curl \
		    --header 'Access-Token: <ACCESS_TOKEN>' \
		    --header 'Content-Type: application/json' \
		    -XPOST https://api.pushbullet.com/v2/pushes \
		    --data-binary '{"type": "note", "title": "'"$title"'", "body": '"$json_details"'}'

    fi
done <<< "$devices"
