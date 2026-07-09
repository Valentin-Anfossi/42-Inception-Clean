#!/bin/bash

# Update and install openssl
sudo apt update
sudo apt install openssl

# Add Docker's official GPG key:
sudo apt install ca-certificates curl
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
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl status docker
sudo systemctl start docker

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

# Create gitHub ssh key
ssh-keygen -t ed25519 -C "vanfossi@student.42nice.fr"
ssh-keygen -t ed25519 -C "vanfossi@student.42nice.fr" -f ~/.ssh/inception -q -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/inception
echo "============ SSH PUBLIC KEY : ============"
cat ~/.ssh/inception.pub
echo "=========================================="