#!/bin/bash

# Set environment variables

# Name
while true; do
    read -p "Enter your name (lowercase only): " NAME
    if [[ $NAME =~ ^[abcdefghijklmnopqrstuvwxyz]*$ ]]; then
        break
    else
        echo "Invalid name! Please enter a name containing only lowercase letters."
    fi
done

# Password
while true; do
    read -p "Enter your password (only text and numbers): " PASSWORD
    if [[ $PASSWORD =~ ^[a-zA-Z0-9]*$ ]]; then
        break
    else
        echo "Invalid password! Please enter a password with only text and numbers."
    fi
done

# Email
while true; do
    read -p "Enter your email: " EMAIL
    if [[ $EMAIL =~ @.*\. ]]; then
        break
    else
        echo "Invalid email! Please enter a valid email address."
    fi
done

# Mnemonic
while true; do
    read -p "Enter your mnemonic: " MNEMONIC
    VALID_MNEMONIC=($MNEMONIC)
    if [[ ${#VALID_MNEMONIC[@]} -eq 12 ]]; then
        echo "Valid mnemonic."
        break
    else
        echo "Invalid mnemonic! Please enter exactly 12 words."
    fi
done

# Set port numbers
read -p "Enter the port number for Dropbox (default 3400): " DROPBOX_PORT
DROPBOX_PORT=${DROPBOX_PORT:-3400}
read -p "Enter the port number for IPFS (default 4444): " IPFS_PORT
IPFS_PORT=${IPFS_PORT:-4444}
read -p "Enter the port number for PgAdmin (default 4445): " PGADMIN_PORT
PGADMIN_PORT=${PGADMIN_PORT:-4445}
read -p "Enter the port number for Ganache (default 8545): " GANACHE_PORT
GANACHE_PORT=${GANACHE_PORT:-8545}
read -p "Enter the port number for MongoExpress (default 4446): " MONGOEX_PORT
MONGOEX_PORT=${MONGOEX_PORT:-4446}

#!/bin/bash

# Create data folder if it doesn't exist
if [ ! -d "volumes" ]; then
    mkdir "volumes"
fi

# Create subfolders inside data folder
if [ ! -d "volumes/ganache" ]; then
    mkdir "volumes/ganache"
fi

if [ ! -d "volumes/ipfs/data" ]; then
    mkdir "volumes/ipfs/data"
fi

if [ ! -d "volumes/ipfs/ipfs" ]; then
    mkdir "volumes/ipfs/ipfs"
fi

if [ ! -d "volumes/ipfs/ipns" ]; then
    mkdir "volumes/ipfs/ipns"
fi

if [ ! -d "volumes/mongodb" ]; then
    mkdir "volumes/mongodb"
fi

if [ ! -d "volumes/pgadmin" ]; then
    mkdir "volumes/pgadmin"
fi

if [ ! -d "dropbox" ]; then
    mkdir "dropbox"
fi

# Generate .env file
echo "NAME=${NAME}" > .env
echo "PASSWORD=${PASSWORD}" >> .env
echo "EMAIL=${EMAIL}" >> .env
echo "MNEMONIC=${MNEMONIC}" >> .env
echo "DROPBOX_PORT=${DROPBOX_PORT:-3400}" >> .env
echo "IPFS_PORT=${IPFS_PORT:-4444}" >> .env
echo "PGADMIN_PORT=${PGADMIN_PORT:-4445}" >> .env
echo "GANACHE_PORT=${GANACHE_PORT:-8545}" >> .env
echo "MONGOEX_PORT=${MONGOEX_PORT:-4446}" >> .env
echo ".env file created successfully!"

# Download docker-compose.yml file
curl -o docker-compose.yml 'https://raw.githubusercontent.com/rumsan/rs-devtools/main/core-apps/docker-compose.yml'

# Start docker containers
docker-compose up -d

rm setupLinux.sh