---
layout: post
title: 使用PowerShell管理环境变量
category: 敏捷开发
tags: [powershell]
---
想用PowerShell对环境变量进行永久性的修改，只发现两种方式：

1. 修改注册表。

PowerShell使用注册表的方式跟普通的文件目录基本相同，所以可以：
<code> </code>
<pre><code>$envkey = Get-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
$envValue = Get-ItemProperty $envKey.PSPath
$envPathValue = $envValue.Path
if(!$envPathValue.Contains($pathToBeAdded)) {
  Set-ItemProperty $envKey.PSPath -Name "Path" -Value $envPathValue$pathToBeAdded
}
</code></pre>
<code> </code>

但是这种方式有个缺点，就是重启以后才能生效。

2. 调用.NET api。
<pre>Function Add-To-Environment-Path($pathToBeAdded) {
 Add-To-Environment "Path" $pathToBeAdded
}

Function Add-To-Environment($variableName, $valueToBeAdded) {
 $value = [environment]::GetEnvironmentVariable($variableName,"Machine")
 if(!$value.Contains($valueToBeAdded)) {
 [Environment]::SetEnvironmentVariable($variableName, $value+$valueToBeAdded, "Machine")
 }
}</pre>
这个只要重启powershell就可以了，还是可以接受的。