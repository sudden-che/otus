#!/bin/bash

cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
systemctl restart chronyd

systemctl status nginx
ss -tln | grep 80 

echo -e '\n\n'
# conf nginx
cat > /etc/nginx/nginx.conf<<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;

error_log syslog:server=192.168.51.15:514,tag=nginx_error;


pid /run/nginx.pid;
include /usr/share/nginx/modules/*.conf;
events {
    worker_connections 1024;
}
http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
#    access_log  /var/log/nginx/access.log  main;

access_log syslog:server=192.168.51.15:514,tag=nginx_access,severity=info combined;
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;
        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;
        error_page 404 /404.html;
        location = /404.html {
        }
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
}
EOF

systemctl restart nginx

# audit
#
#cat >> /etc/audit/rules.d/audit.rules<<EOF
#-w /etc/nginx/nginx.conf -p wa -k nginx_conf
#-w /etc/nginx/default.d/ -p wa -k nginx_conf
#EOF
#
##service auditd restart
#
#sed -i 's/80/8080/' /etc/nginx/nginx.conf
#sed -i 's/8080/80/' /etc/nginx/nginx.conf
#
# check
#
#
#echo -e '\n\n'
#cat /var/log/audit/audit.log | grep 'nginx_conf\|sed'
#
# remote
sed -i 's/NONE/HOSTNAME/' /etc/audit/auditd.conf
sed -i 's/no/yes/' /etc/audisp/plugins.d/au-remote.conf 

sed -i '/remote_server/s/=/= 192\.168\.51\.15/' /etc/audisp/audisp-remote.conf
#sed -i '/tcp_listen_port/s/^##//' /etc/audit/auditd.conf


service auditd restart


#check

echo -e '\n\n'
ls -l /etc/nginx/nginx.conf
chmod +x /etc/nginx/nginx.conf

echo -e '\n\n'
ls -l /etc/nginx/nginx.conf
echo -e '\n\n'
chmod -x /etc/nginx/nginx.conf








