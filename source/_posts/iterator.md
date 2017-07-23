---
title: iterator 迭代器
date: 2017-07-23 19:14:14
tags: [C++, Java]
---

迭代器是一种对数据结构数据进行遍历的模式，也成为游标(Cursor)模式。这种模式为了适应各种被封装了的复杂数据结构的完全顺序遍历而设计。其设计思想依旧是封装的思想，屏蔽各种数据结构底层的存储差异，使用统一的方法来遍历所有的数据。

## C++

先以C++中的迭代器的使用来说一下。举两个常用的容器的例子。
### vector

#### 遍历、删除元素

```C++
vector<int>::iterator it;
for( it = A.begin(); it!=A.end(); it++){
    cout << *it << endl;
    if(*it == 3){
        A.erase(it);
    }
}

/*
   上面这种写法是有问题的，当你删掉3这元素的时候，it再++，直接就到了5了，4就跳过去了。
   因为erase后，后面的元素都会前移。
   从这里我们可以看到，vector中的迭代器应该就是指针。
   正确的写法如下：
 */

vector<int>::iterator it;
for( it = A.begin(); it!=A.end(); it++){
    cout << *it << endl;
    if(*it == 3){
        vector<int>::iterator it_tmp = it;
        it--;
        A.erase(it_tmp);
    }
}
```
#### set

```c++
set<int>::iterator it;
for(it = S.begin(); it!=S.end(); it++){
    cout << *it << endl;
    if(*it == 3){
        set<int>::iterator it_tmp=it;
        it--;
        S.erase(it_tmp);
    }
}
```
复杂的部分，暂时我也用不到。很尴尬，说明写的东西比较简单吧。以我目前的认知，写一些封装的数据结构的时候会使用迭代器比较多，我不写那些东西，就基本上不怎么用迭代器，何况我还是C/C++混合型的程序员。

下面介绍个不常用的语法，其实现是基于迭代器的。

### for
```c++
// 接上面的set部分

for(int item : S){
    cout << item << endl;
}
```
这个遍历起来代码就少很多了。编译的时候用选项参数`-std=gnu++11` 或`-std=c++11`


## Java 

java中有一个`Iterator`接口类，所有提供迭代器的类需要实现这个接口。这个接口定义了一个迭代器所具有的功能。我觉得这里我们可以很好的理解接口的意义，就是给出定义。

定义如下：
```java
package java.util;    
public interface Iterator<E> {    
    boolean hasNext();    
    E next();    
    void remove();    
}    
```
三个函数十分好理解。常用的用法如下：
```java
while(it.hasNext()){    
    System.out.println(it.next());    
}    
```

还有一个接口`Iterable`。这个接口更加简单，只有一个函数，产生一个迭代器并返回这个迭代器。对于提供迭代遍历的类，必须实现的接口。

迭代器的使用：
```java
List list=new ArrayList();   
Map map=new HashMap();  

for(int i=0;i<10;i++){  

    list.add(new String("list"+i) );  

    map.put(i, new String("map"+i));  

}  

Iterator iterList= list.iterator();     //List接口实现了Iterable接口  

while(iterList.hasNext()){  

    String strList=(String)iterList.next();  

    System.out.println(strList.toString());  

}  

Iterator iterMap=map.entrySet().iterator();  

while(iterMap.hasNext()){  

    Map.Entry  strMap=(Map.Entry)iterMap.next();  

    System.out.println(strMap.getValue());  

}  
```

### for each 语法

在JAVA1.5后添加了一个循环结构，语法与C++的一样。
```java
for(String str:list){

    System.out.println(str);

}

```

不是很深入，但是应该算有用。从我找资料的过程中就可以看出Java的生态圈要比C++大不少，而且Java体系的思维也会简单一些。很多文章都是Java的内容，C++就比较少，而且C++很多只是介绍怎么用像我这样。深入到STL源码来解释怎么写迭代器的不多。
