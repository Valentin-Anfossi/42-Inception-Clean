#!/bin/bash
set -e

#Launch php in background
php-fpm8.2 --nodaemonize &
php_pid=$!

#Launch nginx in background
nginx -g "daemon off;" &
nginx_pid=$!

#Trap sigterm to kill both
trap 'kill -TERM "$php_pid" "$nginx_pid"; wait' SIGTERM

#Wait for one to die
wait -n "$php_pid" "$nginx_pid"