#!/bin/bash

# Start SSH server
/usr/sbin/sshd

# Start Apache2 server
source /etc/apache2/envvars
exec apache2 -D FOREGROUND