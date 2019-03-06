#!/usr/bin/env bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket


# setup logging of this script /data/command.log
mkdir -p /data
readonly LOG_LOCATION=/data/command.log
if [ -f $LOG_LOCATION ]; then
#   rm $LOG_LOCATION
fi
exec >> (tee -i $LOG_LOCATION)
exec 2>&1


# Choose a condition for running WiFi Connect according to your use case:

# 1. Is there a default gateway?
# ip route | grep default

# 2. Is there Internet connectivity?
# nmcli -t g | grep full

# 3. Is there Internet connectivity via a google ping?
# wget --spider http://google.com 2>&1

# check for active WiFi Connection regularly 
while true; do
    echo `date` "1. Is there a default gateway?"
    ip route | grep default

    echo `date` " 2. Is there Internet connectivity?"
    nmcli -t g | grep full

    echo `date` " 3. Is there Internet connectivity via a google ping?"
    wget --spider http://google.com 2>&1

    # 4. Is there an active WiFi connection?
    #iwgetid -r

    if [ $? -eq 0 ]; then
        printf 'Skipping WiFi Connect\n'
    else
        printf 'Starting WiFi Connect\n'
        ./wifi-connect --portal-ssid "EIO Camera ${RESIN_DEVICE_NAME_AT_INIT}" --activity-timeout 60
    fi


    # Start your application here. In the background. 
    echo "Use control-c to quit this script"

    sleep 10
done
