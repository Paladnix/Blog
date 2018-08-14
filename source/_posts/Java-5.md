---
title: Java 多线程实现异步调用
date: 2017-08-10 16:53:28
tags: [Java]
---

昨天开始拿到了一个很厉害的师兄的项目，最近几篇的博客文章都是与此有关，我主要的任务是将其中的一个异步调用的架构改成同步的。所以要先来学习一下这个异步到底是怎么实现的。

## 异步调用

异步调用最主要的特点就是调用方并不等待函数的结果，而是继续进行下面的动作，函数自己去完成相应的过程。在函数完成以后将结果以某种方式返回给调用者。

实现异步的方式有很多，在前端的技术中使用的最多，这里我记录一下Java项目的内部自己异步调用某个函数的方式。

### 角色

在异步调用中，有三个角色，分别是消费者、取货凭据、生产者。对应的就是调用方、数据返回方式、执行函数。

举小蛋糕的例子非常好理解，订蛋糕、蛋糕店给你个取蛋糕的收据，或者也可以给你送到某个地方、蛋糕店生产蛋糕。

### 消费者

首先来看一下调用方的代码应该怎么写。

```java

public class Customer {  
  
    public static void main(String[] args) {  
        System.out.println("main BEGIN");  
        CakeShop host = new CakeShop();  
        Cake cake1 = host.request(10, 'A');  
        Cake cake2 = host.request(20, 'B');  
        Cake cake3 = host.request(30, 'C');  
        System.out.println("main otherJob BEGIN");  
        try {  
            Thread.sleep(2000);  
        } catch (InterruptedException e) {  
        }  
  
        System.out.println("main otherJob END");  
        System.out.println("cake1 = " + cake1.getCake());  
        System.out.println("cake2 = " + cake2.getCake());  
        System.out.println("cake3 = " + cake3.getCake());  
        System.out.println("main END");   
    }  
}  

```

代码先实例化一个蛋糕店，然后再下了三个订单，然后去做其他的事情了。在睡眠了多久以后执行了单据的`getCake`方法获取蛋糕。

所以这里就涉及到了三个类，分别是蛋糕店、消费者、蛋糕。

### 蛋糕店

看一下蛋糕店在收到订单以后做了什么

```java

public class CakeShop {  
  
    public Data request(final int count, final char c) {  
  
        System.out.println("request(" + count + ", " + c + ") BEGIN");  
        // (1) 建立DeliveryOrder的实体  
        final DeliveryOrder order = new DeliveryOrder();  
          
        // (2) 为了建立RealData的实体，启动新的线程  
        new Thread() {  
            public void run() {  
                //在匿名内部类中使用count、order、c。  
                CakeBaker cakeBaker = new CakeBaker(count, c);  
                order.setCakeBaker(cakeBaker);  
            }  
        }.start();  
        System.out.println("request(" + count + ", " + c + ") END");  
          
        // (3) 取回FutureData实体，作为传回值  
        return order;  
  
    }  
}  
```

蛋糕店在收到订单以后就实例化了一个对应的篮子，我们假设这个蛋糕店是将蛋糕放在篮子里交付的。然后新起了一个线程去生产蛋糕，并且生产完以后将蛋糕放在篮子里。这些都是在新的线程中做的。

线程一旦建立起来，这条语句就完成了，线程自己的生命周期就是操作系统和进程的事情了。所以在起完线程以后就直接将这个篮子返回给顾客，虽然这个时候篮子是空的。


那么顾客在需要取蛋糕的时候就调用这个篮子的取蛋糕的方法就可以获得相应的蛋糕了。如果在消费者取的时候蛋糕还没有做完，那消费者就得决定是否要等，如果不等就浪费了，如果等的话就写个循环等好了。

当然等的这个步骤可以不用用户自己写，在篮子的代码中我们要写一下，如果没有蛋糕在篮子里就等待，这样等待的步骤就回到了主线程中了。直到等到蛋糕才返回继续执行。


