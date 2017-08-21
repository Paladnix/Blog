---
title: apache curator
date: 2017-08-18 17:45:34
tags: [Zookeeper, Java, Distributed]
---

**"Guava is to java what Curator is to Zookeeper".**

## Start

Curator之前介绍过一些，是一个使用流式API方式实现的Zookeeper的Java客户端。

### Get a connection

connection的实例(CuratorFramework)是用工厂模式分配的(CuratorFrameworkFactory)，对于一个zk集群，你只需要一个连接的实例。
同时你可能会用到的是RetryPolicy 去设置失败重试的参数，一般你会这样使用：

```java
RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3)
CuratorFramework client = CuratorFrameworkFactory.newClient(zookeeperConnectionString, retryPolicy);
client.start();
```
客户端需要显式的start并且在不用的时候显式的close.

在链接成功以后就可以直接操作对应的集群。并且，如果在执行操作的过程中出现了连接错误，curator的manage会自动重新尝试操作。

### 分布式锁
不可以对某个路径下的节点进行上锁：
```java
InterProcessMutex lock = new InterProcessMutex(client, lockPath);
if ( lock.acquire(maxWait, waitUnit) ) 
{
    try 
    {
        // do some work inside of the critical section here
    }
    finally
    {
        lock.release();
    }
}
```



