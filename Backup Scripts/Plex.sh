#!/bin/bash

SyncthingFolder="/home/user/Syncthing"
DATE="$(date +%Y_%m_%d)"

mkdir $SyncthingFolder/"$DATE"

tar -cvpzf $SyncthingFolder/"$DATE"/"$DATE"_Nextcloud.tar.gz /media/easystore/Nextcloud/* --exclude="$DATE"_Nextcloud.tar.gz # Backup Nextcloud.
tar -cvpzf $SyncthingFolder/"$DATE"/"$DATE"_Docker-Vols.tar.gz /var/lib/docker/volumes/* --exclude="$DATE"_Docker-Vols.tar.gz # Backup Docker Volumes.

sudo chown -R user:user $SyncthingFolder # Fix perms for WWW-Backup since for some reason it needs it.