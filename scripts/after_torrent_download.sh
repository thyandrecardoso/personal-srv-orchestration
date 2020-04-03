#!/usr/bin/env bash

# This script is to be pointed to by Transmission's configuration, to be executed after a torrent has been downloaded.
# It clears finished torrents older than a day.

DAY_IN_SECONDS=86400

# port, username, password
SERVER="localhost:9091 --auth <USER>:<PASSWORD>"

# use transmission-remote to get torrent list from transmission-remote list
TORRENTLIST=`transmission-remote $SERVER --list | sed -e '1d' -e '$d' | awk '{print $1}' | sed -e 's/[^0-9]*//g'`

# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
    INFO=$(transmission-remote $SERVER --torrent $TORRENTID --info)
    echo -e "Processing #$TORRENTID - $(echo $INFO | sed -e 's/.*Name: \(.*\) Hash.*/\1/')"

    # check if torrent download is completed
    DL_COMPLETED=`echo $INFO | grep "Done: 100%"`
    # check torrents current state is
    STATE_STOPPED=`echo $INFO | grep "State: Seeding\|State: Stopped\|State: Finished\|State: Idle"`

    # if the torrent is "Stopped", "Finished", or "Idle after downloading 100%"
    if [ "$DL_COMPLETED" ] && [ "$STATE_STOPPED" ]; then
        DATE_FINISHED=$(echo "$INFO"| grep 'Date finished' | sed 's/Date finished:[[:space:]]*\(.*\)$/\1/')
        echo -e "Torrent finished in $DATE_FINISHED"
        DATE_FINISHED_SECONDS=`date "+%s" -d "$DATE_FINISHED"`
        DATE_NOW_SECONDS=`date "+%s"`
        DATE_DIFF=$((DATE_NOW_SECONDS - DATE_FINISHED_SECONDS))
	if  [ "$DATE_DIFF" -gt "$DAY_IN_SECONDS" ]; then
            echo "Torrent #$TORRENTID is completed. Removing torrent and data from list."
            transmission-remote $SERVER --torrent $TORRENTID --remove-and-delete
	else
            echo "Torrent #$TORRENTID is not finished for more than a day. Ignoring."
        fi

    else
        echo "Torrent #$TORRENTID is not completed. Ignoring."
    fi
    echo -e "\n"
done
