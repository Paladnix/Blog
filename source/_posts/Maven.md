---
title: Maven
date: 2017-07-02 21:48:02
tags: [Java, Maven, Web]
---

使用maven已经是不可避免的事情了，如果你是个java工程师的话。并且，使用maven基本上是你最好的选择。但是我并不喜欢用IDE来集成maven，这算是强迫症，命令行强迫症。

# Maven 是什么？
传说他的功能十分强大，目前我感受到的是如下几个功能：
- 自动构建项目结构，根据不同的框架需求
- 自动包依赖管理
- 自动编译工程
- 自动启动测试
总而言之就是恰到好处的做了你觉得很麻烦又没有必要自己做的事情。

# 安装
跟JDK是一个思路的，在环境变量中添加`M2_HOME`即可。

# 使用
```bash
# 创建Java Web 项目

mvn archetype:generate -DgroupId=com.hello -DartifactId=hello -DarchetypeArtifactId=maven-archetype-webapp

# 生成项目
mvn install

# 发布到tomcat
# 复制生成的./target/xxx.war到tomcat目录下的webapps中去，如果不能访问就重启一下tomcat。

```

上述是将项目自带的helloworld页面显示出来，我们自己使用会用到一个更核心的方法--配置文件。

# pom.xml
这个配置文件是maven的核心。

在创建好的文件夹中有一个pom.xml 这里的内容分成两部分，一部分是你的项目基本信心，叫啥，啥版本的等等；还有一部分是我们要配置的部分。这一部分又分成好几部分，有依赖关系(dependencies)、生成(build)等等。

##依赖--dependencies
基本上主流的包都有maven的库，所以基本上在官方的文档中也都能找的到，只要将其对应的部分配置进来就可以了，举个例子。
```xml
        <!-- spring boot -->
        <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter</artifactId>
		</dependency>

        <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>

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

更多的命令下回再写，目前多线作战……
