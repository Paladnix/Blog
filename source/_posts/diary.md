---
title: Latex写工作日志的实践
date: 2017-07-25 10:26:38
tags: [Latex, Log]
---

最近1个月手里同时在日常环境上跑通6个应用，脑内存实在不够用，现实在召唤新的工作模式的诞生。于是有了这篇文章。

一直在寻找一种方法，能满足我记录各种东西的需求又不要太凌乱，还要不时画一下软件结构图等。我需要一种可以一站解决这个问题的解决方案，但是很遗憾，貌似并没有。所以还是决定自己搞最原始的方案，使用latex直接写工作日志吧。

工作日志不同于其他笔记，相对比较机密，也不好写在其他地方。也为以后开发日志打个基础。

## Latex的Ubuntu安装

除了体积略大以外，并没有什么太大的缺点。latex支持的东西貌似更多，用户也更多。

顺序执行以下命令：
```bash
sudo apt install texlive-latex-base
sudo apt install latex-cjk-all
sudo apt install texlive-latex-extra
sudo apt install texlive-xetex
```
四个包加起来不到2G，其中第二个是中文支持包。我使用的方式是用命令行直接编译，用vim写代码。

在后续的使用过程中，你有可能会遇到有些包没有，这些包都是以`xxx.sty` 的形式命名的，这个时候这样来安装缺少的包：
```bash
sudo apt search xxx

# 查找到对应的包名，因为有的时候软件库中的名字可能不一致，有些前缀什么的。
# 从查出来的列表中选择你要的那个包然后安装就可以了

sudo apt install xxx
```
缺少包的情况会在编译的时候报错报出来。
还有的时候是因为缺少一些字体，在Ubuntu 上安装字体的方式如下：
```bash
# 下载你的字体包到本地。
# 你可以将自己的字体都放在一起，例如~/.share/fonts/ 文件夹中，没有这个文件夹就自己建。
# 然后将字体放进来，终端进入这个文件夹后执行下面的命令

sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
```
提醒你success就安装成功了，重新编译就可以了。


## 编译Latex

编译的命令是`xelatex filename.tex`。编译完成以后可以打开来看效果，我一般直接使用一个makefile文件来完成这一系列操作: 编译、后台打开，清除多余文件
Makefile代码如下：
```makefile
all:
	xelatex T.tex
	evince T.pdf &

clean:
	rm *.aux *.log
```

就是这么简单。

## 工作日志样式

回去加。
