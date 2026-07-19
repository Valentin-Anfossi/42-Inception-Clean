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

echo "Creating cockpit user ${COCKPIT_USER}"
#add the cockpit_user to users
adduser --gecos "" --disabled-password $COCKPIT_USER
echo "${COCKPIT_USER}:${COCKPIT_PASSWORD}" | chpasswd
usermod -aG sudo $COCKPIT_USER

#Launch nginx in background
./usr/lib/cockpit/cockpit-ws --no-tls &
cockpit_pid=$!

#Trap sigterm to kill both
trap 'kill -TERM "$php_pid" "$cockpit_pid"; wait' SIGTERM

#Wait for one to die
wait "$cockpit_pid"

exec "$@"