#!/bin/bash

# Args
miabp1="curl -X PUT --user"
miabemail=""
miabpw=""
miabp2="https://mail.nebulahost.us/admin/dns/custom"
dbpw=""
wpuser="Chase"
# Args (Not user gen'd)
servn=$1
dbname=$(echo "${servn//.}")
rndpw=$(bash /root/pwgen.sh)
rndpw2=$(bash /root/pwgen.sh)


# Checking things...
if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi
# Check for WP-CLI
if [ ! -e "/usr/local/bin/wp" ]; then
       curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp
# Check if dir exists
if ! mkdir -p /var/www/$servn; then
echo "Already Exists."
exit 1;
else
  # Begin installing...
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
cd /var/www/$servn/
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress/* .
rm -r wordpress/
rm latest.tar.gz
mysql -uroot -p$dbpw -e "CREATE DATABASE $dbname;"
mysql -uroot -p$dbpw -e "CREATE USER $dbname@localhost IDENTIFIED BY '$rndpw';"
mysql -uroot -p$dbpw -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbname'@'localhost';"
mysql -uroot -p$dbpw -e "FLUSH PRIVILEGES;"
wp config create --dbname=$dbname --dbuser=$dbname --dbpass=$rndpw --allow-root
wp core install --url=https://$servn --title=$servn --admin_user=$wpuser --admin_password=$rndpw2 --admin_email=$miabemail --allow-root
wp plugin install maintenance --activate --allow-root
wp plugin install daggerhart-openid-connect-generic --allow-root
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
chown -R www-data:www-data /var/www/$servn/
sudo systemctl restart apache2
clear
echo Add $servn to DNS Host Mapping on modem.
echo
echo
echo Your WP Login:
echo https://$servn/wp-admin
echo Chase
echo $rndpw2
echo
echo
echo Go configure all the plugins now.
echo Activate MainWP when ready, and OpenID-Connect.
echo
echo
echo Install any additional plugins.
echo     WP Mail SMTP
echo     Contact Form 7
echo     Email Subscribers and Newsletters
echo     Ultimate Member
echo     WooCommerce
fi