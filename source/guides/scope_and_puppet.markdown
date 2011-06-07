---
layout: default
title: Scope and Puppet
---

Scope and Puppet as of 2.7
==========================

Puppet 2.7 issues deprecation warnings for dynamic variable and resource defaults lookup. Find out why, and learn how to adapt your Puppet code for the future!

* * * 

What's Changing?
----------------

Dynamic scope will be removed from the Puppet language in a future version. **This will be a major and backwards-incompatible change.** Currently, if an unqualified variable isn't defined in the local scope, Puppet looks it up along a chain of parent scopes, eventually ending at top scope; resource defaults (`File{ owner => root, }`, e.g.) travel in much the same way. In the future, Puppet will only examine the local scope and top scope when resolving an unqualified variable or a resource default; intervening scopes will be ignored. **In effect, all variables will be either strictly local or strictly global.** The one exception will be derived classes, which will continue to consult the scope of the base class they inherit from. 

To ease the transition, Puppet 2.7 issues deprecation warnings whenever dynamic variable lookup occurs. You should strongly consider refactoring your code to eliminate these warnings. 

Why?
----

Dynamic scope is confusing and dangerous, and often causes unexpected behavior. There are already better methods for accomplishing everything dynamic scope currently does, but even if you're being good, it can step in to "help" at inopportune moments. Dynamic scope interacts really badly with class inheritance, and it makes the boundaries between classes a lot more porous than good programming practice demands. 

Thus, it's time to bid it a fond farewell.

Making the Switch
-----------------

So you've installed Puppet 2.7 and are ready to start going after those deprecation warnings. What do you do?

### Qualify Your Variables! 

Whenever you need to refer to a variable in another class, give the variable an explicit namespace: instead of simply referring to `$packagelist`, use `$git::core::packagelist`. This is a win in readability --- any casual observer can tell exactly where the variable is being set, without having to model your code in their head --- and it saves you from accidentally getting the value of some completely unrelated `$packagelist` variable.

If you're referring explicitly to a top-scope variable, use the empty namespace (e.g. `$::packagelist`) for extra clarity. 

### Declare Resource Defaults Per-File!

If you're using dynamic scope to share resource defaults, there's no way around it: you'll have to repeat yourself in each file that the defaults apply to. 

But this is not a bad thing! Resource defaults are really just code compression, and were designed to make a single file of Puppet code more concise. By making sure your defaults are always on the same page as the resources they apply to, you'll make your code vastly more legible and predictable. 

If you need to apply resource defaults more broadly, you can still set them at top scope in your primary site manifest. If you need the resource defaults in a class to change depending on where the class is being declared, you need parameterized classes. 

All told, it's more likely that defaults have been traveling through scopes without your knowledge, and the eventual elimination of dynamic scope will just make them act like you thought they were acting. 

### Use Parameterized Classes!

If you need a class to dynamically change its behavior depending on where and how you declare it, it should be rewritten as a parameterized class; see our [guide to using parameterized classes][parameterized] for more details. 

[parameterized]: ./parameterized_classes.html

Appendix: How Scope Works in Puppet ≤ 2.7.x
-------------------------------------------

(Note that nodes defined in the Puppet DSL function identically to classes.) 

* Classes, nodes, and instances of defined types introduce new scopes. 
* When you declare a variable in a scope, it is local to that scope.
* Every scope has one and only one "parent scope."
    * If it's a class that inherits from a base class, its parent scope is the base class.
    * Otherwise, its parent scope is the FIRST scope where that class was declared. (If you are declaring classes in multiple places with `include`, this can be unpredictable. Furthermore, declaring a derived class will implicitly declare the base class in that same scope.)
* If you try to resolve a variable that doesn't exist in the current local scope, lookup proceeds through the chain of parent scopes --- its parent, the parent's parent, and so on, stopping at the first place it finds that variable. 

These rules seem simple enough, so an example is in order:

    # manifests/site.pp
    $nodetype = "base"
    
    node "base" {
        include postfix
        ...snip...
    
    }
    
    node "www01", "www02", ... , "www10" inherits "base" {
         $nodetype = "wwwnode"
         include postfix::custom
    
    }
    
    # modules/postfix/manifests/init.pp
    # (Template stored in modules/postfix/templates/main.cf.erb)
    class postfix {
         package {"postfix": ensure => installed}
         file {"/etc/postfix/main.cf":
              content => template("postfix/main.cf.erb")
         }
    
    }
    
    # modules/postfix/manifests/custom.pp
    class postfix::custom inherits postfix {
         File ["/etc/postfix/main.cf"] {
              content => undef,
              source => [ "puppet:///files/$hostname/main.cf",
                          "puppet:///files/$nodetype/main.cf" ]
         }
    
    } 

When nodes www01 through www10 connect to the puppet master, `$nodetype` will always be set to "base" and main.cf will always be served from files/base/. This is because `postfix::custom`'s chain of parent scopes is `postfix::custom < postfix < base < top-scope`; the combination of inheritance and dynamic scope causes lookup of the `$nodetype` variable to bypass `node 01-10` entirely. 

Thanks to Ben Beuchler for contributing this example.
