---
title: web.xml
date: 2017-08-01 20:59:50
tags:
---

其作用就是配置一个web程序的基本功能。容器在启动一个web项目的时候先读取这个配置文件，在配置文件读取无误后开始按照配置启动剩余的服务。

### 加载顺序
```
<context-param> -> <listener> -> <filter> -> <servlet>

```
容器会创建一个ServletContext，整个项目都会共用这个上下文。而`<context-param>`的内容以键值对的形式存在这个上下文中。
然后对读取`<listener>`，并实例化`listener`类，并初始化。
listener类中会有contextInitialized(ServletContextEvent args)初始化方法，启动Web应用时，系统调用Listener的该方法，在这个方法中获得：
```
ServletContext application = ServletContextEvent.getServletContext();
context-param的值 = application.getInitParameter("context-param的键");
```
得到这个context-param的值之后，你就可以做一些操作了。
**举例**：你可能想在项目启动之前就打开数据库，那么这里就可以在<context-param>中设置数据库的连接方式（驱动、url、user、password），在监听类中初始化数据库的连接。这个监听是自己写的一个类，除了初始化方法，它还有销毁方法，用于关闭应用前释放资源。比如:说数据库连接的关闭，此时，调用contextDestroyed(ServletContextEvent args)，关闭Web应用时，系统调用Listener的该方法。

所以归根结底，这个`<context-param>`就是用来存一些配置数据的地方。

比如：定义一个管理员email地址用来从程序发送错误，或者与你整个应用程序有关的其他设置。使用自己定义的设置文件需要额外的代码和管理；直接在你的程序中使用硬编码（Hard-coding）参数值会给你之后修改程序带来麻烦，更困难的是，要根据不同的部署使用不同的设置；通过这种办法，可以让其他开发人员更容易找到相关的参数，因为它是一个用于设置这种参数的标准位置。


#### web-app

根元素，不用多说

#### display-name
应用的名称，这个在tomcat的维护信息中会出现。

#### session
```xml
<session-config>   
<session-timeout>120</session-timeout>   
</session-config>

```

#### listener
```xml
<!--****************************监听器配置*********************************-->  
<!-- Spring的log4j监听器 -->  
<listener>  
    <listener-class>org.springframework.web.util.Log4jConfigListener</listener-class>  
</listener>  
<listener>  
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
</listener>

```

监听器用来监听各种事件，比如：application和session事件，所有的监听器按照相同的方式定义，功能取决去它们各自实现的接口，常用的Web事件接口有如下几个：

- ServletContextListener：用于监听Web应用的启动和关闭；
- ServletContextAttributeListener：用于监听ServletContext范围（application）内属性的改变；
- ServletRequestListener：用于监听用户的请求；
- ServletRequestAttributeListener：用于监听ServletRequest范围（request）内属性的改变；
- HttpSessionListener：用于监听用户session的开始和结束；
- HttpSessionAttributeListener：用于监听HttpSession范围（session）内属性的改变。

`listener`类是实现了以下两个接口中任何一个接口的简单java类：javax.servlet.ServletContextListener或javax.servlet.http.HttpSessionListener，如果想让你的类监听应用的启动和停止事件，你就得实现ServletContextListener接口；想让你的类去监听Session的创建和失效事件，那你就得实现HttpSessionListener接口。

有两种为应用配置listener的方式：
- 使用@WebListener修饰Listener实现类即可。
- 在web.xml文档中使用<listener>进行配置。

在下一节配置spring的加载类的时候会给出例子。

#### spring相关配置
配置spring，必须需要`<listener>`，`<context-param>`如果有就去加载配置的路径，没有就默认是`/WEB-INF/applicationContext.xml`。
```xml
<!-- spring config -->  
<!-- if this node is not exist, -->
<context-param>  
    <param-name>contextConfigLocation</param-name>  
    <param-value>/WEB-INF/spring-configuration/*.xml</param-value>  
</context-param>  
<listener>  
     <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
 </listener>

```
事实上，spring的配置也是有两种不同的方式的，一种是上面的这种使用`listener`的方式，还有一种是使用`servlet`的方式，这两种方式的区别在与什么时候加载。
使用listener的方式，是在web启动的时候加载，并且加载的顺序是在`filter`之前。所以在`filter`中就可以使用spring的类，否则其中的对象就是空的，就无法使用。所以我们一般选用上面的这种配置方式来启动spring。

另外一种方式也放出来：
```xml
<servlet>    
    <servlet-name>context</servlet-narne>   
    <servlet-class>org.springframework.web.context.ContextLoaderServlet</servlet-class>    
    <load-on-startup>1</load-on-startup>    
</servlet>

```

### Filter
Filter可认为是Servle的一种“加强版”，主要用于对用户请求request进行预处理，也可以对Response进行后处理，是个典型的处理链。使用Filter的完整流程是：Filter对用户请求进行预处理，接着将请求HttpServletRequest交给Servlet进行处理并生成响应，最后Filter再对服务器响应HttpServletResponse进行后处理。Filter与Servlet具有完全相同的生命周期，且Filter也可以通过<init-param>来配置初始化参数，获取Filter的初始化参数则使用FilterConfig的getInitParameter()。

换种说法，Servlet里有request和response两个对象，Filter能够在一个request到达Servlet之前预处理request，也可以在离开Servlet时处理response，Filter其实是一个Servlet链。以下是Filter的一些常见应用场合，

- (1)认证Filter
- (2)日志和审核Filter
- (3)图片转换Filter
- (4)数据压缩Filter
- (5)密码Filter
- (6)令牌Filter
- (7)触发资源访问事件的Filter
- (8)XSLT Filter
- (9)媒体类型链Filter

Filter可负责拦截多个请求或响应；一个请求或响应也可被多个Filter拦截。
Filter必须实现javax.servlet.Filter接口，在该接口中定义了三个方法：

- void init(FilterConfig config)：用于完成Filter的初始化。FilteConfig用于访问Filter的配置信息。
- void destroy()：用于Filter销毁前，完成某些资源的回收。
- void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)：实现过滤功能的核心方法，该方法就是对每个请求及响应增加额外的处理。该方法实现对用户请求request进行预处理，也可以实现对服务器响应response进行后处理---它们的分界线为是否调用了chain.doFilter(request，response)，执行该方法之前，即对用户请求request进行预处理，执行该方法之后，即对服务器响应response进行后处理。

#### filter配置
Filter配置与Servlet的配置非常相似，需要配置两部分：配置Filter名称和Filter拦截器URL模式。区别在于Servlet通常只配置一个URL，而Filter可以同时配置多个请求的URL。配置Filter有两种方式：
- Annotation注解相应类
- web.xml

<filter>用于指定Web容器中的过滤器，可包含`<filter-name>`、`<filter-class>`、`<init-param>`、`<icon>`、`<display-name>`、`<description>`。

- <filter-name>用来定义过滤器的名称，该名称在整个程序中都必须唯一。
- <filter-class>元素指定过滤器类的完全限定的名称，即Filter的实现类。
- <init-param>为Filter配置参数，与<context-param>具有相同的元素描述符<param-name>和<param-value>。

**<filter-mapping>**元素用来声明Web应用中的过滤器映射，过滤器被映射到一个servlet或一个URL 模式。这个过滤器的<filter>和<filter-mapping>必须具有相同的<filter-name>，指定该Filter所拦截的URL。过滤是按照部署描述符的<filter-mapping>出现的顺序执行的。


#### Example
```xml
<!-- 字符集过滤器 -->  
  <filter>  
    <filter-name>CharacterEncodingFilter</filter-name>  
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>  
    <init-param>  
      <param-name>encoding</param-name>  
      <param-value>UTF-8</param-value>  
    </init-param>  
    <init-param>  
      <param-name>forceEncoding</param-name>  
      <param-value>true</param-value>  
    </init-param>  
  </filter>  
<filter-mapping>  
    <filter-name>CharacterEncodingFilter</filter-name>  
    <url-pattern>/*</url-pattern>  
  </filter-mapping>


```

### Servlet

Servlet通常称为服务器端小程序，是运行在服务器端的程序，用于处理及响应客户的请求。Servlet是个特殊的java类，继承于HttpServlet。客户端通常只有GET和POST两种请求方式，Servlet为了响应则两种请求，必须重写`doGet()`和`doPost()`方法。大部分时候，Servlet对于所有的请求响应都是完全一样的，此时只需要重写`service()`方法即可响应客户端的所有请求。
另外HttpServlet有两个方法:
- init(ServletConfig config)：创建Servlet实例时，调用该方法的初始化Servlet资源。
- destroy()：销毁Servlet实例时，自动调用该方法的回收资源。
通常无需重写`init()`和`destroy()`两个方法，除非需要在初始化Servlet时，完成某些资源初始化的方法，才考虑重写`init()`方法，如果重写了`init()`方法，应在重写该方法的第一行调用super.init(config)，该方法将调用HttpServlet的`init()`方法。如果需要在销毁Servlet之前，先完成某些资源的回收，比如关闭数据库连接，才需要重写`destory()`。

#### 生命周期

创建Servlet实例有两个时机：
客户端第一次请求某个`Servlet`时，系统创建该`Servlet`的实例，大部分`Servlet`都是这种`Servlet`。
Web应用启动时立即创建`Servlet`实例，即`load-on-start Servlet`。

每个Servlet的运行都遵循如下生命周期：
1. 创建Servlet实例。
2. Web容器调用Servlet的init()方法，对Servlet进行初始化。
3. Servlet初始化后，将一直存在于容器中，用于响应客户端请求，如果客户端发送GET请求，容器调用Servlet的doGet()方法处理并响应请求；如果客户端发送POST请求，容器调用Servlet的doPost()方法处理并响应请求。或者统一使用service()方法处理来响应用户请求。
4. Web容器决定销毁Servlet时，先调用Servlet的destory()方法，通常在关闭Web应用时销毁Servlet实例。

#### 配置

为了让Servlet能响应用户请求，还必须将Servlet配置在web应用中。
从Servlet3.0开始，配置Servlet有两种方式：
- 在Servlet类中使用`@WebServlet Annotation`进行配置。
- 在`web.xml`文件中进行配置。

我们用web.xml文件来配置Servlet，需要配置`<servlet>`和`<servlet-mapping>`。
`<servlet>`用来声明一个Servlet。`<icon>`、`<display-name>`和`<description>`元素的用法和`<filter>`的用法相同。`<init-param>`元素与`<context-param>`元素具有相同的元素描述符，可以使用<init-param>子元素将初始化参数名和参数值传递给Servlet，访问Servlet配置参数通过ServletConfig对象来完成，ServletConfig提供如下方法：
- java.lang.String.getInitParameter(java.lang.String name)：用于获取初始化参数
- ServletConfig获取配置参数的方法和ServletContext获取配置参数的方法完全一样，只是ServletConfig是取得当前Servlet的配置参数，而ServletContext是获取整个Web应用的配置参数。

- `<description>`：为Servlet指定一个文本描述。
- `<display-name>`：为Servlet提供一个简短的名字被某些工具显示。
- `<icon>`：为Servlet指定一个图标，在图形管理工具中表示该Servlet。

`<servlet>`必须含有`<servlet-name>`和`<servlet-class>`，或者`<servlet-name>`和`<jsp-file>`。 描述如下：
- `<servlet-name>`用来定义servlet的名称，该名称在整个应用中必须是惟一的
- `<servlet-class>`用来指定servlet的完全限定的名称。
- `<jsp-file>`用来指定应用中JSP文件的完整路径。这个完整路径必须由/开始。

**<load-on-startup>**

如果`load-on-startup元素存在`，而且也指定了`jsp-file`元素，则JSP文件会被重新编译成`Servlet`，同时产生的Servlet也被载入内存。`<load-on-startup>`的内容可以为空，或者是一个整数。这个值表示由Web容器载入内存的顺序。
举个例子：如果有两个Servlet元素都含有`<load-on-startup>`子元素，则`<load-on-startup>`子元素值较小的`Servlet`将先被加载。如果`<load-on-startup>`子元素值为空或负值，则由Web容器决定什么时候加载Servlet。如果两个Servlet的`<load-on-startup>`子元素值相同，则由Web容器决定先加载哪一个Servlet。
`<load-on-startup>1</load-on-startup>`表示启动容器时，初始化Servlet。

**<servlet-mapping>**

<servlet-mapping>含有<servlet-name>和<url-pattern>
- <servlet-name>：Servlet的名字，唯一性和一致性，与<servlet>元素中声明的名字一致。
- <url-pattern>：指定相对于Servlet的URL的路径。该路径相对于web应用程序上下文的根路径。<servlet-mapping>将URL模式映射到某个Servlet，即该Servlet处理的URL。

**加载Servlet的过程**
容器的Context对象对请求路径(URL)做出处理，去掉请求URL的上下文路径后，按路径映射规则和Servlet映射路径i`<url- pattern>`做匹配，如果匹配成功，则调用这个Servlet处理请求。


#### DispatcherServlet在web.xml中的配置：

```xml
<!-- Spring view分发器  对所有的请求都由business对应的类来控制转发 -->  
<servlet>  
    <servlet-name>business</servlet-name>  
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>  
    <init-param>  
      <param-name>publishContext</param-name>  
      <param-value>false</param-value>  
    </init-param>  
    <load-on-startup>1</load-on-startup>  
</servlet>  
```
