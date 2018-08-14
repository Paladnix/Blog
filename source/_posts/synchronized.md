---
title: synchronized 同步锁
date: 2017-08-18 15:45:11
tags: [Java]
---

## synchronized



1. 修饰一个代码块，被修饰的代码块称为同步语句块，其作用的范围是大括号{}括起来的代码，作用的对象是调用这个代码块的对象； 
2. 修饰一个方法，被修饰的方法称为同步方法，其作用的范围是整个方法，作用的对象是调用这个方法的对象； 
3. 修饰一个静态的方法，其作用的范围是整个静态方法，作用的对象是这个类的所有对象； 
4. 修饰一个类，其作用的范围是synchronized后面括号括起来的部分，作用的对象是这个类的所有对象。


### 代码块加锁

一个线程访问一个对象中的synchronized(this)同步代码块时，其他试图访问该对象的线程将被阻塞。我们看下面一个例子：

```java
/**
 * 同步线程
 */
class SyncThread implements Runnable {
   private static int count;

   public SyncThread() {
      count = 0;
   }

   public  void run() {
      synchronized(this) {
         for (int i = 0; i < 5; i++) {
            try {
               System.out.println(Thread.currentThread().getName() + ":" + (count++));
               Thread.sleep(100);
            } catch (InterruptedException e) {
               e.printStackTrace();
            }
         }
      }
   }

   public int getCount() {
      return count;
   }
}
```
调用的方式如下：
```java
SyncThread syncThread = new SyncThread();
Thread thread1 = new Thread(syncThread, "SyncThread1");
Thread thread2 = new Thread(syncThread, "SyncThread2");
thread1.start();
thread2.start();
```

这里只有一个对象，创建了两个线程。两个县城先后启动。其结果就是先后的，因为有同步锁的存在。
```
SyncThread1:0 
SyncThread1:1 
SyncThread1:2 
SyncThread1:3 
SyncThread1:4 
SyncThread2:5 
SyncThread2:6 
SyncThread2:7 
SyncThread2:8 
SyncThread2:9
```

但是对于没有同步锁的代码块就没有这个限制：
```java
class Counter implements Runnable{
   private int count;

   public Counter() {
      count = 0;
   }

   public void countAdd() {
      synchronized(this) {
         for (int i = 0; i < 5; i ++) {
            try {
               System.out.println(Thread.currentThread().getName() + ":" + (count++));
               Thread.sleep(100);
            } catch (InterruptedException e) {
               e.printStackTrace();
            }
         }
      }
   }

   //非synchronized代码块，未对count进行读写操作，所以可以不用synchronized
   public void printCount() {
      for (int i = 0; i < 5; i ++) {
         try {
            System.out.println(Thread.currentThread().getName() + " count:" + count);
            Thread.sleep(100);
         } catch (InterruptedException e) {
            e.printStackTrace();
         }
      }
   }

   public void run() {
      String threadName = Thread.currentThread().getName();
      if (threadName.equals("A")) {
         countAdd();
      } else if (threadName.equals("B")) {
         printCount();
      }
   }
}
```

调用方式：

```java
Counter counter = new Counter();
Thread thread1 = new Thread(counter, "A");
Thread thread2 = new Thread(counter, "B");
thread1.start();
thread2.start();
```
结果如下：
```
A:0 
B count:1 
A:1 
B count:2 
A:2 
B count:3 
A:3 
B count:4 
A:4 
B count:5
```
### 对象加锁

```java
/**
 * 银行账户类
 */
class Account {
   String name;
   float amount;

   public Account(String name, float amount) {
      this.name = name;
      this.amount = amount;
   }
   //存钱
   public  void deposit(float amt) {
      amount += amt;
      try {
         Thread.sleep(100);
      } catch (InterruptedException e) {
         e.printStackTrace();
      }
   }
   //取钱
   public  void withdraw(float amt) {
      amount -= amt;
      try {
         Thread.sleep(100);
      } catch (InterruptedException e) {
         e.printStackTrace();
      }
   }

   public float getBalance() {
      return amount;
   }
}

/**
 * 账户操作类
 */
class AccountOperator implements Runnable{
   private Account account;
   public AccountOperator(Account account) {
      this.account = account;
   }

   public void run() {
      synchronized (account) {
         account.deposit(500);
         account.withdraw(500);
         System.out.println(Thread.currentThread().getName() + ":" + account.getBalance());
      }
   }
}
```

主要是账户操作类中的操作，调用方式：
```java
Account account = new Account("zhang san", 10000.0f);
AccountOperator accountOperator = new AccountOperator(account);

final int THREAD_NUM = 5;
Thread threads[] = new Thread[THREAD_NUM];
for (int i = 0; i < THREAD_NUM; i ++) {
   threads[i] = new Thread(accountOperator, "Thread" + i);
   threads[i].start();
}

/*
    结果如下：

Thread3:10000.0 
Thread2:10000.0 
Thread1:10000.0 
Thread4:10000.0 
Thread0:10000.0

*/
```
获得锁的顺序会乱，但是没有两个线程同时修改一个count对象。

利用这种方式你可以让任何一段代码变成同步且有同步锁的，只要建立一个对象，对这个对象加锁就可以了，最快的就是开个长度为空的数组：
```java
class Test implements Runnable
{
   private byte[] lock = new byte[0];  // 特殊的instance变量
   public void method()
   {
      synchronized(lock) {
         // todo 同步代码块
      }
   }

   public void run() {

   }
}
```
生成零长度的byte[]对象只需3条操作码，而Object lock = new Object()则需要7行操作码。

#### 注意事项 - synchronized关键字不能继承

这个其实也不算是注意事项，但是有的人对继承的中的函数覆盖和重写如果理解不够深刻就可能会出问题， 主要表现在子类中重写父类同步方法的时候如果没有加同步关键字是默认不同步的。

但是你调用父类的同步方法还是没有问题的。


### 修饰静态方法

其实修饰静态方法就相当与锁定了所有对象的某个方法，因为静态的就是所有的嘛。

### 修饰类

这个类的所有的对象共用一把锁。




