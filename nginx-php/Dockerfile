FROM centos:7

MAINTAINER magic

ENV BASE_PATH /usr/local/software
ENV PHP_VERSION 7.1.20
ENV OPENRESTY_VERSION 1.13.6.2

COPY cmd.sh /cmd.sh
RUN /bin/bash /cmd.sh

ENV PATH $BASE_PATH/php-$PHP_VERSION/bin:$BASE_PATH/php-$PHP_VERSION/sbin:$BASE_PATH/openresty-$OPENRESTY_VERSION/bin:$BASE_PATH/openresty-$OPENRESTY_VERSION/nginx/sbin:$PATH

EXPOSE 80
CMD supervisord -n -c /etc/supervisord.conf

