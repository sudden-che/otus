#!/bin/bash

setenforce 0


# create if not exist
mkdir -p ~/.ssh



 
cat  > /etc/systemd/system/borg-backup.service<<EOF
[Unit]
Description=Borg Backup

[Service]
Type=oneshot

# Парольная фраза
Environment=BORG_PASSPHRASE=cheese

# Репозиторий
Environment=REPO=borg@192.168.11.10:/var/backup/

# Что бэкапим
Environment=BACKUP_TARGET=/etc

# Создание бэкапа
ExecStart=/bin/borg create \
--stats \
\${REPO}::etc-{now:%%Y-%%m-%%d_%%H:%%M:%%S} \${BACKUP_TARGET}

# Проверка бэкапа
ExecStart=/bin/borg check \${REPO}

# Очистка старых бэкапов
ExecStart=/bin/borg prune \
--keep-daily 90 \
--keep-monthly 12 \
--keep-yearly 1 \
\${REPO}
EOF




cat >  /etc/systemd/system/borg-backup.timer<<EOF
[Unit]
Description=Borg Backup

[Timer]
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
EOF


# run ssh-keygen and copy id_rsa.pub
# cat ~/.ssh/id_rsa.pub
# copy it to bak srv /home/borg/.ssh/authorized_keys
##init manually
# enable and check manually


#systemctl enable borg-backup.service
#systemctl start borg-backup.service
#systemctl enable borg-backup.timer
#systemctl start borg-backup.timer



