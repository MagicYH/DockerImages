#/bin/bash

adduser -u 1000 linux
mkdir -p /data/logs
mkdir -p $BASE_PATH

yum install -y wget
yum install -y epel-release
yum install -y supervisor

# install kafka
cd $BASE_PATH
KAFKA=kafka_2.11-2.0.0
wget http://mirrors.shu.edu.cn/apache/kafka/2.0.0/kafka_2.11-2.0.0.tgz -O $KAFKA.tgz
tar -xzf $KAFKA.tgz
rm $KAFKA.tgz
cd $KAFKA

# set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

cat <<EOF > /etc/supervisord.d/default.ini
[program:zookeeper]
directory=/usr/local/software/$KAFKA
command=bash bin/zookeeper-server-start.sh config/zookeeper.properties
autorestart=true
redirect_stderr=true
stdout_logfile=/data/logs/zookeeper.log

[program:kafka]
directory=/usr/local/software/$KAFKA
command=bash bin/kafka-server-start.sh config/server.properties
autorestart=true
redirect_stderr=true
stdout_logfile=/data/logs/kafka.log
EOF

yum remove wget
yum clean all