---
title: sso 单点登录
date: 2017-08-14 10:57:24
tags: [Solution]
---

每天要接N多个需求，我也是很怀疑人生。本是在集群运维组干着运维系统开发，却被隔壁存储数据库组拉着每天做些数据结构思考题，虽然到现在我已经积攒了很多个思考题没来的及思考了。今天又来了个自己组的一个月前的bug要搞定。

多应用服务下，实现单点登录，多点信任的方案。

## SSO的基本概念

在wiki上的解释非常清晰，比其本身的名字(Single Sign-On)更清晰：在一个多应用但彼此独立的系统上，只要进行一次登录就可以在不同的应用中获得信任。就是你在淘宝登录一下，然后你在咸鱼、tmall、阿里云等等网站上都不用登录了，就可以直接被识别出来，不过是在一定时间长度内。

## 基本问题

实现这个系统有两个问题：

1. 用户数据统一
2. 系统内信息统一

首先就是你的一个用户名和密码在每个应用上都能登录。其次就是在你登录以后其他的应用都能获取到这个登录信息。

解决这个问题的主要思路就是建立一个公共的缓存，所有的应用都去这里提取用户的信任信息。有了公共缓存以后，问题的核心又转移到了客户端。因为客户端（这里就是指浏览器）在访问每个应用的时候所带有的信息是不一样的，所以你去缓存中也提取不到这个信息了。主要解决的就是如何让客户端在访问同一个系统中的不同应用的时候带有一个相同的ID信息。

## Cookie

这一部分的具体细节可以看下一篇博客。

## SSO的基本流程

在网上看到了很多实现方式的分析，还有人要步步深入，循序渐进。我觉得这个模型还是比较简单的，所以就直接来聊聊这个模型就可以了。

我们模型要解决的问题是：跨域名的单点登录。
问题主要使用的技术就是Cookie。

### 主要流程

1. 本机客户端也就是浏览器，发起一个请求到目标应用的服务器。
2. 服务器判断你没有登录，因为你没有携带任何的凭证信息在你的Cookie中。
3. 于是给你返回一个302，302就是一个重定向的返回代码，并且与之匹配的还有一个参数也会被返回过来，就是重定向的目标地址。同时还携带了这个服务器自己的URL地址，也就是你最终要访问的那个。
4. 浏览器接收到302和参数以后，自行发起一个到重定向地址的请求。请求中有一个参数，就是原目标地址。
5. 链接上这个地址，并且这个页面一般就是个登录页面。登录完成以后，这个第三方的服务器会在你的Cookie里写一个TokenId，并且也返回给你一个302。这次重定向的目的地是你真正要访问的地址。
6. 你的浏览器接受到这个参数就再一次发起请求，并且在Cookie中带有了一个TokenID。
7. 目的服务器验证成功，登录成功。

对于上面的过程中有几个东西要解释一下。
#### 302 
这是HTTP的一个状态码，表示暂时性的重定向到另外一个地址上去访问。在浏览器收到这个状态码的时候就去请求新的URL。

在php代码中，我们写`<?php header("Location:http://ip/path/"); ?>`就是返回一个重定向302的状态。基础知识很重要。

在下一篇Cookie中，也有这方面的内容。

### 如何认证

我自己用php写了一个简单的模型。还是比较简单的。
下面就按步骤介绍一下：

#### 修改本地hosts

hosts作为你的联通网络的第一个路由表，你可以做一些修改，比如给自己的电脑绑定n个不同的域名。
当然这个域名只在你的路由表中，所以只在你的电脑上管用。不过没关系，我们用这种方法模拟出了一个跨域名的环境。

ubuntu下hosts文件：`/etc/hosts`

在其中添加：
```
127.0.0.1   baiyan.a
127.0.0.1   paladnix.b

```

然后我们编写下面的几个php文件来模拟整个过程，文件位置在`/var/www/html/sso/`下。

#### 过程

首先我们去访问：`http://baiyan.a/sso/hello.php`
```php
<?php 

if( ($_GET['uuid']== '' || $_GET['uuid']!=553) && ($_COOKIE['uuid']=='' || $_COOKIE['uuid']!=553 )){
    header("Location:http://paladnix.b/sso/log.php?call_back=http://baiyan.a/sso/hello.php");
}
else{
    setcookie('uuid', $_GET['uuid'], time()+3600);
    echo "Hello ".$_GET['uuid']." ".$_COOKIE['uuid'];
}

```

根据你的参数和cookie来确定是否要定向到登录站点。并将自己的uri作为参数附在后面。

跳转到验证点
```php
<?php 

$call_back = $_GET['call_back'];

if( $_COOKIE['uuid'] == '' ){
    header("Location:http://paladnix.b/sso/loginh.php?call_back=$call_back");
}else{ 
    $uuid = 553;
    setcookie('uuid', $uuid);
    //echo $_COOKIE['uuid'];
    header("Location:$call_back?uuid=$uuid");
}

```

在这里判断一下对方最近是否有登录，也是通过cookie来判断，注意这里已经是另外一个域名了，所以cookie已经不一样了。没有登录定向到登录页面。

```php
<html>
    <head>
        <title>Login</title>
    </head>

    <body>
        <form method="post" action="login.php">
        <input type="text" name="name" value="" />
        <br>
        <input type="text" name="pw" value=""/>
        <br>
        <input type="hidden" name="call_back" value="<?php echo $_GET['call_back'] ?>" />

        <button type="submit">submit</button> 
        </form>
    </body>
</html>


```
在表单中添加了一个隐藏字段，`call_back`。填写信息并去验证。

```php
<?php

$name = $_POST['name'];
$pw = $_POST['pw'];
$call_back = $_POST['call_back'];

if($name == 'baiyan'){
    $uuid = 553;
    setcookie('uuid',$uuid, time()+1800);
    header("Location:$call_back?uuid=$uuid");
}
else {
    header("Location:http://paladnix.b/sso/loginh.php?call_back=$call_back");
}

```
验证并且写个cookie，并设置半小时后过期。
然后就会跳转回去显示hello了。

## 加密

上面的方式都是明文的非藏不安全，一般的做法，我们可以给cookie的内容加密。

在验证方式上，现在是没有再验证uuid的正确性。有些做法会拿到uuid以后再发送给登录服务器去校验真伪。我觉得这个完全可以避免，可以设计一个算法，在本地验证uuid的正确性比较优。

所以在编码uuid的时候我们可以将其有效时间也编在内，校验准确性的同时也也可以校验是否过期。我们可以再增加一个字段，使得uuid是由这个字段通过不可逆计算得到的hash值，然后到本地以后，重复这个算法，比对结果hash是否一致。

逐步完善吧。暂时还没有时间。
