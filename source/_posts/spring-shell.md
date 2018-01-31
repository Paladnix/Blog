---
title: spring-shell
date: 2017-08-10 13:59:53
tags: [Java, Spring]
---

这是一个spring框架提供的编写shell命令的一个工具，能够让你用spring的编程模式编写命令支持在shell运行。

看一下这个工具的框架是怎么样的。[documentation地址](http://docs.spring.io/spring-shell/docs/current/reference/htmlsingle/)。

# 核心组件

spring shell 的最核心的组件是三个：`plugin model`、`built-in commands` and `converters`。


## Plugin Model

插件模块我理解的就是将你写的命令加载进去。你的每个jar模块都要包含一个文件：`META-INF/spring/spring-shell-plugin.xml`。这个文件会在shell启动的时候被加载并生成Spring的上下文。
在这个文件里你需要定义你的命令相关的类。当然你也可以用spring的扫描功能去自己扫描一个包，然后自己将相关的类进行加载。

这个文件可以写成这样：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context 
       http://www.springframework.org/schema/context/spring-context-3.1.xsd">

  <context:component-scan 
           base-package="org.springframework.shell.samples.helloworld.commands" />

</beans>
```

这里官方的文档说：所有的类都是用同一个类加载器加载的，所以建议提供一个类加载器进行隔离。

这些命令是Spring组件，使用@Component注解进行划分。例如，HelloWorldCommands类的示例应用程序是这样的
```java

@Component
public class HelloWorldCommands implements CommandMarker {

  // use any Spring annotations for Dependency Injection or other Spring 
  // interfaces as required.

    @CliCommand(value = "delete-group", help = "delete group")
    public String deleteGroup(@CliOption(key = {"id"}, mandatory = true, help = "The id of " +
            "the group") final String id) {
        ClientResponse response = RestClient.delete(GROUPS_RESOURCE_URL + "/" + id);
        return response.getEntity(String.class);
    }

}
```

## Converters 转换器

这个转换器是将输入的字符串转换为Java的对象，基本的转换器可以实现基础的对象的转换，包括`Date`、`charactor`、`File`等。


## Build in Command

是一些内置的命令，包括清空控制台、显示当前日期、帮助、退出等。



## 总结

这个东西其实并不是用来开发终端命令的，一般我们的终端命令都是C语言开发的，或者是bash等。这个事实上是给一个Java项目提供一个更方便的交互途径，比如我们某个应用需要用Java来做交互来做控制，能够有一个终端命令的方式是最方便的，所以，是个加分项。等以后做的项目多了以后就会用到了。
