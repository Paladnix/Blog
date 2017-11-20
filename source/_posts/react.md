---
title: react 初探-一些基础概念
date: 2017-07-31 17:31:49
tags: [Web, Javascript]
---

（这一篇写的很杂，因为自己也是没有章法的断断续续的看了react的东西，所以内容没有组织好。勉强有个认知就好了）

前端的技术现在发展的其实相对简单了很多，但是我觉得这才是正常的前端，以前的前端发展的太混乱，光是屏幕适配的问题就要搞出很多的工作量。而且以前的前后端的耦合过大，使得前端想发展也不发展不动，不过设计总是在进步，异步请求的普适催生了新的前后端设计模式，使得前后端完全解耦成为可能，前端的事情在前端搞定，后台的事情在后台封装掉。前端发展到今天主要就是接下来我要学习的几个js的框架，利用js实现动态的数据绑定，以及异步的请求，所有的前端操作都在封装在前端，开发的脑智压力开始下降，所以现在的全栈也并不是太难。

这样前端框架会用的人一般都比较多，因为学习栈比较浅，很多人自学一天就可以了。所以相对的资料也就非常完善，网上的学习教程编写教学例子也很方便，所以在这里我主要就是偏理论一些的认知，其背后的设计实现等。

## 简介

React是Facebook出品的一款开源框架，虽说是开源，但是其在标准的BSD协议后添加了一些条款，使得现在很多公司并不敢使用这个框架了，其添加条款中说明，如果使用该开源项目的产品威胁到facebook的商业产品，facebook有权起诉该产品。不过没有并那么可怕，因为貌似想威胁到也不太容易。

React这类框架主要的注意力放在的是用户的交互界面上，最突出的就是内容的动态绑定，内容变化后的高效刷新。并且屏蔽了DOM。

React使用的是JSX语法，是一种将js与html混合编写的语言。

## Javascript

在学习使用这个框架之前，必须对Javascript有所了解，因为这是一个Javascript框架。对于这部分了解的就直接跳过去看JSX的语法部分。

这门语言传说是被人误解最深的语言，确实貌似大家的学习路线都没有关注过这个东西，以为就是前端脚本搞着玩的语言，但是其语言还是有很多优点并且应用的场景正越来越多。

JavaScript 是一种面向对象的动态语言，它的语法来源于 Java 和 C，所以这两种语言的许多语法特性同样适用于 JavaScript。需要注意的一个主要区别是 JavaScript 不支持类，类这一概念在 JavaScript 通过对象原型（object prototype）得到延续。另一个主要区别是 JavaScript 中的函数也是对象，JavaScript 允许函数在包含可执行代码的同时，能像其他对象一样被传递。

### 类型

- Number（数字）
- String（字符串）
- Boolean（布尔）
- Symbol（符号）（第六版新增）
- Object（对象）
    - Function（函数）
    - Array（数组）
    - Date（日期）
- RegExp（正则表达式）
- Null（空）
- Undefined（未定义）

**等**

更多基础的语法不冗余重复了。

### Javascript对象

如果你知道Json的全称，你就理解了这个东西：JSON(JavaScript Object Notation, JS 对象标记)。一个符合Json协议的字符串可以直接解析为Javascript对象。

对于Object的成员访问可以使用链式访问：

```javascript
var obj = {
    name: "Carrot",
    "for": "Max",
    details: {
        color: "orange",
        size: 12
    }
}

obj.details.color; // orange

obj["details"]["size"]; // 12
```
下面的例子创建了一个对象原型，Person，和这个原型的实例，You。
```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
}

// 定义一个对象
var You = new Person("You", 24); 
// 我们创建了一个新的 Person，名称是 "You" 
// ("You" 是第一个参数, 24 是第二个参数..)

// 字段可以使用点操作符操作也可以使用下标操作。
```

### 数组
```javascript
var a = ["dog", "cat", "hen"];
a.length; // 3

a[100] = "fox";
a.length; // 101

typeof(a[90]); // undefined

a.push(item); // 在后面追加元素
```
遍历数组
```javascript
for (var i = 0; i < a.length; i++) {
    // Do something with a[i]
}

for (var i in a) {
  // Do something with a[i]
}
```

剩余的部分再补充吧。

## React 元素与组件

在元素在react中就是一个对象，只不过，不是简单的js对象，是jsx混合编写的对象。
for example:
```
const element = <div className="element">I'm element</div>
```
这样就创建了一个react元素，但是没有经过渲染是不会成为DOM中的元素的。

组件是由对象组成的，组建是一个类或者是无状态函数。

## JSX 语法简述

JSX是在javascript之上扩展而来的，最终还是会被编译成为javascript来运行的。
要学习其语法有很多地方可以看，这里就主要总结一下特点就好了。

优点：
1. 速度快，在编译成为js的时候做了优化。
2. 类型安全，在前期编译阶段就可以发现错误。
3. 编写简单。

一些语法特点：

1. 可以直接使用html代码。
2. 可以使用js表达式，表达式用大括号括起来。
3. 没有if-else ， 可以使用三目运算符。
4. 注释算是js表达式，所以要写在大括号中。

其他的一些注意点：

- 当给组件传递Props参数的时候，如果不是字符串类型，值就要用打括号扩起来，如果是一个对象的时候就会出现两层括号的现象：`style={{color:"red"}}`。


