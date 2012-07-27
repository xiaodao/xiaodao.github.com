---
layout: default
title: 小刀的草色天涯
---

<div id="posts">
	{% for post in site.posts %}
		<div class="post">
			<div class="title"><a href="{{ post.url }}">{{ post.title }}</a></div>
			<div class="content">{{ post.content }}</div>
			<div class="footer"> 
				<div class="tags">
					{% for tag in post.tags %}
						<span class="tag">#{{ tag }}</span>
					{% endfor %}
				</div>
				<span class="date">{{ post.date | date_to_string }}</span><span class="author"> posted by {{ site.author.name }} in</span>
				<span><a href="">{{ post.category }}</a></span>
			</div>
		</div>
	{% endfor %}
</div>

