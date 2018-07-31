#!/bin/bash

# Mount
#mount 192.168.2.100:/volume1/vm/noveesoft /mnt/synology-kierkels

# Start SSH server
/usr/sbin/sshd

# Start Apache2 server
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
