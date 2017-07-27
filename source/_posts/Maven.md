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

下面是一个Maven的基本结构

```xml

<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                      http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <!-- The Basics -->
  <groupId>...</groupId>
  <artifactId>...</artifactId>
  <version>...</version>
  <packaging>...</packaging>
  <dependencies>...</dependencies>
  <parent>...</parent>
  <dependencyManagement>...</dependencyManagement>
  <modules>...</modules>
  <properties>...</properties>
 
  <!-- Build Settings -->
  <build>...</build>
  <reporting>...</reporting>
 
  <!-- More Project Information -->
  <name>...</name>
  <description>...</description>
  <url>...</url>
  <inceptionYear>...</inceptionYear>
  <licenses>...</licenses>
  <organization>...</organization>
  <developers>...</developers>
  <contributors>...</contributors>
 
  <!-- Environment Settings -->
  <issueManagement>...</issueManagement>
  <ciManagement>...</ciManagement>
  <mailingLists>...</mailingLists>
  <scm>...</scm>
  <prerequisites>...</prerequisites>
  <repositories>...</repositories>
  <pluginRepositories>...</pluginRepositories>
  <distributionManagement>...</distributionManagement>
  <profiles>...</profiles>
</project>
```

#### Maven Coordinates 坐标
`groupId:artifactId:version`这三个字段值是定位一个包不可缺少的坐标构成：组织名：项目名：版本号。

#### packaging 
打包方式，主要是`jar`、`war`。

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
#### exclusion
排除包依赖，有些包不希望使用某些包作为依赖，就加到其对应的`exclusion`中。这是因为有写包之间是冲突的，某个包使用的一个包，这个包是与另一个冲突的，所以在引入这个包的时候就得屏蔽其冲突包。
```xml
<dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-embedder</artifactId>
      <version>3.1.0</version>
      <exclusions>
        <exclusion>
          <groupId>org.apache.maven</groupId>
          <artifactId>maven-core</artifactId>
          <!--  
          <groupId>*</groupId>
          <artifactId>*</artifactId>
          -->
        </exclusion>
      </exclusions>
    </dependency>
    ...
  </dependencies>
```

当你需要使用某些包的时候，就可以去[这里](https://mvnrepository.com/)搜索，获得其对应的maven配置代码，粘贴进来就可以了。

下一次补充maven自动构建过程。
