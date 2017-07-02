---
title: jersey
date: 2017-07-01 20:32:52
tags: [Java, jersy, Web]
---

jersy是一个Web Service的框架，据说是符合RESTful架构的一种框架，这是一种新的思路，而不是新的技术，是对于前端的各种技术而言，所设计的后台实现方式，力图以一种统一的方便的方式组织为前端提供数据。
[jersey的官网](https://jersy.gtihub.io).

此次接触这个框架是业务需要了，但是，觉得这个框架比较简单，正好也有时间，所以就做一个学习实验，探索一下在资源短缺的情况下如何学习一个新的东西。事实上资源也确实不是很多，这一次主要依靠官方文档学习使用。

原本打算直接上代码的，但是在官网上看了一会后就发现有好多名词解释的问题。那就先来看几个名词。

首先第一个就是`JAR-RS`，这是JAVA EE6引进的新技术，全称Java api for RESTful Web Service. 主要是使用了注解的形式来简化Web开发和部署。然后跟Jersey的关系是Jersey实现了JAR-RS的框架接口，并且扩展了更多的东西，提供了自己的API。

然后学习Jersey的第一步就是搞懂他的路由方式，在这里就是注解了。

在讲注解之前还有一个不是很重要的名词：`POJO(Plain Old Java Object)`, 称之为简单一般Java对象，这个概念是与JavaBean做区分的。其实没有什么必要，引用Martin Fowler的一句话：

我们疑惑为什么人们不喜欢在他们的系统中使用普通的对象，我们得到的结论是——普通的对象缺少一个响亮的名字，因此我们给它们起了一个，并且取得了很好的效果。       ——Martin Fowler

所以事实上也就是个名词，所谓简单Java对象就是不包含业务逻辑的对象，一般用于描述数据实体。具体的区别等到写JavaBean的时候就看出来了，这里不讲了。


在我手中的项目使用了其中的两个包，maven代码如下：

```xml
        <!-- jersey -->
        <dependency>
            <groupId>org.glassfish.jersey.containers</groupId>
            <artifactId>jersey-container-servlet</artifactId>
            <version>2.25</version>
        </dependency>
        <dependency>
            <groupId>org.glassfish.jersey.core</groupId>
            <artifactId>jersey-client</artifactId>
            <version>2.25</version>
        </dependency>
```
可以看到一个是servlet的Container，另外一个是client客户端。具体的用法，等到用到再说。

# 注解路由

这里用的路由就是JAR-RS的规范。（一次写不完，慢慢补充）。

## @Path
这个注解的原文解释非常好，解释成中文就变味了，所以有时间的还是去看一下原文是怎么写的吧，下面我就结合自己理解写一下。

这个@Path注解的内容是一个相对的[URI](./)路径
