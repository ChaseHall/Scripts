#!/bin/bash

# Define stuff so I can change MIAB info easier.
# Change ddns, 2, 3, 4 aswell.
argxd=""
miabemail=""
miabpass=""
link=""


# Check root
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi
# Take variable from menu.sh and use it.
servn=$1
# Check if already exists
if ! mkdir -p /var/www/$servn; then
echo "Already Exists."
exit 1;
else
# Start the work...
  echo "<p>$servn</p>">> /var/www/$servn/index.html

  chown -R www-data:www-data /var/www/$servn/

  echo "$argxd $miabemail:$miabpass $link/$servn" >> /root/ddns.sh
  echo "sleep 1" >> /root/ddns.sh
  $argxd $miabemail:$miabpass $link/$servn
  $argxd $miabemail:$miabpass $link/$servn
  
echo "
# BEGIN $servn

# HTTP
<VirtualHost *:80>
ServerName $servn
Redirect permanent / https://$servn/
</VirtualHost>
# HTTP

# HTTPS
<VirtualHost *:443>
    ServerAdmin ch@chasehall.net
    ServerName $servn
ProxyPreserveHost On
<Location />
#Order Deny,Allow
#Deny from all
#Allow from 127.0.0.1 ::1
#Allow from localhost
#Allow from 192.168
# Uncomment me ^ to make this website only available at my house.
#ProxyPass http://192.168.86.XX:XX/
#ProxyPassReverse http://192.168.86.XX:XX/
</Location>
#Include /etc/letsencrypt/options-ssl-apache.conf
#SSLCertificateFile /etc/letsencrypt/live/$servn/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$servn/privkey.pem
</VirtualHost>
# HTTPS

# END $servn
">> /etc/apache2/sites-available/www.conf


sudo systemctl restart apache2
sudo certbot certonly --apache -d $servn
sed -i '/#Include \/etc\/letsencrypt\/options-ssl-apache.conf/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateFile \/etc\/letsencrypt\/live\/'$servn'\/fullchain.pem/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateKeyFile \/etc\/letsencrypt\/live\/'$servn'\/privkey.pem/s/^# *//' /etc/apache2/sites-available/www.conf
sudo systemctl restart apache2
clear
echo =======================================================================
echo Setup Done.
echo
echo "Add $servn to: []"
echo "Modify Reverse Proxy in: /etc/apache2/sites-available/www.conf"
fi
