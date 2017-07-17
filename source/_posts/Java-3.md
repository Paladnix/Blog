---
title: Java-反射
date: 2017-07-04 20:41:16
tags: [Java]
---

Java某些特性决定了他今天的地位，反射就是其中之一。

反射是一种在运行过程中使用的，对于任意一个对象都可以获得他所属的类，进而都能够获取他的任意的方法和属性。我对反射的理解就是可以实现动态调用。
最常见的应用场景就是在Java的Web框架中，就是根据一些路由信息来定位到某个类的某个函数，定位到这个函数后就要启动这个函数。不可能写N多个`if-else`来匹配是否是当前类，是否是这个函数，我们希望的就是我传个参数，然后就能动态调用这个函数。至于类的实例化，函数的调用，交给JVM来做，这就是反射的意义。也是一种语言特性，很多解释型语言都具备这一特性，例如php等，其实java究其本质也算是一个解释型语言，只是有一个预编译的过程，编译出来的字节码也还是要用java虚拟机来解释执行。

## 实例化对象并调用对应函数
使用反射可以根据类名称来实例化对象，调用函数，传递参数。
这一部分涉及到的内容还是很多的，比如可变长参数，反射的机制，函数的重载问题等。

首先要获取我们要调用的函数，所以第一步先`Class.forName()`。这个函数是让JVM去加载这个类，然后获取其对应的函数`getMethod()`。在获取函数的时候会涉及重载的问题，多个函数名称一样的函数会被随机获取，我们可以通过制定参数类型的方式来确定我们要获取的函数具体是哪一个，下面的例子中就有这个问题的体现。后面还会有一个函数的重载的问题，有待求证。

获得了函数，接下来就可以做调用了， `invoke`函数参数列表也是可变的，第一个参数是执行函数的实例，如果是静态函数第一个参数就是`null`。这里我是先`new`了一个实例，然后传进去的，一般也可以在第一个参数的位置上写`class1.newInstance()`，然后就是参数列表了，按照与原函数参数顺序一致的顺序填进去就可以了。我在例子中用的是另外一种方式，也是由于目标函数的参数列表并不是普通的参数导致的，这也是一个坑点。

如果你要调用的函数有一个可变长的参数，你就得绕个弯。一般我们调用可变长参数的函数的时候就是传一个数组进去就可以了，但是这里并不可以，如果参数位置是一个数组的话就会报`IllegalArgumentException: wrong number of arguments`。然后就发现这个invoke本身就是一个参数可变长的函数，所以当我们把参数传进去之后被JVM拆成了单项，这样再往我们要调用的函数里传的时候就会参数数量不一致。这个是由于JVM会做拆分导致的，为了避免这个问题就把参数搞成JVM不会拆分的数据结构，这样做个整体传进去就可以了。下面的代码里就是使用`Object`来解决这个问题，可能也有其他的方式。

```java
package com.paladnix
/**
 * Created by paladnix on 17-7-17.
 */
public class TestReflect {

    public static void main(String[] args) throws Exception {

        String className = "com.paladnix.TestReflect";
        String methodName = "exec";

        Class<?> class1 = Class.forName(className);
        TestReflect testInstance = new TestReflect();
        Method method = class1.getMethod(methodName, String.class);     // 调用exec(String args)
//      Method method = class1.getMethod(methodName, String[].class);   // 调用exec(String... args)

        String[] params = new String[3];
        params[0] = "123";
        params[1] = "234";
        params[2] = "345";
        Object[] p = new Object[]{params};

        System.out.println(method.invoke(testInstance, "2"));   // 调用exec(String args)
//      System.out.println(method.invoke(testInstance, p));     // 调用exec(String... args)

    }

    public String exec(String... args) {
        StringBuilder ret = new StringBuilder();
        for(String param : args){
            ret.append(param+"*");
        }
        return ret.toString();
    }

    public int exec(String args) {
        return 1;
    }
}

```

上面提到的函数重载的问题，如下的两个函数：
```java
    /*
        Method - 1
    */
    public String exec(String a, String... args) {
        StringBuilder ret = new StringBuilder();
        for(String param : args){
            ret.append(param+"*");
        }
        ret.append(a);
        return ret.toString();
    }

    /*
        Method - 2
    */
    public int exec(String args) {
        return 1;
    }

    /*
        Method - 3
    */
    public String exec(String... args) {
        return "s";
    }
```
其理由很简单，当调用语句是`exec("aa")` 的时候应该去调用哪一个？其实，这个问题只存在于方法3和方法1中，他们与方法2之间区分是很明确的，在调用的时候是遵循了正则表达式中`*`和`+`的原理，如果只有一个参数就调用一个参数的那个，如果两个就去调用多的那个。但是在方法1和3之间，就无法区别了，两个参数列表都符合，这就无法调用，虽然函数本身没有编译错误，但是一旦使用，就会有编译错误。
