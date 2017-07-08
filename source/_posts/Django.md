---
title: Django
date: 2017-07-06 12:56:56
tags: [python, Django, Web]
---

(注：本文写在N天之中，随着对其的深入学习，很多的看法会发生变化。我也尽量把东西放在这一篇中解决掉，文章思路会有些跳跃，可能先上了细节后面再归档等等。另外，本文会屏蔽一些技术细节，用一些术语来表达，这些术语均是较容易学习的知识块。)

这段时间神奇的技术走位，Java与Python的爱恨交织。

所以既然写到了肯定就是用到了呗，拿到了一个Django的项目，改写成Java的，玩的就是这么欢脱，做为一个写C++出身的入门级Java工程师生活已经如此艰难，然后发现现实是还要兼职Python工程师。

Django也算是工程师玩的玩意儿？封装成了这个样子还有什么好玩的，估计随随便便学2个小时语法加一点Django的框架设计就可以玩起来的，我只能说写这项目的哥们太会偷懒了，服气，骗完钱就离职，更是任性的不行。

言归正传！框架这种东西嘛，就是为了简化开发，提高速度效率，降低合作成本用的，所以django的设计也算是符合了这个目的。但是他并不是简单的照搬了JavaWeb框架的MVC设计思路，而是他妈的又提出了一个神奇的MTC，不用想也知道，就在人家的基础上变来变去还自以为参透了宇宙的奥秘。所谓的MTV就是把几个分工重新分了一下，对，就是要跟人家不一样，日你哥！

不过话回来，就算是对于MVC这个业界都普遍遵循的设计模式，也有很多不同的理解，比如业务逻辑到底该Controller来做还是Model来做，甚至还有人要把这个交给view来做的。之前貌似还看到了个文章讲什么官方设定，话说都发展到这个地步了谁还管你官方设定。不过呢，这都是个设计思路，不同的程序员当然有自己的理解，自己写项目的时候怎么搞都行，但是现在这框架数量真的有点爆炸了，所以大家还是在设计的时候多用点心吧，实现框架的技术不难，但是设计是艺术。

所谓的MTV分别就是： Model、Templete、View。熟悉就对了，你肯定一眼就看懂了，我也是一瞬间就明白了。但是很抱歉，仔细想一下这个Templete如果是前端模板的话，view是啥？如果view用来组装前端模板的话，要model来做业务逻辑吗？那controller岂不是没有了？……就是这么神奇，人家把业务逻辑交给了view来做，我特么也是佩服的吐血。Model就纯纯的数据库操作，就像是一个sql的python版。至于Templete，我已经没有耐心再跟他浪费时间了，老子一个写接口的要什么前端！

对于理解一个框架来说什么最重要？我在很久以前初学框架的时候一脸懵比。我草，这么多代码我得看到什么年？怎么连个主函数都没有，日了狗。。。好在我当时看了一会php，这个比较简单，不用编译一下就能懂，后来我从别人的文章中看到了学习框架的几个步骤等，才知道，看懂路由，就懂了这个框架的一半。

# 路由

提到这个路由，Python这个框架还是让我吃了一惊的。因为这玩意儿不需要容器，厉害啊。写过其他Web的都知道，我们的Web程序是要在一个Web服务程序的组织下做应答的。但是Django抛弃了这个服务程序，严格来说是Python的Web Server抛弃了其他的服务程序，自己写了一个简单的网关程序--wsgi。其实作用就是做个协议转换，链接机器与python程序，替代了apache2的一些基础功能。不过据说性能欠佳，做做测试还行，上线还是要靠Nginx的帮助，搞个uwsgi。

底层的东西，可以不懂，但是懂一定没有坏处，但是我还没时间搞懂。下面讲一下上层路由。

一个Django的项目特点就是目录比较清晰，比如这个urls.py就是存放路由信息的文件。django在自动化这个地方并没有做太多东西，对于路由信息要显示的写在这里。for一个zample.
```python
from django.conf.urls import url, include
from django.contrib import admin
import views

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^docs/', include('rest_framework_docs.urls')),
    url(r'^er/', views.ERView),

    # ui view
    url(r'^ui/Node', ui_views.node_view),
    url(r'^ui/Cluster', ui_views.cluster_view),
    url(r'^ui/InstanceGroup', ui_views.instance_group_view),
    url(r'^ui/Chart', ui_views.chart_view),
    url(r'^ui.*', ui_views.home_view),

    # API
    url(r'^v1/', include('rest_api.urls')),
    url(r'^v2/', include('rest_api.urls_v2')),
    #url(r'^report/', include('report.urls')),
    url(r'^.*', include('rest_framework_docs.urls')),
]
```
路由中可以预留参数位置，可以写正则表达式，论灵活性也还行。看到有些东西后买你跟的不是一个类，而是一个import语句，这是将路由转移到这个新的应用中去了，所以要去这个应用下再找对应的文件去继续路由，直到找到某个类为止。上面这个程序中其实是用到了一个叫`rest_framwork`的东西，这个玩意貌似是用来写网页文档用的东西，不过这个不是重点。

既然找到了这个类，那么有个经典的问题又来了。去调用那个函数啊？这就涉及到了django路由的两种方式，一种是定义到函数，另一种是调用到类。一把小项目就自己定义到函数就好了。但是当项目比较大的时候就需要将路由定义到类的身上，注意这里我们说的都是在views.py 中的类。

对于基类View，其暴露了一个as\_view()的函数，该函数会对请求进一步做分发。下面两个就是这种方式路由的。
```python
    url(r'^Unit/(?P<pk>\w+)', UnitDetailView.as_view(), name='UnitDetail'),
    url(r'^Unit', UnitView.as_view(), name='Unit'),
```

as\_view() 是如何做分发的呢？它会调用一个dispatch函数对请求方式做个路由出去再调用到你真正的处理函数。总是很麻烦，还没来得及看代码。
不过这里有一个简化的另外一个类，继承的时候继承`Generic.View`， 这是一个系列类， 有很多。用的时候就在处理类中写固定的函数就好了。在View的部分再细说。

# 从安装到Hello World

1. 安装python
2. 安装pip
3. 安装django

找到一个目录来存放你的站点，然后执行命令创建目录：
```bash
django-admin startproject mysite
```
在目录中出现站点的目录，进入发现有一个`manage.py`的文件和一个目录。
目录结构如下：
```bash
mysite/
    manage.py
    mysite/
        __init__.py
        settings.py
        urls.py
        wsgi.py
```
- manage.py 是这个项目的命令行工具，与`django-admin`相似。
- mysite/ 这个文件夹的名字是不能随便更改的，因为这就是包的名字。
- settings.py 就是这个项目的所有设置
- urls.py 就是你自己设计的路由
- wsgi.py 这是事实上的Server入口

然后命令启动这个Web Server就可以了：
```bash
python3 manage.py runserver
```
一般我会给个manage.py运行权限，将首行的python改成python3, 这样看你的django装在了那个版本下面。
运行起来去看8000端口就可以了。这个页面写的还是挺好的，内容不多，但是有一些提示很有人性化。

至此一个项目就算是建成了，但是这里的项目跟其他我们说的项目不太一样，就是个空壳子，往里面塞的事实上我们称之为app。

添加一个app：(在manage.py 同级的目录下执行下列命令，以使app作为独立模块使用而不是子模块)
```bash
python3 manage.py startapp polls 
# 建立一个名为polls的app
```
然后还是来看目录结构：
```bash
polls/
    __init__.py
    admin.py
    apps.py
    migrations/
        __init__.py
    models.py
    tests.py
    views.py
```
- models.py 数据库相关
- views.py 业务逻辑相关

现在我们写一个简单的view，并组装好路由信息，让网站跑起来。
1. 编写views.py 如下：
    ```python
        from django.shortcuts import render
        from django.http import HttpResponse

        # Create your views here.

        def index(request):
            return HttpResponse("Hello World. This is polls app.")
    ```
2. 新增一个urls.py 文件在polls文件夹下，并添加路由信息如下：
    ```python
        #!/usr/bin/env python3
        # coding=utf-8

        from django.conf.urls import url
        from . import views

        urlpatterns =[
            url(r'^$', views.index, name="index"),
        ]
    ```
3. 在mysite目录的urls.py 新增polls的路由信息：
    ```python
        from django.conf.urls import include, url
        from django.contrib import admin

        urlpatterns = [
        url(r'^polls/', include('polls.urls')),
        url(r'^admin/', admin.site.urls),
        ]

    ```
4. runserver

### tips
在mysite的路由中，我们没有加正则结束符`$`,且使用include可以将polls内部独立成一个模块，无论polls在哪里都没关系。

在url中可以添加参数进行访问，在使用到的时候补充这部分例子。

# Model
python在这个方面简直方便的没有人性。我倾向于理解其是用python对象对数据表加以描述，并且！自动生成一个管理中心。可以直接使用python进行数据库交互。更方便的是，如果你对数据库操作很生疏，sql语句使用的不熟练，python自己集成了sqlLite这个玩意，你可以单纯使用python进行数据处理而不需要担心数据持久化的事情。当然你也可以自己搭建好数据库，并在配置中配置你所使用的数据库。

下面就来建立model。编辑polls/models.py代码：
```python
from django.db import models

# Create your models here.
class Question(models.Model):
    queston_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    def __str__(self):
        return self.question_text

class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __str__(self):
        return self.choice_text

```
官方是这样解释的：The code is straightforward. 代码已经很直观了。除了基本的字段，还有一个函数，这个函数一看就是默认的函数，用来字符串化这个model的。也就是说，当你输出这个类的实例的时候，输出什么东西，就是这个函数来决定的。

现在我们只是写了两个类，当然一个类就对应着一个数据表。我们需要手动建立这些表并生成交互接口。下面我们要将polls这个app，install到这个项目中，在mysite的settings.py中添加install项：
```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'polls.apps.PollsConfig',
]

```
然后我们执行下面的命令：
```bash
python3 manage.py makemigrations polls
```
这个时候就完成了建表的任务。这个命令就是专用model操作的。然后使用下面这个命令可以显示出被执行的sql语句：(后面的0001根据执行返回值确定)
```bash
python manage.py sqlmigrate polls 0001
```
然后我们执行以下命令来使我们的变更生效：
```bash
python3 manage.py migrate
```
以上都不是关键，关键是其自动化数据库交互的部分, 在官方文档称之为database API。

其主要思想就是面向对象的概念，将数据表抽象成为一个对象，对这个对象提供了一些增删改查的函数。直接show you the code
```python
from django.utils import timezone
from polls.models import Question, Choice

# 查询Question表中数据
Question.objects.all()

# 创建一条数据并存入数据表， 注意q是一个记录对象，只是一条记录。
q = Question(question_text="What's new?", pub_date=timezone.now())
q.save()

# 获取字段值
q.id
q.question_text

# 更改字段值并保存
q.question_text = "what's your name?"
q.save()

# 获取记录
q = Question.objects.filter(id=1)
q = Question.objects.get(id=1)
# 这两个之间的区别还是有的，暂时没有深究
```
更多操作待补充，继续往下走...

(Django 自动生成了一个admin的操作页面， 使用下列命令生成用户就可以使用了)：
```bash
python3 manage.py createsuperuser
```
然后在url后加/admin/就可以进去了。


# settings

待续...

