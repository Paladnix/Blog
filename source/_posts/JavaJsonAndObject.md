---
title: Java Json And Object
date: 2017-08-15 20:20:44
tags: [Java, Http]
---

在写RESTFul风格的接口的时候最经常使用的就是Json和对象的互换。
今天记录一下阿里巴巴开源的FastJson的使用方式。

FastJson号称最快的Json解析工具包。有幸听了作者的分享会，并且在前几天的转正答辩的时候，他作为我的面试官之一。花名很奇特，叫高铁，可能这就是FastJson为什么这么快的原因吧。

在听分享会的时候，惊叹于其将一个小小的工具包中运用了如此多的优化方式。他曾是阿里安全团队的一元，对于Java底层非常了解，并且一些算法能力也很强，更是运用了产生式编程的神奇方式编写了这个工具包的某些部分。

## package

这是开源的工具，听闻，据说是阿里对Java社区做的最大贡献了。

`import com.alibaba.fastjson.*;`

### maven:

```xml
<!-- https://mvnrepository.com/artifact/com.alibaba/fastjson -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.36</version>
</dependency>

```

## Example

其对于json的操作都是在几个静态类中进行的。
举几个常用的例子来说名用法：

### 将Json文本数据信息转换为JsonObject对象，通过键值对获取值

```java

    private static void json2JsonObject() {  
        
        //一个JsonObject文本数据  
        String s = "{\"name\":\"xxx\"}";  
        
        //将JsonObject数据转换为Json  
        JSONObject object = JSON.parseObject(s);  
        
        //利用键值对的方式获取到值  
        System.out.println(object.get("name"));  
    }  

```

###  将Json文本数据转换为JavaBean

需要注意的是，Json文本信息中的键的名称必须和JavaBean中的字段名称一致。

```java
    private static void json2BeanM2() {  

        String s = "{\"id\":\"xx\",\"city\":\"xxx\"}";  
        
        //一个简单方便 的方法将Json文本信息转换为JsonObject对象的同时转换为JavaBean对象！  
        Weibo weibo = JSON.parseObject(s, Weibo.class);//Weibo类在下边定义  
        
        System.out.println(weibo.getId());  
        System.out.println(weibo.getCity());  
    }  

```


### Map类型的数据转换为JsonString

```java
        Map<Integer, Object> map = new HashMap<Integer,Object>();  
        map.put(1, "No.1");  
        map.put(2, "No.2");  
        map.put(3, group.getList());  
          
        String jsonString = JSON.toJSONString(map);  
        System.out.println(jsonString);

        // Map 套List的结构也可以。
```

有了上面几个例子就可以很明白了，在使用的时候还是用补全来看就可以了。

一般的思路就是先吧Json转成JSONObject，然后进行操作。
如果是直接操作Json，就是用静态类JSON来做，JSONObject就是用JSONObject来做。

在将Json转为对象的时候，要注意，对象的成员名一定要和Json中的键一致，都则就是null了。
