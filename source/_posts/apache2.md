---
title: apache2 配置多端口服务
date: 2018-06-18 21:48:42
tags: [Linux, Web]
---

# 多端口多服务配置

个人服务器和一些低访问量的服务，使用apache2比较方便。
安装完以后打开默认的页面会看到有个介绍：

 ```
/etc/apache2/
|-- apache2.conf
|       `--  ports.conf
|-- mods-enabled
|       |-- *.load
|       `-- *.conf
|-- conf-enabled
|       `-- *.conf
|-- sites-enabled
|       `-- *.conf

```
这就是apache2的基本配置文件

## 1. apache.conf 

这个文件基本不用动，是apache的总配置文件。我只修改一项：
```
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride all    # default is None, change to all.
        Require all granted
</Directory>
```

## 2. ports.conf

这个文件用来添加监听的端口：
```
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 8088
Listen 4321

```
在这里添加了端口，还需要为每个端口配置各自的配置文件。

## 3. sites-avaliable

这个文件夹下是一些端口的配置文件。其中：
```
000-default.conf
```
是默认访问的端口，如果更改其中的内容就更改了默认访问的内容：
```
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/Paladnix.github.io

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

```

目前配置的是80端口，对应的文件目录是: `/var/www/Paladnix.github.io`

对于之前添加的端口，我们要添加一个配置文件，文件名： `端口.conf`, 非必须。

`8088.conf`:
```
<VirtualHost *:8088>

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

```
## 4 sites-enabled

所有在avaliable中的配置文件，如果没有在enabled中有连接，也都是不可访问的。

所以要开放某个端口，最后做一步：
```
ln -s sites-avalibale/8088.conf sites-enabled/8088.conf
```

## 5. 重启apache服务

```
sudo service apache2 restart
```

