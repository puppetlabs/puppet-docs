---
layout: default
title: Learning Puppet — Variables, Conditionals, and Facts
---

[next]: ./modules1.html
[customfacts]: /facter/latest/custom_facts.html


Begin
-----

{% highlight ruby %}
    $my_variable = "A bunch of text"
    notify {$my_variable:}
{% endhighlight %}

Yup, that's a variable, all right.

Variables
---------

Variables! You've almost definitely used variables before in some other programming or scripting language, so we'll cover the basics very quickly. A more complete explanation of the syntax and behavior of variables is available in [the variables chapter of the Puppet reference manual](/puppet/latest/reference/lang_variables.html).

* `$variables` always start with a dollar sign. You assign to variables with the `=` operator.
* Variables can hold strings, numbers, booleans, arrays, hashes, and the special `undef` value. See [the data types chapter of the Puppet reference manual](/puppet/latest/reference/lang_datatypes.html) for more information.
* If you've never assigned a variable, you can actually still use it --- its value will be `undef`.
* You can use variables as the value for any resource attribute, or as the title of a resource.
* You can also interpolate variables inside double-quoted strings. To distinguish a variable from the surrounding text, you can wrap its name in curly braces. (`"This is the ${variable} name."`) This isn't mandatory, but it is recommended.
* Every variable has two names:
    * A short local name
    * A long fully-qualified name

    Fully qualified variables look like `$scope::variable`. Top scope variables are the same, but their scope is nameless. (For example: `$::top_scope_variable`.)
* If you reference a variable with its short name and it isn't present in the local scope, Puppet will also check the global top scope; this means you can almost always refer to global variables with just their short names. You can see more about this in the scope chapter of the Puppet reference manual: [scope in Puppet 2.7](/puppet/2.7/reference/lang_scope.html), [scope in Puppet 3](/puppet/latest/reference/lang_scope.html)
* You can only assign the same variable **once** in a given scope. In this way, they're more like constants from other programming languages.

{% highlight ruby %}
    $longthing = "Imagine I have something really long in here. Like an SSH key, let's say."

    file {'authorized_keys':
      path    => '/root/.ssh/authorized_keys',
      content => $longthing,
    }
{% endhighlight %}

Pretty easy.

> ### Aside: Why Do Everyone's Manifests Seem to Use $::ipaddress?
>
> People who write manifests to share with the public often adopt the habit of always using the `$::variable` notation when referring to facts.
>
> As mentioned above, the double-colon prefix specifies that a given variable should be found at top scope. This isn't actually necessary, since variable lookup will always reach top scope anyway unless you reassign that variable in the local scope. (See [the scope chapter of the Puppet reference manual](/puppet/latest/reference/lang_scope.html).)
>
> Using an explicit top-scope lookup used to help protect from certain classes of failures, but now it's just used to indicate to readers of your code that you're referencing a fact variable. See [this note in the Puppet reference manual for more about referencing facts.](/puppet/latest/reference/lang_facts_and_builtin_vars.html#historical-note-about-)


Facts
-----

[lang_facts]: /puppet/latest/reference/lang_variables.html#facts-and-built-in-variables
[core_facts]: /facter/latest/core_facts.html

Puppet has a bunch of built-in, pre-assigned variables that you can use. Check it out:

{% highlight ruby %}
    # /root/examples/motd.pp

    file {'motd':
      ensure  => file,
      path    => '/etc/motd',
      mode    => 0644,
      content => "This Learning Puppet VM's IP address is ${ipaddress}. It thinks its
    hostname is ${fqdn}, but you might not be able to reach it there
    from your host machine. It is running ${operatingsystem} ${operatingsystemrelease} and
    Puppet ${puppetversion}.
    Web console login:
      URL: https://${ipaddress_eth0}
      User: puppet@example.com
      Password: learningpuppet
    ",
    }
{% endhighlight %}

    # puppet apply /root/examples/motd.pp

    notice: /Stage[main]//Host[puppet]/ensure: created
    notice: /Stage[main]//File[motd]/ensure: defined content as '{md5}bb1a70a2a2ac5ed3cb83e1a8caa0e331'

    # cat /etc/motd
    This Learning Puppet VM's IP address is 172.16.52.135. It thinks its
    hostname is learn.localdomain, but you might not be able to reach it there
    from your host machine. It is running CentOS 5.7 and
    Puppet 2.7.21 (Puppet Enterprise 2.8.1).
    Web console login:
      URL: https://172.16.52.135
      User: puppet@example.com
      Password: learningpuppet

Our manifests are becoming more flexible, with pretty much no real work on our part.

### What Are These Hostname and IPaddress Variables?

And where did they come from?

They're ["facts."][lang_facts] Puppet uses a tool called Facter, which discovers some system information, normalizes it into a set of variables, and passes them off to Puppet. Puppet's compiler then has access to those facts when it's reading a manifest.

* [See here for a list of all of the "core" facts built into Facter.][core_facts] Most of them are always available to Puppet, although some of them are only present on certain system types.
* You can see what Facter knows about a given system by running `facter` at the command line.
* You can also see all of the facts for any node in your Puppet Enterprise deployment by browsing to that node's page in the console and [scrolling down to the inventory information.](/pe/latest/console_reports.html#viewing-inventory-data)
* You can also add new custom facts to Puppet; see [the custom facts guide][customfacts] for more information.

### Other Built-In Variables

In addition to the facts from Facter, Puppet has a few extra built-in variables. You can see a list of them in [the variables chapter of the Puppet reference manual.][lang_facts]


Conditional Statements
----------------------

Puppet has several kinds of conditional statements. You can see more complete info about them in [the conditional statements chapter of the Puppet reference manual.](/puppet/latest/reference/lang_conditional.html).

By using facts as conditions, you can easily make Puppet do different things on different kinds of systems.

### If

We'll start with your basic [`if` statement][lang_if]. Same as it ever was:

[lang_if]: /puppet/latest/reference/lang_conditional.html#if-statements

    if condition {
      block of code
    }
    elsif condition {
      block of code
    }
    else {
      block of code
    }

* The `else` and any number of `elsif` statements are optional.
* The blocks of code for each condition can contain any Puppet code.
* The conditions can be any fragment of Puppet code that resolves to a boolean true/false value, including [expressions][], [functions][] that return values, and variables. Follow the links for more detailed descriptions of expressions and functions.

[functions]: /puppet/latest/reference/lang_functions.html
[expressions]: /puppet/latest/reference/lang_expressions.html

An example `if` statement:

{% highlight ruby %}
    if str2bool("$is_virtual") {
      service {'ntpd':
        ensure => stopped,
        enable => false,
      }
    }
    else {
      service { 'ntpd':
        name       => 'ntpd',
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require => Package['ntp'],
      }
    }
{% endhighlight %}


[bool_convert]: /puppet/latest/reference/lang_datatypes.html#automatic-conversion-to-boolean
[strings]: /puppet/latest/reference/lang_datatypes.html#strings
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib

> ### Aside: Beware of the Fake False!
>
> In the example above, we see something new: `str2bool("$is_virtual")`.
>
> The condition for an `if` statement has to resolve to a boolean true/false value. However, all facts are [strings][], and all non-empty strings --- including the string `"false"` --- are true. This means that facts that are "false" need to be transformed before Puppet will treat them as false.
>
> In this case, we're:
>
> * Surrounding the variable with double quotes --- if it contained an actual boolean for some reason (and it usually wouldn't), this would convert it to a string.
> * Passing the string to the `str2bool` function, which converts a string that _looks_ like a boolean into a real true or false value.
>
> The `str2bool` [function][functions] is part of the [puppetlabs/stdlib][stdlib] module, which is included with Puppet Enterprise. If you are running open source Puppet, you can install it by running `sudo puppet module install puppetlabs/stdlib`.
>
> We could also use an expression instead: the expression `$is_virtual == 'true'` would resolve to true if the `is_virtual` fact has a value of true, and false otherwise.


### Case

Another kind of conditional is the [case statement][lang_case]. (Or switch, or whatever your language of choice calls it.)

[lang_case]: /puppet/latest/reference/lang_conditional.html#case-statements

{% highlight ruby %}
    case $operatingsystem {
      centos: { $apache = "httpd" }
      # Note that these matches are case-insensitive.
      redhat: { $apache = "httpd" }
      debian: { $apache = "apache2" }
      ubuntu: { $apache = "apache2" }
      default: { fail("Unrecognized operating system for webserver") }
    }
    package {'apache':
      name   => $apache,
      ensure => latest,
    }
{% endhighlight %}

Instead of testing a condition up front, `case` matches a variable against a bunch of possible values. **`default` is a special value,** which does exactly what it sounds like.

In this example, we also see the [`fail` function](/references/latest/function.html#fail). Unlike the `str2bool` function above, `fail` doesn't resolve to a value; instead, it fails compilation immediately with an error message.

#### Case matching

[regex]: /puppet/latest/reference/lang_datatypes.html#regular-expressions

Case matches can be simple strings (like above), [regular expressions][regex], or comma-separated lists of either.

Here's the example from above, rewritten to use comma-separated lists of strings:

{% highlight ruby %}
    case $operatingsystem {
      centos, redhat: { $apache = "httpd" }
      debian, ubuntu: { $apache = "apache2" }
      default: { fail("Unrecognized operating system for webserver") }
    }
{% endhighlight %}

And here's a regex example:

{% highlight ruby %}
    case $ipaddress_eth0 {
      /^127[\d.]+$/: {
        notify {'misconfig':
          message => "Possible network misconfiguration: IP address of $0",
        }
      }
    }
{% endhighlight %}

String matching is case-insensitive, like [the `==` comparison operator][lang_eq]. Regular expressions are denoted with the slash-quoting used by Perl and Ruby; they're case-sensitive by default, but you can use the `(?i)` and `(?-i)` switches to turn case-insensitivity on and off inside the pattern. Regex matches also assign captured subpatterns to `$1`, `$2`, etc. inside the associated code block, with `$0` containing the whole matching string. See [the regular expressions section of the Puppet reference manual's data types page][regex] for more details.

[lang_eq]: /puppet/latest/reference/lang_expressions.html#equality

### Selectors

Selectors might be less familiar; they're kind of like the common [ternary operator](http://en.wikipedia.org/wiki/%3F:), and kind of like the case statement.

Instead of choosing between a set of code blocks, selectors choose between a group of possible values. You can't use them on their own; instead, they're usually used to assign a variable.

{% highlight ruby %}
    $apache = $operatingsystem ? {
      centos                => 'httpd',
      redhat                => 'httpd',
      /(?i)(ubuntu|debian)/ => 'apache2',
      default               => undef,
    }
{% endhighlight %}

Careful of the syntax, there: it looks kind of like we're saying `$apache = $operatingsystem`, but we're not. The question mark flags `$operatingsystem` as the control variable of a selector, and the actual value that gets assigned is determined by which option `$operatingsystem` matches. Also note how the syntax differs from the case syntax: it uses hash rockets and line-end commas instead of colons and blocks, and you can't use lists of values in a match. (If you want to match against a list, you have to fake it with a regular expression.)

It can look a little awkward, but there are plenty of situations where it's the most concise way to get a value sorted out; if you're ever not comfortable with it, you can just use a case statement to assign the variable instead.

Selectors can also be used directly as values for a resource attribute, but try not to do that, because it gets ugly fast.

Exercises
---------

> ### Exercise: Build Environment
>
> Use the $operatingsystem fact to write a manifest that installs a C build environment on Debian-based ("debian," "ubuntu") and Enterprise Linux-based ("centos," "redhat") machines. (Both types of system require the `gcc` package, but Debian-type systems also require `build-essential`.)

> ### Exercise: Simple NTP
>
> Write a manifest that installs and configures NTP for Debian-based and Enterprise Linux-based Linux systems. This will be a package/file/service pattern where both kinds of systems use the same package name (`ntp`), but you'll be shipping different config files ([Debian version](./files/examples/modules/ntp/files/ntp.conf.debian), [Red Hat version](./files/examples/modules/ntp/files/ntp.conf.el) -- remember the `file` type's "source" attribute) and using different service names (`ntp` and `ntpd`, respectively).

Next
----

**Next Lesson:**

Now that your manifests can adapt to different kinds of systems, it's time to start grouping resources and conditionals into meaningful units. Onward to [classes, defined resource types, and modules][next]!

**Off-Road:**

Since facts from every node show up in the console, Puppet Enterprise can be a powerful inventory tool. [Download Puppet Enterprise for free][dl], follow [the quick start guide][quick] to get a small environment installed, then try browsing the console's inventory for a central view of your operating system versions, hardware profiles, and more.


[dl]: http://info.puppetlabs.com/download-pe.html
[quick]: /pe/latest/quick_start.html
