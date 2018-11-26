#/bin/bash

adduser -u 1000 linux
mkdir -p /data/logs
mkdir -p $BASE_PATH

cd $BASE_PATH
tar -xzf ${JDK_VERSION}_linux-x64_bin.tar.gz -C ${JDK_VERSION}
rm ${JDK_VERSION}_linux-x64_bin.tar.gz

# set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
