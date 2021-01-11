#!/bin/bash

# Args
MIAB_curl="curl -X PUT --user"
MIAB_Email="ch@chasehall.net"
MIAB_Password=$(<~/MIAB_PW.txt)
DB_PW=$(<~/DB_PW.txt)
MIAB_Link="https://mail.nebulahost.us/admin/dns/custom"
WP_Username="Chase"
Random_PW1=$(bash pwgen.sh)
Random_PW2=$(bash pwgen.sh)


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi
# Check for WP-CLI
if [ ! -e "/usr/local/bin/wp" ]; then
       curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp
fi

read -p 'What domain do you want? (i.e. wp.chse.xyz): ' ServerName_URL
DB_Name=$(echo "${ServerName_URL//.}")

mkdir /var/www/$ServerName_URL
sudo wp cli update
  chown -R www-data:www-data /var/www/$ServerName_URL/
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
    DocumentRoot /var/www/$ServerName_URL
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
cd /var/www/$ServerName_URL/
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress/* .
rm -r wordpress/
rm latest.tar.gz
mysql -uroot -p$DB_PW -e "CREATE DATABASE $DB_Name;"
mysql -uroot -p$DB_PW -e "CREATE USER $DB_Name@localhost IDENTIFIED BY '$Random_PW1';"
mysql -uroot -p$DB_PW -e "GRANT ALL PRIVILEGES ON $DB_Name.* TO '$DB_Name'@'localhost';"
mysql -uroot -p$DB_PW -e "FLUSH PRIVILEGES;"
wp config create --dbname=$DB_Name --dbuser=$DB_Name --dbpass=$Random_PW1 --allow-root
wp core install --url=https://$ServerName_URL --title=$ServerName_URL --admin_user=$WP_Username --admin_password=$Random_PW2 --admin_email=$MIAB_Email --allow-root
wp plugin install maintenance --activate --allow-root
#wp plugin install daggerhart-openid-connect-generic --allow-root
rm -rf /wp-content/themes/twentyfourteen
rm -rf /wp-content/themes/twentyfifteen
rm -rf /wp-content/themes/twentysixteen
wp theme delete twentyseventeen --allow-root
wp theme delete twentynineteen --allow-root
wp site empty --yes --allow-root
wp plugin delete akismet --allow-root
wp plugin delete hello --allow-root
wp rewrite structure '/%postname%/' --allow-root
wp option update default_comment_status closed --allow-root
wp post create --post_type=page --post_status=publish --post_title='Home' --allow-root
wp plugin install all-404-redirect-to-homepage --activate --allow-root
wp plugin install autoptimize --activate --allow-root
wp plugin install insert-headers-and-footers --activate --allow-root
wp plugin install better-wp-security --activate --allow-root
wp plugin install mainwp-child --allow-root
wp plugin install redirection --activate --allow-root
wp plugin install wp-super-cache --activate --allow-root
wp plugin install wordpress-seo --activate --allow-root
wp plugin install adminimize --activate --allow-root
wp plugin install capability-manager-enhanced --activate --allow-root
wp plugin install host-webfonts-local --activate --allow-root
wp plugin install hcaptcha-for-forms-and-more --activate --allow-root
chown -R www-data:www-data /var/www/$ServerName_URL/
#chmod 444 /var/www/$ServerName_URL/wp-config.php
#chmod 444 /var/www/$ServerName_URL/.htaccess
# While recommended, this breaks plugins from adding stuff to htaccess + the config.
clear
echo Add $ServerName_URL to DNS Host Mapping on modem.
echo
echo
echo Your WP Login:
echo https://$ServerName_URL/wp-admin
echo $WP_Username
echo $Random_PW2
echo
echo
echo Go configure all the plugins now.
echo Activate MainWP when ready.
echo
echo
echo Install any additional plugins.
echo     Atomic Blocks
echo     WP Mail SMTP
echo     Contact Form 7
echo     Email Subscribers and Newsletters
echo     Ultimate Member
echo     WooCommerce
