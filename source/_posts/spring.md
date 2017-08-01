---
title: spring-Java web framework
date: 2017-07-28 10:24:01
tags: [Java, Web]
---

并没有用到这个，虽然整个ali都是spring系的，但我手中的项目都是jersey的，所以就这个就不是工作重点了。但是还是要学的，尤其是spring的几个概念很好玩。

Spring 是为了解决企业应用程序开发复杂性而创建的。框架的主要优势之一就是其分层架构，分层架构允许选择使用哪一个组件，同时为 J2EE 应用程序开发提供集成的框架。

之前在学习Spring框架的时候主要研究了两个概念，一个是：控制反转`(IOC)`，还有一个是：面向切面编程`(AOP)`。今天来整理一下。

## Spring 模块

学习框架或是其他的库，先概览一下这个东西是由什么组成，然后顺着这个设计思路就可以理解其工作方式。
据说Spring的模块化做的很好，每个模块都可以单独存在。下面这附图很直观的描述了其体系结构。
分两层，共7个模块，其他模块工作在`Core`模块之上。
![Spring Framework Modle](/img/spring_framework.gif)

每个模块的功能如下:

```
核心容器：核心容器提供 Spring 框架的基本功能。核心容器的主要组件是 BeanFactory，它是工厂模式的实现。BeanFactory 使用控制反转 （IOC） 模式将应用程序的配置和依赖性规范与实际的应用程序代码分开。

Spring Context：Spring 上下文是一个配置文件，向 Spring 框架提供上下文信息。Spring 上下文包括企业服务，例如 JNDI、EJB、电子邮件、国际化、校验和调度功能。

Spring AOP：通过配置管理特性，Spring AOP 模块直接将面向切面的编程功能集成到了 Spring 框架中。所以，可以很容易地使 Spring 框架管理的任何对象支持 AOP。Spring AOP 模块为基于 Spring 的应用程序中的对象提供了事务管理服务。通过使用 Spring AOP，不用依赖 EJB 组件，就可以将声明性事务管理集成到应用程序中。

Spring DAO：JDBC DAO 抽象层提供了有意义的异常层次结构，可用该结构来管理异常处理和不同数据库供应商抛出的错误消息。异常层次结构简化了错误处理，并且极大地降低了需要编写的异常代码数量（例如打开和关闭连接）。Spring DAO 的面向 JDBC 的异常遵从通用的 DAO 异常层次结构。

Spring ORM：Spring 框架插入了若干个 ORM 框架，从而提供了 ORM 的对象关系工具，其中包括 JDO、Hibernate 和 iBatis SQL Map。所有这些都遵从 Spring 的通用事务和 DAO 异常层次结构。

Spring Web 模块：Web 上下文模块建立在应用程序上下文模块之上，为基于 Web 的应用程序提供了上下文。所以，Spring 框架支持与 Jakarta Struts 的集成。Web 模块还简化了处理多部分请求以及将请求参数绑定到域对象的工作。

Spring MVC 框架：MVC 框架是一个全功能的构建 Web 应用程序的 MVC 实现。通过策略接口，MVC 框架变成为高度可配置的，MVC 容纳了大量视图技术，其中包括 JSP、Velocity、Tiles、iText 和 POI。

```
就这一段我copy过来的东西就有很多新鲜的东西。解释一下：
**工厂模式和bean**
这个东西就很大，简单说，工厂模式是一种设计模式。程序设计，搞到现在终于体会到什么是程序设计了吧。跟工业革命是一个道理，从手工作坊到工厂生产。这种设计模式无非就是要简化你写代码的过程，而这个工厂模式就是用来简化对象创建过程的一个设计模式。
在创建一个复杂对象的时候，往往我们要先建一些辅助对象，然后把辅助对象塞进去才能把对象真正new出来。这就是传统手工生产。
但是工厂模式也不是就那么简单的，这个工厂模式还有一个发展过程
```
1）简单工厂模式（Simple Factory） 又称静态工厂方法模式
2）工厂方法模式（Factory Method） 
3）抽象工厂模式（Abstract Factory）
```
简单工厂模式就是有一个工厂类，他专门负责生产对象，但是只能生产某1个对象。
工厂方法模式就是有一个抽象的工厂类或是工厂接口，各个派生工厂类各自生产某一个对象。有一个抽象产品类，然后派生多个产品类。
抽象工厂模式就是有多个抽象工厂类和多个抽象产品类，然后每个工厂类可以生产很多种产品。

其实这就跟现实生活中的工厂发展类似，最初刚有工厂的时候，建这一个工厂只能生产一种特性的产品，这个产品改个颜色都可能实现不了。然后这个产品不断的发展有不同的型号，就开多个工厂，或是多个生产线。对于销售部们来说，工厂怎么生产并不重要，他们只需要发个请求给抽象工厂类，说自己要什么型号工厂就会送过来。
然后对于企业高层整体来说，这样的管理还是太乱了，自己要同时管理这么多工厂，每个工厂在什么时候做什么还要管。他们最希望的就是能有一种综合工厂出现，这个综合工厂什么都能生产，然后这个工厂的管理单独交给一个人来做。当然这是一个抽象的概念了，不存在什么都能生产的工厂，但是抽象以后就把工厂管理这件事情留在了底层，上层不需要插手。这就是工厂的发展思路。
对下工作细分，对上接口统一。这是作为一个组件所必须具有的特性。记住这个原则，就能明白了。

对与写程序来说，刚开始我们会写一个方法，做到传几个参数就返回给我一个类。后来渐渐的每个类都要写这个方法很累。你就想写一个类，在这个类里写一个通用的方法，并设计一种规则来准确描述你的需求，也就是你要生成的对象。然后这个类就根据你的描述流程化的生产出来这个类给你，这样你只要编写描述语句就可以了。也能够一定程度上实现动态配置，因为文本文件变化不需要编译，只需要打包就好了，非常快。再往上就超出了我目前的理解范围，哈。
我的理解也只是一种形象的认识，很浅显。参考自两篇文章:[文章1](http://blog.csdn.net/jason0539/article/details/44976775)、[文章2](http://blog.csdn.net/jason0539/article/details/44976775)。有兴趣的可以去看看。

Java bean是一个规范，符合这个规范的类可以称为Bean。这个规范使用在基础可重用组建的开发中。其特点是类中实现一些：`isXX()`、`setXX()`、`getXX()`、`addXX()`、`removeXX()`等。其主要解决的问题是向后兼容性问题。通俗的讲就是你要保证你的类在更改了内部实现方法以后其接口不变。也就原来怎么获取一个值，现在还怎么获取这个值，无论你类内的实现是实时计算还是实时记录。可以看这个[描述](https://www.zhihu.com/question/19773379)

**ORM框架**
我认为这不是一个好的设计，也不是一个好的组建，最好不用。
这个就是在数据库的SQL上做一层封装，屏蔽数据库SQL之间的差异，用一种ORM语言来进行数据操作。
好处就那么一些，但是坏处：
- 第一 这是设计给不懂数据库的人用的。但是学习ORM语言和体系本身也要成本，不如直接学习SQL。
- 第二 效果不理想，无法覆盖问题，速度还慢。
- 第三 错误不好定位。
### IOC 控制反转

这些框架和规范，其最终的目的都无非这么几个：解耦、兼容、加速。
控制反转也称为依赖注入。
这个控制反转不是很好理解，但是依赖注入就很好理解了。
所谓依赖就是一的一个类中要依赖很多其他的类，那么在实例化的时候就要把这些依赖的类都实例化掉。当然很麻烦了，而且实例化越多程序就越慢！这个依赖注入就是上面的工厂模式的实现方式。
通过配置文件，描述类之间的依赖关系，然后由工厂，也可以认为是`IOC`容器来读取这个文件，并帮你组装好你要的实例，你只要申请一下就行了。在Spring中你都不需要申请，他会监测你的需求。

依赖具体指什么呢？
如果我们写一个汽车的类，那么这个汽车的类就会以其他的类做为成员，比如方向盘类。当我方向盘类中的参数发生变化的时候，不同的代码写法就会有不同的效果。我们肯定希望我们要改动的地方越少越好，最好是不用改代码。下面举例子来说明两种注入方式：`构造注入`、`工厂注入`

```java
class Car {
    P pan;
    Car(){
        pan = new P(10);
    }
}

/*
    如果我们需要一个直径是10的方向盘，我们可以这样写。
    但是如果这个P类的构造方法发生了变化，这个类也要改，因为你调用了这个构造方法。
    构造注入的方式是下面这种：
*/

class Car {
    P pan;
    Car(P _pan){
        pan = _pan;
    }
}

/*
    这就解决了上面的问题。
    下面这个例子是工厂注入的方式。
*/
class Factory{
    Car c = new Car();
    Car getCar(){
        return c;
    }
}

main(String[] args){
    Car car = Factory.getCar();
}

// 其本质就是工厂设计模式，只是在Spring中有了特殊的角色而已。
```

## AOP 面向切面编程

面向对象已经不能满足的程序员对程序设计的追求了。
什么是切面呢。
对于一个程序来说，一旦我们启动就顺序执行，这个是没有问题的。然而面向切面编程的方式能够在你的程序中运行一些特定的程序，但是这些程序是你没有写的，就比如说日志。
其可以将日志等组件，原本是是要分散在程序中各个地方的模块化，在需要使用的部件中配置一下就可以了完成其使命。使得日志对编写程序的工程师来说是透明的。
所以所谓切面就是程序运行流程的切面。

AOP技术是建立在Java语言的反射机制与动态代理机制之上的。其原理也并不复杂，当运行过程中我们要调用一个类的时候，其实我们调用的并不是原始的类，AOP动态创建了一个代理类给你调用，并且将预先配置的例如日志组件插入到目标方法中，从而实现将组建复合进程序切面中同时执行。

关于这方面的东西，底层的东西我也不太懂。有几个概念需要知道：
```
连接点（Joinpoint）：就是程序在运行过程中能够插入切面的地点。例如，方法调用、异常抛出或字段修改等，但spring只支持方法级的连接点。

切入点（Pointcut）：用于定义通知应该切入到哪些连接点上。不同的通知通常需要切入到不同的连接点上，这种精准的匹配是由切入点的正则表达式来定义的。
（用于定义：啥时候干）

通知（Advice）：是切面的具体实现。以目标方法为参照点，根据放置的地方不同，可分为前置通知（Before）、后置通知（AfterReturning）、异常通知（AfterThrowing）、最终通知（After）与环绕通知（Around）5种。在实际应用中通常是切面类中的一个方法，具体属于哪类通知，同样是在配置中指定的。
（用于定义：干啥）
```

*相比之下，面向对象是细腻的，用继承和组合的方式，绵绵编织成一套类和对象体系。*
*面向切面是豪放的，大手一挥：凡某包某类某开头的方法，一并如斯处理！*

*没有依赖注入，面向切面就失去立足之本。*
*没有面向切面，依赖注入之后也只好在各个方法里下死力气写重复代码，或者搞出来一个超级复杂的抽象基类。*

*同时有了这两者，才真正能履行拆分、解耦、模块化、约定优于配置的思想，才真正能实现合并重复代码、专注业务逻辑的愿望。*

概念都介绍的差不多了，下面来用吧。
需要说明的是，Spring是个广泛应用的框架，在软件的各个场景都可以使用，在Web上，有Spring MVC的组合使用方式。这里介绍的就是这个玩意儿。

## maven配置

命令行使用mvn构建项目很简单。
```bash
mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-webapp  -DarchetypeVersion=1.0   -DgroupId=com.test  -DartifactId=first   -Dversion=1.0
```
生成的目录如下：
```
.
└── first
    ├── pom.xml
    └── src
        └── main
            ├── resources
            └── webapp
                ├── index.jsp
                └── WEB-INF
                    └── web.xml

```
然后配置`pom.xml`。

```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.first</groupId>
    <artifactId>first</artifactId>
    <packaging>war</packaging>
    <version>1.0-SNAPSHOT</version>
    <name>hello Maven Webapp</name>
    <url>http://maven.apache.org</url>

  <properties>
	<jdk.version>1.8</jdk.version>
	<spring.version>4.3.9.RELEASE</spring.version>
	<jstl.version>1.2</jstl.version>
	<servletapi.version>3.1.0</servletapi.version>
  </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>3.8.1</version>
            <scope>test</scope>
        </dependency>

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>${spring.version}</version>
    <exclusions>
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>${spring.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-beans</artifactId>
        <version>${spring.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-web</artifactId>
        <version>${spring.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>${spring.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-aop</artifactId>
        <version>${spring.version}</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>${spring.version}</version>
    </dependency>

	<dependency>
		<groupId>javax.servlet</groupId>
		<artifactId>jstl</artifactId>
		<version>${jstl.version}</version>
	</dependency>

	<!-- compile only, deployed container will provide this -->
	<dependency>
		<groupId>javax.servlet</groupId>
		<artifactId>javax.servlet-api</artifactId>
		<version>${servletapi.version}</version>
		<scope>provided</scope>
	</dependency>
  </dependencies>


  <build>
      <finalName>first</finalName>

		<plugins>
		    <!-- Eclipse project -->
		  <plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-eclipse-plugin</artifactId>
			<version>2.9</version>
			<configuration>
			        <!-- Always download and attach dependencies source code -->
				<downloadSources>true</downloadSources>
				<downloadJavadocs>false</downloadJavadocs>
				<!-- Avoid type mvn eclipse:eclipse -Dwtpversion=2.0 -->
				<wtpversion>2.0</wtpversion>
			</configuration>
		  </plugin>

		  <!-- Set JDK Compiler Level -->
		  <plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-compiler-plugin</artifactId>
			<version>3.3</version>
			<configuration>
                <source>${jdk.version}</source>
                <target>${jdk.version}</target>
			</configuration>
		  </plugin>

		  <!-- For Maven Tomcat Plugin -->
		  <plugin>
			<groupId>org.apache.tomcat.maven</groupId>
			<artifactId>tomcat8-maven-plugin</artifactId>
			<version>2.2</version>
			<configuration>
				<path>/CounterWebApp</path>
			</configuration>
		  </plugin>

		</plugins>
  </build>

</project>

```
下面你可以使用命令行编译这个项目看看是否成功：
```
mvn compile
```
或者你也可以直接`install`这个项目的到目标`war`包：
```
mvn install
```
生成的`war`包在`target/`文件夹下。直接将这个war包放到`tomcat`的`webapps/`文件夹下即可。然后打开浏览器，地址栏输入`loaclhost:8080/xxx`。 xxx为你的war包的名字，不带后缀。

## web.xml

现在我们事实上并没有使用到spring，页面上只有一个helloworld。
接下来我们就要配置这个`web.xml`。
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

- <description>：为Servlet指定一个文本描述。
- <display-name>：为Servlet提供一个简短的名字被某些工具显示。
- <icon>：为Servlet指定一个图标，在图形管理工具中表示该Servlet。

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

