#!/bin/bash

Location="Hall@192.168.86.31:/media/easystore/Backups/iMac"
RsyncPart="rsync -e 'ssh -p 1003' -avzp /Users/Hall"

$RsyncPart/Desktop/* $Location/Desktop/
$RsyncPart/Documents/* $Location/Documents/
$RsyncPart/Pictures/* $Location/Pictures/
$RsyncPart/Music/* $Location/Music/
$RsyncPart/Movies/* $Location/Movies/
pmset sleepnow

exit