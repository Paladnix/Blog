---
title: shadowsocks 搭建
date: 2018-06-29 16:59:05
tags: [Proxy]
---

正常的上网需要三个部分。

1. server
2. local
3. SwitchOmega

# shadowsocks server

租一个境外的服务器vps，然后搭建如下：

```bash
sudo apt install git python python-pip pyton3 python3-pip

pip install git+https://github.com/shadowsocks/shadowsocks.git@master


# 编辑配置文件：
# sudo vim /etc/shadowsocks.json
{
	"server": "149.28.194.217",     # 服务器IP
	"server_port": 8964,            # 服务器上的服务端口
	"local_address": "127.0.0.1",   # 本地地址
	"local_port": 1080,             # 本地需要代理的使用的端口
	"password": "www1964878036",    # 密码
	"timeout": 300,                 # 超时时间
	"method": "aes-256-cfb"         # 加密方法： aes-256-cfb, 还有一种比较快的：salsa20
}

# 直接启动：
ssserver -c /etc/shadowsocks.json

# 后台运行：
ssserver -c /etc/shadowsocks.json -d start

# 停止服务
ssserver -c /etc/shadowsocks.json -d stop

# 添加开机启动
sudo vim /etc/rc.local

ssserver -c /etc/shadowsocks.json -d start
```

# shadowsocks local

同样的安装过程，启动略有不同
安装过程同上

启动如下：
```bash
sslocal -s <SERVER IP> -p <SERVER PORT> -b <LOCALHOST IP> -l <LOCAL PORT> -k <PASSWORD> -m aes-256-cfb -d start
```

# 浏览器Chrome

去应用商店找SwitchOmega 插件，然后选项：

```bash
proxy 默认:

代理协议：  socks5
代理服务器：localhost
代理端口：  上面的LOCAL PORT
```

应用，然后选择auto switch
每个页面中有黄色的东西的数字提示的时候，点开插件，点开黄色内容，然后自动添加规则即可。


