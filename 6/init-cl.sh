#!/bin/bash

# disable selinux or permissive 

selinuxenabled && setenforce 0

cat >/etc/selinux/config<<__EOF
SELINUX=disabled
SELINUXTYPE=targeted
__EOF


# install nfs-client
yum install nfs-utils -y
systemctl enable firewalld --now
systemctl status firewalld

# create automount
echo '10.0.0.42:/data/share/ /mnt/ nfs vers=3,proto=udp,noauto,rw,x-systemd.automount 0 0'>> /etc/fstab

# reload systemd
systemctl daemon-reload
systemctl restart remote-fs.target
mount | grep mnt

echo 'ls /mnt'
ls /mnt/
echo 'ls /mnt/upload'
ls /mnt/upload

echo 123 > /mnt/upload/345.txt
echo "listing /mnt/upload/ ......."
ls /mnt/upload
