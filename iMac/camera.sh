#!/bin/bash

# Define Variables.
YEAR="$(date +%Y)"
DATE="$(date +%Y_%m_%d)"

# Check if SD is inserted, if no card is inserted it does funky things.
[ ! -d "/Volumes/SD" ] && exit

# If current year doesn't exist, make one. (2020+)
mkdir -p $YEAR

# Create Folder in year, by date.
cd ~/Pictures/$YEAR
mkdir $DATE

# CD to Camera SD:
cd /Volumes/SD/DCIM

# Move the Files.
mv * ~/Pictures/$YEAR/$DATE

# Bye.
exit
