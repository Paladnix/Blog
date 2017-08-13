---
title: 每天读点Spring(2)--Start
date: 2017-08-12 19:02:40
tags: [Java, Spring, Maven]
---

在本章中，作者开篇就讲到，学习一个新的开发工具最难的就是不知道从哪里入手，尤其是Spring这样有很多选择的框架。但是幸好在这本书中是简单的，下面介绍一些必要的基本知识。

这就是很人性的化的写技术书籍的方式，透露出考虑之周到。
我觉得很多时候，国内的教育体制总是要用比人家多的时间去学会一个东西。很多人看到老外中学成绩都很差，到了大学才开始学习。但是仔细想一下就会发现不太对劲，为什么人家学习的深度比我们还深呢？明明没有我们的基础好，也没有我们花费的时间多啊。

我觉得很大一部分原因是国内的教材有问题。很多教材都是非常的笼统的介绍一个东西是什么，然后就搬上一大堆理论出来证明。但是让人看了很费劲，因为我不一定就具备了看懂这个知识的基础能力，可能我要先去了解一下什么东西再来看这个会效果更好。在我看的很多国外工程师写的文档或者是书中，都有这样的设定，要么会给出在你继续往下看之前你需要去了解的知识清单，要么就直接把需要的知识写在正式内容之前。这是一个非常负责的行为，在人家眼里是很正常的事情，在我们这里可能就是不在我的工作范围中。就像初中上高中的时候，初中老师说这个你们在以后上高中就知道了，高中老师说，你们应该在初中就学过了。有些老师会讲，这些老师的学生就会很轻松的就掌握这部分东西。

不要觉得什么都要别人告诉你很low，学习就是一个这样的过程，你需要别人不断的告诉你一些东西，那些已经被解决的问题不是你主要要解决的问题，而是你要快速掌握的理论。你在学车的时候如果碰到一个什么都不教，直接让你把车开起来上路的师傅，你就会说：“如果我什么都知道还要来学嘛？”，就是这个道理。

国内很多作者纯粹就是急于求成，这些看似不是自己的责任的事情就不做，默认你会。然后把那些确实是核心的问题官方的表述一下，就算是写完了一本技术著作。很不厚道，我作为学生非常鄙视这样的人。

## 需要具备的知识

也不能算是知识，是关于Spring的一些更细节的信息，和设计。

### 理解Spring的包

这部分介绍了Spring是由哪些模块构成，你可以按照自己的需求选择使用那些模块，并介绍了每个模块的基本功能。

在Spring4.0.2发行版中一共有20个包。每个模块的包名格式如下，以aop为例：spring-aop-4.0.2.RELEASE.jar

| Jar File | Description | 
|-----|-------------|
| aop      | 如果你要用到AOP功能，或是你用到的Spring的其他模块用到了这个功能，你就需要把这个包添加进你的项目中|
| aspects  | 如果你用到了AspectJ AOP的功能就要包含这个包（Aspectj是Eclipse出的一个AOP的编程框架，Spring 兼容了它） |
| bean | 包含了所有用来实现Spring控制bean的类，其中很多类也都支持Spring的bean工程模式，例如解析xml和注解的类|
| context | 这个包给Spring core提供了很多扩展能力，Spring的很多功能都依赖于此，并且实现交互的脚本语言也是集成在其中的 | 
| context-support | 这个包有扩展了context的功能，例如邮件支持、模板引擎例如Velocity、FreeMaker，此外还有很多作业的执行和调度，例如CommonJ(计时器)和Quartz(作业调度)都打包在这里。|
| core | 这是你必须包含的包，其中的类被用在很多其他的包中，并且有一些全局工具你也可以用在自己的代码中 | 
| expression | 这个包是支持Spring Expression Language的，是一种强大而简洁的装配Bean的方式 |
| instrument | 这个模块包括Java虚拟机的引导(翻译有待确认)？当你在使用AspectJ时需要使用这个包 |
| instrument-tomcat | JVM Bootstrapping in the tomcat-server | 
| jdbc | 数据库链接操作相关 |
| messaging | 是基于消息的应用相关的，以及支持STOMP消息文本协议 | 
| orm | 扩展了JDBC，支持ORM框架，诸如Hibernate、JDO、JPA |
| oxm | 支持Object/XML Mapping (OXM) | 
| test | 提供了强大的单元测试的功能，紧密集成了JUnit | 
| tx | 支持分布式事物操作 | 
| web | web功能的核心，支持了文件上传，参数解析等 | 
| web-mvc | 支持MVC模式的web | 
| web-portlet | 门户网站服务器部署支持（Not know）|
| websocket | 支持Java API for WebSocket（Not know） |

随后讲了你可以用maven获取这些，就像你不知道maven一样

## Example

下面作者将一个Hello World的程序通过演进，利用Spring来实现。

首先在简单的Hello World就不写了。作者对于这个HelloWorld提出了两个要求，就是要能够动态的输出东西，并且能够支持输出到不同的目标上，并将这个项目改写成了下面的样子。

增加了两个接口，一个是`MessageProvider`还有一个是`MessageRender`。

MessageProvider:

```java
package com.paladnix;

/**
 *  MessageProvider Interface
 * 
 */

public interface MessageProvider {
    String getMessage();
}

```

MessageRender:

```java
package com.paladnix;

/**
 *  MessageRender Interface 
 * 
 */

public interface MessageRender{
    void render();
    void setMessageProvider(MessageProvider provider);
    MessageProvider getMessageProvider();
}

```

这两个都是符合JavaBean风格的接口。所谓JavaBean风格就是get和set一堆的那种。

然后来实现两个实现其功能的类：
HelloMessageProvider:

```java
package com.paladnix;

public class HelloMessageProvider implements MessageProvider{
    @Override
    public String getMessage(){
        return "Hello World";
    }
}

```

StdOutMessageRender:
```java
package com.paladnix;

public class StdOutMessageRender implements MessageRender{
    private MessageProvider messageProvider;

    @Override
    public void render(){
        if( messageProvider == null ){
            throw new RuntimeException("You must set the property messageProvider of class:" + StdOutMessageRender.class.getName());
        }
        System.out.println(messageProvider.getMessage());
    }

    @Override
    public void setMessageProvider(MessageProvider provider){
        this.messageProvider = provider;
    }

    @Override
    public MessageProvider getMessageProvider(){
        return this.messageProvider;
    }
}


```

main:
```java
package com.paladnix;

/**
 * Hello world!
 *
 */
public class Hello {

    public static void main( String[] args ){
        MessageRender mr = new StdOutMessageRender();
        MessageProvider mp = new HelloMessageProvider();
        mr.setMessageProvider(mp);
        mr.render();
    }
}

```

这样的代码就比原来的要高端很多了吧。但是依然是灵活性很差。然后作者引入了工厂模式，工厂模式可以看之前关于Spring的想关文章。这里就不介绍了，其本质就是反射。

## Factory

下面来看工厂模式的实现方式。

Factory
```java
package com.paladnix;

import java.io.FileInputStream;
import java.util.Properties;

public class MessageSupportFactory {
    private static MessageSupportFactory instance;

    private Properties props;
    private MessageRender renderer;
    private MessageProvider provider;

    private MessageSupportFactory(){
        props = new Properties();

        try {
            props.load(new FileInputStream("msf.properties"));

            String renderClass = props.getProperty("render.class");
            String providerClass = props.getProperty("provider.class");

            renderer = (MessageRender)Class.forName(renderClass).newInstance();
            provider = (MessageProvider)Class.forName(providerClass).newInstance();
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    static {
        instance  = new MessageSupportFactory();
    }

    public static MessageSupportFactory getInstance(){
        return instance;
    }

    public MessageRender getMessageRender(){
        return renderer;
    }

    public MessageProvider getMessageProvider(){
        return provider;
    }
}


```

HelloWorldWithFactory:

```java
package com.paladnix;

public class HelloWorldWithFactory {
    public static void main(String[] args){
        MessageRender mr = MessageSupportFactory.getInstance().getMessageRender();
        MessageProvider mp = MessageSupportFactory.getInstance().getMessageProvider();
        mr.setMessageProvider(mp);
        mr.render();
    }
}

```


## Refactoring with Spring

main

```java
package com.paladnix;

import org.spring.framework.context.ApplicationContext;
import org.spring.framework.comtext.support.ClassPathXmlApplicationContext;

public class HelloWorldWithSpring{
    public static void main(String[] args){
        ApplicationContext ctx = new ClassPathXmlApplicationContext
            ("META-INF/spring/app-context.xml");

        MessageRender mr = ctx.getBean("render", MessageRender.class);
        mr.render();
        
    }
}

```

app-context:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:p="http://www.springframework.org/schema/p"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">

<bean id="provider" class="com.paladnix.HelloMessageProvider"/>
<bean id="render" class="com.paladnix.StdOutMessageRender" >
    <property name="messageProvider" ref="provider"/>
</bean>

</beans>

```

这里配置的bean的装配方式。比如其中的`StdOutMessageRender`类是要依赖于`HelloMessageProvider`类的，所以就要配置`property`，使得`messageProvider`成员ref于`provider`， 也就是其依赖的bean的ID。
除了以来关系，我们还可以写`value`来初始化这个成员。

### Maven

上面的这些代码都是我们抛开项目来说的，那么如何从Maven开始建立起这个项目作者并没有写，我在这里补充一下。

首先在命令行建立一个maven项目：
```bash
mvn archetype:generate 
```

这个命令是用交互的方式进行配置项目基本信息的，想比较直接把配置信息写出来更便捷，尤其是在基础的Java项目结构中。
这个命令执行过程中第一个需要你填写或是选择的就是基本的项目结构，命令行中打印出了10个选项，每个项目选项都有一个说明，并且默认是第7个，我就是用的默认结构，最简单。

随后还会有名字，也就是Maven项目的坐标信息了。

建立完目录，接下来就把我们的代码放进去。把我们之前的代码都放在其中的`src/main/java/com/paladnix`，后面的目录是根据名字设定的，看情况就明白了。

这个时候我们的配置文件我们需要建个文件夹来放。我们在`main`文件夹下建立一个`resources`目录，在其中建立路径：`MEAT-INF/spring/app-context.xml`。这个xml就是我们spring的配置文件了。

resources文件夹默认是静态文件夹，在编译的时候这个文件夹中的东西会被原封不动的与class放在一起。所以内部的路径也就不会变，在java代码中，我们就直接引用这个子路径就可以了。

然后目录基本上好了，接下来我们要配置一下pom.xml，主要就是两个事情，一个是添加spring的依赖；还有一个就是指定主类，因为我们打包以后执行这个包没有主类的话无法执行。配置成下面的样子：

```xml

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.paladnix</groupId>
    <artifactId>springDemo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>springDemo</name>
    <url>http://maven.apache.org</url>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>4.3.3.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>3.8.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>1.2.1</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>com.paladnix.HelloWorldWithSpring</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

</project>


```
在其中我们只是配置了一个`context`的组件，但是mvn可以自己识别传递的依赖信息，将这个`context`需要的依赖默认添加进来，添加进来后大概有这些：
```
    ├── dependency
    │   ├── commons-logging-1.2.jar
    │   ├── junit-3.8.1.jar
    │   ├── spring-aop-4.3.3.RELEASE.jar
    │   ├── spring-beans-4.3.3.RELEASE.jar
    │   ├── spring-context-4.3.3.RELEASE.jar
    │   ├── spring-core-4.3.3.RELEASE.jar
    │   └── spring-expression-4.3.3.RELEASE.jar

```

然后这些搞好以后我们就可以编译执行了：
```
mvn clean package  dependency:copy-dependencies 

# 将依赖的包一并打包进来。
```

然后执行jar包就可以看到HelloWorld了。
```
java -jar target/xxxx.jar

```
以上就是第二章中的一些精华部分了，感觉这样跟着写下来会收获很多，比如工厂模式的实现方式，也更能借此实现来理解Spring是怎么做的。还有maven的一些使用细节，在编译的时候是怎么报错，如何看报错信息。在执行的时候发现spring的有个配置语法失效，然后换回了原始的方式去配置。

整体的目录如下：

```
.
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── paladnix
│   │   │           ├── Hello.java
│   │   │           ├── HelloMessageProvider.java
│   │   │           ├── HelloWorldWithFactory.java
│   │   │           ├── HelloWorldWithSpring.java
│   │   │           ├── MessageProvider.java
│   │   │           ├── MessageRender.java
│   │   │           ├── MessageSupportFactory.java
│   │   │           └── StdOutMessageRender.java
│   │   └── resources
│   │       └── META-INF
│   │           └── spring
│   │               └── app-context.xml
│   └── test
│       └── java
│           └── com
│               └── paladnix
│                   └── AppTest.java
└── target
    ├── classes
    │   ├── com
    │   │   └── paladnix
    │   │       ├── Hello.class
    │   │       ├── HelloMessageProvider.class
    │   │       ├── HelloWorldWithFactory.class
    │   │       ├── HelloWorldWithSpring.class
    │   │       ├── MessageProvider.class
    │   │       ├── MessageRender.class
    │   │       ├── MessageSupportFactory.class
    │   │       └── StdOutMessageRender.class
    │   └── META-INF
    │       └── spring
    │           └── app-context.xml
    ├── dependency
    │   ├── commons-logging-1.2.jar
    │   ├── junit-3.8.1.jar
    │   ├── spring-aop-4.3.3.RELEASE.jar
    │   ├── spring-beans-4.3.3.RELEASE.jar
    │   ├── spring-context-4.3.3.RELEASE.jar
    │   ├── spring-core-4.3.3.RELEASE.jar
    │   └── spring-expression-4.3.3.RELEASE.jar
    ├── dependency-reduced-pom.xml
    ├── maven-archiver
    │   └── pom.properties
    ├── maven-status
    │   └── maven-compiler-plugin
    │       ├── compile
    │       │   └── default-compile
    │       │       ├── createdFiles.lst
    │       │       └── inputFiles.lst
    │       └── testCompile
    │           └── default-testCompile
    │               ├── createdFiles.lst
    │               └── inputFiles.lst
    ├── original-springDemo-1.0-SNAPSHOT.jar
    ├── springDemo-1.0-SNAPSHOT.jar
    ├── surefire-reports
    │   ├── com.paladnix.AppTest.txt
    │   └── TEST-com.paladnix.AppTest.xml
    └── test-classes
        └── com
            └── paladnix
                └── AppTest.class

```
