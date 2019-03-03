#!/usr/bin/env python3
"""
Delete all known wifi connection credentials so we can test the wifi-connect interface

$ nmcli connection show
NAME                UUID                                  TYPE             DEVICE
WiFi Connect        0933fe0e-fbee-45f3-832a-9e601b7a8bcb  802-11-wireless  wlan0
Wired connection 1  0c6d7629-1a1e-381d-adaf-81dd7a607efb  802-3-ethernet   eth0
supervisor0         ae518599-1535-4837-a5ec-9b6df788e009  bridge           supervisor0

$ nmcli connection add type 802-11-wireless ifname wlan0 ssid WeWork

$ nmcli connection show
NAME                UUID                                  TYPE             DEVICE
WiFi Connect        0933fe0e-fbee-45f3-832a-9e601b7a8bcb  802-11-wireless  wlan0
Wired connection 1  0c6d7629-1a1e-381d-adaf-81dd7a607efb  802-3-ethernet   eth0
supervisor0         ae518599-1535-4837-a5ec-9b6df788e009  bridge           supervisor0
wifi-wlan0          2e8df048-2d1d-42a0-890f-26d394738098  802-11-wireless  --

"""

import NetworkManager

for conn in NetworkManager.Settings.ListConnections():
    settings = conn.GetSettings()['connection']
    if settings['type'] == '802-11-wireless':
        if settings['id'] != 'WiFi Connect':
            print('Deleting {}'.format(settings))
            conn.Delete()
