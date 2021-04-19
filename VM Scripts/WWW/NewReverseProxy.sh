#!/bin/bash

# Usage: sudo ./NewReverseProxy.sh service.domain.tld 192.168.86.1:1111 [We assume http://]

# Args
MIAB_curl="curl -X PUT --user"
MIAB_Email="ch@chasehall.net"
MIAB_Password=$(<~/MIAB_PW.txt)
MIAB_Link="https://mail.aries.host/admin/dns/custom"


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi

read -p 'New Reverse Proxy Domain (i.e. service.chse.xyz): ' ServerName_URL
read -p 'What is getting reverse proxyd (i.e. 192.168.86.1:1111) [We assume http://] ' RevVar

  echo "$MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL" >> /root/ddns.sh
  echo "sleep 1" >> /root/ddns.sh
  $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL
  $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL
  
echo "<VirtualHost *:80>
ServerName $ServerName_URL
Redirect permanent / https://$ServerName_URL/
</VirtualHost>

<VirtualHost *:443>
ServerAdmin c@chse.xyz
ServerName $ServerName_URL
<IfModule mod_headers.c>
Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\"
Header always set Permissions-Policy: interest-cohort=()
</IfModule>
ProxyPreserveHost On
ProxyPass /.well-known !
<Location />
#ProxyPass http://192.168.86.XX:XX/
#ProxyPassReverse http://192.168.86.XX:XX/
</Location>
#Include /etc/letsencrypt/options-ssl-apache.conf
#SSLCertificateFile /etc/letsencrypt/live/$ServerName_URL/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$ServerName_URL/privkey.pem
</VirtualHost>
" >> /etc/apache2/sites-available/www.conf

sudo systemctl restart apache2
sudo certbot certonly --apache -d $ServerName_URL
sed -i '/#Include \/etc\/letsencrypt\/options-ssl-apache.conf/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateFile \/etc\/letsencrypt\/live\/'$ServerName_URL'\/fullchain.pem/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateKeyFile \/etc\/letsencrypt\/live\/'$ServerName_URL'\/privkey.pem/s/^# *//' /etc/apache2/sites-available/www.conf

sed -i "s/#ProxyPass http:\/\/192.168.86.XX:XX\//ProxyPass http:\/\/$RevVar\//g" /etc/apache2/sites-available/www.conf
sed -i "s/#ProxyPassReverse http:\/\/192.168.86.XX:XX\//ProxyPassReverse http:\/\/$RevVar\//g" /etc/apache2/sites-available/www.conf
sudo systemctl restart apache2

clear
echo "Add $ServerName_URL to DNS Host Mapping on modem."
