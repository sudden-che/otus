#!/bin/bash
echo -e '\n\n\n\n start provision log'
setenforce 0
cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
systemctl restart chronyd


# conf syslog
cat > /etc/rsyslog.conf<<EOF
\$ModLoad imuxsock # provides support for local system logging (e.g. via logger command)
\$ModLoad imjournal # provides access to the systemd journal

\$ModLoad imudp
\$UDPServerRun 514
\$ModLoad imtcp
\$InputTCPServerRun 514

\$WorkDirectory /var/lib/rsyslog
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
\$IncludeConfig /etc/rsyslog.d/*.conf
\$OmitLocalLogging on
\$IMJournalStateFile imjournal.state
*.info;mail.none;authpriv.none;cron.none                /var/log/messages
authpriv.*                                              /var/log/secure
mail.*                                                  -/var/log/maillog
cron.*                                                  /var/log/cron
*.emerg                                                 :omusrmsg:*
uucp,news.crit                                          /var/log/spooler
local7.*                                                /var/log/boot.log


\$template RemoteLogs,"/var/log/rsyslog/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
& ~
EOF

systemctl restart rsyslog

#
#echo -e '\n\n\'
#
#ss -tuln |grep 514
#
#echo -e '\n\n\'
#
#curl -I 192.168.51.10
#curl -I 192.168.51.10
#curl -I 192.168.51.10
curl -I 192.168.51.10
#url -I 192.168.51.10
#
#echo -e '\n\n\'
#cat /var/log/rsyslog/web/nginx_access.log
#echo -e '\n\n\'
#
sed -i '/tcp_listen_port/s/^##//' /etc/audit/auditd.conf
service auditd restart 
#
# check
grep web /var/log/audit/audit.log

