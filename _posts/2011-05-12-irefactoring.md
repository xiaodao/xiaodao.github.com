---
layout: post
title: iRefactoring开发小记
category: 敏捷开发
tags: [可视化管理, irefactoring, opensource, refactoring]
---
<a href="https://github.com/xiaodao/iRefactoring">iRefactoring</a>前前后后花了大概一个多月的时间。下面总结一下这段时间里的心得：

1. 只做好一件事情

换句话说，就是要想好这个项目的scope是什么，哪些地方是我的核心价值，哪些地方我不应该做。拿iRefactoring举例，它的功能是拿代码提交次数和圈复杂度/代码覆盖率的数据做对比，生成报表。但世界上的圈复杂度工具不计其数，覆盖率工具应有尽有，生成的数据格式自然千奇百怪，我是要把所有可能遭遇的工具都支持上一遍，还是制定好一个数据标准，让用到工具的人自己写脚本做格式转换？前一种选择会累死自己，后一种的扩展性则更强──我只要做完log分析，不管你用什么工具，最后生成我要的数据就行。

我曾一度走上过累死自己的路，多亏了<a href="gigix.thoughtworkers.org">熊节</a>和英杰的提醒。

这个事情又一次提醒了我，试图做大而全的工具的人不会有好结果。。。

2. 要有一份排好序的story backlog

上面这句话包含了好几个意思。

1）要有story。自己做自己的项目，为了省事，你可以不把story写成XYZ的形式，但你还是要认真的去想这个story是为什么样的用户服务的，它可以带来什么样的价值；story要小，要有definition of done。这可以防止你lost。

2）要明确风险和优先级。高风险高价值的先做，nice to have的可以往后慢慢排。