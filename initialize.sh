#ADD TO HOSTS vanfossi
#INSTALL GIT
#INSTALL MAKE
#INSTALL DOCKER
sudo usermod -aG docker $USERNAME
sudo newgrp docker
mkdir -p /home/$USERNAME/data/db_data
mkdir -p /home/$USERNAME/data/wp_data

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