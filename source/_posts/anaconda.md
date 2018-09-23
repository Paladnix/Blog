---
title: Tutorial of anaconda & 原生虚环境
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
source activate nlpcc-1.0

# 离开当前环境
deactivate
```

#### 虚环境

很多时候如果是普通的工程开发的python项目conda并不能很好的找到需要包，所以还是要回到pip上来。但是依然有隔离生产环境的需求，因此就出现了虚环境。

虚环境通过一个第三方程序实现，其实非常简单，就是一个库的复制。

1. 安装
```
sudo pip install virtualenv

```

2. 创建虚环境
在任何文件夹下运行下面的命令就会产生一个对应的文件夹，关于这个环境的一切都在这里。
```
virtualenv my_project

# 在当前文件夹下创建一个文件夹，并把python拷贝一份。

# 可以在创建虚环境的时候制定使用的python的版本。

virtualenv -p /usr/bin/python2.7  my_project

```

3. 使用环境

首先就是激活一个环境
```
source my_project/bin/activate
```

此后安装的包都是安装在当前的环境中的，因此是完全隔离的。


结束使用该环境
```
deactivate
```

4. 删除一个环境就只要删除对应的文件夹即可。


#### 环境保持

往往在开发的时候，我们使用的某个库的版本并不一定会被后来的版本完全兼容，python中这太常见了。

因此为了方便我们在次还原环境，我们需要导出一份包的配置。

```
pip freeze > requirements.txt
```
这样就备份了一份，回头可以直接安装

```
pip install -r requirements.txt
```


#### 更优雅的管理虚环境

这个可以使用：`virtualenvwrapper`的包来实现。
