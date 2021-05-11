#!/bin/bash

DestFolder="/home/pi/backups/vms/plex"
DATE="$(date +%Y_%m_%d)"

rsync -e 'ssh -p 1010' -azrd --delete /media/easystore/Nextcloud/* pi@chse.xyz:$DestFolder/$DATE/Nextcloud/
rsync -e 'ssh -p 1010' -azrd --delete /var/lib/docker/volumes* pi@chse.xyz:$DestFolder/$DATE/DockerVols/