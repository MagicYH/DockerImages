#/bin/bash

adduser -m -u 1000 linux
echo "alias ll='ls -al'" > /etc/profile.d/custom.sh

# config proxy

# yum install -y make
# yum install -y gcc
# yum install -y g++
# yum install -y gcc-c++
# yum install -y autoconf
yum install -y wget
yum install -y epel-release
# yum install -y supervisor
# yum install -y libxml2-devel
# yum install -y openssl-devel
# yum install -y libcurl-devel
# yum install -y gd-devel
yum install -y net-tools
yum install -y vim

# set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum clean all