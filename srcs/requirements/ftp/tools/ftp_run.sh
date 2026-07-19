#!/bin/bash
set -e

#Get secrets from the very secret secretive secret files of secrets (oooo)
load_secrets() {
    local secrets_dir="/run/secrets"
    [ -d "$secrets_dir" ] || return 0

    for secret_file in "$secrets_dir"/*; do
        [ -f "$secret_file" ] || continue
        set -a
        source "$secret_file"
        set +a
    done
}

load_secrets

if ! grep -q "$FTP_USER:" /etc/passwd ; then
    echo "Creating ftp user ${FTP_USER}"

    #add the ftp_user to users and vsftpd userlist
    adduser --gecos "" --disabled-password $FTP_USER
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
    echo $FTP_USER | tee -a /etc/vsftpd.userlist
else
    echo "ftp user ${FTP_USER} already exists"
fi

# vsftpd doesnt receive sigterm from docker (idk why)
"$@" & #Launch CMD in the background (&)
child=$! #Saves the last background pid in child
trap 'kill 15 "$child; wait "$child"' SIGTERM #When SIGTERM execute KILL on child pid
wait "$child" #Waiting for the CHILD to DIE :o