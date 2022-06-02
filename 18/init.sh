#!/bin/bash
setenforce 0

mkdir /var/backup


parted -s /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary ext4 0% 100%
partprobe

mkfs.ext4 /dev/sdb1
mount /dev/sdb1 /var/backup

echo '/dev/sdb1 /var/backup ext4 defaults 0 0' >> /etc/fstab 





chown borg:borg /var/backup/




touch /home/borg/.ssh/authorized_keys
chmod 700 /home/borg/.ssh
chmod 600 /home/borg/.ssh/authorized_keys


chown borg:borg -R /home/borg/.ssh

# remove lost+found
rm -Rf /var/backup/*
