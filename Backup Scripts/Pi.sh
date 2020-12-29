#!/bin/bash

SrcFolder="/home/pi/Syncthing"
DestFolder="/home/pi/Backups"
DATE="$(date +%Y_%m_%d)"

mv $SrcFolder/* $DestFolder/ # I don't trust syncthing since you can delete the source from the VMs
find $DestFolder/* -mtime +5 -exec rm -r {} \; # Removes Backups older than 5d. [https://stackoverflow.com/a/31389766]

ssh -p1003 user@chse.xyz 'rm -r /home/user/Syncthing/*' # Empty Syncthing so another sync won't trigger.