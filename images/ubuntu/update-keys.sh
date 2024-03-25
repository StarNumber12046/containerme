#!/bin/bash

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 
    exit 1
fi

# Define the folder containing SSH public keys
SSH_KEY_FOLDER="/keys"

# Check if the folder exists
if [ ! -d "$SSH_KEY_FOLDER" ]; then
    echo "SSH key folder not found: $SSH_KEY_FOLDER"
    exit 1
fi

# Create the .ssh folder for root if it doesn't exist
ROOT_SSH_FOLDER="/root/.ssh"
if [ ! -d "$ROOT_SSH_FOLDER" ]; then
    mkdir -p "$ROOT_SSH_FOLDER"
fi

# Iterate over each file in the folder
for file in "$SSH_KEY_FOLDER"/*; do
    if [ -f "$file" ]; then
        key=$(cat "$file")
        
        # Install the SSH key for root
        echo "$key" >> "/root/.ssh/authorized_keys"
        chmod 600 "/root/.ssh/authorized_keys"

        echo "SSH key installed for root"
    fi
done

echo "All SSH keys installed successfully for root"

