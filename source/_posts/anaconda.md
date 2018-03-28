---
title: Tutorial of anaconda
tags:
  - Python
date: 2018-03-28 17:31:19
---


# 什么是conda？

anaconda是一个用于科学计算的python发行版。其中预置了一些用于科学计算的库，诸如`numpy`等。

并且包含一个包管理系统，可以方便的安装相关的库。

我使用conda主要是搭建机器学习的环境。

# Install

在conda的download页面找适合自己的安装包下载，在Ubuntu上会得到一个bash脚本文件。
也可以使用命令：
```bash

wget https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh
```

然后使用root权限运行就可以了。
在运行的过程中，会询问你一些设置方案，如安装的路径、是否要添加进入PATH等。

## 检查是否安装成功

使用命令：
```bash

python -V
```
出现：
```bash
Python 2.7.14 :: Anaconda, Inc.
```
说明安装成功

# 使用conda创建自己的开发环境

学过python的都知道，py的版本兼容实在太随意了。因此py为了解决同一台电脑上需要不同py环境的问题，设计了一个虚环境。也就是我们可以创建一个虚环境，然后进入这个虚环境安装我们需要的包，这些包的作用范围就是在这个环境中。

因此也就实现了环境隔离。
一般我们在开始一个开发的时候，都会先创建一个虚环境。

## 使用conda创建tenserflow训练环境

```bash
# 创建名为:nlpcc-1.0 的虚环境
# 指定python版本为2.7, tensorflow版本为1.0的gpu版，
# 需要安装anaconda
conda create -n nlpcc-1.0 -c anaconda tensorflow-gpu=1.0 python=2.7

# 为当前环境安装包
conda install numpy

# 升级包的版本
conda update numpy

# 删除包
conda remove numpy


# 列出当前环境的包
conda list

# 删除一个环境
conda remove --name nlpcc-1.0 --all

# 进入一个环境
activate nlpcc-1.0

# 离开当前环境
deactivate
```

