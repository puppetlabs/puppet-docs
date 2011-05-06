---
layout: default
title: Learning — Modules 1
---

Learning — Modules and Classes (Part One)
=========================================

You can write some pretty sophisticated manifests at this point, but they're still at a fairly low altitude, going resource-by-resource-by-resource. Now, zoom out with resource collections. 

* * *

&larr; [Variables, etc.](./variables.html) --- [Index](./) --- TBA &rarr;

* * * 

[next]: tba
[smoke]: http://docs.puppetlabs.com/guides/tests_smoke.html
[manifestsdir]: not-typed-yet

Collecting, Reusing, Teleporting
--------------------------------

So let's say you've already gotten your security settings written into a manifest. You have manifests that get all your packages installed and your services up and running. The email server is configured, etcetera, etcetera, etcetera. Let's say it's time to start differentiating your app servers from your load balancers, or really just anything interesting and higher-level.

Now, one approach would be to just paste in all your previous code as boilerplate at the top of each later manifest that includes it. _This would actually work._ But it would be a holy terror to keep up to date, would make things really hard to read, and is basically just a bad idea.

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

Before you declare a class, you have to **define** it, with the `class` keyword, a name, and a block of code.

{% highlight ruby %}
    # first-class.pp
    
    class someclass {
      TK insert conditional example from the previous chapter
    }
{% endhighlight %}

#### An Aside: Names and Namespaces

Class names have to start with a lowercase letter, and can contain lowercase alphanumeric characters and underscores. It's your standard slightly conservative set of allowed characters. 

Class names can also use a double colon (`::`) as a namespace separator. (Yes, this should [look familiar](http://localhost:9292/learning/variables.html#variables).) This is a good way to show which classes are related to each other; for example, you can tell right away that something's going on with `apache::ssl` and `apache::vhost`. 

This is going to get a lot more important about [two feet south of here][manifestsdir]. 

### Declaring

Notice that applying this manifest doesn't actually _do_ anything:

    # puppet apply first-class.pp
    notice: Finished catalog run in 0.03 seconds

The code inside the class was properly parsed, but the compiler didn't build any of it into the catalog, so none of the resources got synced. For that to happen, the class has to be declared.

Which is easy enough --- each class definition just enables a unique instance of the `class` resource type, so you already know the syntax:

{% highlight ruby %}
    # first-class.pp
    
    class someclass {
      TK insert conditional example from the previous chapter
    }
    
    # Then declare it:
    class {'someclass': }
    # Note that this class has a title but no attributes. We'll get there later.
{% endhighlight %}

This time, all those resources will end up in the catalog:

    # puppet apply first-class.pp
    TK insert actual logging output

#### Include

There's another way to declare classes, but it behaves a little bit differently:

    include someclass
    include someclass
    include someclass

The `include` function will declare a class if it hasn't already been declared, and will do nothing if it has. This means you can safely use it multiple times, whereas the resource syntax will fail if you try that. 

The drawback is that `include` can't currently be used with parameterized classes, but we'll get to that later. 

### Classes In Situ

You've probably already guessed that classes aren't enough: even with the code above, you'd still have to paste the `someclass` definition into your other manifests. So it's time to meet the **module autoloader!**

### An Aside: Printing Config

But first, we'll need to meet its friend, the `modulepath`.

    # puppet apply --configprint modulepath
    /etc/puppetlabs/puppet/modules

By the way, Puppet has a lot of configuration options. It ships with various defaults, and all of the site-specific overrides are stored in the puppet.conf file. Or, as the configuration system knows it, `config`[^configfile]:

    # puppet apply --configprint config
    /etc/puppetlabs/puppet/puppet.conf

Most of the puppet tools will take the `--configprint` flag, which tells them to print a single configuration value (or all of them, if you give it an argument of "all") and exit. Since the various files, directories, and settings can vary pretty wildly from site to site, and since it's not necessarily easy to remember the defaults if the value you're looking for isn't in puppet.conf, `--configprint` is quite useful. 

[^configfile]: Puppet Enterprise and the community release of Puppet keep the file in different places.

Modules
-------

So anyway, modules are re-usable bundles of functionality. Puppet autoloads modules from the directories in its `modulepath`, which means you can declare a class stored in a module anywhere. Let's just convert that last class to a module now, so you can see what we're talking about:

    # cd /etc/puppetlabs/puppet/modules
    # mkdir someclass; cd someclass; mkdir manifests; cd manifests
    # vim init.pp

{% highlight ruby %}
    # init.pp
    
    class someclass {
      TK insert conditional example from the previous chapter
    }
{% endhighlight %}

And now, the reveal:[^dashe]

    # cd
    # puppet apply -e "class {'someclass':}"
    TK insert actual log output

Right? Awesome.

[^dashe]: The `-e` flag lets you give puppet apply a line of manifest code instead of a file, same as with Perl or Ruby.

### Module Structure

A module is just a directory with stuff in it, and the magic comes when the autoloader finds what it's looking for. So here's what it's expecting to see:

* {module}/
    * files/
    * lib/
    * manifests/
        * init.pp
        * {class}.pp
        * {class}.pp
        * {defined type}.pp[^definedtypes]
        * {namespace}/
            * {class}.pp
            * {class}.pp
    * templates/
    * tests/

[^definedtypes]: Patience---those're coming up next lesson.

The main directory should be named after the module. All of the manifests go in the `manifests` directory. Each manifest contains only one class (or defined type). There's a special manifest called `init.pp` that holds the module's main class, which should have the same name as the module. That's your basic module: module folder, manifests folder, init.pp, just like we used in the someclass module above. 

But if that was all a module was, it'd make more sense to just load your classes from one flat folder. Modules really come into their own with namespacing and grouping of classes. 

### Namespacing and Autoloading

The manifests directory can hold any number of other classes and even folders of classes, and Puppet uses [namespacing](#an-aside-names-and-namespaces) to find them. Say we have a manifests folder that looks like this: 

* foo/
    * manifests/
        * init.pp
        * bar.pp
        * bar/
            * baz.pp

The init.pp file should contain the class `foo`, bar.pp should contain `foo::bar`, and baz.pp should contain `foo::bar::baz`. 

This can be a little disorienting at first, but I promise you'll get used to it. Basically, init.pp is special, and the classes in all of the other manifest files live under the module's namespace. (You have to reiterate this when you're defining the classes, like `class foo::bar { ... }`.) If you add any more levels of directory hierarchy, they get interpreted as more levels of namespace hierarchy. 

### Other Directories

We'll get more detail on all of these in due time, but here's the fast version:

#### Tests

The tests directory also holds manifest files, and it should look exactly the same as the manifests directory: one .pp file for each of the classes or defined types the module implements. But instead of defining classes, the tests just declare them.

The value here is that you can run puppet apply with `--noop` on these manifests, and if the class definition is broken, it'll tell you so. It'll also generate a list of the sync events that would have occurred, and the tests can even serve as some bare-bones documentation for the class's prerequisites. 

#### Files

Puppet can serve files! More on this once we get into agent/master Puppet. Like with manifests, there's some magical lookup tricks to take advantage of. 

#### Templates
