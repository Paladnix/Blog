---
title: Java-Log日志
date: 2017-07-26 14:28:29
tags: [Java, Log]
---

日志以我目前使用到的，有两个功能。
第一，在上线调试的时候查看问题所在。
第二，在线上运行的时候，出现故障回看日志查询问题所在。
总之就是查问题出在哪里，因为编译型的程序没有办法直接搞中间输出来确定问题所在，写在文件里是最好的方式了。

Java中有很多日志系统，但是根据经验，一定有一个日志的抽象层来统一各个日志系统。没错，今天就直接来用这个抽象层的日志工具：**SLF4J**(Simple logging facade for Java)。它允许你在后台使用任意一个日志类库。如果是在编写供内外部都可以使用的API或者通用类库，那么你真不会希望使用你类库的客户端必须使用你选择的日志类库。

如果一个项目已经使用了log4j，而你加载了一个类库，比方说 Apache Active MQ——它依赖于于另外一个日志类库logback，那么你就需要把它也加载进去。但如果Apache Active MQ使用了SLF4J，你可以继续使用你的日志类库而无需忍受加载和维护一个新的日志框架的痛苦。

## 日志原理

一般的日志都是由三个部分组成：`logger`、`appenders`、`layouts`。`logger`负责捕获记录信息，转给`appender`去转发到配置的目的地，`layouts`负责定义日志的格式。

下面就具体的介绍一下Log4j帮助理解。

## Log4j

log4j 有很多优点：
1. Log4j是高度可配置的，并可通过在运行时的外部文件配置。它根据记录的优先级别，并提供机制，以指示记录信息到许多的目的地，诸如：数据库，文件，控制台，UNIX系统日志等。
2. 已经扩展到C/C++、C#、Perl、Python等语言中。
3. 线程安全、速度快
4. 多输出

也有一些缺点，比如不能保证所有日志信息都送到目的地在其出现故障的时候，会减慢程序的速度，不过这是所有日志都面临的问题，貌似也没有什么好的解决办法。

log4j 在使用的时候需要一个配置文件：`log4j.properties`或`log4j.xml`。
1. 如果是java project项目，则在项目的根目录下创建log4j.properties而不是在src目录下。
2. 如果是java web项目，则在src目录下创建log4j.properties配置文件，因为这个时候tomcat会去默认的加载这个配置文件，而不需要我们手动的加载log4j的配置文件。

两种配置的基本配置选项都是一样的，`log4j.properties`的格式是更好理解的，奈何我拿到的是个该死的`xml`格式的项目。直观看很丑！非常丑！xml在我这的印象分又掉了一半。
还是先介绍各个选项的内容吧，形式不重要。

### 选项参数
上面讲了日志的三个组成部分，其配置也就是针对这三个部分来搞的。
以`properties`的格式先介绍一下。

```bash
#配置根Logger (Loggers)
log4j.rootLogger  =   [ level ]   ,  appenderName1 ,  appenderName2 ,  …

#配置日志信息输出目的地 (Appenders)
log4j.appender.appenderName  =  fully.qualified.name.of.appender.class 
　　log4j.appender.appenderName.option1  =  value1 
　　… 
　　log4j.appender.appenderName.optionN  =  valueN 

#配置日志信息的格式（Layouts）
log4j.appender.appenderName.layout  =  fully.qualified.name.of.layout.class 
　　log4j.appender.appenderName.layout.option1  =  value1 
　　… 
　　log4j.appender.appenderName.layout.optionN  =  valueN 

```
其中 **[level]** 是日志输出级别，共有5级：
```
FATAL      0  
ERROR      3  
WARN       4  
INFO       6  
DEBUG      7 
```
**Appender** 为日志输出目的地，Log4j提供的appender有以下几种：
```
org.apache.log4j.ConsoleAppender            （控制台）
org.apache.log4j.FileAppender               （文件）
org.apache.log4j.DailyRollingFileAppender   （每天产生一个日志文件）
org.apache.log4j.RollingFileAppender        （文件大小到达指定尺寸的时候产生一个新的文件）
org.apache.log4j.WriterAppender             （将日志信息以流格式发送到任意指定的地方）
```
**Layout** 日志输出格式，Log4j提供的layout有以下几种：
```
org.apache.log4j.HTMLLayout   （以HTML表格形式布局），
org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
org.apache.log4j.SimpleLayout （包含日志信息的级别和信息字符串），
org.apache.log4j.TTCCLayout   （包含日志产生的时间、线程、类别等等信息）
```
**输出格式控制符**
```
　  %m   输出代码中指定的消息
　　%p   输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL 
　　%r   输出自应用启动到输出该log信息耗费的毫秒数 
　　%c   输出所属的类目，通常就是所在类的全名 
　　%t   输出产生该日志事件的线程名 
　　%n   输出一个回车换行符，Windows平台为“/r/n”，Unix平台为“/n” 
　　%d   输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss , SSS}，输出类似：2002年10月18日  22 ： 10 ： 28 ， 921  
　　%l   输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main(TestLog4.java: 10 ) 
```

**Example**
下面这个例子配置了一个Logger三个Appender，并给每个Appender分别配置。

```
 ### set log levels ###
log4j.rootLogger = debug ,  stdout ,  D ,  E

### 输出到控制台 ###
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern =  %d{ABSOLUTE} %5p %c{ 1 }:%L - %m%n
# %5p 的用法与c语言有相似之处，此处指在前面加入5个空格。

### 输出到日志文件 ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = logs/log.log
log4j.appender.D.Append = true
log4j.appender.D.Threshold = DEBUG ## 输出DEBUG级别以上的日志
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

### 保存异常信息到单独文件 ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = logs/error.log ## 异常日志文件名
log4j.appender.D.Append = true
log4j.appender.D.Threshold = ERROR ## 只输出ERROR级别以上的日志!!!
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n


# 可以在%与模式字符之间加上修饰符来控制其最小宽度、最大宽度、和文本的对齐方式。如：  
# 1)%20c：指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，默认的情况下右对齐。  
# 2)%-20c:指定输出category的名称，最小的宽度是20，如果category的名称小于20的话，"-"号指定左对齐。  
# 3)%.30c:指定输出category的名称，最大的宽度是30，如果category的名称大于30的话，就会将左边多出的字符截掉，但小于30的话也不会有空格。  
# 4)%20.30c:如果category的名称小于20就补空格，并且右对齐，如果其名称长于30字符，就从左边较远输出的字符截掉。  
```
在代码中，我们需要先初始化Logger，然后直接使用。不过一般都不是这样用的，基本上都是servlet来自动初始化，基本上是Tomcat的锅。还有就是我们代码使用Slf4j来操作，也不需要自己初始化。
```java

public   class  TestLog4j  {
     public   static   void  main(String[] args)  {
        PropertyConfigurator.configure( " D:/Code/conf/log4j.properties " );
        Logger logger  =  Logger.getLogger(TestLog4j. class );
        logger.debug( " debug " );
        logger.error( " error " );
    } 
}

```

**Another Example**
当我们一个系统中有多个部件的时候，我们会希望不同的部件日志打到不同的地方去。典型的就是一些十分重要的紧急错误需要能够直接发短信给运维人员报警，一些运维正常信息就可以先直接打进日志文件待日后查看即可。所以对于不同的类我们可以配置不同的Logger，还记得Logger的作用是捕获异常信息吧。
我们在需要用到某种Logger的时候只要在程序中GetLogger(LoggerName)即可。然后就可以在这个程序中使用某种Logger了。下面给一个这样的例子：
```
log4j.rootLogger = debug, log

# All Loggers
log4j.logger.com.apa.test.startUpListener =  debug, appendListener
log4j.logger.com.apa.test.brain.common = debug, appendCommon
log4j.logger.com.apa.test.brain.middle = debug, appendMiddle
log4j.logger.com.apa.test.brain.northboundif.restif = debug, appendNorthboundifRestif
log4j.logger.com.apa.test.brain.compute = debug, appendNorthboundifHandle
log4j.logger.com.apa.test.addition.onekey = debug, appendOnekey
log4j.logger.com.apa.test.brain.api.v1private.serviceController = debug, serviceController
log4j.logger.com.apa.test.brain.common.serviceController = debug, serviceController
log4j.logger.com.apa.test.brain.compute.serviceController = debug, serviceController

# All Appenders
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

log4j.appender.appendCommon = org.apache.log4j.DailyRollingFileAppender
log4j.appender.appendCommon.layout = org.apache.log4j.PatternLayout
log4j.appender.appendCommon.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.appendCommon.File = ${catalina.home}/logs/tiddo/common/common.log
log4j.appender.appendCommon.Append = true
log4j.appender.appendCommon.Threshold = DEBUG

log4j.appender.serviceController = org.apache.log4j.RollingFileAppender
log4j.appender.serviceController.MaxFileSize = 300MB
log4j.appender.serviceController.MaxBackupIndex = 10
log4j.appender.serviceController.layout = org.apache.log4j.PatternLayout
log4j.appender.serviceController.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.serviceController.File = ${catalina.home}/logs/tiddo/serviceController/api.log
log4j.appender.serviceController.Threshold = DEBUG

log4j.appender.appendListener = org.apache.log4j.DailyRollingFileAppender
log4j.appender.appendListener.layout = org.apache.log4j.PatternLayout
log4j.appender.appendListener.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.appendListener.File = ${catalina.home}/logs/tiddo/listener/listener.log
log4j.appender.appendListener.Append = true
log4j.appender.appendListener.Threshold = DEBUG

log4j.appender.appendMiddle = org.apache.log4j.DailyRollingFileAppender
log4j.appender.appendMiddle.layout = org.apache.log4j.PatternLayout
log4j.appender.appendMiddle.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.appendMiddle.File = ${catalina.home}/logs/tiddo/middle/middle.log
log4j.appender.appendMiddle.Append = true
log4j.appender.appendMiddle.Threshold = DEBUG

log4j.appender.appendNorthboundifRestif = org.apache.log4j.DailyRollingFileAppender
log4j.appender.appendNorthboundifRestif.layout = org.apache.log4j.PatternLayout
log4j.appender.appendNorthboundifRestif.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.appendNorthboundifRestif.File = ${catalina.home}/logs/tiddo/northboundif/restif/restif.log
log4j.appender.appendNorthboundifRestif.Append = true
log4j.appender.appendNorthboundifRestif.Threshold = DEBUG

log4j.appender.appendNorthboundifHandle = org.apache.log4j.DailyRollingFileAppender
log4j.appender.appendNorthboundifHandle.layout = org.apache.log4j.PatternLayout
log4j.appender.appendNorthboundifHandle.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.appendNorthboundifHandle.File = ${catalina.home}/logs/tiddo/northboundif/handle/handle.log
log4j.appender.appendNorthboundifHandle.Append = true
log4j.appender.appendNorthboundifHandle.Threshold = DEBUG

log4j.appender.appendOnekey = org.apache.log4j.DailyRollingFileAppender
log4j.appender.appendOnekey.layout = org.apache.log4j.PatternLayout
log4j.appender.appendOnekey.layout.ConversionPattern = [%d{yyyy-MM-dd HH:mm:ss}]--[%t] [%p] -%l -%m%n%n
log4j.appender.appendOnekey.File = ${catalina.home}/logs/tiddo/onekey/onekey.log
log4j.appender.appendOnekey.Append = true
log4j.appender.appendOnekey.Threshold = DEBUG


log4j.appender.qpsWaterLevel=org.apache.log4j.RollingFileAppender
log4j.appender.qpsWaterLevel.MaxFileSize=100MB
log4j.appender.qpsWaterLevel.MaxBackupIndex=10
log4j.appender.qpsWaterLevel.layout=org.apache.log4j.PatternLayout
log4j.appender.qpsWaterLevel.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss}|%m%n
log4j.appender.qpsWaterLevel.file= ${catalina.home}/logs/tiddo/healthReport/qpsWaterLevel.log

log4j.appender.abnormalQpsTenant=org.apache.log4j.RollingFileAppender
log4j.appender.abnormalQpsTenant.MaxFileSize=100MB
log4j.appender.abnormalQpsTenant.MaxBackupIndex=10
log4j.appender.abnormalQpsTenant.layout=org.apache.log4j.PatternLayout
log4j.appender.abnormalQpsTenant.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss}|%m%n
log4j.appender.abnormalQpsTenant.file= ${catalina.home}/logs/tiddo/healthReport/abnormalQpsTenant.log
```


关于其输出到其他地方的做法，留待以后探索，参考自[Blog](http://blog.csdn.net/azheng270/article/details/2173430/)。

**log4j.XML**
当你对`properties`的规则有所了解之后，再看xml格式的就很好理解了。本质是一样的，只是换了一种组织形式。
在其中我们找到`root`、`appender`、`layout`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration>
	<appender name="event4j"
		class="org.apache.log4j.DailyRollingFileAppender">
		<param name="File" value="logs/com.test.event.third.event4j.log" />
		<layout class="org.apache.log4j.PatternLayout">
			<param name="ConversionPattern"
				value="%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p %m%n" />
			<!--
			value="%d %-5p [%t] %C{2} (%F:%L) - %m%n
			value="%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p [%t] %C{2} (%F:%L) - %m%n
			-->
		</layout>
	</appender>
	
	<appender name="Console"
		class="org.apache.log4j.ConsoleAppender">
		<layout class="org.apache.log4j.PatternLayout">
			<param name="ConversionPattern"
				value="%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p %m%n" />
		</layout>
	</appender>
	
	<root>
		<priority value="info" />
		<appender-ref ref="event4j" />
		<appender-ref ref="Console" />
	</root>

</log4j:configuration>

```
**留作参考的另外一个例子**
```xml
<?xml version="1.0" encoding="GBK" ?>    
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">    
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">      
    <!-- 输出日志到控制台  ConsoleAppender -->   
        <appender name="console"   
        class="org.apache.log4j.ConsoleAppender">  
        <param name="Threshold" value="info"></param>  
        <layout class="org.apache.log4j.TTCCLayout">  
            <param name="ConversionPattern" value="TTCCLayout"></param>  
        </layout>  
    </appender>  
  
    <!-- 输出日志到文件  每天一个文件 -->  
    <appender name="dailyRollingFile"  
        class="org.apache.log4j.DailyRollingFileAppender">  
        <param name="Threshold" value="info"></param>  
        <param name="ImmediateFlush" value="true"></param>  
        <param name="File" value="c:/logs/dailyRollingFile.log"></param>  
        <param name="DatePattern" value="'.'yyyy-MM-dd'.log'"></param>  
        <layout class="org.apache.log4j.PatternLayout">  
            <param name="ConversionPattern" value="[%d{yyyy-MM-dd HH:mm:ss\} %-5p] [%t] {%c:%L}-%m%n"></param>  
        </layout>  
    </appender>   
      
    <!-- 输出日志到文件  文件大小到达指定尺寸的时候产生一个新的文件 -->  
    <appender name="railyFile"   
        class="org.apache.log4j.RollingFileAppender">  
        <param name="File" value="c:/logs/railyFile.log"></param>  
        <param name="ImmediateFlush" value="true"/>  
        <param name="Threshold" value="info"></param>  
        <param name="Append" value="true"></param>  
        <param name="MaxFileSize" value="30KB"></param>  
        <param name="MaxBackupIndex" value="100"></param>  
        <layout class="org.apache.log4j.PatternLayout">  
            <param name="ConversionPattern" value="[%d{yyyy-MM-dd HH:mm:ss\} %-5p] [%t] {%c:%L}-%m%n"></param>  
        </layout>  
    </appender>  
  
    <!-- 输出日志到文件 -->  
    <appender name="file"  
        class="org.apache.log4j.FileAppender">  
        <param name="File" value="c:/logs/file.log"></param>  
        <param name="Threshold" value="info"></param>  
        <layout class="org.apache.log4j.PatternLayout">  
            <param name="ConversionPattern" value="[%d{yyyy-MM-dd HH:mm:ss\} %-5p] [%t] {%c:%L}-%m%n"></param>  
        </layout>  
    </appender>  
  
    <!--   
        定义全局的日志输出级别,但是在输出目的地的配置中配置的具体输出级别优先级高于全局定义的优先级。  
        如果在railyFile中定义<param name="Threshold" value="info"></param>，那么将会把info以上级别的信息输出  
     -->  
    <root>       
        <priority value="debug" />       
        <appender-ref ref="console" />    
        <appender-ref ref="dailyRollingFile" />    
        <appender-ref ref="railyFile" />    
        <appender-ref ref="file" />    
    </root>         
  
</log4j:configuration>   
```

## Slf4j 使用

其maven依赖如下：
```xml
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.12</version>
</dependency>

<!-- 后台使用log4j日志系统 -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    <version>1.6.1</version>
</dependency>

```

一般我们是以log4j作为底层的日志系统，代码中使用slf4j来编写。所以下面就直接上程序实例了。

example: Hello World
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloWorld {
  public static void main(String[] args) {
    Logger logger = LoggerFactory.getLogger(HelloWorld.class);
    logger.info("Hello World");
  }
}

/*
   file.log:

    0 [main] INFO HelloWorld - Hello World
*/
```
占位符的使用：（该方式减小了频繁字符串拼接的多余开销）
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Wombat {
  
   final Logger logger = LoggerFactory.getLogger(Wombat.class);
   Integer t;
   Integer oldT;

   public void setTemperature(Integer temperature) {
    
     oldT = t;        
     t = temperature;

     logger.debug("Temperature set to {}. Old temperature was {}.", t, oldT);
     
     if(temperature.intValue() > 50) {
       logger.info("Temperature has risen above 50 degrees.");
     }
   }
 } 

/*
    {} 是占位符
*/
```
从上面可以看出来log有这么几种：`info()`、`debug()`、`warn()`、`error()`


## SLF4j 结合其他日志系统

在前期看的时候，我一直纠结于这个slf4j是如何知道用哪个log来做底层日志系统的。

在应用中，通过LoggerFactory类的静态getLogger()获取logger。通过查看该类的代码可以看出，最终是通过StaticLoggerBinder.SINGLETON.getLoggerFactory()方法获取LoggerFactory然后，在通过该具体的LoggerFactory来获取logger的。类org.slf4j.impl.StaticLoggerBinder并不在slf4j-api-1.5.2.jar包中.
仔细查看每个与具体日志系统对应的jar包，就会发现，相应的jar包都有一个org.slf4j.impl.StaticLoggerBinder的实现，不同的实现返回与该日志系统对应的LoggerFactory，因此就实现了所谓的静态绑定，达到只要选取不同jar包就能简单灵活配置的目的。 

### logback
就记录这一个了，因为他传说比log4j更好用。

**Maven dependency**
```xml
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
     <version>1.7.5</version>
</dependency>
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.0.13</version>
</dependency>
```
**配置logback.xml**
大家都是日志系统，所以配置起来也就很像，log4j的配置文件可以直接转换成logback的配置，据说使用某工具，不过这样不保险，也不打算学。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--debug="true" : 打印logback内部状态（默认当logback运行出错时才会打印内部状态 ），配置该属性后打印条件如下（同时满足）： 
    1、找到配置文件 2、配置文件是一个格式正确的xml文件 也可编程实现打印内部状态，例如： LoggerContext lc = (LoggerContext) 
    LoggerFactory.getILoggerFactory(); StatusPrinter.print(lc); -->
<!-- scan="true" ： 自动扫描该配置文件，若有修改则重新加载该配置文件 -->
<!-- scanPeriod="30 seconds" : 配置自动扫面时间间隔（单位可以是：milliseconds, seconds, minutes 
    or hours，默认为：milliseconds）， 默认为1分钟，scan="true"时该配置才会生效 -->
<configuration debug="false" scan="true" scanPeriod="30 seconds" packagingData="true">
    <!-- 设置 logger context 名称,一旦设置不可改变，默认为default -->
    <contextName>myAppName</contextName>
    
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <!-- encoders are by default assigned the type ch.qos.logback.classic.encoder.PatternLayoutEncoder -->
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">  
        <!-- 当前活动日志文件名 -->
        <file>./my_log.log</file>
        <!-- 文件滚动策略根据%d{patter}中的“patter”而定，此处为每天产生一个文件 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 归档文件名“.zip或.gz结尾”,表示归档文件自动压缩 -->
            <FileNamePattern>./my_log%d{yyyyMMdd}.log.zip</FileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
       
        <!--rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
            <fileNamePattern>renhai%i.log</fileNamePattern>
            <minIndex>1</minIndex>
            <maxIndex>10</maxIndex>
        </rollingPolicy>
        
        <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
            <maxFileSize>20MB</maxFileSize>
        </triggeringPolicy-->
        
        <!-- <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
          rollover daily
          <fileNamePattern>mylog-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
           each file should be at most 30MB, keep 60 days worth of history, but at most 20GB
           <maxFileSize>30MB</maxFileSize>    
           <maxHistory>60</maxHistory>
           <totalSizeCap>20GB</totalSizeCap>
        </rollingPolicy> -->
        

        <encoder>
          <pattern>%d{HH:mm:ss.SSS}[%-5level][%thread]%logger{36} - %msg%n</pattern>
          <!-- <pattern>%d{HH:mm:ss.SSS}[%-5level][%thread] - %msg%n</pattern> -->
        </encoder>
    </appender>
    
    <!-- 日志级别若没显示定义，则继承最近的父logger（该logger需显示定义level,直到rootLogger）的日志级别-->
    <!-- logger的appender默认具有累加性（默认日志输出到当前logger的appender和所有祖先logger的appender中），可通过配置 “additivity”属性修改默认行为-->
    <logger name="com.yinz"  level="debug" additivity="false" >
        <appender-ref ref="FILE"/>
    </logger>

    <!-- 至多只能配置一个root -->
    <root level="debug">
        <appender-ref ref="STDOUT" />
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

### 放在哪

`src/main/resources` 日志系统的配置文件都放在这就好了。
