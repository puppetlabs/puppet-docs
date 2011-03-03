---
layout: default
title: Learning — Resource Ordering
---

Learning — Resource Ordering
============================

You understand manifests and resource declarations; now learn about metaparameters, resource ordering, and one of the most useful patterns in Puppet.

* * * 

&larr; [Manifests](./manifests.html) --- [Index](./) --- TBA &rarr;

* * * 

[metaparameters]: http://docs.puppetlabs.com/references/latest/metaparameter.html

Disorder
--------

Let's look back on one of our manifests from the last page: 

{% highlight ruby %}
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
{% endhighlight %}

Although we wrote these declarations one after another, Puppet might sync them in any order: unlike with a procedural language, the physical order of resources in a manifest doesn't imply a logical order.

But some resources depend on other resources. So how do we tell Puppet which ones go first?

Metaparameters, Resource References, and Ordering
-------------------------------------------------

{% highlight ruby %}
    file {'/tmp/test1':
        ensure  => present,
        content => "Hi.",
    }
    
    notify {'/tmp/test1 has already been synced.':
        require => File['/tmp/test1'],
    }
{% endhighlight %}

Each resource type has its own set of attributes, but there's another set of attributes, called [metaparameters][], which can be used on any resource. (They're meta because they don't describe any feature of the resource that you could observe on the system after Puppet finishes; they only describe how Puppet should act.)

There are four metaparameters that let you arrange resources in order: `before`, `require`, `notify`, and `subscribe`. All of them accept a **resource reference** (or an array[^array] of them). Resource references look like this:

{% highlight ruby %}
    Type['title']
{% endhighlight %}

(Note the square brackets and capitalized resource type!)

### Before and Require

`before` and `require` make simple dependency relationships, where one resource must be synced before another. `before` is used in the earlier resource, and lists resources that depend on it; `require` is used in the later resource and lists the resources that it depends on. 

These two metaparameters are just different ways of writing the same relationship --- our example above could just as easily be written like this: 

{% highlight ruby %}
    file {'/tmp/test1':
        ensure  => present,
        content => "Hi.",
        before  => Notify['/tmp/test1 has already been synced.'],
        # (See what I meant about symbolic titles being a good idea?)
    }
    
    notify {'/tmp/test1 has already been synced.':}
{% endhighlight %}

### Notify and Subscribe

A few resource types[^refreshtypes] can be **"refreshed"** --- that is, told to react to changes in their environment. For a service, this usually means restarting when a config file has been changed; for an `exec` resource, this could mean running its payload if any user accounts have been changed. (Note that refreshes are performed by Puppet, so they only occur during Puppet runs.) 

The `notify` and `subscribe` metaparameters make dependency relationships the way `before` and `require` do, but they also make **refresh relationships.** Not only will the earlier resource in the pair get synced first, but if Puppet makes any changes to that resource, it will send a refresh event to the later resource, which will react accordingly. 


[^refreshtypes]: Of the built-in types, only `exec`, `service`, and `mount` can be refreshed.

[^array]: Arrays in Puppet are made with square brackets and commas, so an array of resource references would `[ Notify['look'], Notify['like'], Notify['this'] ]`. 

### Chaining

{% highlight ruby %}
    file {'/tmp/test1':
        ensure  => present,
        content => "Hi.",
    }
    
    notify {'after':
        message => '/tmp/test1 has already been synced.',
    }
    
    File['/tmp/test1'] -> Notify['after']
{% endhighlight %}

There's one last way to declare relationships: chain resource references with the ordering (`->`) and notification (`~>`; note the tilde) arrows. The arrows can point in either direction (`<-` works too), and you should think of them as representing the flow of time: the resource at the blunt end of the arrow will be synced _before_ the resource the arrow points at. 

The example above yields the same dependency as the two examples before it. The benefit of this alternate syntax may not be obvious when we're working with simple examples, but it can be much more expressive and legible when we're working with resource collections. 

### Autorequire

Some of Puppet's resource types will notice when an instance is related to other resources, and they'll set up automatic dependencies. The one you'll use most often is between files and their parent directories: if a given file and its parent directory are both being managed as resources, Puppet will make sure to sync the parent directory before the file. 

Don't sweat much about the details of autorequiring; it's fairly conservative and should generally do the right thing without getting in your way. If you forget it's there and make explicit dependencies, your code will still work. 

Summary
-------

So to sum up: whenever a resource depends on another resource, use the `before` or `require` metaparameter or chain the resources with `->`. Whenever a resource needs to refresh when another resource changes, use the `notify` or `subscribe` metaparameter or chain the resources with `~>`. Some resources will autorequire other resources if they see them, which can save you some effort. 

Hopefully that's all pretty clear! But even if it is, it's rather abstract --- making sure a notify fires after a file is something of a "hello world" use case, and not very illustrative. Let's break something!

Example: sshd
-------------

You've probably been using SSH and your favorite terminal app to interact with the Learning Puppet VM, so let's go straight for the most-annoying-case scenario: we'll pretend someone accidentally gave the wrong person (i.e., us) sudo privileges, and have you ruin root's ability to SSH to this box. We'll use Puppet to bust it and Puppet to fix it. 

First, if you got the `ssh_authorized_key` exercise from the last page working, undo it. 

    # mv ~/.ssh/authorized_keys ~/old_ssh_authorized_keys

Now let's get a copy of the current sshd config file; going forward, we'll use our new copy as the canonical source for that file. 

    # cp /etc/ssh/sshd_config ~/learning-manifests/

Next, edit our new copy of the file. There's a line in there that says `PasswordAuthentication yes`; find it, and change the yes to a no. Then start writing some Puppet!

{% highlight ruby %}
    # /root/learning-manifests/break_ssh.pp
    file { '/etc/ssh/sshd_config':
        ensure => file,
        mode   => 600, 
        source => '/root/learning-manifests/sshd_config',
        # And yes, that's the first time we've seen the "source" attribute.
        # It accepts absolute paths and puppet:/// URLs, about which more later.
    }
{% endhighlight %}

Except that won't work! If we apply this manifest, the config file will change, but `sshd` will keep acting on the old config file until it restarts... and if it's only restarting when the system reboots, that could be years from now. If we want the service to change its behavior as soon as we change our policy, we'll have to tell it to monitor the config file.

{% highlight ruby %}
    # /root/learning-manifests/break_ssh.pp, again
    file { '/etc/ssh/sshd_config':
        ensure => file,
        mode   => 600, 
        source => '/root/learning-manifests/sshd_config',
    }
        
    service { 'sshd':
        ensure     => running,
        enable     => true, 
        hasrestart => true,
        hasstatus  => true,
        # FYI, those last two attributes default to false, since
        # bad init scripts are more or less endemic.
        subscribe  => File['/etc/ssh/sshd_config'],
    }
{% endhighlight %}

And that'll do it! Run that manifest with puppet apply, and after you log out, you won't be able to SSH into the VM again. _Victory._

To fix it, you'll have to log into the machine directly --- use the screen provided by your virtualization app. Once you're there, you'll just have to edit `/root/learning-manifests/sshd_config` again to change the `PasswordAuthentication` setting and re-apply the same manifest; Puppet will replace `/etc/ssh/sshd_config` with the new version, restart the service, and re-enable remote password logins. (And you can put your SSH key back now, if you like.)

Package/File/Service
--------------------

The example we just saw was very close to a pattern you'll see constantly in production Puppet code, but it was missing a piece. Let's complete it:

{% highlight ruby %}
    # /root/learning-manifests/break_ssh.pp
    package { 'openssh-server':
        ensure => present,
        before => File['/etc/ssh/sshd_config'],
    }
    
    file { '/etc/ssh/sshd_config':
        ensure => file,
        mode   => 600, 
        source => '/root/learning-manifests/sshd_config',
    }
        
    service { 'sshd':
        ensure     => running,
        enable     => true, 
        hasrestart => true,
        hasstatus  => true,
        subscribe  => File['/etc/ssh/sshd_config'],
    }
{% endhighlight %}

This is **package/file/service,** one of the most useful patterns in Puppet: the package resource makes sure the software is installed, the config file depends on the package resource, and the service subscribes to changes in the config file. 

It's hard to understate the importance of this pattern; if this was all you knew how to do with Puppet, you could still do a fair amount of work. But we're not done yet. 

Next
----

Well, actually we _are_ done for the moment. But not for long! Come back soon to learn about variables, conditionals, and facts; after that, we'll move on to resource collections and modules. Send feedback to <faq@puppetlabs.com>, and thanks for reading. 