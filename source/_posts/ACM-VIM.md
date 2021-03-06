---
title: VIM 在ACM/ICPC中的非最佳实践
date: 2017-07-23 21:05:54
tags: [ACM, Vim]
---

5月份在看今年的Final直播，看到了ITMO队的屏幕的时候，看到一些骚操作，感觉自己是拿着冲锋枪当鸟枪使了。

Vim确实十分强大，其强大是有原因的。最主要的原因是他本是依托终端存在的，他与终端有着非常强的联通。终端的强大一定程度上让vim变的很牛逼。不需要插件就可以在内置命令行。

打比赛两年了，现在也算是个退役狗了，才发现自己并没有好好用vim这个神器，不仅仅是装逼。
第一年的时候简单会用vim来写代码，会简单的配置，会用一点点的快捷键。
第二年的时候会用更多的快捷键，并没有什么本质上的突破，除了会用一点bash脚本来加快测试等。

本文将以ACM比赛场景作为线索，介绍一下Vim应该怎么用，以及，你为什么不要用IDE。

## 比赛开始

按照我们队的分工，我在前2分钟负责配置vim环境和代码环境。这里推荐一个简明配置清单：
```bash
vim ~/.vimrc
```

```vimrc
set nu                  " 行号
set mouse=a             " 鼠标可用
set shiftwidth=4        " 与tab宽度相关的
set tabstop=4           " tab宽度
set cindent             " c语言风格缩进
set autoindent          " 自动缩进
set cul                 " 高亮当前行
colorscheme desert      " 配色，选用你平时用的最好
syntax on               " 开启语法高亮

" 以下配置自己酌情
set noswapfile          " 不产生交换文件，在意外退出没有保存的情况下刚写的代码就没有了。
                        " 好处就是不会在打开文件的时候提醒你交换文件，下面会讲怎么处理这种请况。
```
在配置完vim后，我会写一个头文件和主函数的模板，然后命令行给每一题都复制一份。
模板会写：所有会用到的头文件、主函数、输入格式、输出Case、常用的#define、typedef、const等。

用一个四行的脚本来复制：
```bash
#!/bin/bash

for name in {A..M};
do
    cp a.cpp $name.cpp
done

# 我写的模板文件是a.cpp
# 脚本名为copy.sh
```
执行这个脚本有两个选择，一个是命令：`bash copy.sh`。
还有一个是先给脚本执行权限，然后直接运行脚本：`chmod +x copy.sh`、`./copy.sh`。

至此比赛已经开始2分钟了，一个队友应该已经看完一题了，开始玩吧。

## 测样例
写完代码就要开始测样例了。并不需要离开vim环境，直接一个命令搞定。
先来写一个脚本，这个脚本也可以在比赛开始就写掉：
```bash
#!/bin/bash

g++ $1.cpp -std=gnu++11 && cat $1.IN | ./a.out
```
这个脚本极其简单了，我们遵循一个规则来做就好了。
先解释一下脚本内容：脚本可以接受一个参数，按照我们上面的命名方式，这个参数就是题号的大写字母。我们默认编译输出文件为`a.out`， 你也可以换成对应的字母，这个没有关系。有两个命令，中间用逻辑操作符链接起来，只有在编译通过的时候才执行后面一句。第二句读取命名格式如`A.IN`的文件，并用管道输出给编译出来的程序。
结果会直接显示在终端，按Enter可以直接回到vim代码中。

这个脚本和输入文件写完以后，当你要测试的时候，不要退出vim。切换到vim的命令模式，冒号后输入例如A题`:!bash case.sh A` 然后回车就可以看到输出结果或是编译报错，按Enter键回到代码。

这个命令只需要手动输入一次，下一次你要测试的时候进入命令模式后，按上键就可以翻出来历史命令，回车就行了。

这些都是VIM与脚本结合所做的提速工作。下面介绍一些写代码过程中常用的快捷键。

## 编写代码

比赛环境十分紧张，快捷键这种东西等你想到再用其实也快不了多少，基本上都是条件反射的快捷键才真正起到了快捷的作用，所以平时就要经常用。

### 常用 Top N
（下面的快捷键都是在普通模式下）

1. 在当前行之前插入新行：`k + o` 或`O`
2. 在当前行下面插入新行：`o`
3. 复制当前行：`yy`，复制当前光标开始的N行：`Nyy`(N是数字)
4. 剪切当前行：`dd`，剪切当前光标开始的N行：`Ndd`(此功能也可用作删除)
5. 粘贴刚刚复制或剪贴的内容到光标处：`p`
6. 回退刚刚做的修改：`u`，注意这个不能反回退，也就是用此方式回退的步骤不能再被回退。
7. 全选：`ggVG`
8. 所有代码自动对齐：`ggVG + =`

### 交换文件
有的时候队友不小心强行关闭了其他队友没保存的终端，就会产生交换文件。当你再打开这个文件的时候就会提醒你要不要恢复之类的。这个时候你就先选`Q`退回到命令行，然后使用命令：`vim -r filename` 来将交换文件中没有保存的内容保存进原文件中。然后你需要删除这个交换文件，否则下次打开还提醒你。

删除交换文件很简单，首先终端命令查看隐藏文件
`ls -a` 
这个时候你会看到你文件对应的`.filename.cpp.swp`文件，然后命令
`rm .filename.cpp.swp`
就删除了，你也可以批量删除所有的交换文件：`rm .*.sw*`，因为如果你反复产生交换文件，交换文件也不互相覆盖，而是改个后缀变成`.swo`、`.swn`等。

### 结语

上面的那些技巧都没有什么卵用，该做不出来还是做不出来。
这些东西都是些锦上添花的技巧，我个人觉得最大的好处就是在代码出问题的时候测试调试比较快，心情会稍微好受点。一个命令出结果可以保持代码在脑子里的连惯性，快速定位问题。有的时候写代码只要10分钟，找bug可能要半小时。
归根结底，还是要能做出来。当你的能力能做出9道题的时候，这些可以一定程度上保证你能做完9道题。
