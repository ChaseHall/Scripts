#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
	echo "You have to execute this script as root user"
	exit 1;
fi


HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
TITLE="New/Modify Client Menu"
MENU="Choose one of the following options:"

OPTIONS=(1 "Initial Client"
 2 "New Reverse Proxy (Do 1 first)"
	  3 "New WP Site (Do 1 first)"
4 "New HTTP Site (Do 1 first)")

	CHOICE=$(dialog --clear \
   --title "$TITLE" \
--menu "$MENU" \
$HEIGHT $WIDTH $CHOICE_HEIGHT \
"${OPTIONS[@]}" \
2>&1 >/dev/tty)

	clear
	case $CHOICE in
   1)
#   read -p 'ROOT Domain (i.e. chasehall.net): ' uservar
 bash 1.sh # $uservar
	;;
	2)
  read -p 'Domain (i.e. blog.chasehall.net): ' uservar
bash NewReverseProxy.sh $uservar
;;
3)
	read -p 'Domain (i.e. blog.chasehall.net): ' uservar
bash NewWPSite.sh $uservar
;;
4)
read -p 'Domain (i.e. blog.chasehall.net): ' uservar
bash 4.sh $uservar
;;
esac
