---
title: Django
date: 2017-07-06 12:56:56
tags: [python, Django, Web]
---

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

# Model

待续...

