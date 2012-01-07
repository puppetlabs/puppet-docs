---
layout: default
title: Learning — Manifests
---

Learning — Manifests
====================

You understand the RAL; now learn about manifests and start writing and applying Puppet code.

* * *

&larr; [Resources and the RAL](./ral.html) --- [Index](./) --- [Resource Ordering](./ordering.html) &rarr;

* * *

[2state]: ./images/manifest_to_defined_state_unified.png
[cheat]: http://docs.puppetlabs.com/puppet_core_types_cheatsheet.pdf

No Strings Attached
-------------------

You probably already know that Puppet usually runs in an agent/master (that is, client/server) configuration, but ignore that for now. It's not important yet and you can get a lot done without it, so for the time being, we have no strings on us.

Instead, we're going to use [puppet apply](../guides/tools.html#puppet-apply-or-puppet), which applies a manifest on the local system. It's the simplest way to run Puppet, and it works like this:

    $ puppet apply my_test_manifest.pp

Yeah, that easy.

You can use `puppet` --- that is, without any subcommand --- as a shortcut for `puppet apply`; it has the rockstar parking in the UI because of how often it runs at an interactive command line. I'll mostly be saying "puppet apply" for clarity's sake.

The behavior of Puppet's man pages is currently in flux. You can always get help for Puppet's command line tools by running the tool with the `--help` flag; in the Learning Puppet VM, which uses Puppet Enterprise, you can also run `pe-man puppet apply` to get the same help in a different format. Versions of Puppet starting with the upcoming 2.7 will use Git-style man pages (`man puppet-apply`) with improved formatting.

Manifests
---------

Puppet programs are called "manifests," and they use the .pp file extension.

The core of the Puppet language is the _resource declaration,_ which represents the desired state of one resource. Manifests can also use conditional statements, group resources into collections, generate text with functions, reference code in other manifests, and do many other things, but it all ultimately comes down to making sure the right resources are being managed the right way.

An Aside: Compilation
---------------------

Manifests don't get used directly when Puppet syncs resources. Instead, the flow of a Puppet run goes a little like this:

![Diagram: Manifests are compiled into a catalog, which is then applied to yield the desired system state.][2state]

Before being applied, manifests get compiled into a **"catalog,"** which is a [directed acyclic graph][dag] that only represents resources and the order in which they need to be synced. All of the conditional logic, data lookup, variable interpolation, and resource grouping gets computed away during compilation, and the catalog doesn't have any of it.

Why? Several really good reasons, which we'll get to once we rediscover agent/master Puppet;[^reasons] it's not urgent at the moment. But I'm mentioning it now as kind of an experiment: I think there are several things in Puppet that are easy to explain if you understand that split and quite baffling if you don't, so try keeping this in the back of your head and we'll see if it pays off later.

OK, enough about that; let's write some code! This will all be happening on your main Learning Puppet VM, so log in as root now; you'll probably want to stash these test manifests somewhere convenient, like `/root/learning-manifests`.

[^reasons]: There are also a few I can mention now, actually. If you drastically refactor your manifest code and want to make sure it still generates the same configurations, you can just intercept the catalogs and use a special diff tool on them; if the same nodes get the same configurations, you can be sure the code acts the same without having to model the execution of the code in your head. Compiling to a catalog also makes it much easier to simulate applying a configuration, and since the catalog is just data, it's relatively easy to parse and analyze with your own tool of choice.
[dag]: http://en.wikipedia.org/wiki/Directed_acyclic_graph

Resource Declarations
---------------------

Let's start by just declaring a single resource:

{% highlight ruby %}
    # /root/training-manifests/1.file.pp

    file {'testfile':
      path    => '/tmp/testfile',
      ensure  => present,
      mode    => 0640,
      content => "I'm a test file.",
    }
{% endhighlight %}

And apply!

    # puppet apply 1.file.pp
    notice: /Stage[main]//File[testfile]/ensure: created
    # cat /tmp/testfile
    I'm a test file.
    # ls -lah /tmp/testfile
    -rw-r----- 1 root root 16 Feb 23 13:15 /tmp/testfile

You've seen this syntax before, but let's take a closer look at the language here.

* First, you have the **type** ("file"), followed by...
* ...a pair of curly braces that encloses everything else about the resource. Inside those, you have...
    * ...the resource **title,** followed by a colon...
    * ...and then a set of **attribute `=>` value** pairs describing the resource.


A few other notes about syntax:

* Missing commas and colons are the number one syntax error made by learners. If you take out the comma after `ensure => present` in the example above, you'll get an error like this:

        Could not parse for environment production: Syntax error at 'mode'; expected '}' at /root/manifests/1.file.pp:6 on node barn2.magpie.lan

    Missing colons do about the same thing. So watch for that. Also, although you don't strictly need the comma after the final attribute `=>` value pair, you should always put it there anyhow. Trust me.
* Capitalization matters! You can't declare a resource with `File {'testfile:'...`, because that does something entirely different. (Specifically, it breaks. But it's _kind_ of similar to what we use to tweak an existing resource, which we'll get to later.)
* Quoting values matters! Built-in values like `present` shouldn't be quoted, but normal strings should be. For all intents and purposes, everything is a string, including numbers. Puppet uses the same rules for single and double quotes as everyone else:
    * Single quotes are completely literal, except that you write a literal quote with `\'` and a literal backslash with `\\`.
    * Double quotes let you interpolate $variables and add newlines with `\n`.
* Whitespace is fungible for readability. Lining up the `=>` arrows (sometimes called "fat commas") is good practice if you ever expect someone else to read this code --- note that future and mirror universe versions of yourself count as "someone else."

> **Exercise:** Declare a file resource in a manifest and apply it! Try changing the login message by setting the content of `/etc/motd`.

Once More, With Feeling!
------------------------

Okay, you sort of have the idea by now. Let's make a whole wad of totally useless files! (And throw in some `notify` resources for good measure.)

{% highlight ruby %}
    # /root/training-manifests/2.file.pp

    file {'/tmp/test1':
      ensure  => present,
      content => "Hi.",
    }

    file {'/tmp/test2':
      ensure => directory,
      mode   => 0644,
    }

    file {'/tmp/test3':
      ensure => link,
      target => '/tmp/test1',
    }

    notify {"I'm notifying you.":} # Whitespace is fungible, remember.
    notify {"So am I!":}
{% endhighlight %}

    # puppet apply 2.file.pp
    notice: /Stage[main]//File[/tmp/test2]/ensure: created
    notice: /Stage[main]//File[/tmp/test3]/ensure: created
    notice: /Stage[main]//File[/tmp/test1]/ensure: created
    notice: I'm notifying you.
    notice: /Stage[main]//Notify[I'm notifying you.]/message: defined 'message' as 'I'm notifying you.'
    notice: So am I!
    notice: /Stage[main]//Notify[So am I!]/message: defined 'message' as 'So am I!'

    # ls -lah /tmp/test*
    -rw-r--r--  1 root root    3 Feb 23 15:54 test1
    lrwxrwxrwx  1 root root   10 Feb 23 15:54 test3 -> /tmp/test1
    -rw-r-----  1 root root   16 Feb 23 15:05 testfile

    /tmp/test2:
    total 16K
    drwxr-xr-x 2 root root 4.0K Feb 23 16:02 .
    drwxrwxrwt 5 root root 4.0K Feb 23 16:02 ..

    # cat /tmp/test3
    Hi.

That was totally awesome. What just happened?

### Titles and Namevars

All right, notice how we left out some important attributes there and everything still worked? Almost every resource type has one attribute whose value defaults to the resource's title. For the `file` resource, that's `path`; with `notify`, it's `message`. A lot of the time (`user`, `group`, `package`...), it's plain old `name`.

To people who occasionally delve into the Puppet source code, the one attribute that defaults to the title is called the **"namevar,"** which is a little weird but as good a name as any. It's almost always the attribute that amounts to the resource's _identity,_ the one thing that should always be unique about each instance.

This can be a convenient shortcut, but be wary of overusing it; there are several common cases where it makes more sense to give a resource a symbolic title and assign its name (-var) as a normal attribute. In particular, it's a good idea to do so if a resource's name is long or you want to assign the name conditionally depending on the nature of the system.

{% highlight ruby %}
    notify {'bignotify':
      message => "I'm completely enormous, and will mess up the formatting of your
          code! Also, since I need to fire before some other resource, you'll need
          to refer to me by title later using the Notify['title'] syntax, and you
          really don't want to have to type this all over again.",
    }
{% endhighlight %}

The upshot is that our `notify {"I'm notifying you.":}` resource above has the exact same effect as:

{% highlight ruby %}
    notify {'other title':
      message => "I'm notifying you.",
    }
{% endhighlight %}

... because the `message` attribute just steals the resource title if you don't give it anything of its own.

You can't declare the same resource twice: Puppet will always keep you from making resources with duplicate titles, and will almost always keep you from making resources with duplicate name/namevar values. (`exec` resources are the main exception.)

And finally, you don't need an encyclopedic memory of what the namevar is for each resource --- when in doubt, just choose a descriptive title and specify the attributes you need.

### 644 = 755 For Directories

We said `/tmp/test2/` should have permissions mode 0644, but our `ls -lah` showed mode 0755. That's because Puppet groups the read bit and the traverse bit for directories, which is almost always what you actually want. The idea is to let you recursively manage whole directories as mode 0644 without making all their files executable.

### New Ensure Values

The `file` type has several different values for its ensure attribute: `present`, `absent`, `file`, `directory`, and `link`. They're listed on the [core types cheat sheet][cheat] whenever you need to refresh your memory, and they're fairly self-explanatory.

The Destination
---------------

Here's a pretty crucial part of learning to think like a Puppet user. Try applying that manifest again.

    # puppet apply 2.file.pp
    notice: I'm notifying you.
    notice: /Stage[main]//Notify[I'm notifying you.]/message: defined 'message' as 'I'm notifying you.'
    notice: So am I!
    notice: /Stage[main]//Notify[So am I!]/message: defined 'message' as 'So am I!'

And again!

    # rm /tmp/test3
    # puppet apply 2.file.pp
    notice: I'm notifying you.
    notice: /Stage[main]//Notify[I'm notifying you.]/message: defined 'message' as 'I'm notifying you.'
    notice: /Stage[main]//File[/tmp/test3]/ensure: created
    notice: So am I!
    notice: /Stage[main]//Notify[So am I!]/message: defined 'message' as 'So am I!'

The notifies are firing every time, because that's what they're for, but Puppet doesn't do anything with the file resources unless they're wrong on disk; if they're wrong, it makes them right. Remember how I said Puppet was declarative? This is how that pays off: You can apply the same configuration every half hour without having to know anything about how the system currently looks. Manifests describe the destination, and Puppet handles the journey.

> **Exercise:** Write and apply a manifest that'll make sure Apache (`httpd`) is running, use a web browser on your host OS to view the Apache welcome page, then modify the manifest to turn Apache back off. (Hint: You'll have to check the [cheat sheet][cheat] or the [types reference](http://docs.puppetlabs.com/references/stable/type.html), because the `service` type's `ensure` values differ from the ones you've seen so far.)

> **Slightly more difficult exercise:** Write and apply a manifest that uses the [`ssh_authorized_key`](http://docs.puppetlabs.com/references/stable/type.html#sshauthorizedkey) type to let you log into the learning VM as root without a password. You'll need to already have an SSH key.

Next
----

Resource declarations: Check! You know how to use the fundamental building blocks of Puppet code, so now it's time to learn [how those blocks fit together](./ordering.html).
