#!/bin/bash
set -e
#set -x ## debug

# change repo to 'latest-stable'
sed -i -e 's/v[0-9]\.[0-9]\{2\}/latest-stable/g' /etc/apk/repositories

# upgrade packages
apk upgrade -Ua --prune && apk -v cache purge && sync

# run iperf3
echo "$(date +'%Y-%m-%d - %H:%M:%S') - iperf3 started successfully."
exec "${@}"
