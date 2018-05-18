---
title: 编写Bash脚本
tags:
  - Bash
  - Linux
  - Shell
date: 2018-05-18 15:45:40
---


作为一个Linux用户，不会自己写Bash脚本，简直太讽刺了，跟windows用户有什么区别，用鼠标点一点。
使用Bash脚本来解放生产力非常重要。不要做重复性的无意义的劳动。

## Bash 脚本头（shebang）

这个东西汉语里叫"蛇棒"，难听。
以`#!` 开头的，在没有指定解释器的情况下，使用后面路径的解释器运行。

常用的bash命令解释器： `#! /bin/bash`


## Command arguments

| Variables | About | Example |
|:-|:-|:-:|
| $# | The number of arguments. | while [[ $# -gt 0 ]] do ... done |
| $1 | The first argument. | echo "$1"; KEY="$1" |
| $@ | All arguments as a list. | for i in "$@" |
| shift | Past one string of commands that splited by space. | shift # one line | 
