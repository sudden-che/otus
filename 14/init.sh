#!/bin/bash
# install
yum install epel-release -y
yum install nginx setools-console policycoreutils-python -y



# change def port

sed -i "s/80/21/g" /etc/nginx/nginx.conf

# change port ex 21
setsebool -P httpd_can_connect_ftp 1
semanage port -m -t http_port_t -p tcp 21

systemctl start nginx
curl -I localhost:21



# change port to another add module

sed -i "s/21/23/g" /etc/nginx/nginx.conf
systemctl restart nginx

audit2allow -M httpd_add --debug < /var/log/audit/audit.log && semodule -i httpd_add.pp
systemctl start nginx

curl -I localhost:23


echo -e "\n\ntesting nginx different ports done \n"
