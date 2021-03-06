#!/bin/bash

# 時刻を日本に設定
echo "==========================================================="
echo "  Set the time in Japan"
echo "==========================================================="
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
echo 'UTC=false' >> /etc/sysconfig/clock

# Gitのインストール
echo "==========================================================="
echo "  Git install"
echo "==========================================================="
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker gcc gcc-c++
wget -O - https://git-core.googlecode.com/files/git-1.8.5.2.tar.gz | tar zxvf -
cd git-1.8.5.2
./configure --prefix=/usr/local/
make prefix=/usr/local all
make prefix=/usr/local install
cd ../

sed -ir "s/Defaults    secure_path/#Defaults    secure_path/" /etc/sudoers
echo "Defaults    env_keep += \"PATH\"" >> /etc/sudoers

# GitプロトコルをHttpsプロトコルに変更
# 社内等ではポートが閉鎖されている場合があるため
git config --global url."https://".insteadOf git://

# 依存関係ツールをインストール
echo "==========================================================="
echo "  Tools install"
echo "==========================================================="
yum -y install cairo cairo-devel cairomm-devel libjpeg-turbo-devel libxml2-devel pango pango-devel pangomm pangomm-devel giflib-devel libpng-devel freetype freetype-devel libart_lgpl-devel

# MongoDBのインストール
echo "==========================================================="
echo "  MongoDB install"
echo "==========================================================="
cp -f /vagrant/10gen.repo /etc/yum.repos.d/10gen.repo
yum install -y mongo-10gen mongo-10gen-server

cp -f /vagrant/mongod.conf /etc/mongod.conf

# node.jsのインストール
echo "==========================================================="
echo "  Node.js install"
echo "==========================================================="
rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install -y nodejs npm --enablerepo=epel

# Expressのインストール
echo "==========================================================="
echo "  Express install"
echo "==========================================================="
npm install -g express-generator

# Gulpのインストール
echo "==========================================================="
echo "  Gulp install"
echo "==========================================================="
npm install -g gulp

# Bowerのインストール
echo "==========================================================="
echo "  Bower install"
echo "==========================================================="
npm install bower -g

echo "==========================================================="
echo "  All I was completed."
echo "  Goodbye!"
echo "==========================================================="
