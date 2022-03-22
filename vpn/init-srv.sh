#!/bin/bash

. init.sh
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


echo 'client' | /usr/share/easy-rsa/3.0.*/easyrsa gen-req client nopass
echo 'yes' | /usr/share/easy-rsa/3.0.*/easyrsa sign-req client client

cat   > server.conf <<EOF
port 35406
proto udp
dev tun

ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem

server 192.168.148.0 255.255.255.0

persist-key
persist-tun
keepalive 10 120
cipher AES-256-CBC
verb 3
status /var/log/openvpn-status.log
log /var/log/openvpn.log
topology subnet
tls-server
resolv-retry infinite
#  ifconfig-pool-persist ipp.txt
#  client-to-client
#  client-config-dir /etc/openvpn/client
#  comp-lzo
#  route 192.168.148.0 255.255.255.0
#  push "route 192.168.148.0 255.255.255.0"
#  push "redirect-gateway local tun0"



EOF

openvpn --config server.conf



