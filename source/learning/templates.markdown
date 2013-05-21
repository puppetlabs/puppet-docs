---
layout: legacy
title: Learning — Templates
---

Learning — Templates
=========

File serving isn't the be-all/end-all of getting content into place. Before we get to parameterized classes and defined types, take a break to learn about templates, which let you make your config files as versatile as your manifests.

* * *

&larr; [Modules (part one)](./modules1.html) --- [Index](./) --- [Modules (part two)](./modules2.html) &rarr;

* * * 

[erb]: http://ruby-doc.org/stdlib-1.8.7/libdoc/erb/rdoc/ERB.html
[template_syntax]: /guides/templating.html#erb-template-syntax

Templating
------

Okay: in the last chapter, you built a module that shipped and managed a configuration file, which was pretty cool. And if you expect all your enterprise Linux systems to use the exact same set of NTP servers, that's probably good enough. Except let's say you decide most of your machines should use internal NTP servers --- whose ntpd configurations are also managed by Puppet, and which should be asking for the time from an external source. The number of files you'll need to ship just multiplied, and they'll only differ by three or four lines, which seems redundant and wasteful. 

It would be much better if you could use all the tricks you learned in [Variables, Conditionals, and Facts](./variables.html) to rummage around in the actual text of your configuration files. Thus: templates!

Puppet can use ERB templates ([Ruby documentation][erb] / [syntax cheat sheet][template_syntax]) anywhere a string is called for. (Like a file's `content` attribute, for instance, or the value of a variable.) Templates go in the (wait for it) `templates/` directory of a module, and will mostly look like normal configuration files (or what-have-you), except for the occasional `<% tag with Ruby code %>`.

Yes, Ruby --- unfortunately you can't use the Puppet language in templates. But usually you'll only be printing a variable or doing a simple loop, which you'll get a feel for almost instantly. Anyway, let's cut to the chase: 

Some Simple ERB
-----

First, keep in mind that **facts, global variables,** and **variables defined in the current scope** are available to a template as standard Ruby local variables, which are plain words without a `$` sigil in front of them. Variables from other scopes are reachable, but to read them, you have to call the `lookupvar` method on the `scope` object. (For example, `scope.lookupvar('apache::user')`.) 

Facts and global or local variables are also available in templates as instance variables --- that is, `@fqdn, @memoryfree, @operatingsystem`, etc.

### Tags

ERB tags are delimited by angle brackets with percent signs just inside. (There isn't any HTML-like concept of opening or closing tags.)

{% highlight erb %}
    <% document = "" %>
{% endhighlight %}

Tags contain one or more lines of Ruby code, which can set variables, munge data, implement control flow, or... actually, pretty much anything, except for print text in the rendered output.

### Printing an Expression

For that, you need to use a printing tag, which looks like a normal tag with an equals sign right after the opening delimiter:

{% highlight erb %}
    <%= sectionheader %>
      environment = <%= gitrevision[0,5] %>
{% endhighlight %}

The value you print can be a simple variable, or it can be an arbitrarily complicated Ruby expression.

### Comments

A tag with a hash mark right after the opening delimiter can hold comments, which aren't interpreted as code and aren't displayed in the rendered output. 

{% highlight erb %}
    <%# This comment will be ignored. %>
{% endhighlight %}

### Suppressing Line Breaks

Regular tags don't print anything, but if you keep each tag of logic on its own line, the line breaks you use will show up as a swath of whitespace in the final file. If you don't like that, you can make ERB trim the line break by putting a hyphen directly before the closing delimiter. 

{% highlight erb %}
    <% document += thisline -%>
{% endhighlight %}

Rendering a Template
-----

To render output from a template, use Puppet's built-in `template` function: 

{% highlight ruby %}
    file {'/etc/foo.conf':
      ensure  => file,
      require => Package['foo'],
      content => template('foo/foo.conf.erb'),
    }
{% endhighlight %}

This evaluates the template and turns it into a string. Here, we're using that string as the `content`[^timing] of a file resource, but like I said above, we could be using it for pretty much anything. **Note that the path to the template doesn't use the same semantics as the path in a `puppet:///` URL**[^paths] --- it should be in the form `<module name>/<path relative to module's templates directory>`. (That is, `template('foo/foo.conf.erb')` points to `/etc/puppetlabs/puppet/modules/foo/templates/foo.conf.erb`.)

As a sidenote: if you give more than one argument to the template function...

{% highlight ruby %}
    template('foo/one.erb', 'foo/two.erb')
{% endhighlight %}

...it will evaluate each of the templates, then concatenate their outputs and return a single string. 

For more details on the behavior of Puppet templates, see [the guide for Using Puppet Templates][pgtemplating].

[4885]: http://projects.puppetlabs.com/issues/4885
[pgtemplating]: /guides/templating.html
[^timing]: This is a good time to remind you that filling a `content` attribute  happens during catalog compilation, and serving a file with a `puppet:///` URL happens during catalog application. Again, this doesn't matter right now, but it may make some things clearer later.
[^paths]: This inconsistency is one of those problems that tend to crop up over time when software grows organically. We're working on it, and you can keep an eye on [ticket #4885][4885] if that sort of thing interests you.

### An Aside: Other Functions

Since we just went over the template function, this is as good a time as any to cover functions in general. 

Most of the Puppet language consists of ways to say "Here is a thing, and this is what it is" --- resource declarations, class definitions, variable assignments, and the like. Functions are ways to say "Do _something._" They're a bucket for miscellaneous functionality. (You can even write new functions in Ruby and distribute them in modules, if you need to repeatedly munge data or modify your catalogs in some way.)

Puppet's functions are run during catalog compilation,[^agent] and they're pretty intuitive to call; it's basically just `function(argument, argument, argument)`, and you can optionally leave off the parentheses. (Remember that `include` is also a function.) Some functions (like `template`) get replaced with a return value, and others (like `include`) take effect silently. 

You can read the full list of available functions at the [function reference](http://docs.puppetlabs.com/references/stable/function.html). We won't be covering most of these for a while, but you might find `inline_template` and `regsubst` useful in the short term.

[^agent]: To jump ahead a bit, this means the agent never sees them.

An Example: NTP Again
---------

So let's modify your NTP module to use templates instead of static config files. 

First, we'll change the `init.pp` manifest:

{% highlight ruby %}
    # init.pp
    
    class ntp {
      case $operatingsystem {
        centos, redhat: { 
          $service_name    = 'ntpd'
          $conf_template   = 'ntp.conf.el.erb'
          $default_servers = [ "0.centos.pool.ntp.org",
                               "1.centos.pool.ntp.org",
                               "2.centos.pool.ntp.org", ]
        }
        debian, ubuntu: { 
          $service_name    = 'ntp'
          $conf_template   = 'ntp.conf.debian.erb'
          $default_servers = [ "0.debian.pool.ntp.org iburst",
                               "1.debian.pool.ntp.org iburst",
                               "2.debian.pool.ntp.org iburst",
                               "3.debian.pool.ntp.org iburst", ]
        }
      }
      
      if $servers == undef {
        $servers_real = $default_servers
      }
      else {
        $servers_real = $servers
      }
      
      package { 'ntp':
        ensure => installed,
      }
      
      service { 'ntp':
        name      => $service_name,
        ensure    => running,
        enable    => true,
        subscribe => File['ntp.conf'],
      }
      
      file { 'ntp.conf':
        path    => '/etc/ntp.conf',
        ensure  => file,
        require => Package['ntp'],
        content => template("ntp/${conf_template}"),
      }
    }
{% endhighlight %}

There are several things going on, here: 

* We changed the `File['ntp.conf']` resource, as advertised.
* We're storing the servers in an array, mostly so I can demonstrate how to iterate over an array once we get to the template. If you wanted to, you could store them as a string with line breaks and per-line `server` statements instead; it comes down to a combination of personal style and the nature of the problem at hand.
* We'll be using that `$servers_real` variable in the actual template, which might seem odd now but will make more sense during the next chapter. Likewise with testing whether `$servers` is `undef`. (For now, it will always be `undef`, as are all variables that haven't been assigned yet.)

Next, copy the config files to the templates directory, add the `.erb` extension to their names, and replace the blocks of servers with some choice ERB code:

{% highlight erb %}
    # ...
    
    # Managed by Class['ntp']
    <% servers_real.each do |server| -%>
    server <%= server %>
    <% end -%>
    
    # ...
{% endhighlight %}

This snippet will iterate over each entry in the array and print it after a `server` statement, so, for example, the string generated from the Debian template will end up with a block like this: 

    # Managed by Class['ntp']
    server 0.debian.pool.ntp.org iburst
    server 1.debian.pool.ntp.org iburst
    server 2.debian.pool.ntp.org iburst
    server 3.debian.pool.ntp.org iburst

You can see the limitations here --- the servers are still basically hardcoded. But we've moved them out of the config file and into the Puppet manifest, which gets us half of the way to a much more flexible NTP class. 

Next
----

And as for the rest of the way, keep reading to learn about [parameterized classes](./modules2.html). 
