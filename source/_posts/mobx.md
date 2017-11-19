---
title: mobx - redux的优秀替代品
date: 2017-11-18 14:29:49
tags: [Mobx, React, Web]
---

在使用react做大型开发的时候，我们习惯使用redux来做数据管控。但是redux实在是太过繁琐，流程很长，不利于快速开发。
mobx是redux作者非常推荐的一个替代产品。

# 基本概念

与redux的长流程，严管控不同，mobx采用一种更直接的方式，和更自动化的方式管理应用的数据。

## 状态驱动页面更新

应用的state也就是其中的数据，就是应用此时所在的状态，状态的改变驱动页面的改变，这是共识，问题就是怎么设计使状态的改变驱动页面更新。

在mobx中，数据将被监视，当数据发生变化的时候，mobx会自动的知道哪些部分需要被刷新，而不需要程序员来指明更新什么。

应用的状态分成两种， 一种是数据本身组成的基本状态。还有一种是在数据基础上计算得出的衍生状态。在下面我们会讨论这些。

## observable

对于需要被监视的数据，就将他用注解的方式注明，需要被监视。

```javascript
import { observable, computed } from "mobx";

class OrderLine {
    @observable price = 0;
    @observable amount = 1;

    @computed get total() {
        return this.price * this.amount;
    }
}

```

就这样简单的就将一个变量纳入mobx的观察体系中。
被观察的可以是几乎所有的javascript的数据结构，但是，对于对象，建议一律转成map来观察，因为对象只会观察此时有的字段，对于未来新添加的字段需要手动加入观察， 但是map就可以将添加进来的新key一并纳入观察。

## observer

有了被观察的，就要有观察者， 这里的观察者会是前端的组件。通常来说，每个组件都应该是可以观察自身数据的，响应式的应用。
一个观察者，会在数据发生变化的时候自动更新自己的视图。
```javascript
import {observer} from 'mobx-react';

@observer
class TimerView extends React.Component {
    render() {
        return (<button onClick={this.onReset.bind(this)}>
                Seconds passed: {this.props.appState.timer}
            </button>);
    }

    onReset () {
        this.props.appState.resetTimer();
    }
};

ReactDOM.render(<TimerView appState={appState} />, document.body);

```

## action

数据的改变会被捕获，那么由谁来该数据呢？
理论上，mobx不会限制你怎么写代码，它支持让你便捷的开发。但是建议我们使用严格一点的方式，这种方式并没有特别复杂，但是让我们的代码更加清晰和利于管控。

我们规定只在action中更改我们的数据。同样这也是一个注解：
```javascript
@action    createRandomContact() {
        this.pendingRequestCount++;
        superagent
            .get('https://randomuser.me/api/')
            .set('Accept', 'application/json')
            .end(action("createRandomContact-callback", (error, results) => {
                //  注意: 异步回调函数是单独的动作！
                if (error)
                    console.error(error);
                else {
                    const data = JSON.parse(results.text).results[0];
                    const contact = new Contact(this, data.dob, data.name, data.login.username, data.picture)
                    contact.addTag('random-user');
                    this.contacts.push(contact);
                    this.pendingRequestCount--;
                }
            }));
    }
```
其原理是会返回一个同名函数，在函数中间过程产生的数据并不会捕获并去刷新界面。只有在执行结束后才会被得到最终数据。
我们只在函数会更改组件状态的时候才使用这个注解。

在上面的代码中，有两种使用方式，其实所有的这些都有不止一种的调用方式，这里我们使用的ES7的注解语法，在一些地版本的地方，我们还是可以使用函数的方式去调用，毕竟其本质上是一样的。

## compute

之前我们说到，状态分成两个部分，分别是原生状态和衍生状态。对于衍生的状态，我们通过`@compute`来标注，这个注解标注的表达式或是函数，必须只返回一个数据，而不会产生其他多余的动作。因为当这个表达式用到的数据发生变化的时候，这个表达式会自动计算一遍，当其中的数据被reaction使用到的时候。也就意味着衍生的数据也会一并更新。
但是我们在更新衍生数据的时候未必需要做诸如发送请求之类的动作，所以要保持这个表达式的纯净。

## reaction

被称之为反应，在数据发生变化的时候，我们同时可能需要做一些附带的动作，比如发送请求，打印日志等。在反映中来做。

## autorun

当你想创建一个响应式函数，而该函数本身永远不会有观察者时,可以使用 mobx.autorun。 这通常是当你需要从反应式代码桥接到命令式代码的情况，例如打印日志、持久化或者更新UI的代码。 当使用 autorun 时，所提供的函数总是立即被触发一次，然后每次它的依赖关系改变时会再次被触发。 相比之下，computed(function) 创建的函数只有当它有自己的观察者时才会重新计算，否则它的值会被认为是不相关的。 经验法则：如果你有一个函数应该自动运行，但不会产生一个新的值，请使用autorun。 其余情况都应该使用 computed。 Autoruns 是关于 启动效果 (initiating effects) 的 ，而不是产生新的值。 如果字符串作为第一个参数传递给 autorun ，它将被用作调试名。
传递给 autorun 的函数在调用后将接收一个参数，即当前 reaction(autorun)，可用于在执行期间清理 autorun。


