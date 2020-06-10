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

cd /var/www/$servn/
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress/* .
rm -r wordpress/
rm latest.tar.gz
#cd wp-content/themes/
#git clone https://github.com/bakesaled/super-minimal.git
#cd .. && cd ..
dbname=$(echo "${servn//.}")
rndpw=$(bash /root/pwgen.sh)
#rndpw2=$(bash pwgen.sh)
mysql -uroot -p[] -e "CREATE DATABASE $dbname;"
mysql -uroot -p[] -e "CREATE USER $dbname@localhost IDENTIFIED BY '$rndpw';"
mysql -uroot -p[] -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbname'@'localhost';"
mysql -uroot -p[] -e "FLUSH PRIVILEGES;"
clear
wp config create --dbname=$dbname --dbuser=$dbname --dbpass=$rndpw --allow-root
wp core install --url=https://$servn --title=$servn --admin_user=Chase --admin_password=$rndpw --admin_email=ch@chasehall.net --allow-root
#wp theme activate super-minimal --allow-root
wp plugin install maintenance --allow-root
wp plugin activate maintenance --allow-root
#wp plugin install two-factor-authentication --allow-root
wp plugin install daggerhart-openid-connect-generic --allow-root
sudo chown -R www-data:www-data /var/www/$servn
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
wp plugin install all-404-redirect-to-homepage --allow-root
wp plugin install autoptimize --allow-root
wp plugin install insert-headers-and-footers --allow-root
wp plugin install better-wp-security --allow-root
wp plugin install mainwp-child --allow-root
wp plugin install redirection --allow-root
wp plugin install wp-super-cache --allow-root
wp plugin install wordpress-seo --allow-root
sudo chown -R www-data:www-data /var/www/$servn
WP_ROOT=/var/www/$servn
#find ${WP_ROOT} -exec chown www-data:www-data {} \;
#find ${WP_ROOT} -type d -exec chmod 755 {} \;
#find ${WP_ROOT} -type f -exec chmod 644 {} \;
#chgrp www-data ${WP_ROOT}/wp-config.php
#chmod 660 ${WP_ROOT}/wp-config.php
#find ${WP_ROOT}/wp-content -exec chgrp www-data {} \;
#find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
#find ${WP_ROOT}/wp-content -type f -exec chmod 755 {} \;
#sudo chmod 666 /var/www/$servn/wp-cron.php
sudo chown -R www-data:www-data /var/www/$servn
clear
echo =======================================================================
echo Setup Done.
echo
echo Add $servn to: https://cmh.pw/dnsm
echo
echo
echo Your WP Login:
echo https://$servn/wp-admin
echo Chase
echo $rndpw
echo
echo
echo Activate ALL plugins [besides MainWP, unless you are ready.]
echo Configure Plugins in this order.
echo
# All these links are dead, whoops.
echo     SSO Plugin - https://cmh.pw/h84a-k
echo     Redirection
echo     iThemes Security - https://cmh.pw/pl5lvo
echo     MainWP Child - https://cmh.pw/8bvcp8
echo     Autoptimize
echo     WP Super Cache
echo     Insert Headers and Footers - https://cmh.pw/ihf
echo     Yoast SEO - https://cmh.pw/8c84yk
echo     iThemes Security - https://cmh.pw/pl5lvo
echo
echo Install additional plugins.
echo     Adminimize
echo     Contact Form 7
echo     Email Subscribers and Newsletters - https://cmh.pw/m74ag5
echo     PublishPress Capabilities
echo     Ultimate Member
echo     WooCommerce
echo     WP Mail SMTP - https://cmh.pw/2mpa17
echo
echo Add new theme.
fi
