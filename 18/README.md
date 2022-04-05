# run vagrant up to base provision
# after that login to client create ssh-key and copy to bak 

vagrant ssh client
sudo su
ssh-keygen 
cat ~/.ssh/id_rsa.pub

# copy it to bak /home/borg/.ssh/authorized_keys

# init backup services on client manually

systemctl enable borg-backup.service
systemctl start borg-backup.service
systemctl enable borg-backup.timer
systemctl start borg-backup.timer



