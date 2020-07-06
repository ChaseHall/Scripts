#!/bin/bash

# This assumes you already have a Parrot OS Security Edition install up and running, with FDE & a sudo user account.
# https://parrotlinux.org/download/

# Whats missing:
# General customization
# Any form of settings (power/display)
# Plex (AppImage)

sudo apt install vim curl apt-transport-https -y
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
echo "set mouse-=a" >> ~/.vimrc
echo "
# Chase Aliases
alias update="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo snap refresh"
alias www="ssh -p1000 root@chasehall.net"
alias invoiceninja="ssh -p1001 root@chasehall.net"
alias dockerce="ssh -p1002 root@chasehall.net"
alias plex="ssh -p1003 root@chasehall.net"
alias invidious="ssh -p1004 root@chasehall.net"
alias proxmox="ssh -p1005 root@chasehall.net"
alias mail="ssh root@mail.nebulahost.us"
alias pi="ssh -p1000 pi@aidenpi.cmh.pw"
alias usb="ssh chase@lw833.usbx.me"
alias mc="java -jar ~/Nextcloud/1_Personal/Programs/TLauncher-2.69.jar && exit"
alias easystore="sudo sshfs -o allow_other,default_permissions,IdentityFile=/home/user/.ssh/id_rsa -p 1003 root@chasehall.net:/ /media/remotemount"
alias mac="ssh Hall@192.168.86.182"
#alias usb="sudo cryptsetup luksOpen /dev/sdb1 cusb && sudo mount /dev/mapper/cusb /mnt/usb/"
" >> ~/.bashrc
echo "
deb https://assets.checkra.in/debian /
deb http://ppa.launchpad.net/yubico/stable/ubuntu cosmic main 
deb-src http://ppa.launchpad.net/yubico/stable/ubuntu cosmic main
deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ bionic main
" >> /etc/apt/sources.list
echo "
deb https://mirrors.ocf.berkeley.edu/parrot/ rolling main contrib non-free
## stable repository
deb https://deb.parrot.sh/parrot rolling main contrib non-free
deb https://deb.parrot.sh/parrot rolling-security main contrib non-free
" >> /etc/apt/sources.list.d/parrot.list
sudo apt-key adv --fetch-keys https://assets.checkra.in/debian/archive.key # CheckRa1n
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 32CBA1A9 # Yubico
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - # Brave Browser
sudo apt update
sudo snap install spotify
sudo snap install discord
sudo apt install -y vscodium tor filezilla hexchat calibre brave-browser nextcloud-desktop checkra1n neofetch gnupg2 gnupg-agent pinentry-curses scdaemon pcscd yubioath-desktop libpam-yubico yubikey-manager-qt yubikey-manager yubikey-personalization yubikey-personalization-gui
sudo reboot now