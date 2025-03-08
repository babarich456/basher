#!/bin/bash

# Kullanıcıdan girdileri al
read -p "Enter the website URL (e.g., example.com): " WEBSITE_URL
read -p "Number of packets per second: " PACKETS_PER_SECOND
read -p "Duration in seconds: " DURATION

if [ -z "$WEBSITE_URL" ] || [ -z "$PACKETS_PER_SECOND" ] || [ -z "$DURATION" ]; then
    echo "All inputs are required. Please provide Website URL, Number of packets per second, and Duration in seconds."
    exit 1
fi

# nslookup komutunu kullanarak IP adresini bul
IP_ADDRESS=$(nslookup "$WEBSITE_URL" | grep 'Address:' | tail -n 1 | awk '{print $2}')

if [ -z "$IP_ADDRESS" ]; then
    echo "Could not find IP address for $WEBSITE_URL"
    exit 1
fi

if ! command -v hping3 &> /dev/null; then
    echo "hping3 could not be found, please install it first."
    exit 1
fi

echo "Starting load test on $IP_ADDRESS with $PACKETS_PER_SECOND packets per second for $DURATION seconds..."

hping3 -S -p 80 -i u$((1000000 / PACKETS_PER_SECOND)) -c $((PACKETS_PER_SECOND * DURATION)) $IP_ADDRESS

echo "Load test completed."
