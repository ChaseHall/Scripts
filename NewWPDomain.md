# All these links are dead, whoops.

[I was lazy writing this document so the nexted a/b/c doesn't work in markdown view, so click view raw to see the nested abc right. (I'll fix it eventually...)](https://git.chasehall.net/Chase/Scripts/raw/branch/master/NewWPDomain.md)

Sticky Footer:
1. Install "Insert Headers and Footers"
2. Go to Insert Headers and Footers - /wp-admin/options-general.php?page=insert-headers-and-footers
3. Place this inside Footer - https://chse.link/x3yr3l
4. Place this in Additional CSS - https://chse.link/wpd0c6

Plugins:
* Adminimize
* All 404 Redirect to Homepage
* Autoptimize
* Contact Form 7
* Email Subscribers & Newsletters
* Insert Headers and Footers
* iThemes Security
* Maintenance
* MainWP Child
* PublishPress Capabilities
* Redirection
* Ultimate Member
* WooCommerce
* WP Mail SMTP
* WP Super Cache
* WPScan
* Yoast SEO

Moving WP Domains:
0. Obviously switch the domain on web server, and adding it to MIAB
1. Use Better Search Replace By Delicious Brains & replace any filler data
	a. ch@chasehall.net -> []
2. Move WP Mail SMTP to new Domain.
3. Setup CRON for email sending
	a. https://is.gd/muxeve
	b. https://is.gd/olupiw
	c. wp-admin/admin.php?page=es_settings#tabs-email_sending
4. Setup Yoast SEO
	a. wp-admin/admin.php?page=wpseo_configurator
5. Add to Google, Bing, and Yandex Search Console's
	a. Verify via DNS.