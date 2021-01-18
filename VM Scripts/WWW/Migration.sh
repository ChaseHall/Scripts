#!/bin/bash

# Args
MIAB_curl="curl -X DELETE --user"
MIAB_curl2="curl -X PUT --user"
MIAB_Email="ch@chasehall.net"
MIAB_Password=$(<~/MIAB_PW.txt)
MIAB_Link="https://mail.nebulahost.us/admin/dns/custom"


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi

read -p 'What domain are we killing off: ' OldDomain
read -p 'What domain are we switching to: ' NewDomain
echo Kill the HTTPS for $OldDomain.
read -p "Press enter to continue..."
sudo certbot delete
$MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$OldDomain
mv /var/www/$OldDomain /var/www/$NewDomain
$MIAB_curl2 $MIAB_Email:$MIAB_Password $MIAB_Link/$NewDomain
$MIAB_curl2 $MIAB_Email:$MIAB_Password $MIAB_Link/$NewDomain
sed -i -e 's/'$OldDomain'.*$/'$NewDomain'/g' /root/ddns.sh
sed -i -e 's/'$OldDomain'.*$/'$NewDomain'/g' /etc/apache2/sites-available/www.conf

clear
echo Find $NewDomain HTTPS things Include, SSLCertificateFile, SSLCertificateKeyFile and comment them out.
read -p "Press enter to continue..."
vim /etc/apache2/sites-available/www.conf
sudo systemctl restart apache2

sudo certbot certonly --apache -d $NewDomain
sed -i '/#Include \/etc\/letsencrypt\/options-ssl-apache.conf/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateFile \/etc\/letsencrypt\/live\/'$NewDomain'\/fullchain.pem/s/^# *//' /etc/apache2/sites-available/www.conf
sed -i '/#SSLCertificateKeyFile \/etc\/letsencrypt\/live\/'$NewDomain'\/privkey.pem/s/^# *//' /etc/apache2/sites-available/www.conf
sudo systemctl restart apache2

clear

echo "Use the WP Plugin: Better Search Replace and replace all instances of the old url to the new one."
echo "Replace Emails Admin Accs etc)"
echo "Update Plugin specific things (WP Mail, cron @ Email Subscribers, Yoast SEO)."
echo "Update Search Consoles."
echo "    Google: https://search.google.com/search-console"
echo "    Bing: https://www.bing.com/webmaster/home/mysites"


echo Add $NewDomain to DNS Host Mapping on modem.