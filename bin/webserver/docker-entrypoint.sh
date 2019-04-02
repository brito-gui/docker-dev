#!/bin/sh
set -e

# Set right permissions to ssh key
mkdir -p /root/.ssh/
cp -R /tmp/.ssh/* /root/.ssh/
chmod 700 /root/.ssh
chmod 600 /root/.ssh/id_rsa

# Apache2 foreground
/usr/sbin/apache2ctl -D FOREGROUND

exec "$@"
