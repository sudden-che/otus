#!/bin/bash
# install

yum install epel-release -y
yum install docker -y

sudo useradd mrdocker


echo "secret"|sudo passwd --stdin mrdocker

groupadd admin
usermod -aG admin vagrant
usermod -aG admin root


sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"


sed -i "s/nologin\.so/nologin\.so\naccount required pam_time\.so/" /etc/pam.d/sshd





 cat > /usr/local/bin/test_login.sh<<EOF
#!/bin/bash
if  getent group admin | grep  \$PAM_USER ; then
    exit 0
else
    exit 1
fi
EOF
chmod +x /usr/local/bin/test_login.sh



sed -i "s/nologin\.so/nologin\.so\n account required pam_exec\.so \/usr\/local\/bin\/test_login\.sh/" /etc/pam.d/sshd



# add user mrdocker rights to start docker service via polkit
# in centos 8 PODMAN

cat >> /etc/polkit-1/rules.d/01-docker.rules<<EOF
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") == "podman.service" &&
        subject.user == "mrdocker") {
        return polkit.Result.YES;
    }
});
EOF

