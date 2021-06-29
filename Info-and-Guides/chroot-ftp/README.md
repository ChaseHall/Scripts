# Doing chroot stuff for FTP

## Step 1: Create a Group
```
groupadd GroupNameHere
```

## Step 2: Adding a user
```
adduser UserNameHere
gpasswd -a UserNameHere GroupNameHere
usermod -s /sbin/nologin UserNameHere
```

## Step 3: Permissions for wherever they need to be
```
chgrp -R GroupNameHere /FilePathHere/
chmod -R g+rw /FilePathHere/
```

## Step 4: chroot'ing them
```
vim /etc/proftpd/proftpd.conf && sudo systemctl restart proftpd
```

```
DefaultRoot /FilePathHere/ UserNameHere     # Add this to the file by the other ones.
```

---

## Notes

### Removing user from group
```
sudo gpasswd -d user group
```

### Removing user
```
sudo userdel user
```

### Removing group
```
sudo groupdel group
```
