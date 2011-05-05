---
layout: default
title: Learning — Modules and Classes 1
---

Learning — Modules and Classes (Part One)
=========================================

You can write some pretty sophisticated manifests at this point, but they're still at a fairly low altitude, going resource-by-resource-by-resource. Now, zoom out with resource collections. 

* * *

&larr; [Variables, etc.](./variables.html) --- [Index](./) --- TBA &rarr;

* * * 

[next]: tba

Collecting, Reusing, Teleporting
--------------------------------

So let's say you've already gotten your security settings written into a manifest. You have manifests that get all your packages installed and your services up and running. The email server is configured, etcetera, etcetera, etcetera. Let's say it's time to start differentiating your app servers from your load balancers, or really just anything interesting and higher-level.

Now, one approach would be to just paste in all your previous code as boilerplate at the top of each later manifest that includes it. _This would actually work._ But it would be a holy terror to keep up to date, it would make things really hard to read, and it would generally be a bad idea all around.

It's kind of like that point in an old-school console RPG where you can roll over any enemy in the first 3/4 of the world but still have to slog back and forth every time you've got an errand to run. It'd be much better to have some kind of warp spell, right?

Thus, resource collections. In a few minutes, you'll be able to maintain your manifest code in one place and declare groups of it like this: 

    class {'security_base': }
    class {'webserver_base': }
    class {'appserver': }

<!-- note to self: be sure to mention scopes. -->

Classes
-------

There are a few types of resource collections in Puppet, but we'll start with classes. 

Classes are singleton collections of resources that Puppet can apply selectively. You can think of them as blocks of code that can be turned on or off.

### Defining

Before you declare a class, you have to **define** it, with the `class` keyword, a name[^classnames], and a block of code.

[^classnames]: Class names have to start with a lowercase letter, and can contain lowercase alphanumeric characters and underscores. Just your standard slightly conservative set of allowed characters. 

{% highlight ruby %}
    # first-class.pp
    
    class someclass {
      TK insert conditional example from the previous chapter
    }
{% endhighlight %}

### Declaring

Notice that applying this manifest doesn't actually _do_ anything:

    # puppet apply first-class.pp
    notice: Finished catalog run in 0.03 seconds

The code inside the class was properly parsed, but the compiler didn't build any of it into the catalog, so none of the resources were synced. For that to happen, the class has to be declared.

Which is easy enough --- each class definition enables a unique instance of the `class` resource type, so you already know the syntax:

{% highlight ruby %}
    # first-class.pp
    
    class someclass {
      TK insert conditional example from the previous chapter
    }
    
    # Then declare it:
    class {'someclass': }
{% endhighlight %}

This time, all those resources will end up in the catalog:

    # puppet apply first-class.pp
    TK insert actual logging output

#### Include

There's another way to declare classes, but it behaves a little bit differently:

    include someclass
    include someclass
    include someclass

There are two main differences between the include function and the standard class declaration: it's slightly cleaner-looking, and it can be safely used multiple times. 