---
title: tomcat
date: 2017-07-12 11:06:56
tags: [Web, Java, Tomcat]
---


# 日志
Tomcat的日志系统还算很完善的。来看一下，当你的应用出现问题的时候要去哪里找原因吧。
```
apache-tomcat/logs/
    |_ catalina.2017-07-12.log
    |_ catalina.out
    |_ host-manager.2017-07-12.log
    |_ localhost.2017-07-12.log
    |_ localhost_access_log.2017-07-12.txt
    |_ manager.2017-07-10.log
    |_ 对应的App应用的log文件夹，取决与你项目用的日志工具。

```
- catalina.out 这里的数据都是代码输出到标准输出流的重定向，所以你的SOUT都在这里。
- localhost.DATE.log 是你的应用抛出的错误，如页面运行错误，servlet错误等，常用查错工具。

其实目前我也就用过以上两种日志，可能用法还是不太对，入门的时候查日志感觉日志乱的要死。其实这个也不影响使用就是很影响心情，找错误一般可以直接搜索字符串定位就好了。但是我自己感觉还是要在项目开发之前就做好日志的规划工作，什么时候要打log什么时候不打，log的格式是怎样的。心情必须照顾！

# tomcat 安装到发布应用
这一部分非常简单。
### 安装
1. 下载tomcat-core代码包,并解压。
2. 到其bin/目录下，linux执行./startup.sh, windows执行startup.bat脚本。
3. 前提是需要配置JDK到环境变量。
4. 打开http://IP:8080 查看效果。
### 发布应用
将你的应用编译打包成一个war包，然后copy到其webapps文件夹下，通过`http://IP:8080/NameOfWar`访问。
如何开发Java Web？你需要了解：`servlet`、`SpringMVC`、`maven`、`javaBean`等。

# tomcat 源码梳理
打算看一下源码是怎么玩的，也有可能看不下去，坑先挖上...
