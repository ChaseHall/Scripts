# Proxmox default LXC's don't contain stuff to run this simple script, therefor, before running this script, run this.
# $ sudo apt update && sudo apt install wget -y
# $ sudo wget https://git.chasehall.net/Chase/Scripts/raw/branch/master/New-LXC/setup.sh && sudo chmod +x setup.sh && bash setup.sh

sudo apt update && sudo apt install vim wget curl apt-transport-https -y
echo "alias update=\"sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo snap refresh\"" >> ~/.bashrc
read -p "New SSH Port: " portvar
sed -i 's/#Port 22/Port $portvar/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-paassword/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo apt update && sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure -plow unattended-upgrades
# Struggling to replace this one with sed, maybe due to tabs?
# //      "${distro_id}:${distro_codename}-updates";
clear
echo Modify the following file to uncomment this line.
echo "//      \"\${distro_id}:\${distro_codename}-updates\";"
read -n 1 -s -r -p "OK? "
sudo vim /etc/apt/apt.conf.d/50unattended-upgrades
clear
sed -i 's/\/\/Unattended-Upgrade::Remove-Unused-Kernel-Packages \"false\";/Unattended-Upgrade::Remove-Unused-Kernel-Packages \"true\";/g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's/\/\/Unattended-Upgrade::Remove-Unused-Dependencies \"false\";/Unattended-Upgrade::Remove-Unused-Dependencies \"true\";/g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's/\/\/Unattended-Upgrade::Automatic-Reboot \"false\";/Unattended-Upgrade::Automatic-Reboot \"true\";/g' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's/\/\/Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";/Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";/g' /etc/apt/apt.conf.d/50unattended-upgrades
echo "APT::Periodic::AutocleanInterval \"7\";
APT::Periodic::Download-Upgradeable-Packages \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades
sed -i 's/#net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.accept_redirects = 0/net.ipv4.conf.all.accept_redirects = 0/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.accept_redirects = 0/net.ipv6.conf.all.accept_redirects = 0/g' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.send_redirects = 0/net.ipv4.conf.all.send_redirects = 0/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.send_redirects = 0/net.ipv6.conf.all.send_redirects = 0/g' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.accept_source_route = 0/net.ipv4.conf.all.accept_source_route = 0/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.accept_source_route = 0/net.ipv6.conf.all.accept_source_route = 0/g' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.log_martians = 1/net.ipv4.conf.all.log_martians = 1/g' /etc/sysctl.conf
sudo sysctl -p > /dev/null 2>&1
sudo apt update && sudo apt install fail2ban -y && sudo systemctl enable fail2ban && sudo systemctl start fail2ban
clear