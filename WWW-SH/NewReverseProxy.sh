#!/bin/bash

# Args
miabp1="curl -X PUT --user"
miabemail=""
miabpw=""
miabp2="https://mail.nebulahost.us/admin/dns/custom"
dbpw=""
# Args (Not user gen'd)
servn=$1


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi
if ! mkdir -p /var/www/$servn; then
echo "Already Exists."
exit 1;
else
  # Begin installing...
  echo "$miabp1 $miabemail:$miabpw $miabp2/$servn" >> /root/ddns.sh
  echo "sleep 1" >> /root/ddns.sh
  $miabp1 $miabemail:$miabpw $miabp2/$servn
  $miabp1 $miabemail:$miabpw $miabp2/$servn
  
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
#
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
echo "Add $servn to DNS Host Mapping on modem."
echo "Modify ProxyPass with cfg"
fi