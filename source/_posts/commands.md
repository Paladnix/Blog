---
title: 真正的老司机如何用Linux文本命令
date: 2017-07-27 17:23:29
tags: [Linux]
---

Tomcat是最烂的软件，没有之一！Over!
因为日志系统冲突的问题，这两天跟Tomcat斗争了好久，最终被其无耻下流卑鄙所折服，自信点，你就是最烂的！于是就诞生了上一篇长文来叙述日志是怎么搞，现在这一篇也是在实战中学习到的。

曾经学这些命令的时候只知道这些命令有很多功能，也很困惑，一个命令搞这么多参数干嘛，有什么用啊，我反正不会用。然后今天就脸红了，是我不会用。
不得不说设计这些命令的前辈真的很厉害，然后发现windows就这么丢弃这些东西真的是自断后路。盖茨肯定意识到电脑以后会是标配，但是他一定没有意识到自己在让计算机变傻。或许他本身就很傻吧，不是很能懂，自己一个号称最优秀的程序员之一的人，在设计计算机的时候就这么把这些东西屏蔽掉，自己真的打算用吗？计算机是越来越多了，但是其真正强大的功能都被windows阉割了，也阉割了真正的优雅，一定程度上，我认为盖茨理解错了计算机处理信息的价值。

我喜欢vim、latex、linux他们都有一个共同的特点，就是连通性非常强，而且操作简单。在工作过程中除了浏览网页，我基本上不会用鼠标，快捷键加命令可以无所不达。

一般我会开两个终端窗口，一屏左右各占一个。开发服务器相关的应用的时候左边终端在本地，右侧终端`ssh`连进服务器。就单单这一个操作，在windows下就要复杂N倍，要安装软件才能支持`ssh`协议，还要软件模拟服务器终端，丑的要死不说，各种切换操作都要依靠鼠标... 而在linux的终端下，每个操作都只是简单的一个命令的事情，可以用命令完整精准的描述你的想法，所想即所得。

下面几个命令，很强大。
`ps`、`less`、`head`、`tail`、`grep`、`watch`...

## ps
你知道Tomcat自己的`bin/shutdown.sh`是无法把自己关闭的吗？很抱歉，我特么这么用了一天了。然后ps发现一堆tomcat进程在跑，顿时恐惧袭上心头。关不掉你就别写个`shutdown.sh`啊，坑死爸爸了。
下次要关tomcat就特么直接`kill`，就不用那么麻烦了。

`ps` 命令是一个系统进程的快照。他通过读取`/proc`文件的方式获取信息。
使用`man` 命令获取内置说明文档：`man ps`，就可以看到各个参数的说明。这里会介绍一些参数的用法，但是仅仅是做个记录而已，有价值的东西是后面的实战例子。

在参数中，`ps`命令支持三种命令格式：
```
Unix    带短线(dash)：-a 参数
BSD     不带短线(dash)：a 参数
GNU     两个连续短线(two dash)：--a 参数
```
一般我用`Unix`格式的参数。
在解释这个命令之前还要解释一个东西就是Linux的进程。
在Linux中，一个进程组`(process group)`都是独一无二的会话`(session)`，这个`session`的`ID`就是这个`session`的第一个`process`的`ID`。这个进程也叫做`the session leader`。
```
-e              获取所有的进程，与-A 一毛一样。

-aux            获取所有的进程的详细信息。包括没有tty的进程和leader进程。
                包含一下信息：
                USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND

-C cmdlist      获取对应cmd的进程

-p pidlist      获取对应pid的进程

-u userlist     获取对应user的进程

-f              获取格式化信息

--sort spec     根据spec排序输出，example：ps jax --sort=uid,-ppid,+pid
                + - 代表增序和降序
                example: 按cpu时间排序 ps -aux --sort -pcpu
                example: 按内存使用排序 ps -aux --sort -pmem
                example: ps -aux --sort -pcpu,+pmem 多标准排序

k               与sort同等作用

-L pid          获取特定进程的所有线程

-jaxf           以树形显示进程

-eo             控制输出，可用来产看特定字段信息
                example: ps -eo pid,user,args 查看谁登录了你的机器

-m              在进程后面输出线程
```
上面这些只是基础知识，下面在补充一些：
**进程状态STAT代码**
```
               D    uninterruptible sleep (usually IO)
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads
                    do)
               +    is in the foreground process group


```

**-o 输出格式**
example： ps -eo "%p %y %x %c"
```

       CODE   NORMAL   HEADER
       %C     pcpu     %CPU
       %G     group    GROUP
       %P     ppid     PPID
       %U     user     USER
       %a     args     COMMAND
       %c     comm     COMMAND
       %g     rgroup   RGROUP
       %n     nice     NI
       %p     pid      PID
       %r     pgid     PGID
       %t     etime    ELAPSED
       %u     ruser    RUSER
       %x     time     TIME
       %y     tty      TTY
       %z     vsz      VSZ

```

## less
是一个文本查看器，`more`的升级版，且以vi命令为基础。
类似的命令有下面几个：
```
cat     由第一行开始显示内容，并将所有内容输出
 
tac     从最后一行倒序显示内容，并将所有内容输出
 
more    根据窗口大小，一页一页的现实文件内容
 
less    和more类似，但其优点可以往前翻页，而且进行可以搜索字符
 
head    只显示头几行
 
tail    只显示最后几行
 
nl      类似于cat -n，显示时输出行号
 
tailf   类似于tail -f

```
less 选项参数
```
-N      显示每行的行号

空格    向下翻页
d       向后翻半页
u       向前滚动半页
/       向下搜索
?       向上搜索
ma      使用 a 标记文本的当前位置
'a      导航到标记 a 处

```
文件参数有多个的时候可以打开多个文件，使用`:n`下一个文件，`:p`上一个文件。
也可以在less中`:e file` 打开新的文件。

## head
```
head -n 10 # 显示前10行
```

## tail
显示文件最后几行，最关键是当文件尾内容在增加的时候会在这里动态更新出来。
看示例你就明白用来做什么了。
```
tail -f xxx.log
```

## grep
这是个匹配命令，明天详细写。

## watch 
watch可以帮你监测一个命令的运行结果，周期性的执行下个程序
```
-n      间隔秒数，默认2s

-d      高亮发生变化的位置

-d=cumulative   将历史中变化过的地方都标记出来

-t 或-no-title  会关闭watch命令在顶部的时间间隔,命令，当前时间的输出。

```
**Example**
```
watch -d -n 1 netstat -ntlp

watch -n 1 ”df -i;df”  #监测磁盘inode和block数目变化情况

watch -n 60 -d du -ah # 查看usb3.0拷贝到该目录下面的速度

watch -n 1 ‘ps -aux --sort -pmem, -pcpu’ # 动态查看进程排序信息

watch -n 1 ‘ps -aux --sort -pmem, -pcpu | head 20’ # 动态查看前10名
```
