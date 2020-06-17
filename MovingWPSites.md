# Moving WP Domains

1. Rename the folder inside /var/www/
2. Rename the VirtualHost inside cfg
3. Remove the DDNS line from ddns.sh
4. Remove DNS from MIAB
5. Add new DNS to MIAB
6. Add new DNS to ddns.sh
7. Use the WP Plugin: [Better Search Replace](https://wordpress.org/plugins/better-search-replace) and replace all instances of the old url to the new one.
8. Also replace any emails that need replacing.
9. Update WP Mail if needed
10. Fix the cron if using Email Subscribers 
	`wp-admin/admin.php?page=es_settings#tabs-email_sending`
11. Reconfigure Yoast SEO
	`wp-admin/admin.php?page=wpseo_configurator`
12. Update Search Consoles [[Google]](https://search.google.com/search-console) [[Bing]](https://www.bing.com/webmaster/home/mysites) [[Yandex]](#)