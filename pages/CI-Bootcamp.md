---
layout: page
title: CI-Bootcamp
---

## 课程目标及要点

在完成课程教学后，同学们应该能够：

* 理解持续集成的价值
* 理解持续集成的工作原理及内容
* 理解配置管理的作用、策略、应用
* 理解本地构建，掌握提交构建六步法
* 理解构建流水线
* 掌握Jenkins的使用
* 掌握一种构建脚本


## 课程准备

* 学员在个人电脑上须提前下载并安装jdk、git、jenkins、maven2
* 学员须提前申请github账号，并练习github的使用


## 课程大纲


### 第一天上午（两个半小时）

讲课程大纲（十分钟）

讲座：持续集成概述（一小时）

* 从问题出发，讲述为什么要有持续集成

* 什么是持续集成

* 持续集成的工作原理

* 持续集成的内涵（编译、测试、部署、基础设施、静态检查、报告）

休息（十分钟）

实战练习（一小时）

（Jenkins的安装和使用）

* 为Jenkins安装git plugin，配置一个job，使之指向讲师的某个代码库，手工trigger，构建成功后进行下一个操作。

（单元测试与提交构建）

* 学员从github上fork讲师的代码库，clone到本地，针对某个功能添加单元测试，并使之运行通过。

* 学员将Jenkins的job指向个人的github仓库。

* 本地运行mvn test，成功以后提交代码。Jenkins构建成功后进行下一个操作。

### 第一天下午（三个半小时）

讲座：构建流水线 （半小时）

实战练习（Jenkins上的构建流水线）（两个小时，包括中场休息）

* 安装插件，为pipeline做准备，讲解每个插件的作用

http://antagonisticpleiotropy.blogspot.com/2012/02/implementing-real-build-pipeline-with.html

* 学员fork讲师的另一个代码库（分支），clone，针对某个功能添加功能测试，使之运行通过。

* 学员在Jenkins上新建两个job，配置好pipeline，第一个运行mvn test，第二个执行部署脚本，部署后运行功能测试

* 提交代码，观察两个job的运行情况

讲座：持续集成的纪律与实践（一小时）

* 基本纪律（提交前先本地构建，谁弄坏谁修，修好之前其他人不提交）

* 良好的源代码管理

* 全面的构建脚本

* 测试策略

* 一致的环境

* 频繁提交、提交注释

* 信息辐射

* Story拆分

* 团队划分

* 分布式构建

* ……

### 第二天上午（两个半小时）

讲座：配置管理（一小时）

讲座：分支策略及集成策略 （一个半小时）

### 第二天下午（三个半小时）

讲座（练习）Maven实战及工作原理、构建脚本的可维护性（一个半小时）

讲座：持续交付简介（两个小时）

### 高级篇

讲座：构建——构建领域面对的问题，各构建工具如何解决问题，优缺点对比。

讲座+练习 DVCS

讲座+练习：Database Migration

讲座+练习：Infrastructure as code (puppet)


### 配套录像：持续集成的工作过程 

* 编写测试，修改代码，运行测试

* 本地构建

* 更新代码，运行测试

* 提交代码

* CI运行单元测试

* CI执行功能测试，生成artifact

* CI执行静态代码检查

* report