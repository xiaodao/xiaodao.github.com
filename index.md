---
layout: default
title: 小刀的草色天涯
---

<div id="posts">
	{% for post in site.posts limit: 3 %}
		<div class="post">
			<div class="title"><a href="{{ post.url }}">{{ post.title }}</a></div>
			<div class="content">{{ post.content }}</div>
			<div class="footer"> 
				<div class="tags">
					{% for tag in post.tags %}
						<a class="tag" href="/tags.html#{{ tag }}">#{{ tag }}</a>
					{% endfor %}
				</div>
				<span class="date">{{ post.date | date_to_string }}</span><span class="author"> posted by {{ site.author.name }} in</span>
				<span><a class="category" href="/categories.html#{{ post.category }}">{{ post.category }}</a></span>
				<span><a class="comments" href="{{ post.url }}#disqus_thread"></a></span>
			</div>
		</div>
	{% endfor %}
</div>
