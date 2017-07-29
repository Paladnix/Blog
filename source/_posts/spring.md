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

