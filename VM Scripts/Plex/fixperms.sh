#!/bin/bash

# Own Drive 1 by Root
sudo chown -R root:root "/media/easystore/Movies"
sudo chown -R root:root "/media/easystore/TV Shows"

# 777 Drive 1
sudo chmod 777 -R "/media/easystore/Movies"
sudo chmod 777 -R "/media/easystore/TV Shows"
sudo chmod 777 -R "/media/easystore/TorrentDLs" 

# Own Drive 2 by Root
sudo chown -R root:root "/media/easystore2/Movies"
sudo chown -R root:root "/media/easystore2/TV Shows"

# 777 Drive 2
sudo chmod 777 -R "/media/easystore2/Movies"
sudo chmod 777 -R "/media/easystore2/TV Shows"