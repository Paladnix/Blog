---
title: less 笔记
date: 2017-11-20 12:36:39
tags: [Web, Css]
---

作为CSS的一种扩展语言，使得CSS开发更便捷。

# 变量

less中的变量使用`@`开头。

```
  // LESS

@color: #4D926F;

#header {
  color: @color;
}
h2 {
  color: @color;
}


/* 生成的 CSS */

#header {
  color: #4D926F;
}
h2 {
  color: #4D926F;
}

```

甚至可以用变量名定义为变量:

```
@fnord: "I am fnord.";
@var: 'fnord';
content: @@var;

--> content: "I am fnord.";
```
请注意 LESS 中的变量为完全的 ‘常量’ ，所以只能定义一次.

## 字符串嵌入

变量可以用类似ruby和php的方式嵌入到字符串中，像@{name}这样的结构:

`
@base-url: "http://assets.fnord.com";
background-image: url("@{base-url}/images/bg.png");
`

## 作用域

LESS 中的作用域跟其他编程语言非常类似，首先会从本地查找变量或者混合模块，如果没找到的话会去父级作用域中查找，直到找到为止.

# 引入文件

你可以在main文件中通过下面的形势引入 .less 文件, .less 后缀可带可不带:
```
@import "lib.less";
@import "lib";
```
如果你想导入一个CSS文件而且不想LESS对它进行处理，只需要使用.css后缀就可以:
```
@import "lib.css";
```

# 打包重用
```
#bundle {
  .button () {
    display: block;
    border: 1px solid black;
    background-color: grey;
    &:hover { background-color: white }
  }
  .tab { ... }
  .citation { ... }
}

```
使用的时候这样使用：
```

#header a {
  color: orange;
  #bundle > .button;
}
```

# 混合

混合可以将一个定义好的class A轻松的引入到另一个class B中，从而简单实现class B继承class A中的所有属性。我们还可以带参数地调用，就像使用函数一样。

```
// LESS

.rounded-corners (@radius: 5px) {  // 设置默认值
  border-radius: @radius;
  -webkit-border-radius: @radius;
  -moz-border-radius: @radius;
}

#header {
  .rounded-corners;
}
#footer {
  .rounded-corners(10px);
}


/* 生成的 CSS */

#header {
  border-radius: 5px;
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
}
#footer {
  border-radius: 10px;
  -webkit-border-radius: 10px;
  -moz-border-radius: 10px;
}


```
任何 CSS class, id 或者 元素 属性集都可以以同样的方式引入.

## @arguments 变量

@arguments包含了所有传递进来的参数. 如果你不想单独处理每一个参数的话就可以像这样写:
```
.box-shadow (@x: 0, @y: 0, @blur: 1px, @color: #000) {
  box-shadow: @arguments;
  -moz-box-shadow: @arguments;
  -webkit-box-shadow: @arguments;
}
.box-shadow(2px, 5px);

```

# 嵌套

我们可以在一个选择器中嵌套另一个选择器来实现继承，这样很大程度减少了代码量，并且代码看起来更加的清晰。

```
// LESS

#header {
  h1 {
    font-size: 26px;
    font-weight: bold;
  }
  p { font-size: 12px;
    a { text-decoration: none;
      &:hover { border-width: 1px }
    }
  }
}

/* 生成的 CSS */

#header h1 {
  font-size: 26px;
  font-weight: bold;
}
#header p {
  font-size: 12px;
}
#header p a {
  text-decoration: none;
}
#header p a:hover {
  border-width: 1px;
}

```
注意 & 符号的使用—如果你想写串联选择器，而不是写后代选择器，就可以用到&了. 这点对伪类尤其有用如 :hover 和 :focus.

```
.bordered {
  &.float {
    float: left; 
  }
  .top {
    margin: 5px; 
  }
}

/* 输出 */
.bordered.float {
  float: left;  
}
.bordered .top {
  margin: 5px;
}
```
# 函数 & 运算

运算提供了加，减，乘，除操作；我们可以做属性值和颜色的运算，这样就可以实现属性值之间的复杂关系。LESS中的函数一一映射了JavaScript代码，如果你愿意的话可以操作属性值。
```
// LESS

@the-border: 1px;
@base-color: #111;
@red:        #842210;

#header {
  color: @base-color * 3;
  border-left: @the-border;
  border-right: @the-border * 2;
}
#footer {
  color: @base-color + #003300;
  border-color: desaturate(@red, 10%);
}

```


## Color 函数

```
lighten(@color, 10%);     // return a color which is 10% *lighter* than @color
darken(@color, 10%);      // return a color which is 10% *darker* than @color

saturate(@color, 10%);    // return a color 10% *more* saturated than @color
desaturate(@color, 10%);  // return a color 10% *less* saturated than @color

fadein(@color, 10%);      // return a color 10% *less* transparent than @color
fadeout(@color, 10%);     // return a color 10% *more* transparent than @color
fade(@color, 50%);        // return @color with 50% transparency

spin(@color, 10);         // return a color with a 10 degree larger in hue than @color
spin(@color, -10);        // return a color with a 10 degree smaller hue than @color

mix(@color1, @color2);    // return a mix of @color1 and @color2
```
你还可以提取颜色信息:

```
hue(@color);        // returns the `hue` channel of @color
saturation(@color); // returns the `saturation` channel of @color
lightness(@color);  // returns the 'lightness' channel of @color
```

## Math 函数
```
round(1.67); // returns `2`
ceil(2.4);   // returns `3`
floor(2.6);  // returns `2`
percentage(0.5); // returns `50%`
```


# 模式匹配

类似于函数重载。
```
.mixin (@s, @color) { ... }

.class {
  .mixin(@switch, #888);
}
```
如果想让.mixin根据不同的@switch值而表现各异，如下这般设置：
```
.mixin (dark, @color) {
  color: darken(@color, 10%);
}
.mixin (light, @color) {
  color: lighten(@color, 10%);
}
.mixin (@_, @color) {
  display: block;
}
```
变量可以匹配任意的传入值，而变量以外的固定值就仅仅匹配与其相等的传入值。


我们也可以匹配多个参数：
```

.mixin (@a) {
  color: @a;
}
.mixin (@a, @b) {
  color: fade(@a, @b);
}
```

# 导引

当我们想根据表达式进行匹配，而非根据值和参数匹配时，导引就显得非常有用。Less不使用if-else的方式实现条件判断，而是使用导引。

```
.mixin (@a) when (lightness(@a) >= 50%) {
  background-color: black;
}
.mixin (@a) when (lightness(@a) < 50%) {
  background-color: white;
}
.mixin (@a) {
  color: @a;
}
```
可使用的运算符： `=, >, <, >=, <=`。
需要注意的是， 只有关键字true才是真，其余的任何东西都是假。
导引序列使用逗号‘,’—分割，当且仅当所有条件都符合时，才会被视为匹配成功。
```
.mixin (@a) when (@a > 10), (@a < -10) { ... }
```
在导引序列中可以使用and关键字实现与条件：
```
.mixin (@a) when (isnumber(@a)) and (@a > 0) { ... }
```
使用not关键字实现或条件
```
.mixin (@b) when not (@b > 0) { ... }
```

导引可以无参数，也可以对参数进行比较运算：
```
@media: mobile;

.mixin (@a) when (@media = mobile) { ... }
.mixin (@a) when (@media = desktop) { ... }

.max (@a, @b) when (@a > @b) { width: @a }
.max (@a, @b) when (@a < @b) { width: @b }
```
最后，如果想基于值的类型进行匹配，我们就可以使用`is*`函式：
```
.mixin (@a, @b: 0) when (isnumber(@b)) { ... }
.mixin (@a, @b: black) when (iscolor(@b)) { ... }
```
常用的有：
- iscolor
- isnumber
- isstring
- iskeyword
- isurl

如果你想判断一个值是纯数字，还是某个单位量，可以使用下列函式：
- ispixel
- ispercentage
- isem
```

```

# 避免编译

有时候我们需要输出一些不正确的CSS语法或者使用一些 LESS不认识的专有语法.

要输出这样的值我们可以在字符串前加上一个 ~, 例如:
```
.class {
  filter: ~"ms:alwaysHasItsOwnSyntax.For.Stuff()";
}
```
我们可以将要避免编译的值用 “”包含起来。输出的时候会去掉引号的。

# Javascript表达式
```
@var: `"hello".toUpperCase() + '!'`;
```
使用反引号包起来。
注意你也可以同时使用字符串插值和避免编译:

```
@str: "hello";
@var: ~`"@{str}".toUpperCase() + '!'`;
```
它也可以访问JavaScript环境:
```
@height: `document.body.clientHeight`;
```
