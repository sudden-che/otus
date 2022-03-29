#!/bin/bash
echo -e '\n\n\n\n start provision log'
setenforce 0
cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
systemctl restart chronyd


sudo sed -i s/^mirr/#mirr/g /etc/yum.repos.d/CentOS-Base*
sudo sed -i s/^#base/base/g /etc/yum.repos.d/CentOS-Base*
sudo echo 'nameserver 1.1.1.1' > /etc/resolv.conf
sudo yum install dnf epel-release -y
sudo dnf install easy-rsa openvpn -y


cat   > /etc/openvpn/client.conf <<EOF
dev tun
proto udp
remote 192.168.148.1 35406
client
resolv-retry infinite
ca /vagrant/client/ca.crt
cert /vagrant/client/client.crt
key /vagrant/client/client.key

persist-key
persist-tun

verb 3
EOF

systemctl start openvpn@client
systemctl status openvpn@client

ip -br a

