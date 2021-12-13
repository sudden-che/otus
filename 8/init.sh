#!/bin/bash

# disable selinux or permissive 

selinuxenabled && setenforce 0

cat >/etc/selinux/config<<__EOF
SELINUX=disabled
SELINUXTYPE=targeted
__EOF

# enable firewall
systemctl enable firewalld --now
systemctl status firewalld
```
# - разрешаем в firewall доступ к сервисам NFS
```bash
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent
firewall-cmd --reload

# config nfs v3
sed -i 's/\# vers3/vers3/' /etc/nfs.conf

# create share dir
mkdir -p /data/share/upload
chmod 777 /data/share/upload

# export share
echo '/data/share/ *(rw,sync,root_squash)' > /etc/exports

# check
exportfs -rav
exportfs -s

# enable nfs,rpc for v3
systemctl enable nfs --now
systemctl enable rpcbind
systemctl start rpc-statd



