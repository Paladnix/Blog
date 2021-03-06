---
title: Java 抽象与接口
date: 2017-05-29 04:24:56
tags: [Java, OOP]
---

在使用Java的过程中最主要的就是接口、继承这些东西。其实概念十分的简单，只是名字特殊了点，设计的技巧性较强。

之前听到有人在思考抽象类和接口的区别，以及为什么要两个都存在。但是，可能是我的见识太短，并没有这样的疑问。

## 抽象

面向对象编程抽象是避不开的内容，最经典的动物类，没有任何一种生物你可以说他就是动物，但是就是有动物这个概念，所以动物就是思维的抽象。良好的设计就要这样从抽象一步一步实例化最后具象为实体。
那么对于抽象的类来说，有一些东西就没有办法确定，比如动物的行走是用腿还是用腹？这个在动物类中无法确定，所以就需要先抽象着。

抽象类用修饰符`abstract` 修饰，并且抽象类不可以实例化，所以就不能用`final`来叠加修饰。抽象类可以没有抽象函数，但是有抽象函数的类必须定义为抽象类。

### 抽象函数

就是只有声明没有定义的函数，声明如下：

```java
public abstract boolean Update();
```

### 抽象类
```java
public abstract class A{
    ...
}
```

## 接口

与抽象类最大的不同就是，这并不是个类。接口不是类。所以这两个东西在本质上就不一样，所以我不认为二者有什么好冲突的。

而且最重要的就是，在Java中类是单一继承的，也就是说一个类只有一个父亲。那么对于从动物类派生出来的陆地动物、水生动物来说是没有什么问题，但是对于一个两栖动物就很尴尬，他没办法从上面的两个类中做继承，你要单独分出一个两栖动物也不是不可以，但是如果在一个系统中这样的复杂类型非常多就非常的麻烦了，然而在C++中是可以多继承的，于是就出现了接口这个东西。

接口是一种特殊的、完全没有实现的类。其中所有的方法都是没有实现的，且其中的域全都是常量。

### 接口的定义

```java
public interface interfaceName [extends superInterface1, superInterface2, ...]{

    // 常量定义(类型已经默认，可以省略不写)
    [public] [static] [final] type Name = constValue;

    // 方法定义
    [public] [abstract] returnType functionName(params)[throws exceptionList]{
        ...
    }
}

```

在子接口中对父接口的函数可以进行覆盖。

### 接口的实现

```java
public class A implements Interface1, Interface2, ...{
    // 必须实现所有的接口函数
}

public abstract class A implements Interface1, Interface2, ...{
    // 可以不实现，交给自己的子类实现。
}
```

所以Java使用抽象类和接口的形式来实现了多继承。
