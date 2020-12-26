#!/bin/bash

SyncthingFolder="/home/user/Syncthing"
DATE="$(date +%Y_%m_%d)"
MySQLPW=""

mysqldump --all-databases --single-transaction --quick --lock-tables=false > /tmp/sql-dump.sql -u root -p$MySQLPW # Dump Entire DB into /tmp/.
rsync -e 'ssh -p 1003' -avzp /tmp/sql-dump.sql user@chasehall.net:$SyncthingFolder/$DATE/WWW-SQL-Dump.sql # Transfer to VM.
rm /tmp/sql-dump.sql # Remove Locally.

tar -cvpzf /tmp/WWW.tar.gz /var/www/* # Backup /var/www/.
rsync -e 'ssh -p 1003' -avzp /tmp/WWW.tar.gz user@chasehall.net:$SyncthingFolder/$DATE/WWW.tar.gz # Transfer to VM.
rm /tmp/WWW.tar.gz # Remove Locally.

rsync -e 'ssh -p 1003' -avzp /etc/apache2/sites-available/www.conf user@chasehall.net:$SyncthingFolder/$DATE/Apache2-www-conf.conf # Transfer to VM.