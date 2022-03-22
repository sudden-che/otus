#!/bin/bash
echo -e '\n\n\n\n start provision log'
setenforce 0
cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
systemctl restart chronyd


yum install dnf epel-release -y
dnf install easy-rsa openvpn -y

