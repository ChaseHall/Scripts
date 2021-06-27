#!/bin/bash

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
read -p 'Where are we coming from? (i.e. source.chse.xyz): ' ServerName_URL
read -p "Where should $ServerName_URL go to? (dest.chse.xyz) [We assume HTTPS.] " DestVar
  echo "\$MIAB_curl \$MIAB_Email:\$MIAB_Password \$MIAB_Link/$ServerName_URL" >> /root/ddns.sh
  echo "sleep 1" >> /root/ddns.sh
  $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL
  $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$ServerName_URL
  
echo "<VirtualHost *:80>
ServerName $ServerName_URL
Redirect permanent / https://$ServerName_URL/
</VirtualHost>

<VirtualHost *:443>
ServerAdmin c@chse.dev
ServerName $ServerName_URL
Redirect permanent / https://$DestVar/
<IfModule mod_headers.c>
Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\"
Header always set Permissions-Policy: interest-cohort=()
</IfModule>
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
sudo systemctl restart apache2
clear
echo Add $ServerName_URL to DNS Host Mapping on modem.