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
<script type="text/javascript">
/* Iridize.com -- development environment scriptlet only*/
(function(){var e="https:"==document.location.protocol?"https:":"http:";iridize={api:{q:[]},loadScripts:[],loadCss:[],jsPrefix:e+"//static-iridize.netdna-ssl.com/player/latest/static",prefix:e+"//iridize.com/player/latest"};var t=document.createElement("script");var n=document.getElementsByTagName("script")[0];t.src=e+"//static-iridize.netdna-ssl.com/player/latest/static/js/iridizeLoader.min.js";t.type="text/javascript";t.async=true;n.parentNode.insertBefore(t,n)})();window.iridizeCall=function(e,t,n){iridize.api.q.push({method:e,data:t,callback:n})};
//FOR PER USER ACTIVATION RULES AND GOAL TRACKING - UNCOMMENT THE FOLLOWING LINE AND SET user_id
iridizeCall("api.guide.list", {}, function(data) {

   var guidesList,guide,i;
   // get the array of guide information objects
   guidesList = data.guides;
   // print the guides to browser console
   for (i = 0; i < guidesList.length; i++) {
       guide = guidesList[i];

       console.log(guide.apiName + " | " + guide.displayName);

   }
});
</script>
