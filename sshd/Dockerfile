FROM centos:7

MAINTAINER magic

ENV ROOT_PASSWORD 123456

RUN yum install -y epel-release; \
yum install -y wget; \
yum install -y openssh-server; \
yum install -y net-tools; \
yum install -y vim; \
yum clean all; \
sshd-keygen; \
echo "root:${ROOT_PASSWORD}" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]