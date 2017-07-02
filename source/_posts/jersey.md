---
title: jersey
date: 2017-07-01 20:32:52
tags: [Java, jersy, Web]
---

jersy是一个Web Service的框架，据说是符合RESTful架构的一种框架，这是一种新的思路，而不是新的技术，是对于前端的各种技术而言，所设计的后台实现方式，力图以一种统一的方便的方式组织为前端提供数据。
[jersey的官网](https://jersy.gtihub.io).

此次接触这个框架是业务需要了，但是，觉得这个框架比较简单，正好也有时间，所以就做一个学习实验，探索一下在资源短缺的情况下如何学习一个新的东西。事实上资源也确实不是很多，这一次主要依靠官方文档学习使用。

原本打算直接上代码的，但是在官网上看了一会后就发现有好多名词解释的问题。那就先来看几个名词。

首先第一个就是`JAX-RS`，这是JAVA EE6引进的新技术，全称Java api for RESTful Web Service. 主要是使用了注解的形式来简化Web开发和部署。然后跟Jersey的关系是Jersey实现了JAX-RS的框架接口，并且扩展了更多的东西，提供了自己的API。

然后学习Jersey的第一步就是搞懂他的路由方式，在这里就是注解了。

在讲注解之前还有一个不是很重要的名词：`POJO(Plain Old Java Object)`, 称之为简单一般Java对象，这个概念是与JavaBean做区分的。其实没有什么必要，引用Martin Fowler的一句话：

“我们疑惑为什么人们不喜欢在他们的系统中使用普通的对象，我们得到的结论是——普通的对象缺少一个响亮的名字，因此我们给它们起了一个，并且取得了很好的效果。”       ——Martin Fowler

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

这里用的路由就是JAX-RS的规范。（一次写不完，慢慢补充）。

## @Path
这个注解的原文解释非常好，所以有时间的还是去看一下原文是怎么写的吧，下面我就结合自己理解写一下。

这个@Path注解的内容是一个相对的[URI](2017/URI)路径，由其注解的类会被相应的路径访问到。

在下面这个例子中可以看到，这个类被一个@Path注解为"printers"，当URL路径为`/printers`的时候就会路由到这个类中，那么这个类有那么多函数，调用那个函数呢？下面还有子路径以及路径的通信方式。

首先`HTTP-Methods`都是被支持的，常用的有：
- @POST
- @GET
- @PUT
- @DELETE
并且对于每个函数都可以进行@Path的进一步注解，有过Web开发经验的人都知道是怎么玩的。如果你的URL路径是`/printers/list`， 就会定位到`getListOfPrinters()`函数。同理可知其他的用法。
需要说的可能是如果一个函数没有注解而其他的函数有注解，在路径为`printers`的时候就会定位那个没有注解的，因为其他的都是精确匹配的，按照精确匹配无法匹配到其他的函数，这个是不精确匹配的，所以就过来了。

对于`/`，开始和结尾的位置可以加可以不加，都能够被解析。除此以外，这里还有些内容你可能看不太懂，下面会讲。

```java
@Path("/printers")
public class PrintersResource {
 
    @GET
    @Produces({"application/json", "application/xml"})
    public WebResourceList getMyResources() { ... }
 
    @GET @Path("/list")
    @Produces({"application/json", "application/xml"})
    public WebResourceList getListOfPrinters() { ... }
 
    @GET @Path("/jMakiTable")
    @Produces("application/json")
    public PrinterTableModel getTable() { ... }
 
    @GET @Path("/jMakiTree")
    @Produces("application/json")
    public TreeModel getTree() { ... }
 
    @GET @Path("/ids/{printerid}")
    @Produces({"application/json", "application/xml"})
    public Printer getPrinter(@PathParam("printerid") String printerId) { ... }
 
    @PUT @Path("/ids/{printerid}")
    @Consumes({"application/json", "application/xml"})
    public void putPrinter(@PathParam("printerid") String printerId, Printer printer) { ... }
 
    @DELETE @Path("/ids/{printerid}")
    public void deletePrinter(@PathParam("printerid") String printerId) { ... }
}
```
注解除了简单的字符串以外，按照JAX-RS的规范，在路径中可以设定变量。也就是上面看到的`@Path("{printerid}")`的用法，这里的话花括号中的部分就是变量，是用URL的方式传参过来的。对应的在其函数的定义中，参数列表中就对这个参数做了声明：`@PathParam("printerid")`，就作为参数传进来了。对于参数，还可以进行正则匹配，格式如下：`@Path("{name: [a-zA-Z]*}")`，则如果参数符合大小写字母的限制就能够正确匹配，否则就是404了。

## @Produce
很明显这个注解是描述了这个方法或是类可以生产什么东西，什么类型的东西，也就是返回给Client什么类型的内容，如果是`text/html`，则返回的就是一个页面。这个东西在HTTP请求的`accept`字段会有限制，如果accept注明了接受什么类型的数据，那么就会选择对应的生产者去调用，在其他注解方式相同的情况下。

可以选择多个MIME媒体类型。
## @Consumes
消费者，就是这个类或方法可以接受什么媒体类型的数据，例如:`@Consumes(MediaType.APPLICATION_JSON)`就说明该函数可以接受Json类型的数据。具体的用法还没有用过，暂时不写。

待续...
