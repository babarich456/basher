#!/bin/bash

# Kullanıcıdan hedef URL'i al
read -p "Enter the target URL (e.g., http://example.com/page?id=1): " TARGET_URL
read -p "Enter the HTTP method (GET or POST): " HTTP_METHOD

if [ -z "$TARGET_URL" ] || [ -z "$HTTP_METHOD" ]; then
    echo "Target URL and HTTP method are required."
    exit 1
fi

# Ekstra seçenekleri almak için
read -p "Do you need to specify additional data (Y/N)? " ADD_DATA
if [[ $ADD_DATA =~ ^[Yy]$ ]]; then
    read -p "Enter the data (e.g., id=1&name=test): " DATA
    read -p "Enter the headers (e.g., User-Agent=Mozilla/5.0): " HEADERS
else
    DATA=""
    HEADERS=""
fi

# sqlmap komutunu oluştur
SQLMAP_CMD="sqlmap -u \"$TARGET_URL\" -r \"$HTTP_METHOD\" --batch --output-dir=./sqlmap-output"
if [ ! -z "$DATA" ]; then
    SQLMAP_CMD="$SQLMAP_CMD --data=\"$DATA\""
fi
if [ ! -z "$HEADERS" ]; then
    SQLMAP_CMD="$SQLMAP_CMD --headers=\"$HEADERS\""
fi

echo "Starting SQL injection test on $TARGET_URL using method $HTTP_METHOD..."

# sqlmap komutunu çalıştır
eval $SQLMAP_CMD

echo "SQL injection test completed. Check the results in the ./sqlmap-output directory."
