---
title: SpringMVC
date: 2017-08-02 10:41:35
tags: [Java, Spring, Web, MVC]
---

本文是我的学习过程，但是我认为学习过程中并不适合写给别人看。所以本文只是一个临时的笔记，待以后进行深入整合。

`SpringMVC`与`Spring`的关系是什么?
SpringMVC是依托Spring框架开发的一个Web MVC框架，天生与Spring集成，也就是使用了Spring的依赖注入和切面编程。

上一篇中讲解了`Web.xml`，这是Java Web的基础，也就是Servlet容器的工作方式，那个也作为本文的基础。

SpringMVC整体可以看成是一个Servlet，事实上它就是一个Servlet。我们配置`web.xml`来启动这个Servlet，然后这个Servlet来负责处理每个请求。每个处理请求的类都是我们遵照SpringMVC的格式来写的类，由SpringMVC这个框架来调用完成整个请求的处理。

与原本粗放的原生Java Web的开发模式相比，做了一个聚合。原本是每个请求你都写一个Servlet去处理，在`web.xml`中配置好一个请求与处理类的映射关系，由容器来完成调用。然后SpringMVC是分担了容器的压力，将容器的工作交给他来做，它利用Spring框架的依赖注入的特性，以及`bean`的工厂模式重新实现后端的实际处理流程。

有好处也有坏处，我也不太清楚这样做的具体目的是什么，可能会有性能上的提升，因为毕竟工厂模式等特性的加入会提升一些性能和开发便利。坏处感觉也挺明显，首当其冲就是学习栈又深了，还不是深了一个单位是好几个单位。加入了新的配置等，开发过程的脑力成本又增加了。

多说也没用，也是要以后逐步深入才能参透其中的奥妙。

# maven 配置项目

命令行使用mvn构建项目很简单。
```bash
mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-webapp  -DarchetypeVersion=1.0   -DgroupId=com.demo  -DartifactId=demo   -Dversion=1.0
```
生成的目录如下：
```
.
├── pom.xml
└── src
    └── main
        ├── resources
        └── webapp
            ├── index.jsp
            └── WEB-INF
                └── web.xml
```

配置一下项目所需依赖关系`pom.xml`:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.demo</groupId>
    <artifactId>demo</artifactId>
    <packaging>war</packaging>
    <version>1.0-SNAPSHOT</version>
    <name>demo Maven Webapp</name>
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
        <finalName>demo</finalName>
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

# web.xml 配置

下面就是要在这里配置启动SpringMVC，需要配置两个东西。

```xml
<!DOCTYPE web-app PUBLIC
 "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
 "http://java.sun.com/dtd/web-app_2_3.dtd" >

<web-app>
  <display-name>learning springMVC</display-name>

  <!-- 配置该监听器，使得其在容器启动时就去加载SpringMVC的配置文件 -->
  <!-- 如果没有配置下面的这个contextConfigLocation参数，则默认加载同目录下的applicationContext.xml -->
  <context-param>  
    <param-name>contextConfigLocation</param-name>  
    <param-value>/WEB-INF/spring-configuration/*.xml</param-value>  
  </context-param>
  <listener>  
     <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
  </listener>
  
  <!-- 配置SpringMVC的请求分发处理Servlet -->
  <!-- 在项目启动的时候就启动该Servlet -->
  <servlet>
      <servlet-name>Dispatch</servlet-name>
      <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
      <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
      <servlet-name>Dispatch</servlet-name>
      <url-pattern>/</url-pattern>
  </servlet-mapping>


</web-app>

```
可以配置多个`Dispatch`来拦截不同格式的请求，不同的Dispatch要使用不同的配置文件，没错，又来一个配置。
这就是个前端请求拦截器，然后那过来到自己的配置文件里重新路由到要到达的Handler。所以每配置一个就要一个配置文件。默认的配置文件是`/WEB-INF/<servlet-name>-servlet.xml`

**url-pattern**：表示哪些请求交给Spring Web MVC处理， `/` 是用来定义默认servlet映射的。也可以如`*.html`表示拦截所有以html为扩展名的请求。

这样拦截请求会将静态文件的请求都拦截掉，所以我们在配置`DispatchServlet`之前加上一个配置， 这个配置是使用tomcat容器的默认Servlet来处理静态文件请求，让这个servlet先拦截请求就不会被SpringMVC拦截掉了：
```xml
   <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.css</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.swf</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.gif</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.jpg</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.png</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.js</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.html</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.xml</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.json</url-pattern>  
    </servlet-mapping>  
    <servlet-mapping>  
        <servlet-name>default</servlet-name>  
        <url-pattern>*.map</url-pattern>  
    </servlet-mapping>  
```
还有一种方式就是将静态文件全部放在`CDN`结点服务器上，也可以分担服务器压力，速度还快，就是要花钱。

除了上面的这些基础配置，我们还会配置一些过滤器，比较典型的就是字符过滤，防止乱码:
```xml
    <filter>  
        <filter-name>characterEncodingFilter</filter-name>  
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
        <filter-name>characterEncodingFilter</filter-name>  
        <url-pattern>/*</url-pattern>  
    </filter-mapping>  
```
还有一些错误页的配置：
```
    <welcome-file-list><!--指定欢迎页面-->  
        <welcome-file>login.html</welcome-file>  
    </welcome-file-list>  
    <error-page> <!--当系统出现404错误，跳转到页面nopage.html-->  
        <error-code>404</error-code>  
        <location>/nopage.html</location>  
    </error-page>  
    <error-page> <!--当系统出现java.lang.NullPointerException，跳转到页面error.html-->  
        <exception-type>java.lang.NullPointerException</exception-type>  
        <location>/error.html</location>  
    </error-page>  
    <session-config><!--会话超时配置，单位分钟-->  
        <session-timeout>360</session-timeout>  
    </session-config>  

```

# applicationContext.xml

 spring配置文件是用于指导Spring工厂进行Bean生产、依赖关系注入（装配）及Bean实例分发的"图纸"。Java EE程序员必须学会并灵活应用这份"图纸"准确地表达自己的"生产意图"。Spring配置文件是一个或多个标准的XML文档，applicationContext.xml是Spring的默认配置文件，当容器启动时找不到指定的配置文档时，将会尝试加载这个默认的配置文件。

 这个是Spring 的全局配置文件，并不是SpringMVC的。

 ```xml
 
 
 ```
