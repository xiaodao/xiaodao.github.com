---
layout: post
title: 敏捷与三项全能
category: 敏捷开发
tags: [咨询]
---

上个月，Jim Highsmith在[博客](http://blog.cutter.com/2009/09/16/the-agile-triathlete)中写到：于我而言，做TDD的开发者就像参加铁人三项一样，他们得掌握三项不同的运动─跑步、骑车、游泳，而这些运动又是集成在一起的。很多开发者编程技术很强，但就像不会游泳的杰出自行车运动员一样，他们在TDD铁人三项中会遇到很大麻烦。

我觉得这段话的解读方式可以有两个：一个是要完善自己的技能集，二是敏捷开发实践的相互支撑。而第二点在帮助客户排查问题的过程中也起着尤为关键的作用。

前些日子，客户问过这样一个问题，我看敏捷开发的一些书里面，提倡说每个故事做完以后都直接转给QA做测试，但在我们团队里面行不通，这样做的话，QA就会忙得焦头烂额，跟不上开发的节奏，我们只能每个迭代到最后的时候安排一个专门的测试阶段。我请他描述一下详细情况，心里同时猜测着会不会跟故事粒度、QA和开发的人员配比等情况有关系。聊了一会便愕然发现，原来先前的猜测统统挨不上边，真正的原因是他们的开发人员根本就不写单元测试，也没有一丝一毫的自动化测试。

这个结果还是很有意思的，客户以为他们是在尝试故事完成以后转QA这个做法的过程中出了问题，最后发现是因为他们没有单元测试，没有自动化测试。当然，这个事情也可以从问题的现象和本质之间的关联来分析，不过这也不是本文要说的重点，我想说的是，当我们想采用某个敏捷实践的时候，我们是否考虑过，实施这个实践的基础已经具备？

** 客户在很多时候，认为一个实践做不下去只是因为他们的做法有问题，或者干脆认为这个实践不适合他们的环境。这时候我们必须得想到，问题可能不在于他们怎样来应用这个实践，而是与之相关联的哪些地方，尤其是支撑这个实践的基础可能出了麻烦。**

当然，可能不仅仅是技术实践，还有其他种种因素。例如麦罗常说的一句话就是：不要用技术来解决政治问题。光磊在[敏捷质疑系列](http://blog.csdn.net/chelsea/archive/2008/07/27/2720933.aspx)中也列出过这样的问题：

>Q: 我干嘛要把辛辛苦苦很多年积累的经验白白告诉别人? 我喜欢不可替代的感觉.

>A: 是的, 本质上这是一个心理学和政治学的问题, 我也无法说服你.
