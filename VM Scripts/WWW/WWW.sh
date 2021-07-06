#!/bin/bash

# I'm sure I broke something, so dropping this here.
# https://github.com/ChxseH/Scripts/tree/7a30d8fdaaff9e39ad6d154bd31e676ec5414795/VM%20Scripts/WWW

# Global Variables
apache_file="/etc/apache2/sites-available/www.conf"
apache_server_admin="c@chse.dev"

# Check for root, and bail if not root.
if [ "$(whoami)" != 'root' ]; then
    echo -e "Error: You have to execute this script as root.\nMaybe try running the following command:\nsudo !!"
    exit 1
fi

# Do we have dialog?
if ! [ -x "$(command -v dialog)" ]; then
    echo -e "Error: dialog is not installed.\nMaybe try running the following command:\nsudo apt install dialog -y" >&2
    exit 1
fi

# Generate two random passwords, one for the user account, and one for the database if needed.
generatePassword(){
    passwordLength=128
    local generatedPassword=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-$passwordLength};echo;)
    echo "$generatedPassword"
}
generatedPassword1="$(generatePassword)"
generatedPassword2="$(generatePassword)"

doHTTPS(){
    sudo systemctl restart apache2
    sudo certbot certonly --apache -d $1
    sed -i '/#Include \/etc\/letsencrypt\/options-ssl-apache.conf/s/^# *//' $apache_file
    sed -i '/#SSLCertificateFile \/etc\/letsencrypt\/live\/'$1'\/fullchain.pem/s/^# *//' $apache_file
    sed -i '/#SSLCertificateKeyFile \/etc\/letsencrypt\/live\/'$1'\/privkey.pem/s/^# *//' $apache_file
    sudo systemctl restart apache2
}

doSimpleHTML(){
    mkdir /var/www/$1
    chown -R www-data:www-data /var/www/$1/
echo "<VirtualHost *:80>
ServerName $1
Redirect permanent / https://$1/
</VirtualHost>

<VirtualHost *:443>
ServerAdmin $apache_server_admin
ServerName $1
DocumentRoot /var/www/$1
<IfModule mod_headers.c>
Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\"
Header always set Permissions-Policy: interest-cohort=()
</IfModule>
#Include /etc/letsencrypt/options-ssl-apache.conf
#SSLCertificateFile /etc/letsencrypt/live/$1/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$1/privkey.pem
</VirtualHost>
" >> $apache_file
    doHTTPS "$1"
    echo "ErrorDocument 404 https://$1" >> /var/www/$1/.htaccess
    clear
}

doRedirect(){
    # $1 is where we came from  [i.e. troll.chse.dev]
    # $2 is where we are going  [i.e. youtube.com/watch?v=fwjeoi]
echo "<VirtualHost *:80>
ServerName $1
Redirect permanent / https://$1/
</VirtualHost>

<VirtualHost *:443>
ServerAdmin $apache_server_admin
ServerName $ServerName_URL
Redirect permanent / https://$2/
<IfModule mod_headers.c>
Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\"
Header always set Permissions-Policy: interest-cohort=()
</IfModule>
#Include /etc/letsencrypt/options-ssl-apache.conf
#SSLCertificateFile /etc/letsencrypt/live/$1/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$1/privkey.pem
</VirtualHost>
" >> $apache_file
doHTTPS "$1"
}

doReverseProxy(){
    # $1 is our hostname  [i.e. troll.chse.dev]
    # $2 is where we are going  [i.e. 192.168.86.199:13337]
echo "<VirtualHost *:80>
ServerName $1
Redirect permanent / https://$1/
</VirtualHost>

<VirtualHost *:443>
ServerAdmin $apache_server_admin
ServerName $1
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
#SSLCertificateFile /etc/letsencrypt/live/$1/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$1/privkey.pem
</VirtualHost>
" >> $apache_file
sed -i "s/#ProxyPass http:\/\/192.168.86.XX:XX\//ProxyPass http:\/\/$2\//g" $apache_file
sed -i "s/#ProxyPassReverse http:\/\/192.168.86.XX:XX\//ProxyPassReverse http:\/\/$2\//g" $apache_file
doHTTPS "$1"
}

doWordPress(){
    DB_Name=$(echo "${1//.}")
    DB_PW=$(<~/DB_PW.txt)
    WP_Username="Chase"

    # Check for WP-CLI
    if [ ! -e "/usr/local/bin/wp" ]; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp
    fi
    sudo wp cli update
    mkdir /var/www/$1
    chown -R www-data:www-data /var/www/$1/
echo "<VirtualHost *:80>
ServerName $1
Redirect permanent / https://$1/
</VirtualHost>

<VirtualHost *:443>
ServerAdmin $apache_server_admin
ServerName $1
DocumentRoot /var/www/$1
<IfModule mod_headers.c>
Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\"
Header always set Permissions-Policy: interest-cohort=()
</IfModule>
#Include /etc/letsencrypt/options-ssl-apache.conf
#SSLCertificateFile /etc/letsencrypt/live/$1/fullchain.pem
#SSLCertificateKeyFile /etc/letsencrypt/live/$1/privkey.pem
</VirtualHost>
" >> $apache_file
    doHTTPS "$1"
    cd /var/www/$1/
    wget http://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    mv wordpress/* .
    rm -r wordpress/
    rm latest.tar.gz
    mysql -uroot -p$DB_PW -e "CREATE DATABASE $DB_Name;"
    mysql -uroot -p$DB_PW -e "CREATE USER $DB_Name@localhost IDENTIFIED BY '$generatedPassword1';"
    mysql -uroot -p$DB_PW -e "GRANT ALL PRIVILEGES ON $DB_Name.* TO '$DB_Name'@'localhost';"
    mysql -uroot -p$DB_PW -e "FLUSH PRIVILEGES;"
    wp config create --dbname=$DB_Name --dbuser=$DB_Name --dbpass=$generatedPassword1 --allow-root
    wp core install --url=https://$1 --title=$1 --admin_user=$WP_Username --admin_password=$generatedPassword2 --admin_email=$apache_server_admin --allow-root
    wp plugin install maintenance --activate --allow-root
    wp theme delete twentynineteen --allow-root
    wp theme delete twentytwenty --allow-root
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
    wp plugin install redirection --activate --allow-root
    wp plugin install wp-super-cache --activate --allow-root
    wp plugin install wordpress-seo --activate --allow-root
    wp plugin install adminimize --activate --allow-root
    wp plugin install capability-manager-enhanced --activate --allow-root
    wp plugin install host-webfonts-local --activate --allow-root
    wp plugin install hcaptcha-for-forms-and-more --activate --allow-root
    chown -R www-data:www-data /var/www/$1/

    clear
    echo Your WP Login:
    echo https://$1/wp-admin
    echo $WP_Username
    echo $Random_PW2
    echo
    echo
    echo Go configure all the plugins now.
    echo
    echo
    echo Install any additional plugins.
    echo     Atomic Blocks
    echo     WP Mail SMTP
    echo     Contact Form 7
    echo     Email Subscribers and Newsletters
    echo     Ultimate Member
    echo     WooCommerce
}

MIAB_DDNS(){
    MIAB_curl="curl -X PUT --user"
    MIAB_Email="ch@chasehall.net"
    MIAB_Password=$(<~/MIAB_PW.txt)
    MIAB_Link="https://mail.aries.host/admin/dns/custom"

    echo "\$MIAB/$1" >> /root/ddns.sh
    echo "sleep 3" >> /root/ddns.sh
    # We run this twice just because MIAB drops the ball, sometimes.
    $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$1
    $MIAB_curl $MIAB_Email:$MIAB_Password $MIAB_Link/$1
}

postCF(){
    ip=$(curl -4 https://icanhazip.com/)
    auth_email="cf@chse.dev"
    auth_key=$(<~/CF_auth_key.txt)

curl -X POST "https://api.cloudflare.com/client/v4/zones/$2/dns_records" \
     -H "X-Auth-Email: $auth_email" \
     -H "X-Auth-Key: $auth_key" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'$1'","content":"'$ip'","ttl":1,"proxied":'$3'}'

}

orangeCF(){
    # $1 is our domain
    # $2 is our zone id
    echo "\$CF $2 $1 true" >> /root/ddns.sh
    echo "sleep 3" >> /root/ddns.sh
    postCF "$1" "$2" "true"
}

grayCF(){
    # $1 is our domain
    # $2 is our zone id
    echo "\$CF $2 $1 false" >> /root/ddns.sh
    echo "sleep 3" >> /root/ddns.sh
    postCF "$1" "$2" "false"
}

## Start actually asking things...

# Ask the user what their hostname is.
siteName=$(dialog --stdout --title "Hostname" --inputbox "What is your site's hostname? (i.e. site.chse.dev)" 0 0)
clear

# Ask the user if they want to use Cloudflare.
dialog --stdout --title "Cloudflare?"  --yesno "Are we using Cloudflare for $siteName?" 0 0
isCloudflare=$?
clear
if [ "$isCloudflare" -eq 0 ]; then
    zoneID=$(dialog --stdout --title "Zone ID" --inputbox "What is $siteName's Zone ID?" 0 0)
    clear
    dialog --stdout --title "Cloudflare Proxy?"  --yesno "Are we proxying $siteName through Cloudflare?" 0 0
    cloudflare_proxy_question=$?
    clear
    if [ "$cloudflare_proxy_question" -eq 0 ]; then
        orangeCF "$siteName" "$zoneID"
    elif [ "$cloudflare_proxy_question" -eq 1 ]; then
        grayCF "$siteName" "$zoneID"
    else
        exit 1
    fi
elif [ "$isCloudflare" -eq 1 ]; then
    MIAB_DDNS "$siteName"
else
    exit 1
fi

# Ask the user what type of site they want to use.
optionsForSite=$(dialog --stdout --menu "What type of site do you want?" 0 0 0 1 "WordPress" 2 "Reverse Proxy" 3 "HTTP" 4 "Redirect")
clear
if [ $optionsForSite -eq 1 ]; then
    doWordPress "$siteName"
elif [ $optionsForSite -eq 2 ]; then
    destProxySite=$(dialog --stdout --title "Reverse Proxy" --inputbox "Where is $siteName going? (i.e. 192.168.86.12:1337)" 0 0)
    clear
    doReverseProxy "$siteName" "$destProxySite"
elif [ $optionsForSite -eq 3 ]; then
    doSimpleHTML "$siteName"
elif [ $optionsForSite -eq 4 ]; then
    destSite=$(dialog --stdout --title "Hostname" --inputbox "Where is $siteName going? (i.e. dest.chse.dev)" 0 0)
    clear
    doRedirect "$siteName" "$destSite"
else
    exit 1
fi

echo -e "\nAdd $siteName to Modem DNS Host Mapping"