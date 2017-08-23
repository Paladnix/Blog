---
title: Servlet
date: 2017-07-28 11:22:45
tags: [Java, Web, Servlet]
---

这里有一些概念非常的恶心，一开始的时候不太好理解是什么。通过一段时间的实践，我逐渐理解，所以直到今天才开始写这一篇。

## 容器Container

这个概念从我一开始接触Java就让我很困惑。
首先你需要先去看一下我在后面的一篇关于tomcat的配置文件：server.xml。在那里了解一下配置文件的结构，你可以看懂下面的这张图片。
![pic](/img/tomcat-1.jpg)

首先，容器这个东西是针对servlet来说的，也就是我们说的容器都是放置和运行servlet的程序。tomcat是个容器。但是上面的每一级都算是一种容器，只是大小不同。

### 为什么要有容器

其实对于计算机软件体系来说，一切的东西的出现都是因为标准和规定。
所谓容器其实就是一个程序，这个程序按照servlet需要的标准实现了一些接口，使得当你写了一个servlet以后可以成功的放在这个程序中运行，再直白一点就是，你把你的servlet程序交给这个容器，容器可以成功的运行你的程序。

他们之间通过约定一些标志物信息来实现无缝对接。
所以学习这写东西就是在学习了解他们之间约定的事物，以及，为什么这么约定，这样的约定有什么好处和坏处。

### 容器是一段程序吗？

在tomcat中，并没有容器这个东西，所以容器并不是一个东西，就像水果并不是一个具体的苹果一样。容器是一个抽象的概念。

在tomcat中，如上图，有很多的层。这些层就是一个容器结构。他们一起构成了一个完整的容器。

**Engine**
是一段基础的引擎程序。我认为是整个tomcat的基础，所有的其他容器都在其的调度控制之下。

**Host**
这是一个逻辑概念，但也有对应的实体。在讲tomcat的配置文件servers.xml 的时候，有提到这个host是什么回事。有了这一层，可以在一个tomcat容器中部署不同的项目，这些项目的域名都是不同的。也就是这个容器可以容纳很多的servlet并且这些servlet可以是几种粒度的。

你可以是完全不同的两个网站，域名都不同，放在一个容器中运行。你也可以是一个网站的不同组件，放在不同的Context内运行。

所以容器是个体系，不是一个东西。
其实按照这个思路，一切皆容器。因为一切的这些都是调度管理，操作系统调度进程，进程调度线程。一切都是接口和约定。所以万物皆容器。

## 什么是servlet

这是一个标准，你的程序符合这个标准就是一个servlet程序。
一个类其实就是一个servlet，但是很多个类在一起只要有一个servlet的接口，也是一个servlet。
（在此我们不再讨论tomcat的启动过程，我们更关心一个servlet放入tonmcat容器以后的过程）

来看一下这个图片，这就是servlet主要关联的几个类。
![pic](/img/servlet-1.jpg)

    **摘抄：**

从上图可以看出 Servlet 规范就是基于这几个类运转的，与 Servlet 主动关联的是三个类，分别是 ServletConfig、ServletRequest 和 ServletResponse。这三个类都是通过容器传递给 Servlet 的，其中 ServletConfig 是在 Servlet 初始化时就传给 Servlet 了，而后两个是在请求达到时调用 Servlet 时传递过来的。

我们很清楚 ServletRequest 和 ServletResponse 在 Servlet 运行的意义，但是 ServletConfig 和 ServletContext 对 Servlet 有何价值？
仔细查看 ServletConfig 接口中声明的方法发现，这些方法都是为了获取这个 Servlet 的一些配置属性，而这些配置属性可能在 Servlet 运行时被用到。
而 ServletContext 又是干什么的呢？ Servlet 的运行模式是一个典型的“握手型的交互式”运行模式。所谓“握手型的交互式”就是两个模块为了交换数据通常都会准备一个交易场景，这个场景一直跟随个这个交易过程直到这个交易完成为止。这个交易场景的初始化是根据这次交易对象指定的参数来定制的，这些指定参数通常就会是一个配置类。所以对号入座，交易场景就由 ServletContext 来描述，而定制的参数集合就由 ServletConfig 来描述。而 ServletRequest 和 ServletResponse 就是要交互的具体对象了，它们通常都是作为运输工具来传递交互结果。

### 一个web应用是如何被初始化的

对于tomcat来说，会一层一层的往下进行初始化，第一件要做的事情就是去找配置文件。
对于一个应用来说，首先会找到他的`web.xml`。tomcat会把这个文件解析成一个属性的类的对象WebXml。随后根据这个WebXml去设置这个context的容器环境。
这个时候就会创建对应的servlet对象，filter，listener等等。

这里有一个小的点，我看到了，写一下：
创建servlet对象的时候，并不是直接实例化成一个servlet对象，而是包装成StandardWrapper。
为什么要将 Servlet 包装成 StandardWrapper 而不直接是 Servlet 对象。这里 StandardWrapper 是 Tomcat 容器中的一部分，它具有容器的特征，而 Servlet 为了一个独立的 web 开发标准，不应该强耦合在 Tomcat 中。

但是初始化还并没有完成。

### 创建servlet对象

如果 Servlet 的 load-on-startup 配置项大于 0，那么在 Context 容器启动的时候就会被实例化, 在 conf 下的 web.xml 文件中定义了一些默认的配置项，其定义了两个 Servlet，分别是：org.apache.catalina.servlets.DefaultServlet 和 org.apache.jasper.servlet.JspServlet 它们的 load-on-startup 分别是 1 和 3，也就是当 Tomcat 启动时这两个 Servlet 就会被启动。

创建 Servlet 实例的方法是从 Wrapper. loadServlet 开始的。
loadServlet 方法要完成的就是获取 servletClass 然后把它交给 InstanceManager 去创建一个基于 servletClass.class 的对象。如果这个 Servlet 配置了 jsp-file，那么这个 servletClass 就是 conf/web.xml 中定义的 org.apache.jasper.servlet.JspServlet 了。

### 初始化 Servlet

初始化 Servlet 在 StandardWrapper 的 initServlet 方法中，这个方法很简单就是调用 Servlet 的 init 的方法，同时把包装了 StandardWrapper 对象的 StandardWrapperFacade 作为 ServletConfig 传给 Servlet。Tomcat 容器为何要传 StandardWrapperFacade 给 Servlet 对象将在后面做详细解析。

如果该 Servlet 关联的是一个 jsp 文件，那么前面初始化的就是 JspServlet，接下去会模拟一次简单请求，请求调用这个 jsp 文件，以便编译这个 jsp 文件为 class，并初始化这个 class。

这样 Servlet 对象就初始化完成了，事实上 Servlet 从被 web.xml 中解析到完成初始化，这个过程非常复杂，中间有很多过程，包括各种容器状态的转化引起的监听事件的触发、各种访问权限的控制和一些不可预料的错误发生的判断行为等等。我们这里只抓了一些关键环节进行阐述，试图让大家有个总体脉络。

## servlet 是如何工作的

当用户从浏览器向服务器发起一个请求，通常会包含如下信息：
`http://hostname: port /contextpath/servletpath`，
`hostname`和 `port` 是用来与服务器建立 TCP 连接，而后面的 URL 才是用来选择服务器中那个子容器服务用户的请求。那服务器是如何根据这个 URL 来达到正确的 Servlet 容器中的呢？

Tomcat7.0 中这件事很容易解决，因为这种映射工作有专门一个类来完成的，这个就是 org.apache.tomcat.util.http.mapper，这个类保存了 Tomcat 的 Container 容器中的所有子容器的信息，当 org.apache.catalina.connector. Request 类在进入 Container 容器之前，mapper 将会根据这次请求的 hostnane 和 contextpath 将 host 和 context 容器设置到 Request 的 mappingData 属性中。所以当 Request 进入 Container 容器之前，它要访问那个子容器这时就已经确定了。

下面这幅图就解释了整个流程
![pic](/img/servlet-2.jpg)

我们现正知道了请求是如何达到正确的 Wrapper 容器，但是请求到达最终的 Servlet 还要完成一些步骤，必须要执行 Filter 链，以及要通知你在 web.xml 中定义的 listener。  

接下去就要执行 Servlet 的 service 方法了，通常情况下，我们自己定义的 servlet 并不是直接去实现 javax.servlet.servlet 接口，而是去继承更简单的 HttpServlet 类或者 GenericServlet 类，我们可以有选择的覆盖相应方法去实现我们要完成的工作。

上面是基础的servlet原理，现在也很少有人直接这样用了，大多数会使用spring这样的框架来完成，在我的每天读点spring中去详细解释。

在使用spring的时候，我们往往只要配置一个spring的分发器的servlet。然后剩余的工作就交给这个分发器继续管理。所以我们可以使用注解来定义spring框架下的servlet。以及其他的特性。
