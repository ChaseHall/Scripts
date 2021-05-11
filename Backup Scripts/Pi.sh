#!/bin/bash

SrcFolder="/home/pi/backups/vms"
DATE="$(date +%Y_%m_%d)"

mkdir $SrcFolder/plex/"$DATE"
mkdir $SrcFolder/www/"$DATE"

find $SrcFolder/* -mtime +5 -exec rm -r {} \; # Removes Backups older than 5d. [https://stackoverflow.com/a/31389766]
