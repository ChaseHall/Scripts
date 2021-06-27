#!/bin/bash

# cd ~ && wget https://raw.githubusercontent.com/ChxseH/Scripts/master/Mail/Initial_Install.sh && chmod +x Initial_Install.sh && bash Initial_Install.sh && rm Initial_Install.sh

# Add my changes, then install MIAB.
cd ~
echo -e "\nalias update='sudo apt update && sudo apt upgrade -y && curl -s https://mailinabox.email/setup.sh | sudo bash && bash ~/After_MIAB_Upgrade.sh && sudo reboot now'" >> .bashrc

# wget the "after installation script"
wget https://raw.githubusercontent.com/ChxseH/Scripts/master/Mail/After_MIAB_Upgrade.sh
chmod +x After_MIAB_Upgrade.sh


# Install MIAB.
curl -s https://mailinabox.email/setup.sh | sudo bash

# Run after install script.
cd ~
bash After_MIAB_Upgrade.sh
