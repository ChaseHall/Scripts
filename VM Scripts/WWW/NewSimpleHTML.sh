#!/bin/bash

# Args
MIAB_curl="curl -X PUT --user"
MIAB_Email="ch@chasehall.net"
MIAB_Password=$(<~/MIAB_PW.txt)
MIAB_Link="https://mail.nebulahost.us/admin/dns/custom"
ServerName_URL=$1


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi

mkdir /var/www/$ServerName_URL
  chown -R www-data:www-data /var/www/$ServerName_URL/
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
    DocumentRoot /var/www/$ServerName_URL
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
sudo systemctl restart apache2
clear
echo Add $ServerName_URL to DNS Host Mapping on modem.
echo Add content to: /var/www/$ServerName_URL