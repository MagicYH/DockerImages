#/bin/bash

adduser -u 1000 linux
mkdir -p /data/nginx/log
mkdir -p /data/php/log
mkdir -p /data/logs
chown -R linux:linux /data/nginx
chown -R linux:linux /data/logs
chown -R linux:linux /data/php

# config proxy

yum install -y make
yum install -y gcc
yum install -y g++
yum install -y gcc-c++
yum install -y autoconf
yum install -y wget
yum install -y epel-release
yum install -y supervisor
yum install -y libxml2-devel
yum install -y openssl-devel
yum install -y libcurl-devel
yum install -y gd-devel
yum install -y net-tools
yum install -y vim

# Prepare for swoole
yum install -y postgresql-devel
yum install -y libnghttp2-devel
yum install -y hiredis-devel

# install php7
PHP_SOURCE=php-$PHP_VERSION
PHP_HOME=$BASE_PATH/$PHP_SOURCE
export PATH=$PHP_HOME/bin:$PATH
export PATH=$PHP_HOME/sbin:$PATH

cd /tmp
wget http://cn2.php.net/distributions/$PHP_SOURCE.tar.gz -O $PHP_SOURCE.tar.gz
tar xzf $PHP_SOURCE.tar.gz
cd /tmp/$PHP_SOURCE
./configure --prefix=$PHP_HOME \
--with-config-file-path=$PHP_HOME/etc \
--enable-fpm \
--enable-pcntl \
--enable-mysqlnd \
--enable-opcache \
--enable-sockets \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-shmop \
--enable-zip \
--enable-soap \
--enable-xml \
--enable-mbstring \
--disable-rpath \
--disable-debug \
--disable-fileinfo \
--with-pdo-mysql=mysqlnd \
--with-pcre-regex \
--with-iconv \
--with-zlib \
--with-gd \
--with-openssl \
--with-mhash \
--with-xmlrpc \
--with-curl

make && make install 
cp php.ini-development $PHP_HOME/etc/php.ini
cp $PHP_HOME/etc/php-fpm.conf.default $PHP_HOME/etc/php-fpm.conf

pecl install igbinary
pecl install mongodb
yes | pecl install redis
yes | pecl install swoole

# install fileinfo extension
cd /tmp/$PHP_SOURCE/ext/fileinfo
phpize
./configure
make & make install

# php-fpm config
sed -i 's/user = .*/user = linux/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/group = .*/group = linux/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/listen.owner = .*/listen.owner = linux/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/listen.group = .*/listen.group = linux/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/pm.start_servers = .*/pm.start_servers = 2/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/pm.min_spare_servers = .*/pm.min_spare_servers = 2/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/pm.max_spare_servers = .*/pm.max_spare_servers = 4/' $PHP_HOME/etc/php-fpm.d/www.conf.default
sed -i 's/catch_workers_output = .*/catch_workers_output = yes/' $PHP_HOME/etc/php-fpm.d/www.conf.default
cp $PHP_HOME/etc/php-fpm.d/www.conf.default $PHP_HOME/etc/php-fpm.d/www.conf
sed -i 's/;error_log = .*/error_log = \/data\/php\/log\/php_error.log/' $PHP_HOME/etc/php.ini
sed -i 's/;error_log = .*/error_log = \/data\/php\/log\/php-fpm.log/' $PHP_HOME/etc/php-fpm.conf
echo 'extension=igbinary.so' >> $PHP_HOME/etc/php.ini
echo 'extension=redis.so' >> $PHP_HOME/etc/php.ini
echo 'extension=mongodb.so' >> $PHP_HOME/etc/php.ini
echo 'extension=swoole.so' >> $PHP_HOME/etc/php.ini
echo 'extension=fileinfo.so' >> $PHP_HOME/etc/php.ini


# install openresty
OPENRESTY_SOURCE=openresty-$OPENRESTY_VERSION
OPENRESTY_HOME=$BASE_PATH/$OPENRESTY_SOURCE

cd /tmp
wget https://openresty.org/download/$OPENRESTY_SOURCE.tar.gz -O $OPENRESTY_SOURCE.tar.gz
tar xzf $OPENRESTY_SOURCE.tar.gz
cd /tmp/$OPENRESTY_SOURCE
./configure --prefix=$OPENRESTY_HOME
make && make install 
export PATH=$OPENRESTY_HOME/bin:$PATH

# config nginx
NGINX_HOME=$OPENRESTY_HOME/nginx
NGINX_CONFIG_FILE=$NGINX_HOME/conf/nginx.conf
mkdir $NGINX_HOME/conf/vhost.d

sed -i '$d' $NGINX_CONFIG_FILE && echo "    include vhost.d/*.conf;" >> $NGINX_CONFIG_FILE && echo "}" >> $NGINX_CONFIG_FILE
sed -i '1i user linux;' $NGINX_CONFIG_FILE
sed -i '1i daemon off;' $NGINX_CONFIG_FILE
sed -i '1,27 s/#access_log .*/access_log \/data\/nginx\/log\/access.log;/' $NGINX_CONFIG_FILE
sed -i '27a \    error_log \/data\/nginx\/log\/error.log;' $NGINX_CONFIG_FILE

chmod 777 $NGINX_HOME/logs

#install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

cat <<EOF > /etc/supervisord.d/default.ini
[program:php-fpm]
command=php-fpm -F
autorestart=true
redirect_stderr=true
stdout_logfile = /data/php/log/php-fpm.log

[program:nginx]
command=nginx
autorestart=true
redirect_stderr=true
stdout_logfile = /data/nginx/log/nginx.log
EOF

# set time zone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum clean all