# Moving WP Domains

1. Delete old HTTPS cert 
    `sudo certbot delete`
2. Rename the folder inside /var/www/
3. Rename the VirtualHost inside cfg
    `:%s/old-domain.com/new-domain.com/g`
4. Remove DNS from MIAB
5. Replace `ddns.sh`'s old domain with the new one.
6. Use the WP Plugin: [Better Search Replace](https://wordpress.org/plugins/better-search-replace) and replace all instances of the old url to the new one.
7. Also replace any emails that need replacing.
8. Update WP Mail if needed
9. Fix the cron if using Email Subscribers 
	`wp-admin/admin.php?page=es_settings#tabs-email_sending`
10. Reconfigure Yoast SEO
	`wp-admin/admin.php?page=wpseo_configurator`
11. Update Search Consoles [[Google]](https://search.google.com/search-console) [[Bing]](https://www.bing.com/webmaster/home/mysites) [[Yandex]](#)