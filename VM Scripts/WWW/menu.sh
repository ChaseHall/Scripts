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
read -p 'New WP Site Domain (i.e. c1000.nebulahost.us): ' uservar
bash NewWPSite.sh $uservar
;;
2)
read -p 'New Reverse Proxy Domain (i.e. service.chasehall.net): ' uservar
read -p 'What is getting reverse proxyd (i.e. 192.168.86.1:1111) [We assume http://]' uservar2
bash NewReverseProxy.sh $uservar $uservar2
;;
3)
read -p 'New HTTP Site Domain (i.e. simple.cmh.pw): ' uservar
bash NewSimpleHTML.sh $uservar
;;
4)
read -p 'Site you want the redirect to be (i.e. redirect.cmh.pw): ' uservar
bash NewRedirectSite.sh $uservar
;;
esac