#/bin/bash

adduser -u 1000 linux
mkdir -p /data/nginx/log
mkdir -p /data/php/log

cat <<EOF > nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOF

yum install -y epel-release
yum install -y make
yum install -y gcc
yum install -y g++
yum install -y autoconf
yum install -y wget
yum install -y nginx
yum install -y supervisor
yum install -y libxml2-devel
yum install -y openssl-devel
yum install -y libcurl-devel
yum install -y gd-devel

cd /tmp
wget http://cn2.php.net/distributions/php-7.2.8.tar.gz -O php-7.2.8.tar.gz
tar xzf php-7.2.8.tar.gz
cd /tmp/php-7.2.8
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
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
cp php.ini-development /usr/local/php/etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
export PATH=/usr/local/php/bin:$PATH
export PATH=/usr/local/php/sbin:$PATH

cd /tmp/php-7.2.8/ext/fileinfo
phpize
./configure
make & make install

# cd /tmp
# wget https://codeload.github.com/phpredis/phpredis/tar.gz/4.1.0 -O phpredis-4.1.0.tar.gz
# tar xzf phpredis-4.1.0.tar.gz
# cd /tmp/phpredis-4.1.0
pecl install igbinary
yes | pecl install redis

sed -i 's/user = .*/user = linux/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/group = .*/group = linux/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/listen.owner = .*/listen.owner = linux/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/listen.group = .*/listen.group = linux/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/pm.start_servers = .*/pm.start_servers = 2/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/pm.min_spare_servers = .*/pm.min_spare_servers = 2/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/pm.max_spare_servers = .*/pm.max_spare_servers = 4/' /usr/local/php/etc/php-fpm.d/www.conf.default
sed -i 's/catch_workers_output = .*/catch_workers_output = yes/' /usr/local/php/etc/php-fpm.d/www.conf.default
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
sed -i 's/;error_log = .*/error_log = \/tmp\/php_error.log/' /usr/local/php/etc/php.ini
echo 'extension=igbinary.so' >> /usr/local/php/etc/php.ini
echo 'extension=redis.so' >> /usr/local/php/etc/php.ini
echo 'extension=fileinfo.so' >> /usr/local/php/etc/php.ini

sed -i '1,3d' /etc/nginx/nginx.conf
sed -i '1i\daemon off;' /etc/nginx/nginx.conf
sed -i '1i\worker_processes 2;' /etc/nginx/nginx.conf
sed -i '1i\user linux;' /etc/nginx/nginx.conf

cat <<EOF > /etc/supervisord.d/default.ini
[php-fpm]
command=/usr/local/php/sbin/php-fpm -F
user=linux
autorestart=true
redirect_stderr=true
stdout_logfile=/data/php/log/php-fpm.log

[nginx]
command=nginx
user=linux
autorestart=true
redirect_stderr=true
stdout_logfile=/data/nginx/log/nginx.log
EOF

yum clean all
