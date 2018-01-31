---
title: redis
date: 2017-07-14 11:42:58
tags: [NoSQL, Redis]
---

redis 是一个高速的高级的键值对存储系统。开源的，高可用，高效。
其将数据完全保存在内存中，磁盘只做持久化。并且支持多种数据结构：list、set、hashtable等，使用方便。
使用的场景主要有: 
- 如排行榜、计数器缓冲、数据统计（如TopN，交集，并集等）、最新项目检索、地理位置存储及range查询
- 实时统计和过期处理，如用户投票及排序；复杂的数据结构缓存及内存数据库
- 缓存，消息队列(Redis本地支持发布/订阅)，应用程序中的任何短期数据，例如，web应用程序中的会话，网页命中计数等。

由于其属于内存数据库，所以成本比较大，冈起来比较爽一点。

#### Install on Ubuntu
```bash
sudo apt-get install redis-server
```
#### Startup
```bash
redis-server
```
#### Work on it
```bash
redis-cli

# 出现命令提示符即正常工作
```

## 支持的数据结构
正时因为支持这些数据结构才易用。

#### 字符串
Redis中的字符串是一个字节序列。Redis中的字符串是二进制安全的，这意味着它们的长度不由任何特殊的终止字符决定。因此，可以在一个字符串中存储高达512兆字节的任何内容。
```bash
set name `Paladnix` # 存入key-value

get name # 获取key对应的value
```
#### Hash散列
Redis散列/哈希(Hashes)是键值对的集合。Redis散列/哈希是字符串字段和字符串值之间的映射。因此，它们用于表示对象。
```bash
HMSET key uname "Paladnix" password "123" level 0
# key 对应一个对象
```

#### 列表List
Redis列表只是字符串列表，按插入顺序排序。可以向Redis列表的头部或尾部添加元素。
```bash
lpush alist redis   # 插入字符串
lpush alist Paladnix # 插入字符串

lrange alist 0 10   # 获取字符串
```
#### 集合Set
Redis集合是字符串的无序集合。在Redis中，可以添加，删除和测试成员存在的时间O(1)复杂性。
```bash
sadd yiibailist redis   # 添加字符串

smembers yiibailist     # 输出结果
```
#### 可排序集合
Redis可排序集合类似于Redis集合，是不重复的字符集合。 不同之处在于，排序集合的每个成员都与分数相关联，这个分数用于按最小分数到最大分数来排序的排序集合。虽然成员是唯一的，但分数值可以重复。
```bash
zadd yiibaiset 0 redis

ZRANGEBYSCORE yiibaiset 0 1000  # 输出结果
```

## 命令
其实redis的使用跟数据库差不多。
具体的数据操作命令其实非常的简单就不一一介绍了，我自己也用的不熟。那些命令都能很容易获得，介绍一点好玩的命令就好了。

#### 远程链接
示例显示如何连接到Redis远程服务器，在主机(host)127.0.0.1，端口(port)6379上运行，并使用密码为 mypass
```bash
redis-cli -h 127.0.0.1 -p 6379 -a "mypass"
```

#### 发送订阅
Redis发布订阅(pub/sub)是一种消息通信模式：发送者(pub)发送消息，订阅者(sub)接收消息。
Redis 发布订阅(pub/sub)实现了消息系统，发送者(在redis术语中称为发布者)在接收者(订阅者)接收消息时发送消息。传送消息的链路称为信道。

在Redis中，客户端可以订阅任意数量的信道。
```bash
SUBSCRIBE redisChat # 订阅名为"redisChat"的信道。

PUBLISH redisChat "Redis is a great caching technique" 
```

#### 程序连接Redis
跟使用数据库一样，不过不一样的是这个比较统一和简单。
#### java
```java

/*
    Java 连接Redis. 字符串操作。
*/
import redis.clients.jedis.Jedis; 

public class RedisStringJava { 
   public static void main(String[] args) { 
      //Connecting to Redis server on localhost 
      Jedis jedis = new Jedis("localhost"); 
      System.out.println("Connection to server sucessfully"); 
      //set the data in redis string 
      jedis.set("tutorial-name", "Redis tutorial"); 
      // Get the stored data and print it 
      System.out.println("Stored string in redis:: "+ jedis.get("tutorialname")); 
   } 
}


/*
    Java Redis List 操作
*/
import redis.clients.jedis.Jedis; 

public class RedisListJava { 
   public static void main(String[] args) { 
      //Connecting to Redis server on localhost 
      Jedis jedis = new Jedis("localhost"); 
      System.out.println("Connection to server sucessfully"); 

      //store data in redis list 
      jedis.lpush("tutorial-list", "Redis"); 
      jedis.lpush("tutorial-list", "Mongodb"); 
      jedis.lpush("tutorial-list", "Mysql"); 
      // Get the stored data and print it 
      List<String> list = jedis.lrange("tutorial-list", 0 ,5); 

      for(int i = 0; i<list.size(); i++) { 
         System.out.println("Stored string in redis:: "+list.get(i)); 
      } 
   } 
}

/*
    Java Redis Key 操作
*/
import redis.clients.jedis.Jedis; 

public class RedisKeyJava { 
   public static void main(String[] args) { 
      //Connecting to Redis server on localhost 
      Jedis jedis = new Jedis("localhost"); 
      System.out.println("Connection to server sucessfully"); 
      //store data in redis list 
      // Get the stored data and print it 
      List<String> list = jedis.keys("*"); 

      for(int i = 0; i<list.size(); i++) { 
         System.out.println("List of stored keys:: "+list.get(i)); 
      } 
   } 
}
```

#### PHP-Redis on Ubuntu
下载[phpredis](http://github.com/nicolasff/phpredis%E3%80%82)项目代码并安装。
```bash
cd phpredis 
sudo phpize 
sudo ./configure 
sudo make 
sudo make install
```
现在，将“modules”文件夹的内容复制并粘贴到PHP扩展目录中，并在php.ini中添加以下行`extension = redis.so`。
```php
// Connect & String
<?php 
   //Connecting to Redis server on localhost 
   $redis = new Redis(); 
   $redis->connect('127.0.0.1', 6379); 
   echo "Connection to server sucessfully"; 
   //set the data in redis string 
   $redis->set("tutorial-name", "Redis tutorial"); 
   // Get the stored data and print it 
   echo "Stored string in redis:: " .$redis→get("tutorial-name"); 
?>


// List 操作
<?php 
   //Connecting to Redis server on localhost 
   $redis = new Redis(); 
   $redis->connect('127.0.0.1', 6379); 
   echo "Connection to server sucessfully"; 
   //store data in redis list 
   $redis->lpush("tutorial-list", "Redis"); 
   $redis->lpush("tutorial-list", "Mongodb"); 
   $redis->lpush("tutorial-list", "Mysql");  

   // Get the stored data and print it 
   $arList = $redis->lrange("tutorial-list", 0 ,5); 
   echo "Stored string in redis:: "; 
   print_r($arList); 
?>

```
