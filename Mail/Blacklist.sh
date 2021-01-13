#!/bin/bash

read -p "What domain are we blacklisting? " domain

echo "blacklist_from *@$domain" >> /etc/spamassassin/local.cf

sudo systemctl restart spamassassin