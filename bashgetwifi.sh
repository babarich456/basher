#!/bin/bash

# Mevcut Wi-Fi bağlantısını öğren
CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d':' -f2)

if [ -z "$CURRENT_SSID" ]; then
    echo "Currently not connected to any Wi-Fi network."
    exit 1
fi

echo "Currently connected to SSID: $CURRENT_SSID"

# Wi-Fi şifresini öğren
PASSWORD=$(sudo grep -r '^psk=' /etc/NetworkManager/system-connections/ | grep "$CURRENT_SSID" | awk -F'=' '{print $2}')

if [ -z "$PASSWORD" ]; then
    echo "Could not find password for SSID: $CURRENT_SSID"
    exit 1
else
    echo "Password for SSID $CURRENT_SSID: $PASSWORD"
fi
