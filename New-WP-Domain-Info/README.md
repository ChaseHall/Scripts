# Moving WP Domains

1. `sudo certbot delete` the old domain.
2. Delete the old domain from MIAB + DNS on modem.
3. Add new domain to MIAB + DNS on modem.
4. Rename the folder inside /var/www/.
5. Rename the VirtualHost inside cfg with `:%s/old-domain.com/new-domain.com/g`
6. Replace the domain in `ddns.sh` with the new one.
7. Use the WP Plugin: [Better Search Replace](https://wordpress.org/plugins/better-search-replace) and replace all instances of the old url to the new one.
8. Replace Emails (Admin Accs, etc).
9. Update Plugin specific things (WP Mail, cron @ Email Subscribers, Yoast SEO).
10. Update Search Consoles [[Google]](https://search.google.com/search-console) [[Bing]](https://www.bing.com/webmaster/home/mysites) [[Yandex]](#)