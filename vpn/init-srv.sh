#!/bin/bash

setenforce 0
systemctl stop firewalld
systemctl disable firewalld


sudo echo 'nameserver 1.1.1.1' > /etc/resolv.conf

sudo sed -i s/^#base/base/g /etc/yum.repos.d/CentOS-Base*
sudo sed -i s/^mirr/#mirr/g /etc/yum.repos.d/CentOS-Base*
sudo yum install -y epel-release 
sudo yum install -y easy-rsa openvpn
#dnf -y install easy-rsa openvpn
cd /etc/openvpn

/usr/share/easy-rsa/3.0.*/easyrsa init-pki
echo 'rasvpn' | /usr/share/easy-rsa/3.0.*/easyrsa build-ca nopass
echo 'rasvpn' | /usr/share/easy-rsa/3.0.*/easyrsa gen-req server nopass
echo 'yes' | /usr/share/easy-rsa/3.0.*/easyrsa sign-req server server
/usr/share/easy-rsa/3.0.*/easyrsa gen-dh
openvpn --genkey --secret ta.key
echo 'rasvpn' | /usr/share/easy-rsa/3.0.*/easyrsa build-ca nopass
echo 'rasvpn' | /usr/share/easy-rsa/3.0.*/easyrsa gen-req server
nopass
echo 'yes' | /usr/share/easy-rsa/3.0.*/easyrsa sign-req server server
/usr/share/easy-rsa/3.0.*/easyrsa gen-dh
openvpn --genkey --secret ta.key

echo debug req-cli
echo 'client' | /usr/share/easy-rsa/3.0.*/easyrsa gen-req client nopass
echo 'yes' | /usr/share/easy-rsa/3.0.*/easyrsa sign-req client client
echo debug srvconf start

cat   > /etc/openvpn/server.conf <<EOF
port 35406
proto udp
dev tun

ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem

server 192.168.148.0 255.255.255.0
route 192.168.148.0 255.255.255.0
push "route 192.168.148.0 255.255.255.0"
# push "redirect-gateway local tun0"

ifconfig-pool-persist ipp.txt
client-to-client
client-config-dir /etc/openvpn/client
comp-lzo

persist-key
persist-tun
keepalive 10 120
cipher AES-256-CBC

status /var/log/openvpn-status.log
log /var/log/openvpn.log
topology subnet
tls-server
resolv-retry infinite

verb 3

EOF
#usermod -aG openvpn vagrant
#usermod -aG openvpn root
systemctl start openvpn@server
systemctl status openvpn@server

ip -br a




mkdir /vagrant/client

client=/vagrant/client
pki=/etc/openvpn/pki

cp -f $pki/ca.crt $client
cp -f  $pki/issued/client.crt $client
cp -f  $pki/private/client.key $client




