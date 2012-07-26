---
layout: default
title: 小刀的草色天涯
---

<div id="posts">
	{% for post in site.posts %}
		<div class="post">
			<div class="title">{{ post.title }}</div>
			<div class="content">{{ post.content }}</div>
		</div>
	{% endfor %}
</div>

<div id="sidebar">
	<div id="aboutme">
		<img src="assets/images/avatar.png" alt="" class="circle" weight="200" height="200">
		<div class="title">小刀的草色天涯</div>
		<div class="description">
			<p>李剑，ThoughtWorks高级咨询师，持续集成专家。曾为国内领先的大型电信公司提供敏捷转型服务及持续集成解决方案。</p>
			<p>在过去的几年间，我一直致力于敏捷及精益思想在国内的推广传播。</p>
		</div>
	</div>	
	<div class="sidebar-fragment">
		<div class="title">我的开源项目</div>
		<div class="description">
			<ul>
				<li><a href="https://github.com/gigix/beergame">beergame</a></li>
				<li><a href="https://github.com/xiaodao/iRefactoring">iRefactoring</a></li>
				<li><a href="http://code.google.com/p/jenkins-dashboard">checkin-dashboard</a></li>
				<li><a href="https://github.com/xiaodao/psbuild">psbuild</a></li>
			</ul>
		</div>
	</div>
	<div class="sidebar-fragment">
		<div class="title">我的译作</div>
		<div class="description">
			<ul>
				<li><a href="http://book.douban.com/subject/3390446/">硝烟中的Scrum和XP</a></li>
				<li><a href="http://book.douban.com/subject/3324516/">实现模式</a></li>
				<li><a href="http://book.douban.com/subject/4170079/">精益和敏捷开发大型应用指南</a></li>
				<li><a href="http://www.infoq.com/cn/minibooks/kanban-scrum-minibook-cn">看板和Scrum——相得益彰</a></li>
				<li><a href="http://book.douban.com/subject/4909629/">Scala程序设计</a></li>
				<li><a href="http://book.douban.com/subject/4031959/">软件开发沉思录</a></li>
			</ul>
		</div>
	</div>
	<div class="sidebar-fragment">
		<div class="title">与我联系</div>
		<div class="description">
			<p>新浪微博: @凉粉小刀</p>
			<p>Email: veryfaint[at]gmail.com</p>
		</div>
	</div>
	<div class="sidebar-fragment">
		<div class="title">标签</div>
		<div class="description">标签们</div>
	</div>
	<div class="sidebar-fragment">
		<div class="title">分类</div>
		<div class="description">分类们</div>
	</div>
</div>


