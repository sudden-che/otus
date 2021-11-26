#!/bin/bash

# package inst
yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils


yum -y groupinstall 'Development Tools'


# download srpm nginx
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm


# wget openssl
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1a.tar.gz
tar -xvf openssl-1.1.1a.tar.gz

# set openssl conf
sed -i "s|--with-http_ssl_module|--with-http_ssl_module --with-openssl=/home/vagrant/openssl-1.1.1a|g" /root/rpmbuild/SPECS/nginx.spec

# build install & build
yum-builddep /root/rpmbuild/SPECS/nginx.spec -y
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec


ll /root/rpmbuild/RPMS/x86_64/

yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

systemctl start nginx
systemctl status nginx

mkdir /usr/share/nginx/html/repo

cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

wget https://downloads.percona.com/downloads/percona-release/percona-release-0.1-6/redhat/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm 

createrepo /usr/share/nginx/html/repo/

sed -i "/index  index.html index.htm/ s/\;/\;\n autoindex on\;/" /etc/nginx/conf.d/default.conf

nginx -t
nginx -s reload

curl -a http://localhost/repo/

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum repolist enabled | grep otus

yum list | grep otus

yum install percona-release -y


echo -e '\n\n\n\n\n ALL DONE...'




~

~

