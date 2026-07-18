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

echo "Creating ftp user ${FTP_USER} with password ${FTP_PASSWORD}"

ENCRYPTED_PASSWORD=$(openssl passwd -noverify "${FTP_PASSWORD}")

useradd -m -p $ENCRYPTED_PASSWORD $FTP_USER

echo $FTP_USER | tee -a /etc/vsftpd.userlist

exec "$@"

