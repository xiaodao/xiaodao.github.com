---
layout: post
title: 高速公路换轮胎——为遗留系统替换数据库(下)
category: 朝花夕拾
tags: 工作
---

上篇文章讲述了*抽象分支*和*特性开关*的原理，在具体落实的时候，一共分成了如下几个阶段：

### 建立数据访问层 ###

前文说过，系统中ViewController使用NSManageContext的方式一共有两种。

第一种是直接初始化NSFetchedResultsController，发起请求，这种方式比较好处理，我们首先做的事情，就是把跟数据请求有关的操作从ViewController中提取成一个方法，放到另一个对象中实现，以便日后替换。然后把所有的数据访问的方法都提取成一个协议，让数据层之上的对象都依赖于这个协议，而不是具体对象。如下所示

```
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
```

我们同时还需要使用特性开关，来决定给上层返回哪一个PersistenceService对象：

```
@implemention REAPersistenceServiceFactory

+ (id<REAPersistenceService>)service {
  if([REAToggle shouldUseRealm]) {
    return [REARealmPersistenceService sharedInstance];
  } else {
    return [REACoreDataPersistenceService sharedInstance];
  }
}
```

改造过后的ViewController就简单多了

```
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
```

第二种方式是ViewController把自己注册为NSFetchedResultsController的delegate，实现了相应接口，当数据发生变化时刷新UI。这个处理起来就比较棘手，因为我们希望提取之后的接口能够适配于Realm，这样才能无缝切换。然而Realm一方面目前没有像CoreData那样的细粒度通知，另一方面用的也不是delegate，而是提供了addNotificationBlock:方法，让调用者可以注册block。二者的接口并不兼容。

这种情况下，我们的新协议就只能取二者交集：

```
@protocol REAPersistenceDataDelegate<NSObject>
- (void)contentDidChange:(id)content;
@end
```

每个需要监听数据库变化的类都实现REAPersistenceDataDelegate这个协议，把自己注册为REAPersistenceService的delegate，而后我们在REACoreDataPersistenceService内部接受NSFetchedResultsController的回调，收到数据后再调用REAPersistenceDataDelegate的方法。相当于是做了一层转发。

而在Realm的实现中，我们就额外提供了一个Adapter，让它对外使用REAPersistenceDataDelegate这个协议来注册delegate，对内依然使用addNotificationBlock:方法监听。

由于Realm没有细粒度通知，本来还想用

```
- (void)objectDidChange:(id)object;
```
这种方法来封装CoreData的

```
- (void)controller:(NSFetchedResultsController *)controller
        didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
        forChangeType:(NSFetchedResultsChangeType)type
        newIndexPath:(NSIndexPath *)newIndexPath
```
现在也只好作罢，让delegate收到数据后自己计算应当刷新哪部分的数据。

### 为数据对象提取协议 ###

除了数据访问的代码以外，我们还把所有的数据对象上的公有属性和方法都提取了相应的协议，然后修改了整个App，让它使用协议，而不是具体的数据对象。这也是为以后的切换做准备。

### 使用Realm实现 ###

前两步完成之后，我们就建立起了一个完整的抽象层。在这层之上，App里已经没有了对CoreData和数据对象的依赖，我们可以在这层抽象之下，提供一套全新的实现，用来替换CoreData。

在实现过程中，我们还是遇到了不少需要磨合的细节，比如Realm中的一对多关联是通过RLMArray实现的，并不是真正的NSArray，为了保证接口的兼容性，我们就只能把property定义为RLMArray，再提供一个NSArray的getter方法。种种问题不一而足。

### 切换开关状态 ###

上篇文章说到，我们在迁移过程中的特性开关是用NSUserDefaults实现的，在界面上手工切换开关状态。这样的好处是开发过程不会影响在Hockey和TestFlight上内部发布。直到实现完成后，我们再把开关改成

```
+ (BOOL)shouldUseRealm
{
  return isInternalTarget;
}
```

让测试人员可以在真机上测试。回归测试结束之后，再让开关直接返回true，就可以向App Store提交了。

### 数据迁移 ###

这个无需多说，写个MigrationManager之类的类，用来把数据从CoreData中读出，写到Realm里面去。这个类大概要保留上三四个版本，等绝大部分用户都已经升级到新版本之后才会删掉。

### 后续清理 ###

特性开关是不能一直存活下去的，否则代码中的分支判断会越来越多。我们一般都会在上线一两个星期之后，发现没有出现特别严重的crash，就把跟开关有关的代码全都删掉。

在第一步建立数据访问层的时候，我们创建出了一个特别庞大的PersistenceService，它里面含有所有的数据访问方法。这只是为了方便切换而已，切换完成后，我们还是要根据访问数据的不同，建立一个个小的Repository，然后让ViewModel对象访问Repository读写数据，把PersistenceService删掉。

最后形成的架构如图所示



## 总结 ##

四个多月的时间里，看着自己的构思落地生根到开花结实，看着代码结构从混乱变成有序，心里的满足感无可言喻。回头望去崎岖征途，其间的争执、焦虑、兴奋、坚定，尽皆化成了一行行代码融入系统的底层结构，化成了沉甸甸的收获。

### 首先，要勇敢 ###

面对混乱的代码库，人们最容易做出的选择就是复制黏贴。看看前人怎么做，就跟着照猫画虎来几笔。以前的代码是这么写的，我照样拷一份过来，改一改就能实现新需求。这种做法我们不能说它错，然而它既不能让这个系统变得更好一点，更干净一点，也不能让我们的技术得到提升。它能以最快的速度完成眼下的需求，结果是为团队留下更多的技术债。

欠下的债终究是要还的，团队里一定要有人站出来跟大家说，我们不能让代码继续腐烂下去，我们要有清晰的目标和正确的策略，在重构中让优秀的设计渐渐涌现。这才是正途。

### 要有正确的方法 ###

Martin Fowler在博客中总结过

### 不让今天的优秀设计成为明天的遗留代码 ###
