#!/bin/bash

# Usage: sudo ./NewReverseProxy.sh service.domain.tld 192.168.86.1:1111 [We assume http://]

# Args
MIAB_curl="curl -X PUT --user"
MIAB_Email="ch@chasehall.net"
MIAB_Password=$(<~/MIAB_PW.txt)
MIAB_Link="https://mail.nebulahost.us/admin/dns/custom"
ServerName_URL=$1
revvar=$2


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi

  echo "$MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL" >> /root/ddns.sh
  echo "sleep 1" >> /root/ddns.sh
  $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL
  $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL
  
echo "
# BEGIN $ServerName_URL

# HTTP
<VirtualHost *:80>
ServerName $ServerName_URL
Redirect permanent / https://$ServerName_URL/
</VirtualHost>
# HTTP

# HTTPS
<VirtualHost *:443>
    ServerAdmin ch@chasehall.net
    ServerName $ServerName_URL
ProxyPreserveHost On
ProxyPass /.well-known !
<Location />
#Order Deny,Allow
#Deny from all
#Allow from 127.0.0.1 ::1
#Allow from localhost
#Allow from 192.168
#ProxyPass http://192.168.86.XX:XX/
#ProxyPassReverse http://192.168.86.XX:XX/
</Location>
#Include /etc/letsencrypt/options-ssl-apache.conf
#SSLCertificateFile /etc/letsencrypt/live/$ServerName_URL/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$ServerName_URL/privkey.pem
</VirtualHost>
# HTTPS

# END $ServerName_URL
">> /etc/apache2/sites-available/www.conf

sudo systemctl restart apache2
sudo certbot certonly --apache -d $ServerName_URL
sed -i '/#Include \/etc\/letsencrypt\/options-ssl-apache.conf/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateFile \/etc\/letsencrypt\/live\/'$ServerName_URL'\/fullchain.pem/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateKeyFile \/etc\/letsencrypt\/live\/'$ServerName_URL'\/privkey.pem/s/^# *//' /etc/apache2/sites-available/www.conf

sed -i "s/#ProxyPass http:\/\/192.168.86.XX:XX\//ProxyPass http:\/\/$revvar\//g" /etc/apache2/sites-available/www.conf
sed -i "s/#ProxyPassReverse http:\/\/192.168.86.XX:XX\//ProxyPassReverse http:\/\/$revvar\//g" /etc/apache2/sites-available/www.conf
sudo systemctl restart apache2

clear
echo "Add $ServerName_URL to DNS Host Mapping on modem."
