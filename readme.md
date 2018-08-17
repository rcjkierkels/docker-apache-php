# Introduction
This is the source for a docker httpd image that can be used to run a php apache environment for developing and production. Its based on the latest debian distro and uses the latest version of PHP. Any PHP version is supported through official PHP images.

## Installation
This image is designed to run on a Virtual Machine (Ubuntu/Debian) with docker daemon. Required is that the virtual machine has a mount to the location where all sites are physically stored (for example your NAS).

Preferably you should auto mount your sites location using /etc/fstab but this is expected:

_mount.nfs 192.168.2.100:/volume1/vm/noveesoft /mnt/synology-kierkels_

The docker directory on the server should be:

_/docker/httpd_

Make sure you checkout this project as a git repository in this directory.
If you boot your VM for the first time or you want to be sure you use the latest version use:

bash _/docker/httpd/rebuild.sh_

This will build a new image and creates a docker container.
The mount should be available before creating the container!

## Configuration
All configuration should be done inside this repository. Add your configs to the config directory.