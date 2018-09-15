#/bin/bash

adduser -u 1000 linux

yum install -y which
yum install -y git

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm install 2.4
gem install jekyll
gem install bundle

yum clean all
