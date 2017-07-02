---
title: jersey
date: 2017-07-01 20:32:52
tags: [Java, jersy, Web]
---

jersy是一个Web Service的框架，据说是符合RESTful架构的一种框架，这是一种新的思路，而不是新的技术，是对于前端的各种技术而言，所设计的后台实现方式，力图以一种统一的方便的方式组织为前端提供数据。
[jersey的官网](https://jersy.gtihub.io).

此次接触这个框架是业务需要了，但是，觉得这个框架比较简单，正好也有时间，所以就做一个学习实验，探索一下在资源短缺的情况下如何学习一个新的东西。事实上资源也确实不是很多，这一次主要依靠官方文档学习使用。


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


