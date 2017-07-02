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

在安装这个的时候卡了很久，然后才知道自己装的是Node.js, 然而需要的是Node！正确的结果是在命令行输入`node -v` 如果可以看到版本号就可以了。
正确的安装命令是：`sudo apt install nodejs-legacy`，害怕。。。就是有这样的操作，当你install nodejs的时候，对不起，这个并不是你要的node.js， 哈，我也很绝望啊！

然后要安装一下这个npm工具：
```bash
$ sudo apt install npm
$ npm -v        #看npm版本，如果结果显示版本号则安装成功
```

### 安装git
```bash
$ sudo apt install git 
```
有的时候在安装完git后依旧在项目中无法使用，后面发布博客到github上面的时候会使用到git，如果报错：`Deploy not found git` 之类的，就需要再搞一下这个玩意儿！这就是软件版本混乱的锅，想说爱你不容易！

```bash
$ npm install hexo-deployer-git
```

### 安装Hexo

```bash
$ npm install hexo-cli -g
```
当然这个在安装的时候也有坑出现各种问题，那就只好去百度了，我是因为前面的东西出问题后来修好后就好了。一般也不会有啥问题了。

## 使用

其使用逻辑非常简单而且封装很好，命令操作也十分简洁，重点在于配置文件的修改。这是个强配置的框架，事实上好的框架就应该这样，甚至可以将软件由不懂程序设计的人来使用，但是前提得有一个个很清晰的配置文件设计思路以及详细的说明书……

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


## 多机同步

换了公司的电脑再带着自己的电脑写博客有点太low了，最好的方式当然是无牵无挂，有网就能玩的状态，所以就需要多机同步。很自然就想到了github嘛，之前发布的时候是将生成的静态网页发布了github上，但是你的工程源文件并没有同步上去，所以要做的就是将工程文件也搞上去。然后就有两个思路：1. 在io那个仓库新建一个分支，然后把源代码搞到新分支上去。2. 搞个新的仓库，单独放工程源文件。

由于我的github操作水平有限，在尝试新分支的时候总是出错，所以我就选择了另一种简单粗暴的方式。

首先在本地初始化建仓库, 在github上建一个仓库，关联起来
```bash
$ git init
$ git add .
$ git commit -m 'init'
$ git push origin master
```
其实就是跟普通建仓库一样的。。。有些东西没有写，其实默认应该是会的，就是添加新机器的ssh\_key到github上，`ssh-keygen -t rsa -C "你的邮箱地址"`，然后复制`~/.ssh/id_rsa.pub` 到github上就可以了。
不过我在网桑看到了有人将文件夹下的`.gitignore`文件追加了两行：`/deploy_git` 和 `/public` 。如果你直接建仓失败了就这样搞试试。

然后就是在另一台机器上，现在本地建起hexo的工作区，然后同步数据过来就好了。

```bash
$ git init
$ git remote add origin <url>
$ git fetch --all
$ git reset --hard origin/master
```

这样就同步好了，接下来每次更新博客流程如下:

```bash
$ git pull
$ hexo new XXX
$ hexo g
$ hexo d
$ git add .
$ git commit -m 'xx'
$ git push origin master
```


搞起来感觉有点麻烦，因为用的是Node这个体系，不熟悉。
