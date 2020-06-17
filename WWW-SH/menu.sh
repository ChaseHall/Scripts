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
1 "New Reverse Proxy (Do 1 first)"
2 "New WP Site (Do 1 first)"
3 "New HTTP Site (Do 1 first)")

CHOICE=$(dialog --clear \
--title "$TITLE" \
--menu "$MENU" \
$HEIGHT $WIDTH $CHOICE_HEIGHT \
"${OPTIONS[@]}" \
2>&1 >/dev/tty)

clear
case $CHOICE in
1)
read -p 'New Reverse Proxy Domain (i.e. blog.chasehall.net): ' uservar
bash NewReverseProxy.sh $uservar
;;
3)
read -p 'New WP Site Domain (i.e. blog.chasehall.net): ' uservar
bash NewWPSite.sh $uservar
;;
4)
read -p 'New HTTP Site Domain (i.e. blog.chasehall.net): ' uservar
bash NewSimpleHTML.sh $uservar
;;
esac