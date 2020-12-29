#!/bin/bash

SyncthingFolder="/home/user/Syncthing"
DATE="$(date +%Y_%m_%d)"

tar -cvpzf /tmp/MIAB.tar.gz /home/user-data/backup/encrypted/* # Backup MIAB.
rsync -e 'ssh -i ~/.ssh/id_rsa_miab -p 1003' -avzp /tmp/MIAB.tar.gz user@chse.xyz:$SyncthingFolder/$DATE/MIAB.tar.gz # Transfer to VM.
rm /tmp/MIAB.tar.gz # Remove Locally.