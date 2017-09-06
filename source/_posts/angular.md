---
title: angular
date: 2017-07-31 17:32:01
tags: [Web, Front]
---

Angularjs 和Angular2 的区别，就像雷锋和雷峰塔的区别。
笑尿了。

我是跟着它的官方文档学习的，文档还是比较健全的，也很细致。地址：[Quick Start](npm install -g @angular/cli)

## AngularJS 与 Angular2

关于二者的区别，可以肯定的是angular2一定更好。

在细节上，先来说一下angular的特别之处。

其诞生于09年，提出了双向绑定等新特性的概念使得它一出现就被追捧。然而由于09年移动端还没有大规模出现，所以其不支持移动应用的使用。并且其数据绑定使用的是扫描的方式，性能瓶颈很难突破，所以被更适应时代的angular2代替是历史的必然。

所以angular2就拥有了这些它的小弟做的不好的特性。
性能快，支持移动应用开发等。其实现的方式也有很大的区别，所以就出现了雷锋和雷锋塔的区别。

## 直接来学习angular2的使用

首先在什么都不懂的时候先来构建一个实例应用打个招呼：

以下的部分需要：node 6.9.x and npm 3.x.x 及以上。这部分可以去看我的node相关的文章。

**Step 1. Install the Angular CLI globally.**
```
npm install -g @angular/cli

```
**Step 2. Create a new project**
```
ng new my-app
```
**Step 3: Serve the application**
```
cd my-app
ng serve --open

```

你可以看到效果，现在我们来看文件目录。

你的应用需要的内容都在`src`文件夹中。其他的文件都是用来支撑这个应用的框架代码。下面我们看一下`src`文件夹的结构：

### src

| File | Purpose |
|------|:---------|
|app/app.component.{ts,html,css,spec.ts} | 定义组件。HTML模板，CSS，Unit Test。这是一个root组件 |
|app/app.module.ts | 声明应用如何装配 |
| assets/ | 静态资源 |
| environments/ | 存放你应用在不同环境下的配置文件。例如在开发环境还是在发布环境 |
| index.html | 入口，也是你经常要编辑的文件，angular默认加载所有的js和css，所以不需要写任何的`<script>`和`<link>` |
| main.ts | 应用的主要入口，你可以用just-in-time编译模式或者ahead-in-time模式进行调试开发。|
| polyfills.ts | 不同浏览器支持的文件 |
| style.css | 全局的样式，对所有的应用都起作用的 |
| test.ts | 单元测试的入口， 你貌似并不需要编辑这个文件 |
| tsconfig.{app|spec}.json | TypeScript compiler 配置文件，for Angular app and unit tests |

### 其他目录

| File | Purpose |
|:-----|:--------|
| `e2e` | end-to-end 测试，是个独立的模块|
| `node_modules/` | Node.js 创建这个文件夹，用于存放第三方组件，组建列表在package.json 文件中|
| `.angular-cli.json` | 你可以修改哪些文件需要在build的时候被包含进去 | 
| `.gitignore` | 用来将自动生成的文件不纳入资源管理的范围内 |
| `package.json` | npm 配置文件，用于配置第三方的组件 | 
| `protractor.conf.js` | 在点对点测试的时候的配置文件 |
| `tsconfig.json` | Typescript 编译配置文件，对IDE有作用 | 
| `tslint.json` | 标准化你的代码风格 | 

## 从头开始开发一个Angular Application

第一步都是建立工程，所谓建立工程就是建立一个像样的文件夹目录，angular有一个git项目用于快速搭建目录环境，所以第一步的构建需要这样做：

### Setup

```
git clone https://github.com/angular/quickstart.git quickstart
cd quickstart
npm install
npm start

```
然后你会看到一个Hello， 说明建立完成，但是此时有很多没有用的文件我们可以删掉，包括之前的git相关的文件：
```
xargs rm -rf < non-essential-files.osx.txt
rm src/app/*.spec*.ts
rm non-essential-files.osx.txt
```
一些不重要的文件都在一个上面命令中的这个文件中了，以空格分开。


