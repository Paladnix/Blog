---
title: cpp lamda & for_each
date: 2017-08-17 17:49:11
tags: [C++]
---

既然学习了java的lamda表达式，当然要来顺便学习一下C++的实现。

## lamda

C++11 有了对lamda表达式的支持。基本的形式有下面几种：

|-----|
| [capture]  ( params ) mutable exception attribute -> ret { body } |
| [capture]  ( params ) -> ret { body }	|
| [capture]  ( params ) { body }	|
| [capture]  { body }	|

1. **[capture]**: 需要用到的外部变量

```
[a,&b]  a变量以值的方式呗捕获，b以引用的方式被捕获。
[this]  以值的方式捕获 this 指针。
[&]     以引用的方式捕获所有的外部自动变量。
[=]     以值的方式捕获所有的外部自动变量。
[]      不捕获外部的任何变量。
[&, x]  x显式地按值捕获. 其它变量按引用捕获  
[=, &z] z按引用捕获. 其它变量按值捕获  

```
2. **(params)**: 函数的参数, 无参数括号可以省略。
3. **mutable**: 修饰符说明 lambda 表达式体内的代码可以修改被捕获的变量，并且可以访问被捕获对象的 non-const 方法。
4. **exception**: 说明 lambda 表达式是否抛出异常(noexcept)，以及抛出何种异常，类似于void f() throw(X, Y)
5. **attribute**: 用来声明属性

几个例子：

```c++
[](int x, int y) { return x + y; } // 隐式返回类型
[](int& x) { ++x; }                // 没有return语句 -> lambda 函数的返回类型是'void'
[a](int& x) { x+=a; }              // 没有return语句 -> lambda 函数的返回类型是'void';注意，此处a是从lambda函数体外部传入其中的变量
[]() { ++global_x; }               // 没有参数,仅访问某个全局变量
[]{ ++global_x; }                  // 与上一个相同,省略了()
　　
// 可以像下面这样显示指定返回类型:  

[](int x, int y) -> int { int z = x + y; return z; }
　　// 在这个例子中创建了一个临时变量z来存储中间值. 和普通函数一样,这个中间值不会保存到下次调用. 什么也不返回的Lambda函数可以省略返回类型, 而不需要使用 -> void 形式.

```
下面举两个例子：

```c++
std::vector<int> some_list;  
int total = 0;  
for (int i=0;i<5;++i) some_list.push_back(i);  
std::for_each(begin(some_list), end(some_list), [&total](int x)   
{  
    total += x;  
});  
```

在其中用到了`for_each`的语法，直接介绍一下最后一个参数，是一个方法，同样也可以是一个lamda表达式。
`for_each`需要`algorithm`头文件。

比较好奇的就是怎么传的参数。。

以前用过一个函数`sort`，直接传一个函数的名就可以自定义比较函数了，但是一直没有去思考如何做到的。
看到有一种实现方式是函数指针，感觉这个东西在C语言中也有很大的意义，所以打算另起一篇来记录。

在使用lamda的时候参数是包含的函数本身确定的，例如for_each就会传入一个元素。

