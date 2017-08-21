---
title: tomcat Server.xml及其启动顺序
date: 2017-08-16 15:25:20
tags: [Java, Web, Tomcat]
---

欲仙又欲死。阿里巴巴真是一朵大奇葩。
一个写死的回调地址就能浪费我两天的时间去搞，还没有搞定。此坑绵绵无绝期。
一个sso的回调地址，写死的，要强行将应用部署到ROOT里中去。

在tomcat中有一个配置文件经常被用到，`conf/server.xml`。这个配置文件描述了如何启动tomcat server。
tomcat是servlet的容器，也就是能够运行servlet的一个程序。作为一个http服务的程序，可以监听端口，处理请求等。

## 配置文件结构

```
<Server>
    <Listener />
    <GlobaNamingResources>
    </GlobaNamingResources
    <Service>
        <Connector />
        <Engine>
            <Logger />
            <Realm />
               <host>
                   <Logger />
                   <Context />
               </host>
        </Engine>
    </Service>
</Server>
```

对我们来说，内层的`Service`才是有操作意义的部分。主要的部分简介如下：

| 元素 | 说明|
|:-----|-----|
| service | 提供服务的主体，默认的名字是Catalina |
| Connector | 客户端与服务端之间的连接，包括端口，协议版本，超时时间，等。 |
| Engine | 请求的处理机，接收和处理Connector的请求， 与host的联系比较大 |
| Context | 表示一个应用 | 
| host | 表示一个虚拟主机 | 

## Tomcat Server处理一个http请求的过程

假设来自客户的请求为：http://localhost:8080/wsota/wsota_index.jsp

在这里有一幅图我觉得非常清晰的说明了这个过程，但是其本身跟这个毫无关系。

![pic](/img/URL)

1. 请求被发送到本机端口8080，被在那里侦听的Coyote HTTP/1.1 Connector获得
2. Connector把该请求交给它所在的Service的Engine来处理，并等待来自Engine的回应
3. Engine获得请求localhost/wsota/wsota_index.jsp，匹配它所拥有的所有虚拟主机Host
4. Engine匹配到名为localhost的Host（即使匹配不到也把请求交给该Host处理，因为该Host被定义为该Engine的默认主机）
5. localhost Host获得请求/wsota/wsota_index.jsp，匹配它所拥有的所有Context
6. Host匹配到路径为/wsota的Context（如果匹配不到就把该请求交给路径名为""的Context去处理）
7. path="/wsota"的Context获得请求/wsota_index.jsp，在它的mapping table中寻找对应的servlet
8. Context匹配到URL PATTERN为.jsp的servlet，对应于JspServlet类
9. 构造HttpServletRequest对象和HttpServletResponse对象，作为参数调用JspServlet的doGet或doPost方法
10. Context把执行完了之后的HttpServletResponse对象返回给Host
11. Host把HttpServletResponse对象返回给Engine
12. Engine把HttpServletResponse对象返回给Connector
13. Connector把HttpServletResponse对象返回给客户browser

## Context

来看最重要的Context， 一般我们为每个应用做的定制化的东西都是依靠这个来做的，就比如我们要把war包部署成一个默认的应用。

安装完以后tomcat的默认的主目录是webapps/ROOT，我们直接localhost就是去访问这个路径下的应用。如果我们要更改默认路径，改成我们的某个应用可以定制一个context，如下:

```
<Context path="/" docBase="E:\tomcatApp\JeasyCMS" debug="0" reloadable="true" crossContext="true"/>

```

### 参数说明

**path** 是URL的路径。
**docBase** 是应用的文件路径，如果是开放的目录结构，直接写到目录的根目录中，如果是war包，需要将war包解包，然后写解包后的文件夹名。在此我要喷死网上的那些博主，写的什么JB玩意儿，我写war包的路径找了一天的原因，哼。垃圾。
**reloadable** 就是是否检测路径下的文件变化，即热部署的必要条件。

在一个项目中我碰到了一个问题，就是一个项目提供的API是带项目名称来访问的，但是这个项目本身有一个组件，这个组件自己重定向到自己的项目的时候用的是不带项目名称来访问的，而且是写死的，很难改。

也就是索，对于同一个项目有两种访问方式，我心一凉。这会肯定要被其他工程师骂是傻逼了，但是这也不是我写的呀，这个锅我不能背。

于是奇迹就出现了。

war包部署在webapps下是会被自动解包发布的，如果我将根路径也定向到这个解出来的包不就好了。于是加了一个Context就解决了这个口大黑锅。

### appBase & docBase

在host节点的配置中有一个appBase，这个路径是指，放在该路径下的web包或目录都会被自动发布，使用默认的方式发布。

每个host都对应了一个域名，有的时候我们会把多个域名绑定到一个机器上，这时候我们可以通过配置不同的host来定向不同的请求。

每个host下面，配置的是Context，每个context对应的是一个应用。所以可以配置应用的访问路径，并且配置其与实际路径之间的映射。
