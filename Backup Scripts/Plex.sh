#!/bin/bash

DestFolder="/home/pi/backups/vms/plex"

rsync -e 'ssh -p 1010' -azrd --delete /media/easystore2/Nextcloud/* pi@ftp.aries.host:$DestFolder/Nextcloud/
rsync -e 'ssh -p 1010' -azrd --delete /var/lib/docker/volumes/* pi@ftp.aries.host:$DestFolder/DockerVols/
