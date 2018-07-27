FROM centos:7

MAINTAINER magic

COPY cmd.sh /cmd.sh
RUN /bin/bash /cmd.sh

# add user linux, this user will be user by nginx and php
RUN adduser -u 1000 linux
RUN mkdir -p /var/log/nginx/

# add addops resource
RUN rm -f /etc/yum.repos.d/*
COPY ADDOPS.repo /etc/yum.repos.d/ADDOPS.repo
COPY CentOS.repo /etc/yum.repos.d/CentOS.repo
COPY EPEL.repo /etc/yum.repos.d/EPEL.repo
COPY PUPPET.repo /etc/yum.repos.d/PUPPET.repo
COPY ZABBIX.repo /etc/yum.repos.d/ZABBIX.repo

# install addops-php and specify php version
# RUN yum install -y addops-php-5.5.25-3.el6
RUN yum install -y addops-php-7.0.19-1.el6
RUN yum install -y addops-php70-redis
RUN sed -i 's/user = .*/user = linux/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/group = .*/group = linux/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/listen.owner = .*/listen.owner = linux/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/listen.group = .*/listen.group = linux/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/pm.start_servers = .*/pm.start_servers = 2/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/pm.min_spare_servers = .*/pm.min_spare_servers = 2/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/pm.max_spare_servers = .*/pm.max_spare_servers = 4/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/catch_workers_output = .*/catch_workers_output = yes/' /usr/local/php/etc/php-fpm.conf
RUN sed -i 's/;error_log = .*/error_log = \/tmp\/php_error.log/' /usr/local/php/etc/php.ini

# install addops-nginx
RUN yum install -y addops-nginx
COPY fastcgi_params /usr/local/nginx/conf/fastcgi_params
RUN sed -i '1,2d' /usr/local/nginx/conf/nginx.conf
RUN sed -i '1i\daemon off;' /usr/local/nginx/conf/nginx.conf
RUN sed -i '1i\worker_processes 2;' /usr/local/nginx/conf/nginx.conf
RUN sed -i '1i\user linux;' /usr/local/nginx/conf/nginx.conf

# install supervisor
RUN yum install -y supervisor.noarch
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80
CMD supervisord

