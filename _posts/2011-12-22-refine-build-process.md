---
layout: post
title: 构建过程，从混乱到有序
category: 敏捷开发
tags: [Continous Integration]
---
最近一段时间在帮一支团队做构建过程梳理，之前的状况是这样的：

1. 使用ClearCase。虽然是用了号称支持乐观锁的UCM版本──多人可以同时checkout一个文件，但无论如何都要checkout。比如要新建一个类，他们的做法是先到服务器上到对应目录下建立同名的空文件，然后checkout出来，再用ftp把新加的文件上传覆盖掉空文件，最后才能checkin。比如要重构方法，就要先找到会被影响到的类一个一个全checkout出来。这实在是一件令人无法容忍的低效的开发方式。

2. 配置管理中存在脏数据，如跑测试生成的log、tmp,  使用UltraEdit生成的.bak，等等。

3. 构建脚本只存在于某台服务器上，测试脚本只存在于测试人员自己的机器上，都没有进行配置管理。

4. 产品代码目录结构混乱。没地方存放单元测试代码，必须要重新整理代码组织方式。

5. 没有人能够在自己的开发机器上进行完整的编译。编译打包的工作只有在某台服务器上才能执行。

6. 提交代码频率低，一星期左右才会提交一次。

7. 编译、打包、测试的频率极低，尤其是回归测试，很多天才会被手动触发执行一次。

针对这种情况，我们制定了如下的改进策略：

1. Setup SVN服务器，为团队成员开通权限。

2. 宣布将产品代码从ClearCase向SVN迁移，自当日起停止提交代码，并将最新版本的代码打包下载到本地。

3. 删除临时文件、日志文件等无用数据，调整代码组织方式，将构建脚本也同步到本地。做一次提交。

4. 调整本地构建脚本，确认开发人员可以在本地完成编译、单元测试、打包等工作。

5. Setup Jenkins Server，创建编译和单元测试的Job。进行svn使用方法及如何写好提交注释的培训。

6. 宣布启用svn，将过去几天内开发的代码同步到svn上，测试人员提交测试脚本。关闭ClearCase当前stream的写权限。

7. 继续调整构建脚本，保证部署和验收测试的工作可以自动化进行，在Jenkins上建立部署、验收测试的Job。

8. 宣布持续集成纪律。

这个策略实际上是有它的限制条件的，下面介绍项目更具体的场景及制定策略的过程。

首先，这个团队只有5个开发人员，1个要离职，1个刚入职，1个不会写代码，1个要被我拉着调脚本，也就是说实际上只有一个人是能够在这几天内生产代码的。于是，这也就意味着即使我们从停止使用ClearCase到开始使用svn之前有几天无配置管理的状态，也不会给团队带来太大影响。而且既然要调整代码组织结构，那为什么不选择一种自己很熟悉的配置管理工具让这个工作可以做的体面一些呢？

所以第一步并没有选择先打通编译打包部署测试的流程，而是先切换到了svn。

但是如果在一个大团队里面，或是团队每天都在生产很多代码的情况下，还是先有持续集成的保障再切配置管理来的稳妥。

或者，你还可以参考熊节写的这篇博客，“<a href="http://gigix.thoughtworkers.org/2010/9/1/migrating-to-a-decent-scm">切换到体面的SCM工具</a>”。