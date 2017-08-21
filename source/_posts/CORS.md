---
title: CORS Cross-Origin Resource Sharing
date: 2017-08-21 17:52:41
tags: [Web, Http]
---

有一种痛，叫做就是想让你多学习一点东西。

这个知识点，来源于一口还没找到源头的大黑锅。而我不能背这个锅，并且要找到一个人来背锅。

## Introduction

在之前的sso文章中，有提到过一个问题，就是cookie的不能跨域的问题。
出于安全考虑，浏览器会限制从脚本内发起的跨域HTTP请求。例如，XMLHttpRequest 和 Fetch 遵循同源策略。因此，使用 XMLHttpRequest或 Fetch 的Web应用程序只能将HTTP请求发送到其自己的域。为了改进Web应用程序，开发人员要求浏览器厂商允许跨域请求。

针对跨域的解决方案有很多，比如：flush、JSONP、ifame、xhr2等，但是都有很多弊端，我觉得CORS比较有前途。

这个解决方案已经被几乎所有的主流的浏览器支持了。浏览器内置了这种解决方案，所以对于前端的工程师来说就是透明的，当前端使用ajax发起一个跨域请求的时候，浏览器自动使用这个方案来处理。但是这个方案需要浏览器和服务器共同支持才可以。

今天主要的使用是依靠XMLHttpRequest来实现。这是一个js的对象，负责与服务端进行动态数据交互。

## 发起一个XMLHttpRequest请求

原生的请求形式。
```javascript
    <script type="text/javascript">  
        //XmlHttpRequest对象  
        function createXmlHttpRequest(){  
            if(window.ActiveXObject){ //如果是IE浏览器  
                return new ActiveXObject("Microsoft.XMLHTTP");  
            }else if(window.XMLHttpRequest){ //非IE浏览器  
                return new XMLHttpRequest();  
            }  
        }  

        //  调用getFile方法

        function getFile() {
            var img_Container = document.getElementById("img_Div");
            var xhr = createXmlHttpRequest();
            xhr.open('GET', 'http://oss.youkouyang.com/1.jpg', true);
            xhr.setRequestHeader('Content-Type', 'image/jpeg');
            xhr.responseType = "blob";
            xhr.onload = function() {
                if (this.status == 200) {
                    var blob = this.response;
                    var img = document.createElement("img");
                    img.onload = function(e) {
                        window.URL.revokeObjectURL(img.src); 
                    };
                    img.src = window.URL.createObjectURL(blob);
                    img_Container.appendChild(img);    
                }
            }
            xhr.send(null);
        }
    </script>

```

## 请求过程

请求分成两种，一种是简单请求，还有一种是非简单请求。

同时符合下面两种情况的是简单请求：
1. 属于下列method之一的
```
GET
POST
HEAD
```
2. HTTP的头信息不超出以下几种字段：
```
Accept
Accept-Language
Content-Language
Last-Event-ID
Content-Type：只限于三个值application/x-www-form-urlencoded、multipart/form-data、text/plain
```
除此以外是非简单请求。

### 简单请求

对于简单请求，浏览器会自动加上一个header字段Origin，然后发起访问：
```
GET /cors HTTP/1.1
Origin: http://api.bob.com
Host: api.alice.com
Accept-Language: en-US
Connection: keep-alive
User-Agent: Mozilla/5.0...
```
表示这个访问来自于什么源。

服务端收到这个请求以后查看这个源是否是合法的，如果是合法的就继续。如果是不合法的就返回。
但是请求都是成功的，区别就是在返回的header中。

如果是不合法的，返回的header中不会有这个字段：`Access-Control-Allow-Origin`
如果是合法的，就会多出下面的几个字段：
`
Access-Control-Allow-Origin: http://api.bob.com
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: FooBar
Content-Type: text/html; charset=utf-8
`

1. Access-Control-Allow-Origin
该字段是必须的。它的值要么是请求时Origin字段的值，要么是一个`*`，表示接受任意域名的请求。
2. Access-Control-Allow-Credentials
该字段可选。它的值是一个布尔值，表示是否允许发送Cookie。默认情况下，Cookie不包括在CORS请求之中。设为true，即表示服务器明确许可，Cookie可以包含在请求中，一起发给服务器。这个值也只能设为true，如果服务器不要浏览器发送Cookie，删除该字段即可。
3. Access-Control-Expose-Headers
该字段可选。CORS请求时，XMLHttpRequest对象的getResponseHeader()方法只能拿到6个基本字段：Cache-Control、Content-Language、Content-Type、Expires、Last-Modified、Pragma。如果想拿到其他字段，就必须在Access-Control-Expose-Headers里面指定。上面的例子指定，getResponseHeader('FooBar')可以返回FooBar字段的值。

### 非简单请求

非简单请求的CORS请求，会在正式通信之前，增加一次HTTP查询请求，称为"预检"请求（preflight）。
浏览器先询问服务器，当前网页所在的域名是否在服务器的许可名单之中，以及可以使用哪些HTTP动词和头信息字段。只有得到肯定答复，浏览器才会发出正式的XMLHttpRequest请求，否则就报错。

### 带Cookie

一般跨域请求是不带cookie的，需要打开相应的选项才会发送cookie，服务器请求写cookie的时候才会被浏览器接受。

服务器端需要指定`Access-Control-Allow-Credentials`字段。
`
Access-Control-Allow-Credentials: true
`
另一方面，开发者必须在AJAX请求中打开`withCredentials`属性。
`
var xhr = new XMLHttpRequest();
xhr.withCredentials = true;
`

需要注意的是，如果要发送Cookie，Access-Control-Allow-Origin就不能设为星号，必须指定明确的、与请求网页一致的域名。同时，Cookie依然遵循同源政策，只有用服务器域名设置的Cookie才会上传，其他域名的Cookie并不会上传，且（跨源）原网页代码中的document.cookie也无法读取服务器域名下的Cookie。

## Java tomcat实现

上面说的再多，你也很困惑，怎么实现，难道要我自己写吗？

在Java web中我们会使用过滤器来实现这个操作。暂时介绍使用第三方包：`cors-filter-1.7.jar`，`Java-property-utils-1.9.jar`

在web.xml中配置下面的东西就可以实现过滤了。
```xml
<filter>
    <filter-name>CORS</filter-name>
    <filter-class>com.thetransactioncompany.cors.CORSFilter</filter-class>
    <init-param>
     <param-name>cors.allowOrigin</param-name>
        <param-value>*</param-value>
<!--
// 允许访问的网站，多个时用逗号分开；*代表允许所有
<param-value>http://www.baidu.con,
 http://www.jd.com</param-value>
-->
    </init-param>
    <init-param>
     <param-name>cors.supportedMethods</param-name>
        <param-value>GET, POST, HEAD, PUT, DELETE</param-value>
    </init-param>
    <init-param>
     <param-name>cors.supportedHeaders</param-name>
        <param-value>Accept, Origin, X-Requested-With, Content-Type, Last-Modified</param-value>
    </init-param>
    <init-param>
        <param-name>cors.exposedHeaders</param-name>
        <param-value>Set-Cookie</param-value>
    </init-param>
    <init-param>
        <param-name>cors.supportsCredentials</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>CORS</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

```

### 安全

以上这些只能保证可以用，但是并不能保证安全，还是要有其他的方式进行安全验证才好。
