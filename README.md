# Scripts

Scripts & Resources I have made.

---

## Table of Contents: 

* Backup-Scripts  
  * `MIAB.txt` - **Information on how Mail-in-a-Box is setup for backups.**  
  * `Plex.sh` - **Script to backup Nextcloud & Docker Volumes.**  
  * `WWW.sh.example` - **Script to backup MySQL DB, /var/www/, and apache2 configuration(s).**  
* Info-and-Guides  
  * `Migrating-Domains` - **Guide on how to migrate from one domain to another.**  
  * `Ports` - **Current Port Documentation.**  
  * `Resizing-VM` - **Resizing VM Disk inside Proxmox.**  
  * `chroot-ftp` - **Guide on how to chroot users into a specific folder.**  
  * `Crontabs.txt` - **Current system(s) crontab(s)**  
* Mail  
  * `After_MIAB_Upgrade.sh` - **Add my changes after a Mail-in-a-Box upgrade.**  
  * `Blacklist.sh` - **Blacklist a specific email address.**  
  * `Initial_Install.sh` - **Install a fresh copy of Mail-in-a-Box and add my changes.**  
* New-LXC  
  * `setup.sh` - **Setup a new LXC/VM by locking down SSH, setting up unattended-upgrades, sysctl changes, fail2ban, etc.**  
* Plex  
  * `fixperms.sh` - **"Fix" permissions since I'm lazy.**  
  * `kill_stream.py` - **Part of [JBOPS](https://github.com/blacktwin/JBOPS) that is mirrored here**  
* WWW  
  * `cf_ddns.sh` - **Cloudflare DDNS Script**  
  * `ddns.sh.example` - **Script to fire off to various DNS services to update dynamic IP.**  
  * `WWW.sh` - **Sets up various web services. (WordPress, Reverse Proxy, Redirect, etc)**  
* iMac  
  * `Backup.sh` - **Backup various directories**  
  * `Camera.sh` - **Script to copy photos from an SD card into a properly formatted Pictures folder.**  

---

## Mini-Resources

### Text Manipulation (vim): 
`:%g!/price/d` - Removes lines that **don't** contain price  

`:%s/foo/bar/g` - Replace all foo with bar

### Adding prefix/suffix (Notepad++): 
```
Find: ^(.*)$
Replace: Prefix $0 Suffix
```

### Updating `~/GitHub`
`for i in */.git; do ( echo $i; cd $i/..; git pull; ); done`
