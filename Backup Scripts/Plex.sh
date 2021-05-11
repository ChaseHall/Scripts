#!/bin/bash

DestFolder="/home/pi/backups/vms/plex"
DATE="$(date +%Y_%m_%d)"

tar -cvpzf /media/easystore2/Nextcloud_Data.tar.gz /media/easystore/Nextcloud/* # Backup /media/easystore/Nextcloud/.
rsync -e 'ssh -p 1010' -avzp /media/easystore2/Nextcloud_Data.tar.gz pi@chse.xyz:$DestFolder/$DATE/Nextcloud_Data.tar.gz # Transfer to VM.
rm /media/easystore2/Nextcloud_Data.tar.gz # Remove Locally.

tar -cvpzf /media/easystore2/DockerVols.tar.gz /var/lib/docker/volumes/* # Backup /var/lib/docker/volumes/.
rsync -e 'ssh -p 1010' -avzp /media/easystore2/DockerVols.tar.gz pi@chse.xyz:$DestFolder/$DATE/DockerVols.tar.gz # Transfer to VM.
rm /media/easystore2/DockerVols.tar.gz # Remove Locally.
