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




server 10.10.10.0 255.255.255.0
#route 192.168.11.0 255.255.255.0
#push "route 192.168.11.0 255.255.255.0"
push "route 8.8.8.8 255.255.255.255"
push "redirect-gateway local tun0"


ifconfig-pool-persist ipp.txt
client-to-client
client-config-dir /etc/openvpn/client

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

# masq for test
sysctl net.ipv4.ip_forward=1
iptables -A POSTROUTING -t nat -j MASQUERADE



mkdir /vagrant/client

pki=/etc/openvpn/pki

cp -f  $pki/ca.crt /vagrant/client/
cp -f  $pki/issued/client.crt /vagrant/client/
cp -f  $pki/private/client.key /vagrant/client/




