# Resizing VM Disk
*Should only need to be done on a VM, LXC's auto resize as far as I know.*

1. Resize disk in Proxmox.

2. SSH into VM and get the partition. `lsblk`

3. `sudo su -`
4. `growpart /dev/sda 2` # 2 is the partition you want to increase in size.
5. `resize2fs /dev/sda2`