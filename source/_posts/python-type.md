---
title: python type
date: 2018-09-22 13:47:12
tags: [Python]
---

#### type 的普通用法

type一般的用法使用来获取一个变量的类型，但是，type并不适合用来获取一个变量的类型。

想获取一个变量的类型，有其实类的实际类型要用`isinstance`

#### isinstance

```python 
class A:
    pass

class B(A):
    pass

isinstance(A(), A)    # returns True
type(A()) == A        # returns True
isinstance(B(), A)    # returns True
type(B()) == A        # returns False
```

```python
a = 111
isinstance(a, int)
# True
```


python中有一种`old-style class` 这些类用`type`直接取得到的都是`instance`， 也就是所有的类实例都是一样的。在后来的`new-style class`中，得到的会有区别但是，依然不能很好的判断子类的问题。

#### type 创建一个类型

这个用法我看到的时候反正是一脸懵逼，莫非是用来动态创建类用的？

用法：
```python
#type(classname,(parents,...),{attribute})
#第一个参数classname是类名,第二个是一个父类元组，没有可填空元组，第三个参数是类属性字典。


#!/usr/bin/env python
# coding=utf-8


class XA(object):

    a = 1

XB = type('XC', (object, ), dict(a=3))

Xa = XA()

Xb = XB()
# Xc = XC()       # syntax error， there is no such a class named XC， only XB as  a llegal class name.

print(XA)
print(XB)
print(XB)
print(Xa.a)
print(Xb.a)
#print(Xc.a)

```

总之这样可以动态的创建一个类。

比较秀一点的用法：

```python
MonitorThread = type("MonitorThread", (BaseThread, ), dict(__init__=init_monitor_thread, working=work_monitor))

```

用散的函数组装的类，还有这种。。。

python早晚要完，写代码一时爽，维护火葬场。



