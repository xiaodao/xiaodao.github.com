---
layout: post
title: Disable IE8 Welcome Screen with powershell
category: 敏捷开发
tags: [powershell]
---
回归测试每隔一段时间都会挂一次， 后来发现是好像IE8每隔一天左右就会弹出一次Welcome页面，从而导致无法定位页面元素而测试失败——我不得不说，微软这是做出了怎样脑残的设计？

网上给出的解决方案有两种，一个是修改注册表，一个是修改Group Policy。

本来以为修改注册表要重启，就首先把这种方案给排除了，但结果是用了一天多的时间，也没有找到一个能够在命令行下面修改Local Group Policy的方法（具体一点，就是Computer Configuration | Administrative Templates | Windows Components | Internet Explorer | Prevent performance of First Run Customize Settings 这个policy的值）——能用图形界面操作的东西却不提供shell api，让人情何以堪啊。。。

没办法，还得回到注册表的老路上来。

Function Disable-Welcome-Screen {
  $ie =  get-item "HKLM:\SOFTWARE\Microsoft\Internet Explorer\MAIN"
  New-ItemProperty $ie.PsPath -name "IE8RunOnceLastShown" -value "1" -propertyType  dword
  New-ItemProperty $ie.PsPath -name "IE8RunOncePerInstallCompleted" -value "1" -propertyType  dword
  New-ItemProperty $ie.PsPath -name "IE8RunOnceCompletionTime" -propertyType BINARY
  New-ItemProperty $ie.PsPath -name "IE8TourShown" -value "1" -propertyType  dword
  New-ItemProperty $ie.PsPath -name "IE8TourShownTime"-propertyType BINARY
  New-ItemProperty $ie.PsPath -name "IE8RunOnceLastShown_TIMESTAMP" -propertyType BINARY
}