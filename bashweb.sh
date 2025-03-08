#!/bin/bash

# Kullanıcıdan web sitesi URL'sini al
read -p "Enter the website URL (e.g., example.com): " WEBSITE_URL

if [ -z "$WEBSITE_URL" ]; then
    echo "Website URL is required."
    exit 1
fi

# nslookup komutunu kullanarak IP adresini bul
IP_ADDRESS=$(nslookup "$WEBSITE_URL" | grep 'Address:' | tail -n 1 | awk '{print $2}')

if [ -z "$IP_ADDRESS" ]; then
    echo "Could not find IP address for $WEBSITE_URL"
    exit 1
else
    echo "The IP address for $WEBSITE_URL is: $IP_ADDRESS"
fi
