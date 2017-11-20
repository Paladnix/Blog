---
title: django template
date: 2017-11-20 23:00:21
tags: [Python, Django]
---

同许多前后端分离的开发模式相同，模板也是这样的前端的存在。

# 基本语法

在模板文件中，双括号包起来的是变量：`{{ title }}`。

使用`{% if is_weekend %}`，包起来的是代码块。这部分跟php的方式一样。不用多说了。

注释： `{# This is a comment #} `


## if 条件语句

在模板中，没有`elif`， 并且使用`endif`关闭`if`语句。
```
{% if athlete_list %}
    <p>Here are the athletes: {{ athlete_list }}.</p>
{% else %}
    <p>No athletes are available.</p>
    {% if coach_list %}
        <p>Here are the coaches: {{ coach_list }}.</p>
    {% endif %}
{% endif %}
```

## for
不支持`break` 和`continue`。

```
<ul>
{% for athlete in athlete_list %}
    <li>{{ athlete.name }}</li>
{% endfor %}
</ul>

```

{% for %}标签内置了一个forloop模板变量，这个变量含有一些属性可以提供给你一些关于循环的信息：

1. forloop.counter 表示循环的次数，它从1开始计数，第一次循环设为1.
2. forloop.counter0 类似于forloop.counter，但它是从0开始计数，第一次循环设为0
3. forloop.revcounter 表示循环中剩下的items数量，第一次循环时设为items总数，最后一次设为1
4. forloop.revcounter0 类似于forloop.revcounter，但它是表示的数量少一个，即最后一次循环时设为0
5. forloop.first 当第一次循环时值为True.
6. forloop.last当最后一次循环时值为True
7. forloop.parentloop在嵌套循环中表示父循环的forloop：


## ifequal / ifnoequal

两个参数，支持else。


## 过滤器 

跟命令行的管道一样。

# 在View中使用模板

在setting中有个字段定义了模板的位置：
```
TEMPLATE_DIRS = (  
    '/home/django/mysite/templates',  
)  

```

一种更灵活的，低耦合的方式：
`
import os.path

TEMPLATE_DIRS = (
    os.path.join(os.path.dirname(__file__), 'templates'),
)
`

在调用的时候，直接传入当前上下文中的变量，`locals()`。

```
 return render(request, 'problems/problem.html', locals())
```

# 模板的{% block %}

在页面的组织上，我们要分功能模块，一般我们会写一个`base.html` 的东西，然后在里面确定一些块，这些块会被其他的模板进行填充。

```
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">  
<html lang="en">  
<head>  
    <title>{% block title %}{% endblock %}</title>  
</head>  
<body>  
    <h1>My helpful timestamp site</h1>  
    {% block content %}{% endblock %}  
    {% block footer %}  
    <hr>  
    <p>Thanks for visiting my site.</p>  
    {% endblock %}  
</body>  
</html>  

```
这里我们使用了{% block %}模板标签，它告诉模板引擎一个子模板可能覆盖模板的这部分内容

使用其他模板进行填充成为完整的模板：
```
{% extends "base.html" %}  
  
{% block title %}The current time{% endblock %}  
  
{% block content %}  
<p>It is now {{ current_date }}.</p>  
{% endblock %}
```


