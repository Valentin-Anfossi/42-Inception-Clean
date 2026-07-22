#!/bin/bash

#Cmd for mounting vbox shared folder
#sudo mount -t vboxsf <name of shared folder> <path mounted in vm>

#INSTALL GIT
sudo apt install git -y
#INSTALL MAKE
sudo apt install make -y
#INSTALL FILEZILLA
sudo apt install filezilla -y

#INSTALL DOCKER
echo "Installing docker ..."
# Remove conflicting packages
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl -y
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

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Docker installed"

#Adding user to docker group
echo "Adding user to docker group ..."
sudo groupadd docker
sudo usermod -aG docker $USER

#Cleaning
sudo apt autoremove -y

#Creating folders for data persistence
echo "Creating data folders ..."
mkdir -p /home/$USERNAME/data/db_data
mkdir -p /home/$USERNAME/data/wp_data

#ADD TO HOSTS vanfossi
echo "Modifying hosts file ..."
if grep -q "$USERNAME.42.fr" /etc/hosts
then
    echo "hosts file already modified"
else
    echo "127.0.0.1 $USERNAME.42.fr" > /tmp/temp_hosts
    cat /etc/hosts >> /tmp/temp_hosts
    sudo mv /tmp/temp_hosts /etc/hosts
    echo "hosts file modified"
fi

#LAUNCH secrets_init.sh
sudo bash ./secrets_init.sh

echo "==================INCEPTION INSTALLED"
echo "PLEASE RELOG FOR DOCKER GROUP REFRESH"
echo "================================OKBYE"
