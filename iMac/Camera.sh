#!/bin/bash

YEAR="$(date +%Y)"
DATE="$(date +%Y_%m_%d)"

[ ! -d "/Volumes/SD" ] && exit

cd ~/Pictures/
mkdir -p $YEAR

cd ~/Pictures/$YEAR
mkdir $DATE

mv /Volumes/SD/DCIM/* ~/Pictures/$YEAR/$DATE

exit