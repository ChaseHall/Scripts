# Migrating Domains

1. `sudo certbot delete` the old domain.  
2. Delete the old domain from MIAB + DNS on modem.  
3. Add new domain to MIAB + DNS on modem.  
4. Rename the folder inside /var/www/.  
5. Replace the domain in `ddns.sh` with the new one.  
6. Rename the VirtualHost inside cfg with `:%s/old-domain.com/new-domain.com/g`  
6a. Comment out SSL Lines  
7. Generate new SSL Cert. `sudo certbot certonly --apache -d domain.tld`  
8. Update Search Consoles [[Google]](https://search.google.com/search-console) [[Bing]](https://www.bing.com/webmaster/home/mysites) [[Yandex]](https://webmaster.yandex.com/sites/add/)  

---

## WP

1. Insert the following into the `wp-config.php` file.

```
define( 'WP_HOME', 'https://domain.tld' );
define( 'WP_SITEURL', 'https://domain.tld' );
```

2. Use the WP Plugin: [Better Search Replace](https://wordpress.org/plugins/better-search-replace) and replace all instances of the old url to the new one.  
3. Replace Emails (Admin Accs, etc).  
4. Update Plugin specific things (WP Mail, cron @ Email Subscribers, Yoast SEO).  
