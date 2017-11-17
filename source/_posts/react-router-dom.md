---
title: react-router tutorial
date: 2017-11-17 23:40:11
tags: [React, Router]
---

这是一个react router的V4版本。被广泛使用， 非常流行。

# Installation

react router 被包含在三个包中： react-router, react-router-dom, react-router-native. 你几乎不会直接安装react-router这个包，因为这是一个核心包，提供的是基础的react应用的路由库。
另外的两个分别提供了特殊的使用环境，前者是浏览器端， 后者是在react-native中。他们都完全包含react-router这个包中的内容。

`npm install --save react-router-dom`

# The Router

在多页应用中，路由的设计尤为重要。
在react应用中，其实不存在真正的多页应用，而是使用一些浏览器操作来使得单页应用具备多页应用的功能。所谓的多页应用，应该是当你输入一个固定的链接时，得到的页面应该是一致的，并且具备后退的功能。但是在react应用中，页面并不会完全重新加载，而是以特殊的方式来组织，做局部加载，实现多页面的效果。

在浏览器应用中，我们使用的是`<BrowserRouter>`和`<HashRouter>`组件。当我们的请求的网站是一个动态的页面（Know how to respond to any possible URI）的时候，我们使用前者；如果是个纯静态的页面，我们使用后者。很明显我们大多数使用前者。

## History

每个router组件都有一个history的对象，用于记录浏览的记录，用于保持跟踪。
关于这一部分，暂时还没有研究。待研究。


# Rendering a `<Router>`

`<BrowserRouter>` 只允许一个子组件的存在，所以跟react一个尿性的，我们可以将我们的应用封装成`<App \>`的形式来使用。
For example:

```Javascript

import { BrowserRouter } from 'react-router-dom'
ReactDOM.render((
  <BrowserRouter>
    <App />
  </BrowserRouter>
), document.getElementById('root'))
```

# The App

在`<App>`中，我们就可以开始做布局的工作，我们可以不直接添加我们的路由体系，直接在`<App>`组件中添加一些组件。当我们添加我们的路由体系的时候，每个路由信息，都由一个`<Route>`组件来组织。

```Javascript
<Switch>
  <Route exact path='/' component={Home}/>
  {/* both /roster and /roster/:number begin with /roster */}
  <Route path='/roster' component={Roster}/>
  <Route path='/schedule' component={Schedule}/>
</Switch>
```

其中， `<Switch>`组件用于列表匹配，从上到下依次匹配，直到匹配成功退出。

每个`<Router>`有三个参数，分别是：`component`, `render`, `childern`。 这三个只能出现一个。

**component**， 就是渲染对应的组件。
**render**， 是一个函数，返回一个react的组件，跟普通组件很相似，但是会很方便内联渲染和传递更多的参数。
**childern**， 是一个函数，返回一个组件，不像前面两个，这个无论是否匹配都会渲染这个组件。

在上面的例子中，有使用`exact`修饰的path，需要完全精确匹配才会渲染对应的组件。

# 嵌套的Router

在同一个组件中，可能提供多个路由访问的内容，这个时候我们可以将路由信息嵌套起来使用。如上例中的` <Route path='/roster' component={Roster}/>`， 如果我有一个路由是`/roster/6`， 就会去访问roster对应的组件，并在组件内继续匹配路由。

