---
layout: default
title: Learning Puppet — Resource Ordering
---

[variables]: ./variables.html
[metaparameters]: /puppet/latest/reference/lang_resources.html#metaparameters
[resource_reference]: /puppet/latest/reference/lang_datatypes.html#resource-references
[lang_relationships]: /puppet/latest/reference/lang_relationships.html
[array]: /puppet/latest/reference/lang_datatypes.html#arrays
[chaining]: /puppet/latest/reference/lang_relationships.html#chaining-arrows

Disorder
--------

Let's look back on one of our manifests from the last page:

~~~ ruby
    # /root/training-manifests/2.file.pp

    file {'/tmp/test1':
      ensure  => present,
      content => "Hi.",
    }

    file {'/tmp/test2':
      ensure => directory,
      mode   => 644,
    }

    file {'/tmp/test3':
      ensure => link,
      target => '/tmp/test1',
    }

    notify {"I'm notifying you.":}
    notify {"So am I!":}
~~~

When we ran this, the resources weren't synced in the order we wrote them: it went `/tmp/test1`, `/tmp/test3`, `/tmp/test2`, `So am I!`, and `I'm notifying you.`

Like we mentioned in the last chapter, Puppet combines "check the state" and "fix any problems" into a single declaration for each resource. Since each resource is represented by one atomic statement, ordering within a file matters a lot less than it would for an equivalent script.

Or rather, it matters less as long as the resources are independent and not related to each other. And most resources are! But some resources depend on other resources. Consider a service which is installed by a package --- it's impossible to get the service into its desired state if the package isn't installed yet. The service has a _dependency_ on the package.

So when dealing with related resources, Puppet has ways to express those relationships.

> ### Summary of This Page
>
> * You can embed relationship information in a resource with the `before`, `require`, `notify`, and `subscribe` metaparameters.
> * You can also declare relationships outside a resource with the `->` and `~>` chaining arrows.
> * Relationships can be either ordering (this before that) or ordering-with-notification (this before that, and tell that whether this was changed).
> * Puppet's relationship behaviors and syntaxes are documented in [the Puppet reference manual page on relationships.][lang_relationships]
> * The `ordering` setting in `puppet.conf` determines the order in which unrelated resources are applied.

Metaparameters, Resource References, and Ordering
-------------------------------------------------

Here's a notify resource that depends on a file resource:

~~~ ruby
    file {'/tmp/test1':
      ensure  => present,
      content => "Hi.",
    }

    notify {'/tmp/test1 has already been synced.':
      require => File['/tmp/test1'],
    }
~~~

Each resource type has its own set of attributes, but there's another set of attributes, called [metaparameters][], which can be used on any resource. (They're "meta" because they don't describe any feature of the resource that you could observe on the system after Puppet finishes; they only describe how Puppet should act.)

There are four metaparameters that let you arrange resources in order:

* `before`
* `require`
* `notify`
* `subscribe`

All of them accept a [**resource reference**][resource_reference] (or an [array][] of them) as their value. Resource references look like this:

~~~ ruby
    Type['title']
~~~

(Note the square brackets and capitalized resource type!)

> #### Aside: When to Capitalize
>
> The easy way to remember this is that you _only_ use the lowercase type name when _declaring a new resource._ Any other situation will always call for a capitalized type name.

### Before and Require

`before` and `require` make simple dependency relationships, where one resource must be synced before another. `before` is used in the earlier resource, and lists resources that depend on it; `require` is used in the later resource, and lists the resources that it depends on.

These two metaparameters are just different ways of writing the same relationship --- our example above could just as easily be written like this:

~~~ ruby
    file {'/tmp/test1':
      ensure  => present,
      content => "Hi.",
      before  => Notify['/tmp/test1 has already been synced.'],
    }

    notify {'/tmp/test1 has already been synced.':}
~~~

### Notify and Subscribe

A few resource types (`service`, `exec`, and `mount`) can be **"refreshed"** --- that is, told to react to changes in their environment. For a service, this usually means restarting when a config file has been changed; for an `exec` resource, this could mean running its payload if any user accounts have been changed. (Note that refreshes are performed by Puppet, so they only occur during Puppet runs.)

The `notify` and `subscribe` metaparameters make dependency relationships the way `before` and `require` do, but they also make **notification relationships.** Not only will the earlier resource in the pair get synced first, but if Puppet makes any changes to that resource, it will send a refresh event to the later resource, which will react accordingly.

An example of a notification relationship:

~~~ ruby
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => 600,
      source => 'puppet:///modules/ssh/sshd_config',
    }
    service { 'sshd':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/ssh/sshd_config'],
    }
~~~

In this example, the `sshd` service will be restarted if Puppet has to edit its config file.

Chaining Arrows
-----

There's one last way to declare relationships: chain resource references with the [ordering (`->`) and notification (`~>`; note the tilde) arrows.][chaining] Think of them as representing the flow of time: the resource behind the arrow will be synced _before_ the resource the arrow points at.

This example causes the same dependency as the similar examples above:

~~~ ruby
    file {'/tmp/test1':
      ensure  => present,
      content => "Hi.",
    }

    notify {'after':
      message => '/tmp/test1 has already been synced.',
    }

    File['/tmp/test1'] -> Notify['after']
~~~

Chaining arrows can take several things as their operands: this example uses resource references, but they can also take resource declarations and [resource collectors](/puppet/latest/reference/lang_collectors.html).

Since whitespace is freely adjustable in Puppet, and since chaining arrows can go between resource declarations, it's easy to make a short run of resources be synced in the order they're written --- just put chaining arrows between them:

~~~ ruby
    file {'/tmp/test1':
      ensure  => present,
      content => "Hi.",
    }
    ->
    notify {'after':
      message => '/tmp/test1 has already been synced.',
    }
~~~

Again, this creates the same relationship we've seen previously.

Autorequire
-----

Some of Puppet's resource types will notice when an instance is related to other resources, and they'll set up automatic dependencies. The one you'll use most often is between files and their parent directories: if a given file and its parent directory are both being managed as resources, Puppet will make sure to sync the parent directory before the file. **This never creates new resources;** it only adds dependencies to resources that are already being managed.

Don't sweat much about the details of autorequiring; it's fairly conservative and should generally do the right thing without getting in your way. If you forget it's there and make explicit dependencies, your code will still work. Explicit dependencies will also override autorequires, if they conflict.

Unrelated Resources and the `ordering` Setting
-----

For resources that are not associated with metaparameters, chaining arrows, or autorequire, Puppet assumes that they can be applied in any order at all. The idea is that any logical restrictions on resource ordering should be declared explicitly and not simply implied by, say, the order in which they appear in a manifest.

That said, you can set `ordering = manifest` in `/etc/puppetlabs/puppet/puppet.conf` to have Puppet follow manifest ordering **as a fallback** for unrelated resources. All of the above metaparameters will still work as described, but if nothing else gives one resource priority over another, then the resource that appears first in the manifest will be applied first.


Example: sshd
-------------

Hopefully that's all pretty clear! But even if it is, it's rather abstract --- making sure a notify fires after a file is something of a "hello world" use case, and not very illustrative. Let's break something!

You've probably been using SSH and your favorite terminal app to interact with the Learning Puppet VM, so let's go straight for the most-annoying-case scenario: we'll pretend someone accidentally gave the wrong person (i.e., us) sudo privileges, and they ruined root's ability to SSH to this box.

### Prepare

Let's get a copy of the current sshd config file; going forward, we'll use our new copy as the canonical source for that file.

    # cp /etc/ssh/sshd_config ~/examples/

Now we'll write some Puppet code to manage the file:

~~~ ruby
    # /root/examples/break_ssh.pp (incomplete)
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => 600,
      source => '/root/examples/sshd_config',
      # And yes, that's the first time we've used the "source" attribute. It accepts
      # absolute local paths and puppet:/// URLs, which we'll say more about later.
    }
~~~

This is only half of what we need, though. It will change the config file, but those changes will only take effect when the service restarts, which could be years from now.

To make the service restart whenever we make changes to the config, we should tell Puppet to manage the `sshd` service and have it subscribe to the config file:

~~~ ruby
    # /root/examples/break_ssh.pp
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => 600,
      source => '/root/examples/sshd_config',
    }
    service { 'sshd':
      ensure     => running,
      enable     => true,
      subscribe  => File['/etc/ssh/sshd_config'],
    }
~~~

### Manage

Great, we have our Puppet code; now paste it into `/etc/puppetlabs/puppet/manifests/site.pp`, so that puppet agent will manage those resources.

### Break

Next, edit the original `/etc/ssh/sshd_config` file. There's a commented-out line in there that says `#PermitRootLogin yes`; find it, remove the comment, and change the yes to a no:

    PermitRootLogin no

Now manually restart the sshd service:

    # service sshd restart

... and log out. You should no longer be able to log in as root over SSH; test it to make sure. (Although you can still log in via your virtualization software's console.)

### Fix

Actually, now that you've added those resources to site.pp, Puppet will fix this automatically within about half an hour. But if you're impatient, you can [log in to the Puppet Enterprise console](./ral.html#logging-in), then [trigger a puppet agent run](/pe/latest/orchestration_puppet.html) in the live management page.

And that'll do it! After the Puppet run has completed and you can see the report appear in the console (it will have a blue icon, to show that changes were made), you should be able to log in as root via SSH again. _Victory._

> #### No Changes? No Refresh
>
> There's an odd situation you can get into if you apply a manifest that makes config file changes before you finish writing it.
>
> Puppet only sends refresh events if it makes changes to the notifying resource in _this run._ So if you wrote a file resource with new desired content for a config file, applied the manifest, then edited the manifest again to create a refresh relationship with a service, the service would miss its refresh, since the file resource would already be in its desired state.
>
> This will generally only happen to you on the machines you're testing early versions of manifests on, rather than your production boxes. If it does bite you, you can restart the service manually with [the "Advanced Tasks" section of the PE console's live management page](/pe/latest/console_navigating_live_mgmt.html#the-advanced-tasks-tab) --- use the "restart" action in the "service tasks" section.


Package/File/Service
--------------------

The example we just saw was very close to a pattern you'll see constantly in production Puppet code, but it was missing a piece. Let's complete it:

~~~ ruby
    # /root/examples/break_ssh.pp
    package { 'openssh-server':
      ensure => present,
      before => File['/etc/ssh/sshd_config'],
    }
    file { '/etc/ssh/sshd_config':
      ensure => file,
      mode   => 600,
      source => '/root/examples/sshd_config',
    }
    service { 'sshd':
      ensure     => running,
      enable     => true,
      subscribe  => File['/etc/ssh/sshd_config'],
    }
~~~

This is the **package/file/service** pattern, one of the most useful idioms in Puppet: the package resource makes sure the software and its config file are installed, the config file depends on the package resource, and the service subscribes to changes in the config file.

It's hard to overstate the importance of this pattern! If you stopped here and only learned this, you could still get a lot of work done.


> ### Exercise: Apache
>
> Write and apply a manifest that will install the Apache [package](/references/latest/type.html#package), then make sure the Apache [service](/references/latest/type.html#service) is running. Prove that it worked by using a web browser on your host OS to view the Apache welcome page.
>
> **Bonus work:** Manage the httpd.conf file, and have it notify the service. Force Apache to be kept at a certain version (note that you'll have to research the format of the version strings for your operating system, as well as which versions are available).
>
> Hints:
>
> * On modern Red Hat-like (your VM) and Debian-like Linux systems, packages are installed from the operating system's Apt or Yum repositories. Since the system tools know how to find and install a package (or even a specific version of a package), all Puppet needs to know is `ensure => installed`; it doesn't need to know where the package lives.
> * The names of package and service resources depend on the OS's own naming conventions. This means you often need to do a bit of research before writing a manifest, to learn what the local name for, e.g., the Apache package and service are. On CentOS, which your VM runs, both the package and service are named `httpd`.
> * Make sure you're using the right `ensure` values for each resource type; they aren't the same for package, file, and service.
> * The [core types cheat sheet][cheat] and the [type reference](/references/stable/type.html) are your friends.

[cheat]: /puppet_core_types_cheatsheet.pdf


Next
----

**Next Lesson:**

Now that you can express dependencies between resources, it's time to make your manifests more aware of the outside world with [variables, facts, and conditionals][variables].

**Off-Road:**

Now that you can manage a complete service from top to bottom, try managing an important service on your own test systems. [Download Puppet Enterprise for free][dl], follow [the quick start guide][quick] to get a small environment installed, then try building a package/file/service pattern at the bottom of the puppet master's `/etc/puppetlabs/puppet/manifests/site.pp` file. MySQL? Memcached? You decide.


[dl]: http://info.puppetlabs.com/download-pe.html
[quick]: /pe/latest/quick_start.html
