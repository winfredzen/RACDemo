# RACDemo
RAC一些相关的例子
raywenderlich上的例子

[ReactiveCocoa Tutorial – The Definitive Introduction: Part 1/2](https://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1)登录的的一个例子，介绍一些基本的使用场景，包括：

+ 包括map、filter等的介绍
+ 聚合信号`combineLatest:reduce:`
+ 按钮事件信号
+ 信号的信号，使用flattenMap
+ side-effect副作用，`doNext:`

[ReactiveCocoa Tutorial – The Definitive Introduction: Part 2/2](https://www.raywenderlich.com/62796/reactivecocoa-tutorial-pt2)从Twitter获取数据：

+ error和completed事件类型
+ 内存管理，避免循环引用，使用`@weakify`和`@strongify`
+ `then`方法的使用
+ 创建基于网络请求的signal
+ 线程，使用`deliverOn:`
+ 异步加载图片

[iOS之ReactiveCocoa框架](http://www.imooc.com/learn/807)
