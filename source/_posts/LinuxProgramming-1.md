---
title: 《Linux 编程实践教程》- 1
date: 2018-01-02 16:15:13
tags: [Linux, C]
---

2018年恢复写博客的第一篇博客。

「·最近在看书，主要是Linux相关的书，尽管即将要进行NLP的研究生阶段，但是回首自己的本科计算机编程经历其实非常浅薄。这两年的积淀在常用算法和数据结构上有一些，在一些基础理论上有一些，但是距离成为一个程序员还有很大的距离。综合各种因素，我选择将Linux学习更透彻作为程序员的落脚点。这是我作为程序员的自我修养。·」

## 关于这本书

这是一本Linux的基础教材，2004翻译过来的。但是国内貌似很少用，作为了课外读物。

这本书的落脚点是编程实践。其中贯穿着Linux的一些原理和使用，以及编程思维。

包括：用户，文件系统，连接，事件驱动，进程通信，多线程，服务，协议等。以Linux的一些已经实现的功能为基础，进行讲解，再实现。
会涉及很多的编程细节的东西，这是上课不会讲到的。都非常的有意思。做到“知其然，知其所以然”。


## 本书的风格和套路

此书适合初学者，但是任何初学者的书都不是完全适合初学者， 有很多概念和细节都需要读者有些了解才能更好读懂。
我在读本书之前的一天读了一部分《Linux系统编程》。这是一个偏底层概念和细节的书，主要在文件系统，I/O，进程，内存，信号，时间上去为Linux系统编程打细节基础，看起来没那么有趣，因为细节太多，但是确实把文件和I/O的概念给我打通了。
有了这些基础再看本书的第一章，并实现其中的more实例就省力很多。此前一个月左右我看过这一章，但是在写代码的时候还是非常不能理解一些细节。

书中会给出全部的实现，但是并不是完整功能的实现，是一部分功能的完整实现。并将剩下的一些功能的实现作为扩展的作业。
在给出实现的时候，会讲相关的基础知识。

比如在第二章讲`Who`命令的时候，会先告诉你man命令怎么用，以及文档各个部分是什么，怎么去看相关条目，从man手册的那些部分获得什么信息等。

## 第一章：more命令的实现

more命令比较简单的功能就是把文件的内容投射到终端上，并且可以向下翻页或翻行。要能从文件中读取也可以从管道中读取内容。

在Linux一切皆文件的设计理念下，要知道各种I/O都可以作为文件来使用，也就是可以用打开文件的方式来打开。无论是文件、管道、设备(键盘)、重定向数据，都可以作为文件来打开读取。

那么实现这样的功能就没有那么困难了。
整体逻辑就是：
1. 打开文件
2. 读取一定的行数
3. 提示翻页或下一行，接受键盘动作
4. 作出反应，重复。

代码中用到了终端设置接口`termios.h`，让用户输入的操作不被显示，不用回车，直接进入程序。
用到了与终端用文件交互的方式`tty`。


### Code

```C++
#include <bits/stdc++.h>
#include <unistd.h>
#include <termios.h>
using namespace std;

const int PAGELEN = 24;
const int LINELEN = 512;


int see_more(FILE * cmd){
    int c;
    printf("\033[7m more? \033[m");             // 白色底色
    while( (c = getc(cmd)) != EOF ){
        if( c == 'q' ){
            return 0;
        }
        else if( c == ' ' )
            return PAGELEN;
        else if(c == '\n'){
            return 1;
        }
    }
    return 0;
}

void do_more( FILE * fp ){
    char line[LINELEN];
    int num_of_lines = 0;

    FILE * fp_tty = fopen("/dev/tty", "r");         // 一切皆文件，这个文件标志就是与终端交互。

    struct termios initial_settings, new_settings;
    tcgetattr(fileno(fp_tty), &initial_settings);
    new_settings = initial_settings;
    // clflag 局部模式，只在本程序中有效。
    new_settings.c_lflag &= ~ICANON;        // 关闭标准模式， 不允许使用特殊字符 EOF, EOL, EOL2, ERASE, KILL, LNEXT, REPRINT, STATUS, 和 WERASE，以及按行的缓冲。  
    new_settings.c_lflag &= ~ECHO;          // 输入字符不回显
    new_settings.c_cc[VMIN] = 1;            // VMIN :非 canonical 模式读的最小字符数（MIN主要是表示能满足read的最小字元数）。  
    new_settings.c_cc[VTIME] = 0;           // VTIME ：非 canonical 模式读时的延时，以十分之一秒为单位。 
    new_settings.c_lflag &= ~ISIG;          // 当接受到字符 INTR, QUIT, SUSP, 或 DSUSP 时，不产生相应的信号。

    if(tcsetattr(fileno(fp_tty), TCSANOW, &new_settings) != 0)
    {
        fprintf(stderr, "Could not set attributes\n");
    }

    if(fp_tty == NULL ) {
        exit(1);
    }
    int reply;
    while(fgets(line, LINELEN, fp)){
        if(num_of_lines == PAGELEN){
            reply = see_more(fp_tty);
            if( reply == 0 )
                break;
            num_of_lines -= reply;
        }
        if( fputs(line, stdout) == EOF){
            exit(1);
        }
        num_of_lines ++;
    }
    tcsetattr(fileno(fp_tty), TCSANOW, &initial_settings); 
}


int main(int ac, char * av[]){
    FILE * fp;
    if( ac == 1 )
        do_more(stdin);             // 一切皆文件，标准IO也是文件。
    else {
        while( -- ac ) {
            if( (fp = fopen(* ++ av, "r")) != NULL ){
                do_more (fp);
                fclose(fp);
            }
            else 
                exit (1);
        }
    }
    return 0;
}

```

### 更多功能

完整的还有：
获取文件大小，行数，当前行数，百分比。
终端的行数。
more的提示不要跟着上移，要停留在底部。

待完善。
