#!/bin/bash

YEAR="$(date +%Y)"
DATE="$(date +%Y_%m_%d)"

[ ! -d "/Volumes/SD" ] && exit # Exit if SD Card isn't detected.

cd ~/Pictures/
mkdir -p $YEAR # Create year folder if doesn't exist (i.e. 2021)

cd ~/Pictures/$YEAR
mkdir $DATE # Setup folder structure

mv /Volumes/SD/DCIM/* ~/Pictures/$YEAR/$DATE # Doing the actual move now.

exit