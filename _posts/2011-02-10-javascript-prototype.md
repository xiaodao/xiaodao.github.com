---
layout: post
title: JavaScript的prototype
category: 敏捷开发
tags: [javascript]
---
在《JavaScript, The Good Parts》一书中，作者这样写到:
<blockquote>Every object is linked to a prototype object from which it can inherit
properties.</blockquote>
于是，如果我们试图从一个对象中获取属性，而该对象上缺少这个属性，它就会查找自己的prototype对象，如果这个prototype对象上还没有，然后就会继
续往prototype对象的prototype对象上找，一直找到根上--- Object.prototype。
这种prototype的关系是动态的，一旦给某个prototype上加了一个属性，在所有基于此prototype的对象上就都能看到这个属性。

利用这个特性可以完成很多事情，比如添加公共方法和动态的提供对象上的方法增强。

《JavaScript, The Good Parts》这本书中对于第一点给出了很多例子，例如实现Function的curring
<code> </code>
<pre>Function.prototype.method = function(method, func){
  this.prototype[method] = func;
  return this;
};

Function.method('curry', function(){
  var slice = Array.prototype.slice,
    args = slice.apply(arguments),
    that = this;
  return function(){
    return that.apply(null, args.concat(slice.apply(arguments)));
  };
});
</pre>
用Jspec给它写个测试看看:
<code> </code>
<pre>describe 'method should be able to be curried'
  it 'should curry add method'
     var add = function(number1, number2) {
	return number1 + number2;
     }

     var curried_add = add.curry(7)
     curried_add(8).should_be(15)
  end
end
</pre>
同理，我们也可以自己给Array上增加一些便利的方法，比如select:
<code> </code>
<pre>describe 'functional test'
  before_each
    function People(name){
  	this.name = name;
    }
    friends = [new People("jacky"), new People("jane")]
  end

  it 'should do select'
    var jane = friends.select(
	function(people) {
	  if (people.name == "jane") return people;
	})；
    jane.name.should_be("jane");
  end
end
</pre>
实现代码如下:
<code> </code>
<pre>Array.method('select', function(f){
  var i;
  for(i = 0; i  this.length ; i+=1){
    var result = f(this[i]);
    if( result != null){
  	return result;
    }
  }
});
</pre>
也可以把《Scala程序设计》中第七章讲隐式类型转换的例子重写一下:
<code> </code>
<pre>
Number.method('days', function(when){
  var date = new Date();
  switch(when){
    case "ago":
      date.setTime(date.getTime() - this * 3600 * 1000 * 24);
      break;
    case "after":
      date.setTime(date.getTime() + this * 3600 * 1000 * 24);
      break;
    default:
  };
  return date;
});</pre>
然后就可以这样用了: var date2DaysAgo = (2).days("ago");