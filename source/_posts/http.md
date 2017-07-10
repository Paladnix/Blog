---
title: 你所不知道的http协议之优秀
date: 2017-07-10 19:02:33
tags: [http]
---

# 协议

协议就是数据格式+确认策略。
你所需要知道的就是协议是如何分类的，一般我们按照其工作的层次来分类，分成：通信层协议、应用层协议、物理层协议等七个层次的协议。整个计算机网络体系是由这么多层次组成，但是发展到今天我们主要关心的其实就是两个层次上的协议：通信层、应用层。TCP/IP协议属于通信层，Http属于应用层，也有人认为http属于通信层。关于http属于什么层次，可以是两个架构之间的区别，一种就是RESTful模式的，也是我们常用的；还有一种就是SOA（面向服务的体系结构)他是将http当作通信层协议来使用的。这个关于什么是RESTful和SOA就可以写一篇，这里你只需要知道现在正在向RESTful模式迁移就可以了。

(成熟的架构大局观+敏锐的技术嗅觉，这是一个CTO必备的能力。)

# http协议

http协议（超文本传输协议）是现代计算机网络最最重要的组成部分。其协议简洁、高效、灵活、强大，也是计算机应用下一步进化的方向。

除了上面讲的几个你体会不到的特点以外，下面几个特点你要清楚：
- 无连接： 不需要保持连接，一个请求干一件事，干完就过。
- 无状态： 换句话说就是没有记忆，这一点有利有弊。

## 内容
[http1.1](https://tools.ietf.org/pdf/rfc2616.pdf)的RFC文档在此，有兴趣的可以去看看。内容比你想的多得多，比我知道的也多得多。本文就简单的介绍一下http报文结构啊什么的，那些网上到处都是，没必要说太多。

### Request
由于是应用层，所以我们就只关心数据而不关心其他的东西。
报文结构如下：
```http
GET /562f25980001b1b106000338.jpg HTTP/1.1
Host    img.mukewang.com
User-Agent    Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36
Accept    image/webp,image/*,*/*;q=0.8
Referer    http://www.imooc.com/
Accept-Encoding    gzip, deflate, sdch
Accept-Language    zh-CN,zh;q=0.8

xxx
```
报文由四个部分组成，请求行、请求头、空行、请求数据。
1. 第一行是请求行，包含三个数据，空格分隔：请求方法、请求资源(URL)、协议版本。
2. 下面紧跟的是请求头，是n个键值对，空格分隔，包含其他的数据：请求的目的地、什么浏览器、该请求接受什么返回格式、什么编码... 
3. 空一行
4. 请求数据。

### Response
返回报文一样四部分：状态行、消息报头、空行和响应正文。
```http
HTTP/1.1 200 OK
Date: Fri, 22 May 2009 06:07:21 GMT
Content-Type: text/html; charset=UTF-8

<html>
      <head></head>
      <body>
            <!--body goes here-->
      </body>
</html>
```
1. 状态行：协议版本、状态码、状态消息
2. 消息报头： Date:生成响应的日期和时间；
              Content-Type:指定了MIME类型的HTML(text/html),编码类型是UTF-8
3. 空行
4. 正文

#### 状态码
- 1xx：指示信息--表示请求已接收，继续处理
- 2xx：成功--表示请求已被成功接收、理解、接受
- 3xx：重定向--要完成请求必须进行更进一步的操作
- 4xx：客户端错误--请求有语法错误或请求无法实现
- 5xx：服务器端错误--服务器未能实现合法的请求

常用的：
- 200 OK                        //客户端请求成功
- 400 Bad Request               //客户端请求有语法错误，不能被服务器所理解
- 401 Unauthorized              //请求未经授权，这个状态代码必须和WWW-Authenticate报头域一起使用 
- 403 Forbidden                 //服务器收到请求，但是拒绝提供服务
- 404 Not Found                 //请求资源不存在，eg：输入了错误的URL
- 500 Internal Server Error     //服务器发生不可预期的错误
- 503 Server Unavailable        //服务器当前不能处理客户端的请求，一段时间后可能恢复正常

## 请求方法
- GET     请求获取Request-URI所标识的资源
- POST    在Request-URI所标识的资源后附加新的数据
- HEAD    请求获取由Request-URI所标识的资源的响应消息报头
- PUT     请求服务器存储一个资源，并用Request-URI作为其标识
- DELETE  请求服务器删除Request-URI所标识的资源
- TRACE   请求服务器回送收到的请求信息，主要用于测试或诊断
- CONNECT 保留将来使用
- OPTIONS 请求查询服务器的性能，或者查询与资源相关的选项和需求

### GET & POST
老生长谈的问题，从来没有写下来过，写一次：
This is GET:
```http
GET /books/?sex=man&name=Professional HTTP/1.1
Host: www.wrox.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.6)
Gecko/20050225 Firefox/1.0.1
Connection: Keep-Alive
```
And this is POST:
```http
POST / HTTP/1.1
Host: www.wrox.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.6)
Gecko/20050225 Firefox/1.0.1
Content-Type: application/x-www-form-urlencoded
Content-Length: 40
Connection: Keep-Alive

name=Professional%20Ajax&publisher=Wiley
```
That's all.

GET 不安全，长度受到浏览器的限制。POST安全，不受限。

POST还有一个加强版叫：`soap`，POST是无结构数据，就是简单的K-V数据。`soap`是个专用的POST版本，用于传输`xml`格式的数据。

### PUT & POST
这两个的区别牵出了一个新的东西--幂等，而幂等又牵出了另外一个著名的问题--分布式服务的重复问题。

幂等是个数学概念，后来是个计算机概念，意思就是`s*s=s`。

其问题场景是这样的，在一个分布式系统中我们第一次发送的请求已经被正确执行，但是由于网络抖动请求返回报文客户端没有收到，客户端刷新了一下，于是就又发送了这个请求，这个请求又被做了一次，加入这个动作是付款的话。

这就要求我们的操作要具有幂等性，也就是说相同的操作，对整个系统产生的副作用是相同的。幂等是个语义范畴的东西，无法被协议检测出来，但是http本身又是一个分布式的协议，所以这个幂等在http中具有举足轻重的地位。
那么这个问题怎么解决？目前有两种方式，一种是引入分布式中间件。把复杂的验证问题交给中间件来解决，（据其他人说）中间件往往会架构笨重，事物容易被绑定在中间件上，不利于系统异构集成。另外就是性能上也很是问题。另一种就是利用幂等设计，很神奇。

这个幂等就是PUT特有的，而POST不具备幂等的特性。
所谓幂等设计就是说我对于一个请求，由服务端生成一个唯一的处理id，这个id用于为后续操作保证幂等，对于同一个id只做一次操作，但是每次都返回第一次操作的结果。这种设计相比中间件必然很轻量级。

不过这个问题，我也没有深究，所以理解起来也不深刻。大家纠结最多的是POST和PUT什么时候该用哪个的问题，我也没有答案。哈。

# 协议分析利器

下面透露点真正的干货。
不管是搞开发还是搞点乱七八糟的小研究，抓包都是程序员最喜欢玩的喽。介绍三个抓包的玩具。

## tcpdump
如你所见，tcp为基础的包都能抓，最长用来抓http的包。可以定点抓，定端口抓，输出到很多目标。
其特点就是--多。信息流多到人力看不过来，所以一般都是配合提取工具比如`grep` 来获取想要的信息。
这个是linux自带工具，不需要安装。
怎么用，暂时[可以看这里](http://blog.csdn.net/kofandlizi/article/details/8106841)

## httpty
```bash
sudo apt install httpry
```
转为http搞的，用起来感觉信息不太够，可能是我不会用。

[扩展阅读](http://www.cnblogs.com/zhengah/p/4422786.html)

## charles

MAC上的工具，还是个付费的。不过也有免费版，去[官网下载](https://www.charlesproxy.com/download/)

怎么用还没玩过呢。待补充。
