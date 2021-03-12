#!/bin/bash

# Fix links/title of roundcube.
sed -i 's/https:\/\/mailinabox.email\//https:\/\/aries.host\//g' /usr/local/lib/roundcubemail/config/config.inc.php
sed -i 's/mail.aries.host Webmail/aries.host Mail/g' /usr/local/lib/roundcubemail/config/config.inc.php

