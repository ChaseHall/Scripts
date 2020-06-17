#!/bin/bash

# Args
miabp1="curl -X PUT --user"
miabemail=""
miabpw=""
miabp2="https://mail.nebulahost.us/admin/dns/custom"
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
  echo "<p>$servn</p>">> /var/www/$servn/index.html

  chown -R www-data:www-data /var/www/$servn/

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
    DocumentRoot /var/www/$servn
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
sudo chown -R www-data:www-data /var/www/$servn
clear
echo =======================================================================
echo Add $servn to DNS Host Mapping on modem.
echo Add content to: /var/www/$servn
fi