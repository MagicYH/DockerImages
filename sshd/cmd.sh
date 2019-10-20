#/bin/bash

adduser -m -u 1000 linux
echo "alias ll='ls -al'" > /etc/profile.d/custom.sh

# install package
yum install -y wget
yum install -y epel-release
yum install -y openssh-server
yum install -y net-tools
yum install -y vim

# do clean
yum clean all

# set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

systemctl enable sshd