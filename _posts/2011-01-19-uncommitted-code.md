---
layout: post
title: 两天没提交代码了
category: 敏捷开发
tags: [Continous Integration]
---
昨天是因为本地环境有问题，到了要提交代码的时候发现本地跑单元测试跑不过。今天是因为某个agent出现了问题，导致CI一直红。

现在的情况是整个team公用一个Codebase，只有一个负责跟遗留系统做集成的团队在分支上工作（据说从前有过特性分支）。本地改动稍微一多，提交代码的频率一慢，就有可能pull下别人的代码来，于是就要跑所有的单元测试，一跑就半个来小时，顺利通过的话再上CI。CI上的pipeline是这样子的，有一个prePackage的stage，打好包，剩下的所有stage就全用这一个打好的包来跑，然后大概是有十个agent分布式跑Acceptance Test这个pipeline，同时有十个agent跑unit test这个pipeline。CI跑完一遍大概也要一个来小时，如果不红的话。

在这种情况下，可以想象到整个团队每天可以提交多少次代码，以及每次提交的难度有多大了。。。

基于这样的情况，团队采用了令牌机制，每个人想提交代码之前，先申请令牌，然后跑本地测试，通过后提交代码，等CI的提交构建。CI通过之后归还令牌。如果CI红了，并且预计在短时间内无法修复的话，就revert代码，归还令牌。

令牌缓解了团队协作的问题，但测试时间过长的问题依然存在。针对这种问题，我们常常采用的实践就是分布式、分阶段、分层。

分布式无庸多言。

分层可以理解为按特性划分支，在特性分支中的构建（包括本地和CI），都只跑跟这个特性有关的测试，与之同时，分支和主干之间，必须要频繁（每日）同步，在分支向主干push的时候，要跑主干上的所有测试，在从主干向分支pull的时候，要跑跟分支有关的测试。

这是用来解决团队规模过大，特性之间相互影响的问题。这个实践在团队中曾经用过一段时间，为了不影响某个特性的critical release，专门拉了一条分支出去。每天做同步。但release完了以后分支就干掉了。

分阶段是用来解决构建时间过长的问题。其解决方案是，让一部分价值最高，成功率最高，运行时间短的测试作为提交构建，每次提交的时候，都必须要跑这些测试。在这个基础上，把全部的测试作为全量构建，放到不会有人频繁提交代码的时候运行，防止对工作造成影响。执行的策略是专人轮流负责，红了必须修。

全量构建的通过用来评价提交构建的好坏，如果全量构建经常失败，就把全量构建中的一些测试放到提交构建里面去做；提交构建里面一些价值不高的测试，也可以挪到全量构建里面去。

但在执行分阶段集成或者分层集成策略的时候，每个人也必须意识到，这些策略都是有成本的，是在一定条件下达成的妥协。它所带来的好处是可以快速反馈，但问题是这种反馈是不是真实的？在反馈中发现的问题是否容易修复？实践证明，当全量构建、Trunk上的构建失败的时候，已经远离了问题出现的时机，定位问题、修复问题的代价都增加了。这就是成本，也是风险。如果对全量构建的关注度不够、分支主干的同步频率很低……最终的结果可能就是无法在主干上得到一个稳定构建，最终放弃并回到苦苦等待令牌的老路上来。