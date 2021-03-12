#!/bin/bash

# Add my changes, then install MIAB.
cd ~
echo -e "\nalias update='sudo apt update && sudo apt upgrade -y && sudo mailinabox && sudo reboot now'" >> .bashrc

# wget the "after installation script"
wget https://raw.githubusercontent.com/ChxseH/Scripts/master/Mail/After_MIAB_Upgrade.sh
chmod +x After_MIAB_Upgrade.sh


# Install MIAB.
curl -s https://mailinabox.email/setup.sh | sudo -E bash

# Run after install script.
cd ~
bash After_MIAB_Upgrade.sh
