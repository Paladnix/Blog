---
title: java 线程与池
date: 2017-07-25 15:45:44
tags: [Java] 
---

线程与池这两个东西在很多语言中都存在，这是一种编程模式。
池的思维是根本。举个例子，如果某个数据库有一个远程交互的API允许你写代码来远程操作，那么你如果不用池，每条命令都重新发起一个连接，然后要数据库认证身份，然后执行命令。这样的效率不高，你会很当然的想到我要把连接保持住，让多个命令的执行只进行一次身份认证。这个时候就引入池的概念。每次从池中取出对应的连接，执行完命令再放回到池里。
同样的思维在ACM比赛中我们常用内存池的方法来避免频繁申请内存。

线程作为一种资源，也需要申请，申请也要开销，所以能将申请次数降低就可以提高效率，所以我们搞个池。
线程是一个进程的执行单元。一个进程中可以有若干线程，每个线程都是独立的执行单元。线程的调度比进程调度要快很多，因为线程调度的资源涉及更小。

那么为什么要多线程？

先来讲一下并行和并发。
并行：“真正的两个机器同时工作”；
并发：“看上去的同时执行的，实际上在同一个cpu上轮转执行的”；
并发的场景非常多，最基本的就是同时过来两个请求需要做，如果你是单线程的程序，就必须等待前一个完全做完再处理后面一个。如果你是多线程程序，就可以从线程池里取一个线程来处理新的请求，可以保证工作效率。这个地方其实有两个东西，一个是用户体验，一个是异步操作。前一个好理解，后一个讲一下我的理解。
现在很多时候我们都要将处理步骤拆成异步的来做，异步处理的实现方式其中就有多线程。同步就是我前一句代码没有做完，后面的代码后面的步骤就阻塞在那里了。如果我们用异步的方式，开一个新的线程来搞某个步骤。例如写日志和返回执行结果，我们就可以起一个线程去写日志，然后主线程直接返回处理结果，这个处理结果对日志是弱依赖的，日志写的如何并不影响我返回结果的操作，不能因为我日志写失败了我就不把结果返回去，有可能磁盘页被其他程序上锁了，一时半会儿都搞不完，这个时候多线程的优势就显现出来了。

感觉到这里讲了很多东西，都可以讲的很细的，但是讲的太细看的人都没兴趣了，我自己也不需要写太多。

## 如何实现多线程
在Java中封装的很好，用起来也很简单。实现多线程有两种方法，一种是继承`Thread`类，一种是实现`Runable` 接口。

### Thread
```java
class Thread1 extends Thread{  
    private String name;  
    public Thread1(String name) {  
       this.name=name;  
    }  
    public void run() {  
        for (int i = 0; i < 5; i++) {  
            System.out.println(name + "运行  :  " + i);  
            try {  
                sleep((int) Math.random() * 10);  
            } catch (InterruptedException e) {  
                e.printStackTrace();  
            }  
        }    
    }  
}  
public class Main {  
  
    public static void main(String[] args) {  
        Thread1 mTh1=new Thread1("A");  
        Thread1 mTh2=new Thread1("B");  
        mTh1.start();  
        mTh2.start();  
  
    }   
}  
```
这种方法就是继承`Thread`类并重写`run()` 方法，在执行这个`run`的时候并不是直接调用，而是直接调用`start()` 方法。这里是个跟正常思维不一样的地方，因为涉及到线程的状态问题。因为线程是在进程下面的，所以你新起一个线程需要被进程管控的，新加入一个线程并不能立即被执行，而是要将其状态置成“就绪”状态，进程会将其挂进队列里，进行调度。

### Runable
```java
class Thread2 implements Runnable{  
    private String name;  
  
    public Thread2(String name) {  
        this.name=name;  
    }  
  
    @Override  
    public void run() {  
          for (int i = 0; i < 5; i++) {  
                System.out.println(name + "运行  :  " + i);  
                try {  
                    Thread.sleep((int) Math.random() * 10);  
                } catch (InterruptedException e) {  
                    e.printStackTrace();  
                }  
            }  
          
    }  
      
}  
public class Main {  
  
    public static void main(String[] args) {  
        new Thread(new Thread2("C")).start();  
        new Thread(new Thread2("D")).start();  
    }  
  
}  
```
感觉差不多的。调用的时候也是用`start`。

### Thread 与 Runable的区别

`Runable`实现的多线程能够在同一个实例上运行，而`Thread`的不可以。
```java
public class Main {  
  
    public static void main(String[] args) {  
          
        Thread2 my = new Thread2();  
            new Thread(my, "C").start();     
            new Thread(my, "D").start();  
            new Thread(my, "E").start();  
    }  
}  
```
这样的调用，会让三个线程在同一个实例上运行，比如售票系统中，不同的线程是不同的用户，但是减的票数在同一个实例上。

关于线程还有很多东西，才疏学浅，暂时不深究，因为没用到，在造轮子的时候就会用到了。

## 线程池

上面只是简单的写写多线程，并没有涉及到池，也就是一种暴力的多线程。
线程池在Java中也是封装好的一个类，也很方便。

#### 创建线程池

```java
ThreadPoolExecutor executor = new ThreadPoolExecutor(corePoolSize, maximumPoolSize,
            keepAliveTime, milliseconds,runnableTaskQueue, threadFactory,handler);

```

**参数说明**

    - corePoolSize：核心池的大小，这个参数跟后面讲述的线程池的实现原理有非常大的关系。在创建了线程池后，默认情况下，线程池中并没有任何线程，而是等待有任务到来才创建线程去执行任务，除非调用了prestartAllCoreThreads()或者prestartCoreThread()方法，从这2个方法的名字就可以看出，是预创建线程的意思，即在没有任务到来之前就创建corePoolSize个线程或者一个线程。默认情况下，在创建了线程池后，线程池中的线程数为0，当有任务来之后，就会创建一个线程去执行任务，当线程池中的线程数目达到corePoolSize后，就会把到达的任务放到缓存队列当中；
    
    - maximumPoolSize：线程池最大线程数，这个参数也是一个非常重要的参数，它表示在线程池中最多能创建多少个线程；

    - keepAliveTime：表示线程没有任务执行时最多保持多久时间会终止。默认情况下，只有当线程池中的线程数大于corePoolSize时，keepAliveTime才会起作用，直到线程池中的线程数不大于corePoolSize，即当线程池中的线程数大于corePoolSize时，如果一个线程空闲的时间达到keepAliveTime，则会终止，直到线程池中的线程数不超过corePoolSize。但是如果调用了allowCoreThreadTimeOut(boolean)方法，在线程池中的线程数不大于corePoolSize时，keepAliveTime参数也会起作用，直到线程池中的线程数为0；


创建完线程池，要向线程池提交程序，跟多线程一样，你的类实现`Runable`接口，重写`run()` 函数就可以了。

```java
 executor.execute(myTask);

 // myTask 是你要多线程执行的类的实例
```

简述了一些这方面的东西。一般我们在开发项目使用的时候都会初始化很多个线程池，不同的业务代码用不同的线程池，用线程的时候最重要的就是线程安全的问题。这个下次遇到再写，没有碰到过就理解不深刻。
