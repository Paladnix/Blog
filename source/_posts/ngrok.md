---
title: ngrok服务端与客户端
date: 2018-06-16 23:19:50
tags: [Linux]
---

# 自己搭建Ngrok服务器

- 使用平台：Ali云 Ubuntu 16.04
- Go编译器版本： 1.9.1
- 依赖： gcc、cmake、build-essential、git

## 1. Ubuntu安装Go编译器

```bash
wget https://dl.google.com/go/go1.9.7.linux-amd64.tar.gz
tar -zxvf go1.9.7.linux-amd64.tar.gz
mv go/ /usr/local/


# vim /etc/profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# save & exit vim

source /etc/profile
go version

# 显示Go的版本即安装成功
```

## 2. 安装其他依赖

```bash

sudo apt install -y git gcc cmake build-essential screen

```

## 3. 下载ngrok源码并编译

```
git clone https://github.com/inconshreveable/ngrok.git ngrok
cd ngrok


# 生成ssl自签名证书， 需要被编译进最终可执行文件中

NGROK_DOMAIN="tunnel.paladnix.top"
#    注意域名换成你自己的
openssl genrsa -out base.key 2048
openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=$NGROK_DOMAIN" -out base.pem
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out server.crt
#    将生成的证书文件拷贝到指定位置，替代默认证书
cp base.pem assets/client/tls/ngrokroot.crt
cp server.crt assets/server/tls/snakeoil.crt
cp server.key assets/server/tls/snakeoil.key


# compile
# 可以交叉编译客户端和服务端
# 可以编译出Linux、Mac、Windows三个平台上的可执行文件
# 如果是当前平台运行的直接：
make release-server release-client

# 如果客户端需要在不同的平台

# Mac
GOOS=darwin GOARCH=amd64 make release-client

# Linux
GOOS=linux GOARCH=amd64 make release-client

# arm
GOOS=linux GOARCH=arm make release-client

# Windows
GOOS=windows GOARCH=amd64 make release-client

# 编译完成后，在./bin目录下出现:ngrok(client)、ngrokd(server)

```

## 4. Server端运行

```bash
# 直接执行命令
./ngrokd -domain="之前生成的证书中的域名或IP" -httpAddr=":8081" -httpsAddr=":8082"

# 执行成功后会监听4443端口和client进行通讯

```

一般会开成后台运行，使用screen

```

screen -S ngrok-keeper

./ngrokd -domain="之前生成的证书中的域名或IP" -httpAddr=":8081" -httpsAddr=":8082"

# Ctrl + A + D 离开当前screen
# screen -r 回到之前离开的screen

```

## 5. Client端运行

将对应平台的可执行文件下载下来，这里注意，自签名的证书是编译进可执行文件中的，因此要更换域名的时候要重新编译。

先创建一个配置文件

```bash
# vim ngrok.conf
server_addr: "YOUR_DOMAIN/IP"
trust_host_root_certs: false
# save & exit vim

# 将本机的TCP协议22端口暴露出去，用于ssh登录和scp
./ngrok -config=ngrok.conf -proto=tcp 22

# 将本机的http协议8080端口暴露出去， 用于访问本机网站
./ngrok -config=ngrok.conf -proto=http 8080

```

执行成功以后会看到下面的信息：
```bash
ngrok                                               (Ctrl+C to quit)

Tunnel Status                 online
Version                       1.7/1.7
Forwarding                    tcp://tunnel.paladnix.com:35291-> 127.0.0.1:22
Web Interface                 127.0.0.1:4040
# Conn                        0
Avg Conn Time                 0.00ms

```

接下来你就认为tunnel.paladnix.top:35291 就是你的内网主机就可以了。

## SSH & SCP 登录

```
# 任何其他电脑
ssh -p 35291 paladnix@tunnel.paladnix.top
# 其中用户名是你内网主机上的用户，密码是内网主机对应的密码
# 注意是小写的`-p`


scp -P 35291 paladnix@tunnel.paladnix.top:/home/paladnix/a.cpp ./
# 注意是大写的`-P`

```

接下来就可以各种骚了。
ngrok是以tcp协议做基础的，所以理论上可以有很多用法。有待开发。

## ngrok 配置文件

ngrok开源的1.x 的版本默认的配置文件是：`$HOME/.ngrok`, 这里的HOME不是PATH中的HOME是机器指定的HOME，一般就是用户目录。

```bash

# vim ~/.ngrok

server_addr: "tunnel.paladnix.top:4443"
trust_host_root_certs: false

tunnels:
    ssh:
        remote_port: 54321 # 指定远程端口是54321， 避免每次都是随机端口
        proto:
            tcp: 22
    
    http:
        proto:
            http: 3000

# 启动方式，可以同时启动，也可以单独启动
ngrok start ssh http
```

## 补充

客户端机器需要安装ssh—server，开启sshd服务

```bash
sudo apt install -y openssh-server
ps -e | ack sshd
# 查看是否有启动服务
# 如果没有启动就手动启动
sudo service ssh start
```

## ！解决断链接的问题

在使用的过程中总是频繁的断开连接，这个很影响游戏体验，主要就是ssh保持长连接的问题。
解决的办法也很简单

### 1. 配置客户端的sshd

```bash

# sudo vim /etc/ssh/sshd_config

# 添加下面代码在最后

ClientAliveInterval 10
ClientAliveCountMax 5

# 由于断开频繁，因此这里我的时间间隔很小只有10s

```

### 顺带配置客户端的ssh

非必须

```bash

# sudo vim /etc/ssh/ssh_config
# 在末尾添加

TCPKeepAlive yes
ServerAliveInteval 30
```
