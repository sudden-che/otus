#!/bin/bash
#setenforce 0
#sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

timedatectl set-timezone Europe/Moscow
#yum install -y epel-release
#yum install -y yum install ipa-server ipa-server-dns

#systemctl enable chronyd --now
#systemctl enable firwalld
#systemctl start firewalld


firewall-cmd --permanent --add-port=53/{tcp,udp} --add-port={80,443}/tcp --add-port={88,464}/{tcp,udp} --add-port=123/udp --add-port={389,636}/tcp
#firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
firewall-cmd --reload

sysctl net.ipv4.ip_forward=1


#ipa-server-install
echo '192.168.51.1 server.777.local' >> /etc/hosts

#yum update nss* -y

#client install freeipa-client libsss_sudo krb5-kinit bind-utils libbind
#yum update nss* -y

