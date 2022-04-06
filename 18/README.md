# run vagrant up to base provision
# after that login to client create ssh-key and copy to bak 

vagrant ssh client
sudo su
ssh-keygen 
cat ~/.ssh/id_rsa.pub

\\ copy it to bak /home/borg/.ssh/authorized_keys

\\ init backup services on client manually
REPO=borg@192.168.11.10:/var/backup/

borg init --repokey  ${REPO}
\\passphrase cheese

systemctl enable borg-backup.service
systemctl start borg-backup.service
systemctl enable borg-backup.timer
systemctl start borg-backup.timer


# процесс восстановления:
смотрим список резервных копий
borg list ${REPO}

где репозиторий:
REPO=borg@192.168.11.10:/var/backup/


восстанавливаем нужный файл в нужную директорию (etc-2022-04-06_17:39:02 имя р.к.)

borg extract ${REPO}::etc-2022-04-06_17:39:02 etc/hostname

cp etc/hostname /etc/hostname

