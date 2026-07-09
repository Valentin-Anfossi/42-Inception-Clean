#!/bin/bash

# Update and install openssl
sudo apt update
sudo apt install openssl -y

# Add Docker's official GPG key:
sudo apt install ca-certificates curl linux-utils-extra make 
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update
sudo apt update

# Install Docker Engine, containerd, and Docker Compose:
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl status docker
sudo systemctl start docker

# Adds user to docker group
sudo usermod -aG docker $USERNAME
sudo newgrp docker

# Create data directories
mkdir -p /home/$USERNAME/data/db_data
mkdir -p /home/$USERNAME/data/wp_data

# Modify hosts file
echo "========== MODIFYING HOSTS FILE =========="
if grep -q "vanfossi.42.fr" /etc/hosts
then
    echo "hosts file already modified"
else
    echo "127.0.0.1 vanfossi.42.fr" > /tmp/temp_hosts
    cat /etc/hosts >> /tmp/temp_hosts
    sudo mv /tmp/temp_hosts /etc/hosts
    echo "hosts file modified"
fi

# Create secrets files
mkdir ./secrets
echo "========== CREATING SECRETS FILES =========="
if [ ! -f ./secrets/sql_credentials.txt ]; then
    echo "Creating sql_credentials.txt..."
    echo "SQL_ROOT_PASSWORD ?"
    read -r value
    echo "SQL_ROOT_PASSWORD=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_USER ?"
    read -r value
    echo "SQL_USER=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_PASSWORD ?"
    read -r value
    echo "SQL_PASSWORD=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_ADMIN ?"
    read -r value
    echo "SQL_ADMIN=$value" >> ./secrets/sql_credentials.txt
    echo "SQL_ADMINPASSWORD ?"
    read -r value
    echo "SQL_ADMINPASSWORD=$value" >> ./secrets/sql_credentials.txt
    echo "sql_credentials.txt created."
fi

if [ ! -f ./secrets/wp_credentials.txt ]; then
    echo "Creating wp_credentials.txt..."
    echo "WP_ADMIN_USER ?"
    read -r value
    echo "WP_ADMIN_USER=$value" >> ./secrets/wp_credentials.txt
    echo "WP_ADMIN_PASSWORD ?"
    read -r value
    echo "WP_ADMIN_PASSWORD=$value" >> ./secrets/wp_credentials.txt
    echo "WP_ADMIN_EMAIL ?"
    read -r value
    echo "WP_ADMIN_EMAIL=$value" >> ./secrets/wp_credentials.txt
    echo "wp_credentials.txt created."
fi