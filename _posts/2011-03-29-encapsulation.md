---
layout: post
title: 有关封装的一点事
category: 敏捷开发
tags: [重构]
---
“Clean Code”第六章开头写到：

There is a reason that we keep our variables private. We don't want anyone else to depend on them...Why, then, do so many programmers automatically add gettters and setters to their objects, exposing their private variables as if there were public?

这让我想到了“OOD启思录”的几段描述。作者在第三章中说：“在面向对象设计中只要出现了get或set函数，设计者就有必要问自己，‘我到底在对这个数据做什么？为什么不是由类来替我做这件事情？’”，“访问方法并不因为暴露实现细节而具有危险性，它们危险是因为它们表明了对相关数据和行为的不良封装。”

总的来看，使用getter/setter有两个问题。1. 它依然是在暴露实现细节，比起使用public变量而言并没有太大改进；2. 使用了getter/setter可能会引起数据和行为的分离。

当然，这样说似乎太抽象了一点。那我们来看看下面这段代码：
<pre>public class WorkFlow
    {
        public readonly IWorkItem accountSettingItem = new WorkItem();
        ....(省略4个IWorkItem)
    }

public abstract class StatusChecker : IStatusChecker
    {
        protected abstract bool IsAvailable();
        public void Check(IWorkItem workItem)
        {
            workItem.Available = IsAvailable();
        }
    }

public class AccountSettingChecker : StatusChecker
    {
        private readonly AccountSettings accountSettings;
        public AccountSettingChecker(AccountSettings accountSettings)
        {
            this.accountSettings = accountSettings;
        }
        protected override bool IsAvailable()
        {
            return !accountSettings.IsValid;
        }
    }
</pre>
这几个类在使用的时候就是：
<pre>var accountSettingChecker = new AccountSettingChecker()
accountSettingChecker.check(workflow.accountSettingItem)

...(省略其他的checker调用)
</pre>
这段代码还挺好读懂的，StatusChecker要检查WorkFlow中Item的状态，通过设置它的Available属性来达到控制Workflow是否流经这个Item的目的。

但仔细想一下，Check的意图是修改workItem的Available属性，既然如此，那么这个操作WorkItem数据的行为是不是应该和数据放在一起，也就是放到WorkItem对象上面呢？

这样一来，WorkItem也不用暴露Available属性，WorkFlow更用不着暴露它里面的WorkItem了。

于是，这里面需要进行两大类重构：1. encapsulate public field; 2. move method。

最后得出的结果大概是这样的：
<pre>public class WorkFlow
    {
        private readonly IWorkItem accountSettingItem;

        ....
        public WorkFlow(AccountSettings accountSettings, ...){
           accountSettingItem = new AccountSettingItem(accountSettings)
        }

        public void check(){
             accountSettingItem.check();
              ...
        }
    }

public class AccountSettingItem extends WorkItem{
     private readonly AccountSettings accountSetting;
     public AccountSettingItem(AccountSettings accountSettings){
          this.accountSettings = accountSettings;
     }

     public check(){
          this.Available = !accountSettings.IsValid;
     }
}
</pre>
调用的地方变成了
<pre>     workflow.check()
</pre>
做完这个重构以后，大部分要读写Workflow和WorkItem的数据的行为都放到了这两个对象内进行。

然后就想起了Kent beck在“实现模式”中曾经讲过一条原则：将逻辑和数据捆绑。他的原话是这样的：“把逻辑和逻辑所处理的数据放在一起，如果有可能尽量放到一个方法中，或者退一步，放到一个对象里面，最起码也要放到一个包下面。在发生变化时，逻辑和数据很可能会同时被改动。如果它们放在一起，那么修改它们所造成的影响就会只停留在局部。”观点何其相似，只是表述方式不同。

感兴趣的童鞋可以把这两个类重构一下（出自“Refactoring Workbook”，Exercise 30）:
<pre>public class Person {
    public String last;
    public String first;
    public String middle;

    public Person(String last, String first, String middle) {
        this.last = last;
        this.first = first;
        this.middle = middle;
    }
}

public class PersonClient{
    public void client1(Writer out, Person person) throws IOException {
        out.write(person.first);
        out.write(" ");
        if (person.middle != null) {
            out.write(person.middle);
            out.write(" ");
        }
        out.write(person.last);
    }

    public String client2(Person person) {
        String result = person.last + ", " + person.first;
        if (person.middle != null)
            result += " " + person.middle;
        return result;
    }

    public void client3(Writer out, Person person) throws IOException {
        out.write(person.last);
        out.write(", ");
        out.write(person.first);
        if (person.middle != null) {
            out.write(" ");
            out.write(person.middle);
        }
    }

    public String client4(Person person) {
        return person.last + ", " +
               person.first +
               ((person.middle == null) ? "" : " " + person.middle);
    }
}
</pre>