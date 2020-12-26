#!/bin/bash

SyncthingFolder="/home/user/Syncthing"
DATE="$(date +%Y_%m_%d)"

tar -cvpzf /tmp/Docker-Vols-DockerVM.tar.gz /var/lib/docker/volumes/*  # Backup all Docker Volumes.
rsync -e 'ssh -i ~/.ssh/id_rsa -p 1003' -avzp /tmp/Docker-Vols-DockerVM.tar.gz user@chasehall.net:$SyncthingFolder/$DATE/Docker-Vols-DockerVM.tar.gz # Transfer to VM.
rm /tmp/Docker-Vols-DockerVM.tar.gz # Remove Locally.

rsync -e 'ssh -p 1003' -avzp /root/nitter.conf user@chasehall.net:$SyncthingFolder/$DATE/nitter.conf # Transfer to VM.