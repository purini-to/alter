#!/bin/bash

# 時刻を日本に設定
echo "==========================================================="
echo "  Set the time in Japan"
echo "==========================================================="
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
echo 'UTC=false' >> /etc/sysconfig/clock

# ファイヤーウォール無効化
#echo "==========================================================="
#echo "  Iptables disabled"
#echo "==========================================================="
#service iptables stop
#chkconfig iptables off

# 現在インストール済みのツールを最新にする
#echo "==========================================================="
#echo "  Currently the installed tool to the latest"
#echo "==========================================================="
#yum update -y

# カーネルのバージョンアップと必要なパッケージのインストール
# これをしないとvagrantのmountエラーが起こる
# http://qiita.com/wakaba260/items/b5c87b7815b710f303a0
#echo "==========================================================="
#echo "  Kernel version up"
#echo "==========================================================="
#yum install -y kernel-devel kernel-headers dkms gcc gcc-c++ wget
#yum install -y http://vault.centos.org/6.4/cr/x86_64/Packages/kernel-devel-2.6.32-431.el6.x86_64.rpm
#/etc/init.d/vboxadd setup

# Gitのインストール
echo "==========================================================="
echo "  Git install"
echo "==========================================================="
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
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
