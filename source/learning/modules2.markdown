---
layout: default
title: Learning — Modules 2
---

Learning — Modules, Classes, and Defined Types (Part Two)
=========================================

Now that you have basic classes and modules under control, it's time for some more advanced code re-use. 

* * *

&larr; [Templates](./templates.html) --- [Index](./) --- TBA &rarr;

* * * 

Investigators
-------------

Most classes have to do slightly different things on different systems. You already know some ways to do that --- all of the modules you've written so far have switched their behaviors by looking up system facts. Let's say that they "investigate:" they expect some information to be in a specific place (in the case of facts, a top-scope variable), and go looking for it when they need it. 

But this isn't always the best way to do it, and it starts to break down once you need to switch a module's behavior on information that doesn't map cleanly to system facts. Is this machine a database server? Is it supposed to be running your internal NTP server? These are almost more social distinctions than technical ones. 

So you could still have your modules investigate; instead of looking at the standard set of system facts, you could just point them to an arbitrary variable and make sure it's filled if you plan on using that class.[^olderversions] 

But it might be better to just tell the class what it needs to know when you declare it. 

[^olderversions]: This was the only way to do things in older versions of Puppet, and later I'll go into more detail about how to do this sanely.

Passing Parameters
------------------

When defining a class, you can optionally give it a list of parameters. 

{% highlight ruby %}
    class mysql ($user, $port) {
      ...
    }
{% endhighlight %}

The parameter list is a comma-separated list of variables and, optionally, their default values `($one = "a default value", $two, $three = "another default value")`. Parameters without defaults are required when you eventually declare the class, and parameters with defaults are optional. All of the parameters can be used as normal local variables throughout the class definition. 

Then, when you declare the class, declare each of the parameters as an attribute of the class resource:

{% highlight ruby %}
    class {'mysql':
      user => 'mysql',
      port => '3306',
    }
{% endhighlight %}
