---
layout: post
title: Quicksilver进阶应用指南（3）──几款好用的插件
category: 朝花夕拾
tags: [productivity, quicksilver]
---
1. Firefox Module/Safari Module

可以方便的打开Firefox/Safari Bookmarks中的书签（前提──书签以英文命名），如下图所示：

<a href="http://www.iamxiaodao.com/wp-content/uploads/2011/05/qs_open_url.png"><img src="http://www.iamxiaodao.com/wp-content/uploads/2011/05/qs_open_url-260x300.png" alt="" title="qs_open_url" width="260" height="300" class="alignnone size-medium wp-image-735"></a>

使用Firefox的用户注意：FF的书签是在SQLite数据库中保存，所以QS的插件找不到它们。不过FF3是可以周期性的把书签保存到bookmarks.html里面去的。在FF的地址栏里面输入about:config按回车，再在过滤器里面输入autoExport，我们可以看到browser.bookmarks.autoExportHTML这个选项，它的默认值是false，双击可以把它改成true。最后重启FF和QS，bookmarks.html就会自动生成了。FF3会在退出的时候自动把书签写入bookmarks.html文件。

2. Screen Capture Module

可以从此省去Shift + Command + 3/4。支持区域、屏幕、窗口三种截图方式。如下图所示：

<a href="http://www.iamxiaodao.com/wp-content/uploads/2011/05/qs_capture_module.png"><img src="http://www.iamxiaodao.com/wp-content/uploads/2011/05/qs_capture_module-254x300.png" alt="" title="qs_capture_module" width="254" height="300" class="alignnone size-medium wp-image-736"></a>

使用此插件需要在QuickSilver -&gt; Catalog -&gt; QuickSilver 中选中"Internal Command"；需要在Preferences -&gt; Application 中选中"Enable Advanced Features"。

3. Extra Scripts

支持很多命令，比如Empty Trash，比如Empty Trash，比如Empty Trash……