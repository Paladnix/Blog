---
title: Java 基础数据结构
date: 2017-07-03 22:00:27
tags: [Java]
---

最近在高频率的开新坑，所以博客也就高频率的开新东西，但是由于精力有限而且需求不是很大，所以在很多问题上暂时是不求深解的。浅尝辄止，还要去快攻下一个堡垒。但是以后都是要补回来的。。

但是这个应该不是浅尝，因为会经常用到。

# String
其构造方法比较特殊，可以直接等于赋值，也可以用严格的Java面向对象的写法。

## 构造
```java
String s = "abc";
s = "abc"
String s = new String("abc");

char[] data = {'a','b','c'};
String s = new String(data);
String str = s.subString(1,2);      //start from 1, length=2
```
## 方法
```java
charAt(int );
length();
replace(char old, char new);

// 常见的对象转换成字符串与转换回去的问题。
// 待补充

```

String对象是不可改变的。每次使用 System.String类中的方法之一时，都要在内存中创建一个新的字符串对象，这就需要为该新对象分配新的空间。在需要对字符串执行重复修改的情况下，与创建新的 String对象相关的系统开销可能会非常昂贵。如果要修改字符串而不创建新的对象，则可以使用System.Text.StringBuilder类。例如，当在一个循环中将许多字符串连接在一起时，使用 StringBuilder类可以提升性能。

# StringBuilder

其一般使用方式很简单。
```java
StringBuilder sb = new StringBuilder();
sb.append("abc"+"bbc");
sb.append(1.0);
System.out.println(sb.toString());
```
至于StringBuffer，可以理解为线程安全的StringBuilder。Builder的是非线程安全的，Buffer是安全的。所以在单线程的时候就可以使用StringBuilder。在速度上是 Builder > Buffer > String 。

# Map

在Java中Map是一个接口，实现这个接口的类有那么几个常用的，分别是：EnumMap, HashMap, HashTable, IdentityHashMap, LinkedHashMap, WeakHashMap, TreeMap, SortedMap and more.

## 常用方法
```java
public interface Map<K, V>

Map<String, List<String>> map = new HashMap<>();

clear();
put(K, V);
get(K);

```

## HashMap和Hashtable的区别

HashMap和Hashtable都实现了Map接口，但决定用哪一个之前先要弄清楚它们之间的分别。主要的区别有：线程安全性，同步(synchronization)，以及速度。

HashMap几乎可以等价于Hashtable，除了HashMap是非synchronized的，并可以接受null(HashMap可以接受为null的键值(key)和值(value)，而Hashtable则不行)。
HashMap是非synchronized，而Hashtable是synchronized，这意味着Hashtable是线程安全的，多个线程可以共享一个Hashtable；而如果没有正确的同步的话，多个线程是不能共享HashMap的。Java 5提供了ConcurrentHashMap，它是HashTable的替代，比HashTable的扩展性更好。
另一个区别是HashMap的迭代器(Iterator)是fail-fast迭代器，而Hashtable的enumerator迭代器不是fail-fast的。所以当有其它线程改变了HashMap的结构（增加或者移除元素），将会抛出ConcurrentModificationException，但迭代器本身的remove()方法移除元素则不会抛出ConcurrentModificationException异常。但这并不是一个一定发生的行为，要看JVM。这条同样也是Enumeration和Iterator的区别。
由于Hashtable是线程安全的也是synchronized，所以在单线程环境下它比HashMap要慢。如果你不需要同步，只需要单一线程，那么使用HashMap性能要好过Hashtable。
HashMap不能保证随着时间的推移Map中的元素次序是不变的。

# List 
这个是有一个类一个接口，类是awt中的东西我们就不看了。就只看作为接口，那些东西实现了这些接口，常用的用法就好了。这个接口集成了Collection和Iterable的接口，所以总的来说。
常用的类有：ArrayList， LinkedList。

- List:元素是有序的(怎么存的就怎么取出来，顺序不会乱)，元素可以重复（角标1上有个3，角标2上也可以有个3）因为该集合体系有索引，
- ArrayList：底层的数据结构使用的是数组结构（数组长度是可变的百分之五十延长）（特点是查询很快，但增删较慢）线程不同步
- LinkedList：底层的数据结构是链表结构（特点是查询较慢，增删较快）
- Vector：底层是数组数据结构 线程同步（数组长度是可变的百分之百延长）（无论查询还是增删都很慢，被ArrayList替代了）

## 方法
```java
List<String> list = new ArrayList<>();

add(index, Value);
addAll(index, Collection);

remove(index);
set(index, Value);
get(index);
subList(from, to);  // [from, to)
```
有一些LinkedList的东西暂时用不上就先不写了。

以上的几个东西都有迭代器的使用，可能会单开一篇来写迭代器的内容(还有C++的那部分)。


