---
layout: post
title: 高速公路换轮胎——为遗留系统替换数据库(下)
category: 朝花夕拾
tags: 工作
---

[上篇文章](http://xiaodao.github.io/2016/04/06/legacy-refactoring-part-1)讲述了*抽象分支*和*特性开关*的原理，在具体落实的时候，一共分成了如下几个阶段：

### 建立数据访问层 ###

前文说过，系统中ViewController使用NSManageContext的方式一共有两种。

第一种是直接初始化NSFetchedResultsController，发起请求，这种方式比较好处理，我们首先把跟数据请求有关的操作从ViewController中提取成一个方法，放到另一个对象中实现，以便日后替换。然后把所有的数据访问的方法都提取成一个协议，让数据层之上的对象都依赖于这个协议，而不是具体对象。如下所示

{% highlight objective-c %}
@protocol REAPersistenceService <NSObject>
- (NSArray *)getTodayUpcomingEvents;
//其余方法略过
@end

@interface REACoreDataPersistenceService: NSObject<REAPersistenceService>
+ (instancetype)sharedInstance;
@end

@implemention REACoreDataPersistenceService

- (NSArray *)getTodayUpcomingEvents {
  //封装了NSFetchedResultsController的初始化和performFetch操作
}
@end
{% endhighlight %}

我们同时还需要使用特性开关，来决定给上层返回哪一个PersistenceService对象：

{% highlight objective-c %}
@implemention REAPersistenceServiceFactory

+ (id<REAPersistenceService>)service {
  if([REAToggle shouldUseRealm]) {
    return [REARealmPersistenceService sharedInstance];
  } else {
    return [REACoreDataPersistenceService sharedInstance];
  }
}
{% endhighlight %}

改造过后的ViewController就简单多了

{% highlight objective-c %}
- (instancetype)init {
  self = [super init];
  if (self) {
    _persistenceService = [REAPersistenceServiceFactory service];
  }
  return self;
}

- (NSArray *)getTodayUpcomingEvents {
  return [self.persistenceService getTodayUpcomingEvents];
}
{% endhighlight %}

第二种方式是ViewController把自己注册为NSFetchedResultsController的delegate，实现了相应接口，当数据发生变化时刷新UI。这个处理起来就比较棘手，因为我们希望提取之后的接口能够适配于Realm，这样才能无缝切换。然而Realm一方面目前没有像CoreData那样的细粒度通知，另一方面用的也不是delegate，而是提供了addNotificationBlock:方法，让调用者可以注册block。二者的接口并不兼容。

这种情况下，我们的新协议就只能取二者交集：

{% highlight objective-c %}
@protocol REAPersistenceDataDelegate<NSObject>
- (void)contentDidChange:(id)content;
@end
{% endhighlight %}

这个协议跟CoreData和Realm的接口都不一致，两个PersistenceService都在内部做了适配和转发。比如在Realm的实现中，我们让它对外使用REAPersistenceDataDelegate协议来注册delegate，对内依然使用addNotificationBlock:方法监听，收到消息以后再调用delegate的contentDidChange方法。

由于Realm没有细粒度通知，本来还想用

{% highlight objective-c %}
- (void)objectDidChange:(id)object;
{% endhighlight %}
这种方法来封装CoreData的

{% highlight objective-c %}
- (void)controller:(NSFetchedResultsController *)controller
        didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
        forChangeType:(NSFetchedResultsChangeType)type
        newIndexPath:(NSIndexPath *)newIndexPath
{% endhighlight %}
现在也只好作罢，让delegate收到数据后自己计算应当刷新哪部分的数据。

### 为数据对象提取协议 ###

除了数据访问的代码以外，我们还把所有的数据对象上的公有属性和方法都提取了相应的协议，然后修改了整个App，让它使用协议，而不是具体的数据对象。这也是为以后的切换做准备。

### 使用Realm实现 ###

前两步完成之后，我们就建立起了一个完整的抽象层。在这层之上，App里已经没有了对CoreData和数据对象的依赖，我们可以在这层抽象之下，提供一套全新的实现，用来替换CoreData。

在实现过程中，我们还是遇到了不少需要磨合的细节，比如Realm中的一对多关联是通过RLMArray实现的，并不是真正的NSArray，为了保证接口的兼容性，我们就只能把property定义为RLMArray，再提供一个NSArray的getter方法。种种问题不一而足。

### 切换开关状态 ###

上篇文章说到，我们在迁移过程中的特性开关是用NSUserDefaults实现的，在界面上手工切换开关状态。这样的好处是开发过程不会影响在Hockey和TestFlight上内部发布。直到实现完成后，我们再把开关改成

{% highlight objective-c %}
+ (BOOL)shouldUseRealm
{
  return isInternalTarget;
}
{% endhighlight %}

让测试人员可以在真机上测试。回归测试结束之后，再让开关直接返回true，就可以向App Store提交了。

### 数据迁移 ###

这个无需多说，写个MigrationManager之类的类，用来把数据从CoreData中读出，写到Realm里面去。这个类大概要保留上三四个版本，等绝大部分用户都已经升级到新版本之后才会删掉。

### 后续清理 ###

特性开关是不能一直存活下去的，否则代码中的分支判断会越来越多。我们一般都会在上线一两个星期之后，发现没有出现特别严重的crash，就把跟开关有关的代码全都删掉。

在第一步建立数据访问层的时候，我们创建出了一个特别庞大的PersistenceService，它里面含有所有的数据访问方法。这只是为了方便切换而已，切换完成后，我们还是要根据访问数据的不同，建立一个个小的Repository，然后让ViewModel对象访问Repository读写数据，把PersistenceService删掉。

最后形成的架构如图所示

<img src="/assets/images/clean_architecture.png" alt="" class="large">

## 总结 ##

四个多月的时间里，看着自己的构思落地生根到开花结实，看着代码结构从混乱变成有序，心里的满足感无可言喻。回头望去崎岖征途，其间的争执、焦虑、兴奋、坚定，尽皆化成了一行行代码融入系统的底层结构，化成了沉甸甸的收获。

### 首先，要勇敢 ###

面对混乱的代码库，人们最容易做出的选择就是复制黏贴。看看前人怎么做，就跟着照猫画虎来几笔。以前的代码是这么写的，我照样拷一份过来，改一改就能实现新需求。这种做法我们不能说它错，然而它既不能让这个系统变得更好一点，更干净一点，也不能让我们的技术得到提升。它能以最快的速度完成眼下的需求，结果是为团队留下更多的技术债。

欠下的债终究是要还的，团队里一定要有人站出来跟大家说，我们不能让代码继续腐烂下去，我们要有清晰的目标和正确的策略，在重构中让优秀的设计渐渐涌现。这才是正途。

### 要有正确的方法 ###

Martin Fowler在博客中总结过[重构的几种流程](http://martinfowler.com/articles/workflowsOfRefactoring)，在遗留代码中工作，Long-Term Refactoring是不可或缺的。

人们需要预见到在未来的产品规划中，哪些组件应当被替换，哪部分架构需要作出调整，把它们放到迭代计划里面来，当做日常工作的一部分。抽象分支和特性开关在Long-Term Refactoring可以发挥显著的效果，它们是持续交付的保障。

技术债同样需要适当管理，按照严重程度和所需时间综合排序，一点点把债务偿还。或许有人觉得这是浪费时间，但跟一路披荆斩棘，穿越溪流，攀过险峰，历尽艰难险阻相比，我宁愿朝着另一个方向走上一段，因为那边有高速公路。

遗留代码的出现，也意味着在过往的岁月中团队忽略了对代码质量的关注。为了不让代码继续腐化，[童子军规则](http://programmer.97things.oreilly.com/wiki/index.php/The_Boy_Scout_Rule)必须要养成习惯。

### 设计会过时，但设计原则不会 ###

很多技术决策都不是非黑即白的，它们更像是在种种约束下做出的权衡。比如在本文的例子中，当CoreData被Realm所替换以后，抽象层还要不要保留？ViewModel应该直接调用Repository，还是RepositoryProtocol？有人会觉得这一层抽象就好比只有单一实现的接口一样，没有存在的价值，有人会觉得几年后Realm也会过时被新的数据库取代，如果保留这层抽象，就会让那时候的迁移工作变得简单。但无论怎么做，过上一两年后，新加入团队的人都可能会觉得之前那些人做的很傻。

我们无法预见未来，只能根据当前的情况做出简单而灵活的设计。这样的设计应当服从这些设计原则：单一职责、关注点分离、不要和陌生人说话……让我们的代码尽可能保持高内聚低耦合，保证良好的可测试性。时光会褪色，框架会过时，今天的优秀设计也会沦落成明天的遗留代码，但这些原则有着不动声色的力量。
