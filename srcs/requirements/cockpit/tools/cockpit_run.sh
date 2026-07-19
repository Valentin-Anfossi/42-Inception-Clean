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

if ! grep -q "$COCKPIT_USER:" /etc/passwd ; then
    echo "Creating cockpit user ${COCKPIT_USER}"
    adduser --gecos "" --disabled-password $COCKPIT_USER
    echo "${COCKPIT_USER}:${COCKPIT_PASSWORD}" | chpasswd
    #add to sudo group
    usermod -aG sudo $COCKPIT_USER
else
    echo "cockpit user ${COCKPIT_USER} already exists"
fi

#same thing as ftp, doesnt receive sigterm
"$@" & #Launch CMD in the background (&)
child=$! #Saves the last background pid in child
trap 'kill 15 "$child; wait "$child"' SIGTERM #When SIGTERM execute KILL on child pid
wait "$child" #Waiting for the CHILD to DIE :o