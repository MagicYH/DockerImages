#/bin/bash

adduser -u 1000 linux

# config proxy

yum install -y epel-release
yum install -y supervisor
yum install -y net-tools
yum install -y wget
yum install -y vim

mkdir -p $BASE_PATH
cd $BASE_PATH
GO_TAR_GZ=go.tar.gz
wget https://dl.google.com/go/go1.11.3.linux-amd64.tar.gz -O $GO_TAR_GZ
tar xzf $GO_TAR_GZ
mv go $GO_VERSION
rm $GO_TAR_GZ

# set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum clean all