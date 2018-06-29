---
title: Tutorial of Taskwarrior
date: 2018-03-13 13:45:32
tags: [Tools, Linux]
---

[Taskwarrior](https://taskwarrior.org/) 是一款命令行的TODO应用，功能强大，且使用逻辑简单方便，命令行的操作非常适合程序员。
（基本上能在命令行解决的问题就不要用GUI， 能用键盘解决的就不要用鼠标。）

目前我使用到的功能有：

* 添加task
* 给task修改所属的project、截至日期
* 更改task的状态，如：start、done
* 修改task的priority
* 添加tags给task
* 给task添加task依赖关系
* ...

## 基本使用

* 添加 task
```bash
task add xxxx [project:xxx] [priority:xx] [due:xx]
```

* 修改task状态
```bash
task ID start

task ID done
```

* 修改task信息
    ```bash
    task ID modify [project:xx] [due:xx] [priority:xx]
    ```
    其中`due`常用的选项有：
    * eom : end of month

* 添加tags
```bash
task ID modify +house +problem
```
其中有个特殊的tag是：`next`， 这回提升这个task的优先级。
```bash
task ID modify +next
```

* 添加依赖关系
```bash
task ID modify depends:OTHER_ID
```

## 命令格式

> task [filter] [command] [modifications | miscellaneous]

如果将Task比作一个类，可以把每个task都理解成一个实例。我们将实例存储在一个文件中，task就是用来处理这个文件的改动、信息筛选的命令。

- filter-筛选器
通过一些条件，筛选出我们每次操作的对象。
```bash
# 筛选所有pending的task，并计数
#
task status:pending count

# 筛选所有tag是work的，并计数
#
task +work count

# 筛选所有tag不包含work的，并计数
#
task -work count
```
如果有多个条件，可以使`and`、`or`来进行连接
```bash
task project:home -work count

# the same to 
task project:home and -work count
```

(待续...)
## 配色
## calendar
## burndown
## timewarrior

## Reference

[1]. [taskwarrior Docs](https://taskwarrior.org/docs/)
[2]. [laserx's Blog](https://laserx.github.io/2017/05/17/taskwarrior-and-trello/)



