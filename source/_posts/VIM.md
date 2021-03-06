---
title: VIM 花式进阶
date: 2017-07-24 20:36:46
tags: [Vim]
---

据说Vim在程序员鄙视链的顶端，呵呵，连编辑器都能用来鄙视别人的程序员肯定是个菜鸡。
但是一个Vim修炼之路真的是挺好玩的，一个编辑器居然能这么炫酷的写代码，这么强的扩展能力，和这么顺畅的操作，站上顶端也不是空有其名的，当然用Vim写代码的工程师的代码能力也不是浪得虚名。

IDE有IDE的好处，个人喜欢Vim。

所谓花式，就是没有章法，一点一点积累。

## Vim的剪切板-寄存器

Vim有大概47块剪切板，牛逼坏了。也就是说你可以存N份不同的东西在不同的剪切板中，当要用那个东西的时候直接一键粘出来。这其中有一个误会，就是以前总以为Vim默认不支持系统剪切板，其实系统剪切板是这N块中的一块，只不过不是默认剪切板而已，怎么想都不可能没有系统剪切板的，只是自己不会用。
在Vim中，这些其实并不叫剪切板，而叫寄存器，功能比剪切板大很多。

Vim中有10种寄存器，命令模式下：`:help registers` 就可以调出帮助文档。至于这10种寄存器具体的区别就不说了，列举一下都有那些寄存器。
寄存器的标志是`"`开头加寄存器名称。

1. 默认的无名寄存器`""`，就是引号所代表的寄存器
2. `"0-"9`号寄存器
3. `"a-"z` 或`"A-Z"` 字母寄存器
4. `"+` 寄存器，就是系统剪切板

其中默认的无名寄存器是我们平时剪切`dd`和复制`yy`用的剪切板。
如果我们要把一个东西存到某个寄存器，例如将某两行存在1号寄存器中，在普通模式下：
`2"1y`
这个命令地一个2是要复制的行数，然后是1号寄存器，然后是`y`复制。
要粘贴1号寄存器中的内容就在普通模式下：
`"1p`
要想将系统剪切板的内容剪切到vim中就把`"1`换成`"+` 就可以了。


