---
title: ZooKeeper
date: 2017-08-17 10:06:34
tags: [Java, Distributed]
---

暂且将恼人的Tomcat放在一边，来解决新的问题，并学习新的玩意儿。

## Zookeeper 是啥

动物园管理员，分布式服务就像是一个动物园。

Zookeeper是一个开源的分布式应用程序协调程序，为分布式应用程序提供一致性服务。
在分布式计算的应用中，最令人头疼的就是分布式锁的问题。同时各种同步问题也很让人崩溃，Zookeeper就是封装可一些算法，保证了其分布式服务的一致性，作为很多分布式服务的基础服务程序。

## ZooKeeper 的设计原理

官方称之为鸟瞰：

第一段在百度百科上。
在特性上面，zookeeper有这样几个特点。

1. 使用文件系统的结构来存储数据。
数据在用户的角度来看，是以类似与unix文件系统的方式来组织的，所以其定位方式是使用路径来定位数据。但是与文件系统不同的是，每个结点都可以存储数据，没有文件夹和文件的区别概念。

2. 高并发低延迟。
存储的数据在每一个zookeeper服务节点上都是一样的，所以读数据只要连接一个服务器直接读取就可以。数据的大小被限制在1M以内。

3. 高可用，自动故障转移。
这个是其设计的精髓之一，下面重点会讲。

下面概要的讲一下运行的逻辑。

![pic](/img/zkservice.jpg)

**选举**
第一个，非常重要的步骤就是选举，在集群上部署完zookeeper以后，他们便开始执行选举流程，使用选举算法Fast Paxos作为基础。选举会产生一个leader。

**客户端与server**
当有客户端与一个服务器建立连接的之后，他们之间会维持一个tcp连接，客户端会给服务器发送心跳请求，告诉服务器自己还在线。如果一个server监测到一个客户端断线了，就会在本地清除相关的数据。而客户端会重新去找一个server建立连接。

**写请求**
在客户端读取数据的时候只要在其对应的服务器上读取就可以了。当其要写数据的时候，server会将这个写请求转发给leader服务器，leader将这个写请求统一发给每一个server进行写数据操作，当确认有严格的大于一半的server都写入成功以后，就算是写请求成功，再返回给原server，由原server返回成功给客户端。

**重新选举**
leader会给server之间保持通信，通常就是所说的心跳。leader通过心跳来确认server是否存活，同时，server也可以确认leader是否存活，如果leader挂了，servers就会重新进行选举，然后再提供服务。

**通知**
watcher是zk比较特殊的设计，允许一个或多个客户端绑定多个节点数据。当zk上的数据发生变化的时候能够通知到相应的客户端。这个设计就可以用来做很多的应用啦。redis数据库同样也有提供这样的消息发布与订阅的功能，不过那个是特意实现的一个功能给应用使用的。

#### 实现上的诸多细节

在听之前的老司机分享的时候，他们探讨了很多实现细节上的问题，感觉实现这样的一个分布式系统还是非常有挑战的。

比如，如果写请求进行中leader挂掉了怎么办，数据tcp丢包了怎么办。如何同步数据等等。有空很想看看其实现方式。

## 使用

(这里补充一下服务器版的安装。与使用)


最主要的使用途径还是通过客户端程序来访问zk。客户端有Java、python、lua、Go等。
我用java，所以。。

### maven 

```xml
<dependency>  
  <groupId>org.apache.zookeeper</groupId>  
  <artifactId>zookeeper</artifactId>  
  <version>3.3.5</version>  
</dependency>  
```

不过，这个有一点低端，所以我使用另外一个客户端的实现：curator。也是一个开源的zk客户端的实现，封装层次更高，所以操作更简便。

Curator框架提供了一套高级的API， 简化了ZooKeeper的操作。 它增加了很多使用ZooKeeper开发的特性，可以处理ZooKeeper集群复杂的连接管理和重试机制。 这些特性包括：

- 自动化的连接管理: 重新建立到ZooKeeper的连接和重试机制存在一些潜在的错误case。 Curator帮助你处理这些事情，对你来说是透明的。
- 清理API:
简化了原生的ZooKeeper的方法，事件等
- 提供了一个现代的流式接口

(提供了Recipes实现： 如前面的文章介绍的那样，基于这些Recipes可以创建很多复杂的分布式应用.这部分不明白，待补充)。

Curator框架通过CuratorFrameworkFactory以工厂模式和builder模式创建CuratorFramework实 例。 CuratorFramework实例都是线程安全的，你应该在你的应用中共享同一个CuratorFramework实例.

工厂方法newClient()提供了一个简单方式创建实例。 而Builder提供了更多的参数控制。一旦你创建了一个CuratorFramework实例，你必须调用它的start()启动，在应用退出时调用close()方法关闭.

```xml
 <dependency>
        <groupId>org.apache.curator</groupId>
        <artifactId>curator-recipes</artifactId>
        <version>2.7.0</version>
 </dependency>
```

这个版本的API 是流式的API，也就是。。用的时候一句话里有一串的调用，不断的点操作符。
for 一个zample: `client.create().creatingParentContainersIfNeeded().forPath(node.getPath(), node.data());` 这并不是最长的。



### 基本方式

1. 声明两个变量，存zk信息。
```java
    /** Zookeeper info */
    private static final String ZK_ADDRESS = "192.168.1.100:2181";
    private static final String ZK_PATH = "/zktest";

```

2. 实例化客户端
```java

    // 1.Connect to zk
    CuratorFramework client = CuratorFrameworkFactory.newClient(
            ZK_ADDRESS,
            new RetryNTimes(10, 5000)
    );
    client.start();

```

3. 目前zk还是空的，因为我们没有写数据。
先create一个ZNode，参数是路径和数据
```java
    client.create().
           creatingParentsIfNeeded().
           forPath(ZK_PATH, data1.getBytes());
```

4. 取数据
```java
    client.getData().forPath(ZK_PATH)
```

5. 更多操作

```java

    // 获取节点的子节点
    client.getChildren().forPath("/")

    // 修改数据
    client.setData().forPath(ZK_PATH, data2.getBytes());

    // 删除结点
    client.delete().forPath(ZK_PATH);

```

### 监视器的使用

在curator中提供了三种监视器：

1. PathCache：
监视一个路径下孩子结点的创建、删除，以及结点数据的更新。产生的事件会传递给注册的PathChildrenCacheListener。
2. NodeCache：
监视一个结点的创建、更新、删除，并将结点的数据缓存在本地。
3. TreeCache：
Path Cache和Node Cache的“合体”，监视路径下的创建、更新、删除事件，并缓存路径下所有孩子结点的数据。

1. 监视器在client启动之后进行注册。
```java
        // Register watcher
        PathChildrenCache watcher = new PathChildrenCache(
                client,
                ZK_PATH,
                true    // if cache data
        );
```

2. 添加Listener
```java
        watcher.getListenable().addListener((client1, event) -> {
            ChildData data = event.getData();
            if (data == null) {
                System.out.println("No data in event[" + event + "]");
            } else {
                System.out.println("Receive event: "
                        + "type=[" + event.getType() + "]"
                        + ", path=[" + data.getPath() + "]"
                        + ", data=[" + new String(data.getData()) + "]"
                        + ", stat=[" + data.getStat() + "]");
            }
        });
```
这一部分涉及到了lamda表达式的东西，决定下一篇就来学习一下lamda表达式和泛型编程这两个特性。

addListener 方法的参数可以是一个匿名的函数，在监听到对应的消息的时候执行。也可以是一个接口，实现一个函数，函数包含两个参数(client, event)就可以被执行。

这一点看了一个小时才理解出来，基础的Java特性不了解就是不行啊。


关于zk的东西就先介绍到这里。基本上够我继续往下用的。

同样都是写代码，不同的功力的人写出来的东西就是不一样啊。整个代码的大逻辑架构很清晰，但是写起来非常复杂。线程开的满天飞，监听器，触发器，写起来就像是组装一个巨大的流水线系统。非常的优美，没有暴力计算的感觉。
