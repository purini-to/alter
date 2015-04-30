# Alter
勉強用に作成
「MEAN stack」を使用してチャットアプリを作成する

## 依存関係
- Node.js
- MongoDB

## 環境構築
### Vagrant使用の場合(おすすめ)
Vagrantの使用できる環境で以下のコマンドを入力する
```
git clone https://github.com/purini-to/alter
cd alter
vagrant up
```
Provisionが動作して、「MEAN stack」の環境が整う

### 既存サーバーにインストールする
CentOS 6.6(64bit)の例です  
**Node.js**のインストール
```
rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install -y nodejs npm --enablerepo=epel
```
**MongoDB**のインストール
```
cat <<_EOT_ > /etc/yum.repos.d/10gen.repo
[10gen]
name=10gen Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64
gpgcheck=0
enabled=1
_EOT_
yum install -y mongo-10gen mongo-10gen-server
service mongod start
```
**NPM**を使用して各種ライブラリをインストール
```
npm install -g express-generator
npm install -g gulp
npm install -g bower 
```

## 実行方法
GitHubからソースをクローンする
```
git clone https://github.com/purini-to/alter
```
プロジェクトフォルダに移動後、依存関係のライブラリをインストールし、gulpタスクを実行する
```
cd alter
npm install
bower install
gulp
```
ローカルホスト(または、サーバーのホスト)の3000ポートにアクセス
```
http://localhost:3000
```
