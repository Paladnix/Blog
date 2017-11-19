---
title: react 设计概念
date: 2017-11-19 15:12:18
tags: [React, Web]
---

react是一个前端库，着力在床在新的前端渲染的工作模式。
react单个可以做为开发库来单独使用，但是一般我们会将其与其他的相关库一起使用，在使用的时候，基本的react概念是不变的，只是在某些环节发生一些变化。

# react 组件的生命周期

对于一个react的组件，其生命周期决定了其思维方式。
一个组件什么时候产生实例，在什么时候调用什么函数，决定了这个组件在什么时候做什么动作。

react严格的定义了组件的生命周期，分别是装载过程，更新过程，卸载过程。我们重点是要清楚，在装载和更新的过程中，react组件都要做哪些动作。

## 装载过程

当组件第一次被装载的时候，一次被调用的分别是：

- constructor
- componentWillMount
- render
- componentDidMount

这里我们使用的是ES6语法的方式来创建组建，所以有一些老的函数就没有被用到，也就不用再提了。

### contructor

并不是每个组件都需要构造函数，当有构造函数的时候，一定要先执行父类的构造函数。
```javascript
class Sample extends React.Component{
    contructor(props){
        super(props);

        this.state = {foo: 'bar'};

        this.onClickSubmitButton = this.onClickSubmitButton.bind(this);
        // this.onClickSubmitButton = ::this.onClickSubmitButton;
    }
}
```

在构造函数中，我们要：
1. 给内部数据初始化，也就是赋值state。
2. 将函数绑定this，否则内部使用的数据会是错的，绑定以后使用的数据就是本组件中的数据。

### componentWillMount & componentDidMount

这是一组函数，分别在render之前和之后调用。
`WillComponent`这个函数其实有点多余，因为所有在这里做的事情我们都可以在构造函数中做，因此基本不会用到这个函数。
`DidMount` 就是在render函数过后调用，此时页面已经渲染出来。 在这个函数的执行时间上，还是比较有文章的。

举个例子，组件A有三个子组件B，B都有实现这个函数，在A的render函数中，会执行B的render函数，但是当一个B的render函数执行完后，并不立即执行这个B的`DidMount`函数，而是等所有的B的render函数被调用完毕后才一起调用。当然也是按顺序的。
由于此时已经渲染出来，所以我们也就可以获得DOM树上的节点。因此我们可以在这时候请求服务器去填充数据。这在我们使用其他的一些前端库的时候比较方便。例如在使用jQuery的时候，jQuery只能对已经存在的元素进行操作，所以此时正是调用jquery的时候。

### render

但凡React组件都要实现这个函数，因为这个函数在Component中没有默认的实现。

render函数并不直接操作渲染，而是返回一个JSX语法的描述。最终的渲染动作由react来做。如过没有什么要渲染就可以返回一个`null`或者`false`。

render应该是一个纯函数，只接受state和props并产生返回值，没有其他任何的副作用。

## 更新过程

要实现交互，就需要更新：

- componentWillReceiveProps
- shouldComponentUpdate
- componentWillUpdate
- render
- componentDidUpdate

在父组件发生Update调用render函数的时候，子组件就会经历更新过程。

### componentWillReceiveProps

这个函数在使用`this.setState`更改数据的时候不会被调用。因为这个函数根据新`props`的值来计算是不是要更新内部状态state。更新内部状态使用setState，因此不会产生循环调用。
这个函数接受一个参数， 新传进来的`nextProps`。

### shouldComponentUpdate

这是决定是否要刷新的函数，也是唯二需要返回值的函数，这个函数用于提高react的效率。
当我们使用`this.setState`去更改内部状态的时候，并不是直接更改的。而是直到执行到这里，还都没有更新。在这里可以做对比，然后决定是否有必要做更新。

### componentDidUpdate

这个函数和之前的额装载过程一样，不用做很多解释。

## 卸载过程

这个过程基本上只涉及一个函数，`componentWillUnmount`。一般我们在这里处理一些在`componentDidMount`中创建的元素，以免造成内存泄漏。


