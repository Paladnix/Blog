---
title: Husky - A Light Web MVC Framework
date: 2017-05-17 21:56:06
tags: [PHP, WEB, MVC]
categories: PHP
---

这篇文章是对我自己编写的`PHP MVC` 框架：`Husky` 的详细说明， 算作是官方说明文档。

项目的[GitHub地址](https://github.com/Paladnix/Husky)

## Husky是什么？

`Husky` 是一个使用`PHP`语言编写的Web MVC微框架，此项目最初是作者偶然看到的一篇[博客](https://github.com/yeszao/fastphp)中的教学项目。我对项目的代码进行了一些修改和整理，删除了一些不必要的内容，添加了部分设计，目前框架处于第一个版本(Husky-0.9)，框架将会长期维护更新。目前只在Linux开发环境下测试可用。

如果你是一个初出茅庐的Web开发者，那么本框架就十分适合你来使用了。相比较很多成熟的PHP框架来说，Husky的体积小，逻辑简单，还没有加入很多集成的自动化功能。整个框架按照一个既定的数据格式实现了MVC开发的需求，更主要的是，在一定程度上说，这个框架还处于比较原始的状态， 这对新手深入了解框架的体系结构十分有利，你可以按照自己的想法对框架进行修改，甚至可能在此基础上改写出更出色的框架。

本框架的开发初衷是为作者所在的学生社团开发网站，多人合作模式下编写网站没有一个框架实在太乱了。但是衡量工作内容，于是决定自己开发一个微框架来辅助网站的开发，就有了这个项目。

## 你需要掌握什么？

此框架需要一定的php网站开发经验才能熟练的使用。所以在使用之前，你需要具备以下的知识或能力:
- 配置apache2 的Rewrite功能
- 数据库SQL语句
- php基本语法
- 面向对象编程的基本知识
- 简要了解http协议与请求url链接
- 清楚的了解软件 MVC 架构的组成

在进一步开发框架之前，你需要进一步具备以下的知识或能力:

- apache2 的更多配置选项
- 熟练掌握http协议
- 深入理解 MVC 框架结构
- 熟练使用php语言进行面向对象编程
- 熟练使用PDO数据库操作库
- 良好的编程习惯

## Husky 做了什么？

Husky 实现了下面几个功能：
1. 唯一的网站入口，url地址重定向
2. 自动化加载MVC控制类，自动化解决类间依赖
3. 过滤SQL注入攻击的安全问题， 使用PDO进行数据库操作
4. Controller、Model、View模块分离
5. 定义数据参数等的格式

## 配置环境

框架需要软件环境：
- Linux
- apache2
- php(>=5.4)
- mysql


### 开启apache2 rewrite 功能

默认的Ubuntu apache2是没有开启这个功能的，要先去看一下 `/etc/apache2/mods-enabled/` 文件夹下是否存在`rewrite.load` 模块的链接，如果没有，要去看一下  `/etc/apache2/mods-available/` 中是否存在对应的文件，如果有，则使用下面的命令建立一个链接到 `../mods-enabled/` 文件夹下：

```bash
$ ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
```

旧版本的`apache2`需要修改`httpd.conf` 文件中的`AllowOverride None` 修改为 `AllowOverride All`

如果是新版本的`apache2`需要修改`/etc/apache2/apache2.conf` 中的 `AllowOverride None` 修改为 `AllowOverride All`, 同时看一下 `AccessFileName` 为 `.htaccess` ;

### download code 
准备好环境以后，下载该项目的代码包到你本地的文件夹 `eg: project/` 中。注意请将代码包中所有的文件放置在 `project/` 文件夹下，并检查隐藏文件`.htaccess`是否存在，如不存在请到Github上下载下来并放置在 `project/` 目录下。

此时项目中默认会存在一个本教程的某个版本，直接在浏览器的地址栏输入:`localhost/project/(如果你的project/文件夹不在localhost的目录下请移至localhost/)`。此时如果你看到了本教程的某个版本的网页，则除数据库部分的环境配置成功，否则请检查软件是否安装，`apache2`的`Rewrite`功能是否已经打开。

## 开始编写代码

下载下来的框架带有一个项目的目录结构，我们不需要变动。但是需要说明一下目录的结构和用途：
```bash
project/
    \__ application/
            \__ controllers/
            \__ models/
            \__ views/
    \__ config/
            \__ config.php
    \__ PHP_MVC/
            \__ phpmvc.php
            \__ Core.class.php
            \__ Model.class.php
            \__ Sql.class.php
            \__ View.class.php
            \__ Controller.class.php
            \__ Model.class.php
    \__ runtime/
    \__ sql/
    \__ css/
    \__ js/
    \__ fonts/
    \__ images/
    \__ index.php
    \__ .htaccess
    
```


- `application/`文件夹内放置的就是整个网站即将开发的MVC部分的代码，基本上整个网站代码都会在这里。
- `config/`放置整个网站的配置信息，包括数据库的密码、用户名等。
- `PHP_MVC`是整个框架的核心代码，也包含了框架的基类，其余的代码都继承自这里的基类。
- `runtime/`存放网站运行过程中的log日志文件和错误记录。
- `sql/`做为开发过程中存放网站的数据库文件。
- `index.php`是整个网站的唯一入口，已经重定向过来，在其中有两个宏定义：`APP_DEBUG`和`APP_DEBUG_FRA`分别用于网站开发时错误检测和框架开发时的错误检测。网站发布时需要将两个宏全部关闭。
- `.htaccess`是网站url重定向文件


### 代码风格

框架的整体采用Java代码风格，命名规则上也大部分借鉴Java命名规则。

- MySQL表名， 小驼峰命名法 `testTable`
- 类名(Class)， 大驼峰命名法：`Sql`
- 方法名(Actions)， 小驼峰命名法：`index`, `indexPost`
- 模块名(Models)， 大驼峰命名法， 后缀Model： `TestModel`
- 控制器(Controllers)， 大驼峰命名法，后缀Controller： `TestController`
- 视图(Views)， 控制器名/行为名： `TestView`


### Controller 

```php
 
/*
 *  php 代码： /application/controllers/TestController.class.php
 *   
 */
 
class TestController extends Controller{
 
    /* 
     *  当 url 为：localhost/project/test/ 或 localhost/project/text/index/ 时调用该函数 
     * 
     *  index 可以做为默认打开页面时的处理函数，
     *  不写则默认调用父类的index函数，直接渲染页面。
     *  该函数接受一个字符串数组参数 如：$params , 该字符串是url中的参数，数组中每个元素形如： id=2 ；
     *  每组参数使用 'name=value' 的形式存储。
     *  assign() 函数可以将键值对存储进视图模块中，交由视图模块进一步处理。
     *  render() 函数渲染视图，调用视图模块的函数进行渲染。 可以写一个参数用来标志：action
     */
 
    public function index( $params ){
 
        $content = (new TestModel)->selectAll();
 
        $this->assign('title', '全部条目');
 
        $this->assign('content', $content);
 
        $this->_view->render("index");
    }
 
 
 
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     * * * 当 url 为：localhost/project/test/add/ 时调用该函数 * *
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
     *   同样也可以带参数
     */
 
    public function add( $params ){
 
        $data['name'] = $_POST['value'];
 
        $count = (new TestModel)->add($data);
 
        $this->assign('title', '添加成功');
        $this->assign('count', $count);
        
        $this->_view->render("add");
    }
 
}

```


### View

```php
/* 
 *	php 代码： /application/views/TestView.class.php
 */
     
class TestView extends View{
 
    /*
     *   对于不同的函数可以编写不同的前端组件，重写render函数按需加载组件
     *   
     *   此类对应上面的 TestController		
     *
     */ 
 
    public function render( $action="index" ){
    	
    	if($action == "index"){
    		$this->index(); return ;
    	}
    	else if($action == "add"){
    		$this->add(); return ;
    	}
    	
    }
    
    public function index( ){
    	
    	$pages[] = APP_PATH."/application/views/Index/header.php";
    	$pages[] = APP_PATH."/application/views/Index/body.php";
    	$pages[] = APP_PATH."/application/views/Index/footer.php";
    	
    	foreach( $pages as $page) $this->page($page);
    }
 
 	public function add( ){
    	
    	$pages[] = APP_PATH."/application/views/Index/header.php";
    	$pages[] = APP_PATH."/application/views/Index/add.php";
    	$pages[] = APP_PATH."/application/views/Index/footer.php";
    	
    	foreach( $pages as $page) $this->page($page);
    }
}

```


### Model

```php
 
/*
 *  php 代码： /application/models/TestModel.class.php
 */
 
 
 /*
 
 
 	$this->formatInsert($data) : 接受一个键值对数组，将其格式化为：键='值' ， 键='值' 的字符串， 如果对应字段为整形数，则没有引号
 
 	$this->formatWhere($data) : 键值对 -> 字符串，
 	
 	$this->formatUpdate($data) : 键值对 -> 字符串，
 
 	$this->selectSQL($sql) : 执行$sql 语句，并返回二维数组做为结果。
 	
 	$this->querySQL($sql) : 执行$sql 语句，返回被影响的行数。

 */
 
 
class TestModel extends Model{
 
     /*  例如需要将数据库中所有的记录都提取出来并返回一个二维数组记录所有的数据 
      *
      */  
 
    public function selectAll(){
 
        $sql = sprintf("select * from `%s` ", $this->_table);
 
        return $this->selectSQL($sql);
    }
 
 
    /*  如果要插入记录到数据库中，则将键值对存在 $data 中 
     *  query函数将返回受影响的行数
     */
 
    public function insert( $data ){
 
        $sql = sprintf( "insert into `%s` %s", $this->_table, $this->formatInsert($data) );
 
        return $this->querySQL($sql);
    }
 
}

```






