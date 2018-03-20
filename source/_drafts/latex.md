---
title: Tutorial of Latex - The difference with .cls and .sty
tags: [Latex]
---

总的来说，`.cls` 和`.sty` 文件都是用来增强latex功能的。

**二者的最主要的区别就是：**

- .cls 文件使用`\documentclass{}` 的方式引入
- .sty 文件使用`\usepackage{}` 的方式引入

.cls文件用于确定的描述一个文档的结构，一个文档只能引入一个。.sty 文件是可选的，功能隔离的包，当我们需要某些功能的时候我们就引入。
二者都包含任意的tex或是latex代码，都是文档的功能的补充。

