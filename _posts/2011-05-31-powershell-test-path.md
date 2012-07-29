---
layout: post
title: Test-Path的用法
category: 敏捷开发
tags: [powershell]
---
Test-Path是powershell中一个很常用的命令。可以用来检测：

* 文件、目录是否存在

Test-Path -path "c:\users\xiaodao" (-path 可以省略)

* 注册表项是否存在

Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control"

* 变量是否存在

$a = 1
Test-Path "variable:\a"

通过上面的用法可以看出，Powershell为注册表项和参数都提供了虚拟盘符，比如变量的盘符就是variable:。于是，同样可以用Get-ChildItem(ls, dir), del等命令来查询、删除注册表项和变量。