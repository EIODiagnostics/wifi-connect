#!/bin/bash
# NAME                UUID                                  TYPE             DEVICE
# WiFi Connect        52bc1f92-c4b7-418b-8ce8-6abb603e6073  802-11-wireless  wlan0
# Wired connection 1  0c6d7629-1a1e-381d-adaf-81dd7a607efb  802-3-ethernet   eth0
# supervisor0         ae518599-1535-4837-a5ec-9b6df788e009  bridge           supervisor0
# WeWork              77ad151f-eaa4-4793-9866-e345b91996c6  802-11-wireless  --

# nm_connections=$(nmcli connection show)


declare _contents=()
while IFS= read -r _line
do
  _contents="${_contents}${_line}"$'\n'
done < sampleConnections.txt
declare nm_connections=$(echo "${_contents}")
echo "${nm_connections}"


declare wifi_networks=$(\
   awk 'NF >= 4 && $(NF-1) == "802-11-wireless" && $(NF) == "--" \
        { \
            print $0; \
        }' <<< "${nm_connections}" \
    )

echo "${wifi_networks}"

# for each $wifi_networks nmcli connection delete WeWork