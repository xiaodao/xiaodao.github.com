---
layout: post
title: 可测试性驱动的Javascript重构
category: 敏捷开发
tags: [重构, javascript]
---

##引子

项目里面曾经有这样一段遗留代码，嵌在了jspx页面里面：
{% highlight javascript %}
function getDropDownOptions(data) {
  $.ajax({
    url: "/dropdownoptions.json",
    dataType: json,
    cache: false,
    data: data,
    success: function(data) {
      $("#journals").html();
      for (idx in data.journals) {
          $("#journals").append( + data.journals[idx].name + );
      }
      $("#journals").removeAttr(disabled);
    }
  });
}

$(document).ready(function() {
  $("#series").change(function() {
    $("#journals").attr(disabled, disabled);
    $("#journals").html(Loading journals...);
    getDropDownOptions({
    	journalType: $("#series").val()
    });
  });
});
{% endhighlight %}
实现的功能很简单，就是个级联下拉框，第一个下拉框#series被选中以后，第二个下拉框#journals先被禁用掉，等异步请求返回数据之后，再把数据填充到下拉框里面，并将之使能。

看上去代码还是很好读懂的，但测试却是个大问题。后来就发现了[jspec](http://visionmedia.github.com/jspec/)这个好东西，于是我想，那就把这段代码重构一下，然后加上测试吧。

##开工

要给一段遗留代码补测试，首先要弄明白要测试的功能是什么。上面这陀代码实际上干了三件事情: 1. 禁用#journals下拉框；2. 发起ajax请求；3. 拿到返回的json对象，用它填充#journals下拉框。也可以归为两类，一类是发送ajax请求，一类是操作dom。我想先把操作dom的这部分功能加上测试，比如禁用下拉框(dropdownmodel_spec.js):

{% highlight javascript %}
describe 'dropdownModel'
  before_each
    html = $(fixture('dropdownlist.html'))
    dropdownModel = new DropdownModel(html)
  end
  
  it 'should prepare for series change'
    dropdownModel.prepare()
    
    journals = html.find("#journals")
    journals.should.be_disabled
    journals.find(option).should.have_text('Loading journals...')
  end
end
{% endhighlight %}

在上面的代码里，首先是用fixture()这个方法构建了一个fixture，把dom传给DropdownModel的构造参数，让js和html解耦。fixture的加载路径是在测试页面中配置的，可参考jspec文档。然后是DropdownModel：

{% highlight javascript %}
function DropdownModel(dom){
  this._dom = dom;
}

DropdownModel.prototype = {
  prepare : function(){
   var journals = this._dom.find("#journals");
   journals.attr(disabled, disabled);
   journals.html(Loading journals...);
  }
}
{% endhighlight %}
但测试页面显示有failure，这是因为fixture页面还没有写好，这里写个最简单的页面就好了，只要带有id为journals的select元素就行。测试通过以后，我们可以继续把用json数据填充下拉框的测试也写完。先构造一个json字符串:
{% highlight javascript %}
{
journals : [
  {
  id : 0,
  name : All journals in series
  },	{
  id : 3009,
  name : Alzheimer Research
  }]
}
{% endhighlight %}

然后是测试:

{% highlight javascript %}
it 'should populate journals'
  journal_json = fixture('journal.json')
  journal_data = eval('('+ journal_json +')')
  
  dropdownModel.populate(journal_data)
  
  journals = html.find("#journals")
  journals.should.have_many 'option'
  journals.find(option)[0].should.have_text(All journals in internal series);
  journals.find(option)[1].should.have_text(Alzheimer Research);
end
{% endhighlight %}

实现就略过不提了。接下来就是测试发送ajax请求的部分，这个类对外只有一个接口，比如叫做changeSeries吧，它要先调用model的prepare方法，然后发请求，然后把json对象做参数，调用model的populate方法。JSpec提供了mock ajax request的方法，于是测试也变得很简单了。比如:

{% highlight javascript %}
describe 'heading'
  before_each
    html = $(fixture('dropdownlist.html'))
    model = new DropdownModel(html);
    controller = new DropdownController(model);
  end
  
  describe 'change series'
    it 'should call model populate journals after a success ajax call'
      journal_json = fixture('journal.json')
      mock_request().and_return(journal_json, 'application/json');
  
      controller.changeSeries();
  
      journals = html.find("#journals")
      journals.should.have_many 'option'
      journals.find(option)[0].should.have_text("All journals in internal series");
      journals.find(option)[1].should.have_text("Alzheimer Research");
    end
  end
end
{% endhighlight %}

实现代码如下:

{% highlight javascript %}
function DropdownController(model){
  var _model = model;
  
  this.changeSeries = function(){
    _model.prepare();
    
    getDropDownOptions({
    	journalType: $("#series").val()
    });
  }
  
 function getDropDownOptions(data) {
   var model = _model;
   $.ajax({
     url: dropdownlist.json,
     dataType: json,
     cache: false,
     data: data,
     success: function(data) {
    	model.populate(data)
     }
   });
  }
}
{% endhighlight %}

##结束语

到此为止，原先嵌在页面中的一段js代码已经分离了出来，并根据职责的不同，拆分出了两个类，一个操作dom，一个处理ajax请求，并且有了针对操作dom行为的两个单元测试，以及针对ajax请求的一个集成测试(如果愿意的话，还可以mock一下model的prepare方法，测试它会被controller的changeSeries方法调用到)。

在这个过程中，我的感触是:

*   JSpec是很牛逼的。提供了如rspec一样清爽的语法；有很大一陀功能强大，也更易读的Matchers，一如hamcrest；有before_each和after_each用；支持JQuery；原生支持mock ajax call；可以用selenium把js测试集成到CI里面去

*   Javascript的可测试性是很重要的，这样才能用低成本的单元测试、集成测试来覆盖javascript的功能，而不是成本高昂的功能测试，或者是傻傻的一味加断点Debug。

(完)