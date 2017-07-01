---
title: Hexo
date: 2017-05-28 14:24:05
tags: [Blog, Github]
---

这是一个经济又快速又好看的博客搭建教程。

你的博客将会有一个后缀为github.io的域名，并且在该域名下有300M的存储空间。但是，本教程只写给Linux用户，其他用户参考自行摸索，原理一致，操作类似。

你看到的我的这篇博客就是最后的效果，当然你也可以自行修改样式。

博客使用Hexo博客生成系统，其优点如下：
1. 简单快速，无需服务器端架设环境。
2. 可选样式众多，易于修改。
3. 扩展插件众多，且使用方便。
4. 使用markdown语法编写博客，易于上手。
5. 生成博客为纯静态代码，无需运行环境可直接移植，不依赖数据库。

## 本机环境的准备

你需要以下几个软件的环境：
1. Node.js
2. Git
3. Hexo

### 安装node.js
```bash
$ sudo apt install npm
$ npm -v        #看npm版本，如果结果显示版本号则安装成功
```

### 安装git
```bash
$ sudo apt install git 
```

### 安装Hexo

```bash
$ npm install hexo-cli -g
```


## 使用

其使用逻辑非常简单而且封装很好，命令操作也十分简洁，重点在于配置文件的修改。
### 建立工作区
```bash
$ hexo init Blog
$ cd Blog
```
### 新建一篇博文
在Blog文件夹内执行：
```bash
$ hexo new 文件名(不加后缀)
$ hexo new Hello
```
此时新建了一个文件在`source/_posts/Hello.md`， 打开文件即可编写内容，内容使用markdown语法。
事实上在第一次初始化博客的时候其中带有一篇示例博文，与你新建的这个文件在同一目录下。你可以先不着急编写文章，先来看一下默认文章的效果。

### 本地启动服务
```bash
$ hexo server
```
随后你在本地浏览器输入`localhost:4000` 应该就可以看到你的博客。如果你的`4000`端口被占，请参照命令给出的提示信息操作。

### 部署到Github.io
在讲这个之前必须要说一下，配置文件的使用和Github Page的用法。

## Github Page
Github提供了这样一个服务，可以做项目的说明博客等，也可以用来做个人主页。

首先你要在Github上有一个帐号，然后新建一个repository，项目名称必须为`YourUserName.github.io`。然后你需要在此项目下上传纯静态网页代码。之后可以使用`https://YourUserName.github.io`来访问这个站点。

上传代码这件事当然是Hexo一个命令搞定，生成代码也是一个命令搞定，所以不用担心，先来看如何配置Hexo

## 配置

配置文件路径：`Blog/_comfig.yml`
打开并修改其中如下几个必要的信息：

1. `title` ： 更改为你博客的标题，就是你风骚的昵称。
2. `author`： 更改为你喜欢的你的代号。
3.    `url`： 未来你博客的地址。
4.   `root`:  这个十分重要，就是你项目所在的文件夹的名称（如果你选择使用github page做站点，就写`YourUserName.github.io`， 如果你选择使用自己的服务器来做站点，就写你服务器上存放代码的文件夹名称，你会用`YourIP/YourRoot`的方式来访问，所以你应该知道填写什么了吧）。
5. `#Directory`：块下的几行你可以全部打开，但是其中的某些东西需要进一步配置。
6.  `theme`： 你可以选择你喜欢的主题，[更多主题](https://hexo.io/themes/)，每个主题都有其自己的详细说明，不再赘述。
7. `deploy`： `type: git`, `repo: git@github.com:YourUserName/YourUserName.github.io.git`, `branch: master`。这个配置的就是上传部署的目标地址。也就是你的Github Page 的项目地址。

好了，以上配置做好后就可以尝试第一次上传了。

### 上传部署
```bash
$ hexo clean    # 清除之前生成的文件
$ hexo g        # 生成博客文件
$ hexo d        # 部署到`deploy`的目的地址。
```
然后你可以尝试使用`https://YourUserName.github.io` 来访问你的博客了。

你也可以选择在本地测试，使用上面提到的 `本地启动服务` 即可。

### 主题

主题非常多，你可以选择你喜欢的主题，并到其详细说明中寻找安装、使用和修改的方法。
每个主题都有自己的配置文件，且配置文件的格式是统一的，所以很方便。

本博客使用的主题为[Next](https://github.com/iissnan/hexo-theme-next)。

一些人气颇高的主题会有自己的官方网站，上面有更多插件的使用。如果有时间，我会补充该部分内容到该文章中。如果你对此做了整理，我也很乐意讲你的成果添加到本文的附录中。

Thanks.
