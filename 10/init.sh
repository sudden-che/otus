#!/bin/bash

# conf create
cat > /etc/sysconfig/watchlog<<__EOF
WORD="ALERT"
LOG=/var/log/messages
__EOF




# create script
cat > /opt/watchlog.sh<<__EOF
#!/bin/bash

WORD=\$1
LOG=\$2
DATE=\$(date)

if grep \$WORD \$LOG &> /dev/null
   then 
      logger "\$DATE: I HEAR THT WORD! )))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))"
   else
  exit 0
fi

__EOF




chmod +x /opt/watchlog.sh
logger ALERT_test




#unit create
cat > /etc/systemd/system/watchlog.service<<__EOF
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
__EOF


#unit create
cat > /etc/systemd/system/watchlog.timer<<__EOF
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
__EOF



# start
systemctl start watchlog.service
systemctl start watchlog.timer


# status

systemctl enable watchlog.service
systemctl status watchlog.timer

sudo systemctl restart watchlog.service
systemctl status watchlog.service
systemctl status watchlog.service




# part2
yum install -y epel-release
yum install spawn-fcgi php php-cli mod_fcgid httpd -y


sed -i "s/\#OPTIONS/OPTIONS/g"  /etc/sysconfig/spawn-fcgi
sed -i "s/\#SOCKET/SOCKET/g"  /etc/sysconfig/spawn-fcgi


cat > /etc/systemd/system/spawn-fcgi.service<<_EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
_EOF

systemctl start spawn-fcgi.service
systemctl status watchlog.service

sed -i "s/Service\]/Service\]\nEnviromentFile\=\/etc\/sysconfig\/httpd\-\%I/" /usr/lib/systemd/system/httpd.service


for i in first second; do grep -ve ^# -e "    #" /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd-$i.conf ;done


echo "OPTIONS=-f conf/first.conf" > /etc/sysconfig/httpd-first
echo "OPTIONS=-f conf/second.conf" > /etc/sysconfig/httpd-second


sed -i "s/Listen\ 80/Listen\ 8080\nPidFile\ \/var\/run\/httpd\-first\.pid/" /etc/httpd/conf/httpd-first.conf
sed -i "s/Listen\ 80/Listen\ 80\nPidFile\ \/var\/run\/httpd\-second\.pid/" /etc/httpd/conf/httpd-second.conf



systemctl start httpd@httpd-first
systemctl start httpd@httpd-second
systemctl status httpd@httpd-first
systemctl status httpd@httpd-second



 ss -tnulp | grep http

#
