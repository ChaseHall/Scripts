#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
echo "You have to execute this script as root user"
exit 1;
fi

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
TITLE="Menu"
MENU="Choose one of the following options:"

OPTIONS=(
1 "New WP Site"
2 "New Reverse Proxy"
3 "New HTTP Site"
4 "New Redirect Site")

CHOICE=$(dialog --clear \
--title "$TITLE" \
--menu "$MENU" \
$HEIGHT $WIDTH $CHOICE_HEIGHT \
"${OPTIONS[@]}" \
2>&1 >/dev/tty)

clear
case $CHOICE in
1)
bash NewWPSite.sh
;;
2)
bash NewReverseProxy.sh
;;
3)
bash NewSimpleHTML.sh
;;
4)
bash NewRedirectSite.sh
;;
esac
