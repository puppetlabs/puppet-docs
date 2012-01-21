---
layout: default
title: Language Guide
---

Language Guide
=================

The purpose of Puppet's language is to make it easy to specify the
resources you need to manage on the machines you're managing.

This guide will show you how the language works, going through
some basic concepts.  Understanding
the Puppet language is key, as it's the main driver of how
you tell your Puppet managed machines what to do.

* * *

Ready To Dive In?
-----------------

Puppet language is really relatively simple compared to many
programming languages.  As you are reading over this guide,
it may also be helpful to look over various Puppet modules
people have already written.   Complete real world examples
can serve as a great introduction to Puppet.  See the [Modules](/guides/modules.html)
page for more information and some links to list of community developed Puppet content.


Language Feature by Release
---------------------------

Feature                         | 0.23.1 | 0.24.6 | 0.24.7 | 0.25.0 | 2.6.0 |
--------------------------------|:------:|:------:|:------:|:------:|:-----:|
Plusignment operator (+>)       |    X   |   X    |   X    |   X    |   X   |
Multiple Resource relationships |        |   X    |   X    |   X    |   X   |
Class Inheritance Overrides     |        |   X    |   X    |   X    |   X   |
Appending to Variables (+=)     |        |   X    |   X    |   X    |   X   |
Class names starting with 0-9   |        |   X    |   X    |   X    |   X   |
Multi-line C-style comments     |        |        |   X    |   X    |   X   |
Node regular expressions        |        |        |        |   X    |   X   |
Expressions in Variables        |        |        |        |   X    |   X   |
RegExes in conditionals         |        |        |        |   X    |   X   |
Elsif in conditionals           |        |        |        |        |   X   |
Chaining Resources              |        |        |        |        |   X   |
Hashes                          |        |        |        |        |   X   |
Parameterised Class             |        |        |        |        |   X   |
Run Stages                      |        |        |        |        |   X   |
The "in" syntax                 |        |        |        |        |   X   |

Resources
---------

The fundamental unit of modelling in Puppet is a resource.  Resources
describe some aspect of a system; it might be a file, a service, a
package, or perhaps even a custom resource that you have developed.
We'll show later how resources can be aggregated together with
"defines" and "classes", and even show how to organize things
with "modules", but resources are what we should start with first.

Each resource has a type, a title, and a list
of attributes --- each resource in Puppet can support various attributes,
though many of them will have reasonable defaults and you won't have
to specify all of them.

You can find all of the supported resource
types, their valid attributes, and documentation for all of it in
the [References](/references/stable/type.html).

Let's get started.   Here's a simple example of a resource in Puppet,
where we are describing the permissions and ownership of a file:

{% highlight ruby %}
    file { '/etc/passwd':
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }
{% endhighlight %}

Any machine on which this snippet is executed will use it to verify
that the passwd file is configured as specified. 

The field before
the colon is the resource's _title,_ which must be unique and can be used to refer to
the resource in other parts of the Puppet configuration. Following the title are
a series of _attributes_ and their _values_. 

Most resources have an attribute (often called simply `name`) whose value will default to the title if you don't specify it. (Internally, this is called the "namevar.") For the `file` type, the `path` will default to the title. **A resource's namevar value almost always has to be unique.** (The `exec` and `notify` types are the exceptions.)

For simple resources that don't vary much, leaving out the name or path and falling back to the title is
sufficient. But for resources with long names, or in cases where filenames differ between
operating systems, it makes more sense to choose a symbolic title:

{% highlight ruby %}
    file { 'sshdconfig':
      path => $operatingsystem ? {
        solaris => '/usr/local/etc/ssh/sshd_config',
        default => '/etc/ssh/sshd_config',
      },
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }
{% endhighlight %}

This makes it easy to refer
to the file resource elsewhere in our configuration, since the title is always the same.

For instance, let's add a service that depends on the file:

{% highlight ruby %}
    service { 'sshd':
      subscribe => File['sshdconfig'],
    }
{% endhighlight %}

This will cause the `sshd` service to get restarted when the
`sshdconfig` file changes. You'll notice that when we reference a
resource we capitalise the name of the resource, for example
`File[sshdconfig]`.   When you see an uppercase resource type,
that's always a reference.  A lowercase version is a declaration.
Since resources can only be declared once, repeating the same
declaration twice will cause an error.   This is an important
feature of Puppet that makes sure your configuration is well
modelled.

What happens if our resource depends on multiple resources?
From Puppet version 0.24.6 you can specify multiple relationships
like so:

{% highlight ruby %}
    service { 'sshd':
      require => File['sshdconfig', 'sshconfig', 'authorized_keys']
    }
{% endhighlight %}

### Metaparameters

In addition to the attributes specific to each Resource Type Puppet also has
global attributes called metaparameters. Metaparameters are
parameters that work with any resource type.

In the examples in the section above we used two metaparameters,
`subscribe` and `require`, both of which build relationships
between resources. You can see the full list of all metaparameters in the
[Metaparameter Reference](/references/stable/metaparameter.html), though
we'll point out additional ones we use as we continue the guide.

### Resource Defaults

Sometimes you will need to specify a default parameter value for a set
of resources; Puppet provides a syntax for doing this, using a
capitalized resource specification that has no title.  For instance,
in the example below, we'll set the default path for all execution
of commmands:

{% highlight ruby %}
    Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
    exec { 'echo this works': }
{% endhighlight %}

The first statement in this snippet provides a default value for
`exec` resources; Exec resources require either fully qualified paths or a
path in which to look for the executable. Individual resources can
still override this path when needed, but this saves typing.
This way you can specify a single default path for your entire configuration, and then override that value as necessary.

Defaults work with any resource type in Puppet.

Defaults are not global --- they only affect the current scope and scopes below the current one.  If you want a default setting to affect your entire configuration, your only choice currently is to specify them outside of any class.  We'll mention classes in the next section.

### Resource Collections

Aggregation is a powerful concept in Puppet.  There are two ways to combine multiple resources into one easier to use resource: Classes and defined resource types. Classes model fundamental aspects of nodes, they say "this node IS a webserver" or "this node is one of these".  In programming terminology classes are
singletons --- they only ever get evaluated once per node.

Defined resource types, on the other hand, can be reused many times on the same node.  They essentially work as if you created your own Puppet type just by using the language.  They are meant to be evaluated multiple times, with different inputs each time.  This means you can pass variable values into the defines.

Both classes and defines are very useful and you should make use of them when building out your puppet infrastructure.

#### Classes

Classes are introduced with the `class` keyword, and their contents
are wrapped in curly braces.  The following simple example creates a simple class that manages two separate files:

{% highlight ruby %}
    class unix {
      file {
        '/etc/passwd':
          owner => 'root',
          group => 'root',
          mode  => '0644';
        '/etc/shadow':
          owner => 'root',
          group => 'root',
          mode  => '0440';
      }
    }
{% endhighlight %}

You'll notice we introduced some shorthand here.   This is the same
as saying:

{% highlight ruby %}
    class unix {
      file { '/etc/passwd':
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }
      file { '/etc/shadow':
        owner => 'root',
        group => 'root',
        mode  => '0440',
      }
    }
{% endhighlight %}

Classes also support a simple form of object inheritance.  For those
not acquainted with programming terms, this means that we can extend
the functionality of the previous class without copy/pasting
the entire class.  Inheritance allows
subclasses to override resource settings declared in parent classes. A
class can only inherit from one other class, not more than one.
In programming terms, this is called 'single inheritance'.

{% highlight ruby %}
    class freebsd inherits unix {
      File['/etc/passwd'] { group => 'wheel' }
      File['/etc/shadow'] { group => 'wheel' }
    }
{% endhighlight %}

If we needed to undo some logic specified in a parent class, we can
use undef like so:

{% highlight ruby %}
    class freebsd inherits unix {
      File['/etc/passwd'] { group => undef }
    }
{% endhighlight %}

In the above example, nodes which include the `unix` class will have the
password file's group set to `root`, while nodes including
`freebsd` would have the password file group ownership left
unmodified.

In Puppet version 0.24.6 and higher, you can specify multiple overrides like
so:

{% highlight ruby %}
    class freebsd inherits unix {
      File['/etc/passwd', '/etc/shadow'] { group => 'wheel' }
    }
{% endhighlight %}

There are other ways to use inheritance.  In Puppet 0.23.1 and
higher, it's possible to add values to resource parameters using
the '+>' ('plusignment') operator:

{% highlight ruby %}
    class apache {
      service { 'apache': require => Package['httpd'] }
    }

    class apache-ssl inherits apache {
      # host certificate is required for SSL to function
      Service['apache'] { require +> File['apache.pem'] }
    }
{% endhighlight %}

The above example makes the service resource in the second class require all the packages in the first,
as well as the `apache.pem` file.

To append multiple requires, use array brackets and commas:

{% highlight ruby %}
    class apache {
      service { 'apache': require => Package['httpd'] }
    }

    class apache-ssl inherits apache {
      Service['apache'] { require +> [ File['apache.pem'], File['/etc/httpd/conf/httpd.conf'] ] }
    }
{% endhighlight %}

The above would make the `require` parameter in the `apache-ssl`
class equal to

{% highlight ruby %}
    [Package['httpd'], File['apache.pem'], File['/etc/httpd/conf/httpd.conf']]
{% endhighlight %}

Like resources, you can also create relationships between classes with
'require', like so:

{% highlight ruby %}
    class apache {
      service { 'apache': require => Class['squid'] }
    }
{% endhighlight %}

The above example uses the `require` metaparameter to make the `apache`
class dependent on the `squid` class.

In Puppet version 0.24.6 and higher, you can specify multiple relationships
like so:

{% highlight ruby %}
    class apache {
      service { 'apache':
        require => Class['squid', 'xml', 'jakarta'],
      }
    }
{% endhighlight %}

The `require` metaparameter does not implicitly declare a class; this means it can be used multiple times and is compatible with parameterized classes, but you must make sure you actually declare the class you're requiring at some point. 

Puppet also has [a `require` function](/references/latest/function.html#require), which can be used inside class definitions and which _does_ implicitly declare a class, in the same way that the `include` function does. This function doesn't play well with parameterized classes. The `require` function is largely unnecessary, as class-level dependencies can be managed in other ways.

#### Parameterised Classes

In Puppet release 2.6.0 and later, classes are extended to allow the passing of parameters into classes.

To create a class with parameters you can now specify:

{% highlight ruby %}
    class apache($version) {
      ... class contents ...
    }
{% endhighlight %}

Classes with parameters are not declared using the include function but with an alternate syntax similar to a resource declaration:

{% highlight ruby %}
    node webserver {
      class { 'apache': version => '1.3.13' }
    }
{% endhighlight %}

You can also specify default parameter values in your class like so:

{% highlight ruby %}
    class apache($version = '1.3.13', $home = '/var/www') {
      ... class contents ...
    }
{% endhighlight %}

#### Run Stages

Run stage were added in Puppet version 2.6.0, you now have the ability to specify any
number of stages which provide another method to control the ordering of
resource management in puppet.  If you have a large number of resources in your
catalog it may become tedious and cumbersome to explicitly manage every
relationship between the resources where order is important.  In this
situation, run-stages provides you the ability to associate a class to a single
stage.  Puppet will guarantee stages run in a specific predictable order every
catalog run.

In order to use run-stages, you must first declare additional stages beyond the
already present main stage.  You can then configure puppet to manage each stage
in a specific order using the same resource relationship syntax, before,
require, "->" and "<-".  The relationship of stages will then guarantee the
ordering of classes associated with each stage.

By default there is only one stage named "main" and all classes are
automatically associated with this stage.  Unless explicitly stated, a class
will be associated with the main stage.  With only one stage the effect of run
stages is the same as previous versions of puppet since resources within a
stage are managed in arbitrary order unless they have explicit relationships
declared.

In order to declare additional stage resources, follow the same consistent and
simple declarative syntax of the puppet language:

{% highlight ruby %}
    stage { 'first': before => Stage['main'] }
    stage { 'last': require => Stage['main'] }
{% endhighlight %}

All classes associated with the first stage are to be managed before the
classes associated with the main stage.  All classes associated with the
last stage are to be managed after the classes associated with the main
stage.

Once stages have been declared, a class may be associated with a stage other
than main using the "stage" class parameter.

{% highlight ruby %}
    class {
      'apt-keys': stage => first;
      'sendmail': stage => main;
      'apache':   stage => last;
    }
{% endhighlight %}

Associate all resources in the class apt-keys with the first run stage, all
resources in the class sendmail with the main stage, and all resources in the
apache class with the last stage.

This short declaration guarantees resources in the apt-keys class are managed
before resources in the sendmail class, which in turn is managed before
resources in the apache class.

Please note that stage is not a metaparameter.  The run stage must be specified
as a class parameter and as such classes must use the resource declaration
syntax as shown rather than the "include" statement.

#### Defined Resource Types

Defined resource types follow the same basic form as classes, but they are introduced with the
`define` keyword (not `class`) and they support arguments but no inheritance.  As
mentioned previously, defined resource types take parameters and can be reused multiple times on the same system.   Suppose we want to create a resource collection that creates source control
repositories.  We probably would want to create multiple repositories on the same
system, so we would use a defined type, not a class.  Here's an example:

{% highlight ruby %}
    define svn_repo($path) {
      exec { "/usr/bin/svnadmin create ${path}/${title}":
        unless => "/bin/test -d ${path}",
      }
    }

    svn_repo { 'puppet_repo': path => '/var/svn_puppet' }
    svn_repo { 'other_repo':  path => '/var/svn_other' }
{% endhighlight %}

Note how parameters specified in the definition (`define svn_repo($path)`) must appear as resource attributes (`path => '/var/svn_puppet'`) whenever a resource of the new type is declared and are available as variables (`unless => "/bin/test -d ${path}"`) within the definition. Multiple variables (separated by commas) can be specified. Default values can also be specified for any parameter with `=`, and any parameter which has a default becomes non-mandatory when a resource of the new type is declared.

Defined types have a number of built-in variables available, including `$name` and `$title`, which are set to the title of the resource when it is declared. (The reasons for having two identical variables with this information are outside the scope of this document, and these two special variables cannot be used the same way in classes or other resources.) As of Puppet 2.6.5, the `$name` and `$title` variables can also be used as default values for parameters:

    define svn_repo($path = "/var/${name}") {...}

Any metaparameters used when a defined resource is declared are also made available in the definition as variables:

{% highlight ruby %}
    define svn_repo($path) {
      exec { "create_repo_${name}":
        command => "/usr/bin/svnadmin create ${path}/${title}",
        unless  => "/bin/test -d ${path}",
      }
      if $require {
        Exec["create_repo_${name}"] {
          require +> $require,
        }
      }
    }

    svn_repo { 'puppet':
      path    => '/var/svn',
      require => Package['subversion'],
    }
{% endhighlight %}

The above is perhaps not a perfect example, as most likely we would
know that subversion was always required for svn checkouts, but it illustrates how `require` and other metaparameters can be used in defined types.

Defined resource types can have namespace separators (`::`) in their names, just like classes. When making a resource reference (e.g. `File['/etc/motd']`) to an instance of a defined type, you must capitalize all segments of the type's name (e.g. `Apache::Vhost['wordpress']`). 

#### Classes vs. Defined Resource Types

Classes and defined types are created similarly, but they are used very differently.

Defined types are used to define reusable objects which will have
multiple instances on a given host, so they cannot include any
resources that will only have one instance.  For instance, multiple
uses of the same define cannot create the same file.

Classes, on the other hand, are guaranteed to be singletons --- you
can include them as many times as you want and you'll only ever
get one copy of the resources.

Most often, services will be defined in a class, where the
service's package, configuration files, and running service will
all be gathered, because there will normally be one
copy of each on a given host.   (This idiom is sometimes
referred to as "service-package-file").

Defined types would be used to manage resources like virtual hosts, of
which you can have many, or to encode some simple information in a reusable
wrapper to save typing.

#### Modules

You can (and should!) combine collections of classes, defined types, and resources
into modules. Modules are portable collections of configuration,
for example a module might contain all the resources required to
configure Postfix or Apache. You can find out more on the
[Modules Page](./modules.html)

### Chaining resources

As of puppet version 2.6.0, resources may be chained together to declare
relationships between and among them.

You can now specify relationships directly as statements in addition to
the before and require resource metaparameters of previous versions:

{% highlight ruby %}
    File['/etc/ntp.conf'] -> Service['ntpd']
{% endhighlight %}

Manage the ntp configuration file before the ntpd service

You can specify a "notify" relationship by employing the tilde instead of the
hyphen:

{% highlight ruby %}
    File['/etc/ntp.conf'] ~> Service['ntpd']
{% endhighlight %}

This manages the ntp configuration file before the ntpd service and notifies the
service of changes to the ntp configuration file.

You can also do relationship chaining, specifying multiple relationships on a
single line:

{% highlight ruby %}
    Package['ntp'] -> File['/etc/ntp.conf'] -> Service['ntpd']
{% endhighlight %}

Here we first manage the ntp package, second manage the ntp configuration file,
and third manage the ntpd service.

Note that while it's confusing, you don't have to have all of the arrows be the
same direction:

{% highlight ruby %}
    File['/etc/ntp.conf'] -> Service['ntpd'] <- Package['ntp']
{% endhighlight %}

Here the ntpd service requires /etc/ntp.conf and the ntp package.

Please note, relationships declared in this manner are between adjacent
resources.  In this example, the ntp package and the ntp configuration file are
not directly related to each other, and puppet may try to manage the
configuration file before the package is even installed, which may not be the
desired behavior.

Chaining in this manner can provide some succinctness at the cost of
readability.

You can also specify relationships when resources are declared, in addition to
the above resource reference examples:

{% highlight ruby %}
    package { 'ntp': } -> file { '/etc/ntp.conf': }
{% endhighlight %}

Here we manage the ntp package before the ntp configuration file.

But wait! There's more! You can also specify a collection on either side
of the relationship marker:

{% highlight ruby %}
    yumrepo { 'localyumrepo': .... }
    package { 'ntp': provider => yum, ... }
    Yumrepo <| |> -> Package <| provider == yum |>
{% endhighlight %}

This manages all yum repository resources before managing all package resources
using the yum provider.

This, finally, provides easy many to many relationships in Puppet, but it also
opens the door to massive dependency cycles. This last feature is a very
powerful stick, and you can considerably hurt yourself with it. In particular,
watch out when using virtual resources, as the collection operator realizes
resources as a side-effect.

### Nodes

Having knowledge of resources, classes, defines, and modules
gets you to understanding of most of Puppet.   Nodes are a very
simple remaining step, which are how we map the what we define
("this is what a webserver looks like") to what machines are
chosen to fulfill those instructions.

Node definitions look just like classes, including supporting
inheritance, but they are special in that when a node (a managed
computer running the Puppet client) connects to the Puppet master daemon, its
name will be looked for in the list of defined nodes.   The information
found for the node will then be evaluated for that node, and then node will
be sent that configuration.

Node names can be the short host name, or the fully qualified
domain name (FQDN).  Some names, especially fully qualified ones,
need to be quoted, so it is a best practice to quote all of them.
Here's an example:

{% highlight ruby %}
    node 'www.testing.com' {
      include common
      include apache, squid
    }
{% endhighlight %}

The previous node definition creates a node called
`www.testing.com` and includes the `common`, `apache` and `squid`
classes.

You can also specify that multiple nodes receive an identical
configuration by separating each with a comma:

{% highlight ruby %}
    node 'www.testing.com', 'www2.testing.com', 'www3.testing.com' {
      include common
      include apache, squid
    }
{% endhighlight %}

The previous examples creates three identical nodes:
`www.testing.com`, `www2.testing.com`, and `www3.testing.com`.

#### Matching Nodes with Regular Expressions

In Puppet 0.25.0 and later, nodes can also be matched
by regular expressions, which is much more convenient than
listing them individually, one-by-one:

{% highlight ruby %}
    node /^www\d+$/ {
      include common
    }
{% endhighlight %}

The above would match any host called `www` and ending with one or more
digits.  Here's another example:

{% highlight ruby %}
    node /^(foo|bar)\.testing\.com$/ {
      include common
    }
{% endhighlight %}

The above example would match either host `foo` or `bar` in the testing.com
domain.

What happens if there are multiple regular expressions or node definitions
set in the same file?

-   If there is a node without a regular expression that matches
    the current client connecting, that will be used first.
-   Otherwise the first matching regular expression wins.

#### Node Inheritance

Nodes support a limited inheritance model.  Like classes, nodes
can only inherit from one other node:

{% highlight ruby %}
    node 'www2.testing.com' inherits 'www.testing.com' {
      include loadbalancer
    }
{% endhighlight %}

In this node definition the `www2.testing.com` inherits any
configuration specified for the `www.testing.com` node in addition
to including the `loadbalancer` class.   In other words, it does
everything "www.testing.com" does, but also takes on some
additional functionality.

#### Default Nodes

If you create a node named `default`, the node configuration
for default will be used if no other node matches are found.

#### External Nodes

In some cases you may already have an external list of machines
and what roles they perform.  This may be in LDAP, version
control, or a database.  You may also need to pass some
variables to those nodes (more on variables later).

In these cases, writing an [External Nodes](./external_nodes.html)
script can help, and that can take the place of your node definitions.  See
that section for more information.

## Additional Language Features

We've already gone over features such as ordering and
grouping, though there's still a few more things to learn.

Puppet is not a programming language, it is a way of describing
your IT infrastructure as a model.  This is usually quite
sufficient to get the job done, and prevents you from having
to write a lot of programming code.

### Quoting

Most of the time, you don't have to quote strings in Puppet.
Any alphanumeric string starting with a letter (hyphens are also allowed), can leave out the quotes, though it's a best practice to quote strings
for any non-native value.

### Variable Interpolation With Quotes

So far, we've mentioned variables in terms of defines.  If you
need to use those variables within a string, use double quotes,
not single quotes.   Single-quoted strings will not do any variable interpolation,  double-quoted strings will. Variables in strings can also be bracketed with `{}` which makes them easier to use together, and also a bit cleaner to read:

{% highlight ruby %}
    $value = "${one}${two}"
{% endhighlight %}

To put a quote character or `$` in a double-quoted string where it would
normally have a special meaning, precede it with an escaping `\`. For an actual `\`, use `\\`.

In single-quoted strings only two escape sequences are supported, `\'`
for single quote and `\\` for single backslash. Except for these two escape sequences, everything else between single quotes is treated literally.

We recommend using single quotes for all strings that do not require variable interpolation. Use double quotes for those strings that require variable interpolation.  The [Style Guide](./style_guide.html#quoting) also discusses this with examples.

### Capitalization

Capitalization of resources is used in three major ways:

-   Referencing: when you want to reference an already declared resource, usually for dependency purposes, you have to capitalize the name of the resource, for example
{% highlight ruby %}
    require => File['sshdconfig']
{% endhighlight %}

-   Inheritance.  When overwriting the resource settings of a parent class from a subclass, use the uppercase versions of the resource names.  Using the lowercase versions will result in an error.   See the inheritance section above for an example of this.

-   Setting default attribute values: Resource Defaults.  As mentioned previously, using a capitalized resource with no `title` works to set the defaults for that resource.  Our previous example was setting the default path for command executions.

Note that when capitalizing a namespaced defined type, you have to capitalize
all segments of the type's name, e.g. `Apache::Vhost['wordpress']`.

### Arrays

As mentioned in the class and resource examples above, Puppet allows usage of arrays in various areas.  Arrays defined in puppet look like this:

{% highlight ruby %}
    [ 'one', 'two', 'three' ]
{% endhighlight %}

You can access array entries by their index, for example:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three' ]
    notice $foo[1]
{% endhighlight %}

Would return `two`.

Several type members, such as 'alias' in the 'host' definition
accept arrays as their value. A host resource with multiple
aliases would look like this:

{% highlight ruby %}
    host { 'one.example.com':
      ensure => present,
      alias  => [ 'satu', 'dua', 'tiga' ],
      ip     => '192.168.100.1',
    }
{% endhighlight %}

This would add a host 'one.example.com' to the hosts list with the
three aliases 'satu', 'dua', and 'tiga'.

Or, for example, if you want a resource to require multiple other
resources, the way to do this would be like this:

{% highlight ruby %}
    resource { 'baz':
      require  => [ Package['foo'], File['bar'] ],
    }
{% endhighlight %}

Another example for array usage is to call a custom defined
resource multiple times, like this:

{% highlight ruby %}
    define php::pear() {
      package { "php-${name}": ensure => installed }
    }

    php::pear { ['ldap', 'mysql', 'ps', 'snmp', 'sqlite', 'tidy', 'xmlrpc']: }
{% endhighlight %}

Of course, this can be used for native types as well:

{% highlight ruby %}
    file { [ 'foo', 'bar', 'foobar' ]:
      owner => 'root',
      group => 'root',
      mode  => '0600',
    }
{% endhighlight %}

### Hashes

Since Puppet version 2.6.0, hashes have been supported in the language.  These hashes are defined like Ruby hashes using the form:

{% highlight ruby %}
    { key1 => val1, key2 => val2, ... }
{% endhighlight %}

The hash keys are strings, but hash values can be any possible RHS values allowed in the language like function calls, variables, etc.

It is possible to assign hashes to a variable like so:

{% highlight ruby %}
    $myhash = { key1 => 'myval', key2 => $b }
{% endhighlight %}

And to access hash members (recursively) from a variable containing a hash (this also works for arrays too):

{% highlight ruby %}
    $myhash = { key => { subkey => 'b' }}
    notice($myhash[key][subkey])
{% endhighlight %}

You can also use a hash member as a resource title, as a default definition parameter, or potentially as the value of a resource parameter,

### Variables

Puppet supports variables like most other languages you may be familiar with.  Puppet variables are denoted with `$`:

{% highlight ruby %}
    $content = 'some content\n'

    file { '/tmp/testing': content => $content }
{% endhighlight %}

Puppet language is a declarative language, which means that its scoping and
assignment rules are somewhat different than a normal imperative
language. The primary difference is that you cannot change the
value of a variable within a single scope, because that would rely
on order in the file to determine the value of the variable.  Order
does not matter in a declarative language.  Doing so will result in an error:

{% highlight ruby %}
    $user = root
    file { '/etc/passwd':
      owner => $user,
    }
    $user = bin
    file { '/bin':
      owner   => $user,
      recurse => true,
    }
{% endhighlight %}

Rather than reassigning variables, instead use the built in conditionals:

{% highlight ruby %}
    $group = $operatingsystem ? {
      solaris => 'sysadmin',
      default => 'wheel',
    }
{% endhighlight %}

A variable may only be assigned once per scope.  However you still can set the same variable in non-overlapping scopes. For example, to set top-level
configuration values:

{% highlight ruby %}
    node a {
      $setting = 'this'
      include class_using_setting
    }
    node b {
      $setting = 'that'
      include class_using_setting
    }
{% endhighlight %}

In the above example, nodes "a" and "b" have different scopes, so this is
not reassignment of the same variable.

#### Variable Scope

Scoping may initially seem like a foreign concept, though in
reality it is pretty simple.   A scope defines where
a variable is valid.  Unlike early programming languages like BASIC,
variables are only valid and accessible in certain places in a
program.  Using the same variable name in different parts of
the language do not refer to the same value.

Classes and nodes introduce new scopes. Puppet is
currently dynamically scoped, which means that scope hierarchies
are created based on where the code is evaluated instead of where
the code is defined.

For example:

{% highlight ruby %}
    $test = 'top'
    class myclass {
      exec { "/bin/echo ${test}": logoutput => true }
    }

    class other {
      $test = 'other'
      include myclass
    }

    include other
{% endhighlight %}

In this case, there's a top-level scope, a new scope for `other`,
and the a scope below that for `myclass`. When this code is
evaluated, `$test` evaluates to `other`, not `top`.

#### Qualified Variables

Puppet supports qualification of variables inside a class. This
allows you to use variables defined in other classes.

For example:

{% highlight ruby %}
    class myclass {
      $test = 'content'
    }

    class anotherclass {
      $other = $myclass::test
    }
{% endhighlight %}

In this example, the value of the `$other` variable evaluates to
`content`. Qualified variables are read-only --- you cannot set a variable's value from other class.

Variable qualification is dependent on the evaluation order of your
classes. Class `myclass` must be evaluated before class
`anotherclass` for variables to be set correctly.

#### Facts as Variables

In addition to user-defined variables, the facts generated by
Facter are also available as variables.  This allows values that you
would see by running `facter` on a client system within Puppet manifests
and also within Puppet templates.  To use a fact as a variable
prefix the name of the fact with `$`. For example, the value of the
`operatingsystem` and `puppetversion` facts would be available as
the variables `$operatingsystem` and `$puppetversion`.

#### Variable Expressions

In Puppet 0.24.6 and later, arbitrary expressions can be assigned
to variables, for example:

{% highlight ruby %}
    $inch_to_cm = 2.54
    $rack_length_cm = 19 * $inch_to_cm
    $gigabyte = 1024 * 1024 * 1024
    $can_update = ($ram_gb * $gigabyte) > 1 << 24
{% endhighlight %}

See the Expression section later on this page for further details
of the expressions that are now available.

#### Appending to Variables

In Puppet 0.24.6 and later, values can be appended to array variables:

{% highlight ruby %}
    $ssh_users = [ 'myself', 'someone' ]

    class test {
      $ssh_users += ['someone_else']
    }
{% endhighlight %}

Here the `$ssh_users` variable contains an array with the elements
`myself` and `someone`. Using the variable append syntax, `+=`, we
added another element, `someone_else` to the array.

Please note, variables cannot be modified in the same scope because of the
declarative nature of Puppet.  As a result, $ssh_users contains the element
'someone_else' only in the scope of class test and not outside scopes.
Resources outside of this scope will "see" the original array containing only
myself and someone.

### Conditionals

At some point you'll need to use a different value based on the value of a variable, or decide to not do something if a particular value is set.

Puppet currently supports two types of conditionals:

-   The *selector* which can be used within resources and variable assignments
    to pick the correct value for an attribute, and
-   *statement conditionals* which can be used more widely in your
    manifests to include additional classes, define distinct sets of
    resources within a class, or make other structural decisions.

Case statements do not return a value.   Selectors do.  That is the primary difference between them and why you would use one and not the other.

#### Selectors

If you're familiar with programming terms, The selector syntax works like a multi-valued ternary operator, similar to C's `foo = bar ? 1 : 0` operator where `foo` will be set to `1` if `bar` evaluates to true and `0` if `bar` is false.

Selectors are useful to specify a resource attribute or assign a
variable based on a fact or another variable. In addition to any
number of specified values, selectors also allow you to specify a
default if no value matches; if no default is supplied and a selector fails to match, it will result in a parse error.

Here's a simple example of selector use:

{% highlight ruby %}
    file { '/etc/config':
      owner => $operatingsystem ? {
        'sunos'  => 'adm',
        'redhat' => 'bin',
        default  => undef,
      },
    }
{% endhighlight %}

If the `$operatingsystem` fact (sent up from 'facter') returns `sunos` or `redhat` then the ownership of the file is set to `adm` or `bin` respectively. Any other result and the `owner` attribute will not be set, because it is listed as `undef`.

Remember to quote the comparators you're using in the selector as
the lack of quotes can cause syntax errors.

Selectors can also be used in variable assignment:

{% highlight ruby %}
    $owner = $operatingsystem ? {
      'sunos'  => 'adm',
      'redhat' => 'bin',
      default  => undef,
    }
{% endhighlight %}

In Puppet 0.25.0 and later, selectors can also be used with regular
expressions:

{% highlight ruby %}
    $owner = $operatingsystem ? {
      /(redhat|debian)/ => 'bin',
      default           => undef,
    }
{% endhighlight %}

In this last example, if `$operatingsystem` value matches either redhat
or debian, then `bin` will be the selected result, otherwise the owner
will not be set (`undef`).

Like Perl and some other languages with regular expression support, captures in selector regular expressions automatically create some
limited scope variables (`$0` to `$n`):

{% highlight ruby %}
    $system = $operatingsystem ? {
      /(redhat|debian)/ => "our system is $1",
      default           => "our system is unknown",
    }
{% endhighlight %}

In this last example, `$1` will get replaced by the content of the
capture (here either `redhat` or `debian`).

The variable `$0` will contain the whole match.

#### Case Statement

`Case` is the other form of Puppet's two conditional statements, which
can be wrapped around any Puppet code to add decision-making logic
to your manifests.  Case statements, unlike selectors, do not return a value. Also unlike selectors, a failed match without a default specified will simply skip the case statement instead of throwing a parse error.  A common use for the `case` statement is to apply different classes to a particular node based on its operating
system:

{% highlight ruby %}
    case $operatingsystem {
      'sunos':  { include solaris } # apply the solaris class
      'redhat': { include redhat  } # apply the redhat class
      default:  { include generic } # apply the generic class
    }
{% endhighlight %}

Case statements can also specify multiple match conditions by separating
each with a comma:

{% highlight ruby %}
    case $hostname {
      'jack','jill':     { include hill    } # apply the hill class
      'humpty','dumpty': { include wall    } # apply the wall class
      default:           { include generic } # apply the generic class
    }
{% endhighlight %}

Here, if the `$hostname` fact returns either `jack` or `jill` the
`hill` class would be included.

In Puppet 0.25.0 and later, the `case` statement also supports
regular expressions:

{% highlight ruby %}
    case $hostname {
      /^j(ack|ill)$/: { include hill    } # apply the hill class
      /^[hd]umpty$/:  { include wall    } # apply the wall class
      default:        { include generic } # apply the generic class
    }
{% endhighlight %}

In this last example, if `$hostname` matches either `jack` or
`jill`, then the `hill` class will be included. But if `$hostname`
matches either `humpty` or `dumpty`, then the `wall` class will be
included.

As with selectors (see above), regular expressions captures are also available.
These create limited scope variables `$0` to `$n`:

{% highlight ruby %}
    case $hostname {
      /^j(ack|ill)$/: { notice("Welcome $1!") }
      default:        { notice("Welcome stranger") }
    }
{% endhighlight %}

In this last example, if `$host` is `jack` or `jill` then a notice
message will be logged with `$1` replaced by either `ack` or
`ill`.  `$0` contains the whole match.

#### If/Else Statement

The `if/else` provides branching options based on the truth value of a variable:

{% highlight ruby %}
    if $variable {
      file { '/some/file': ensure => present }
    } else {
      file { '/some/other/file': ensure => present }
    }
{% endhighlight %}

In Puppet 0.24.6 and later, the `if` statement can also branch
based on the value of an expression:

{% highlight ruby %}
    if $server == 'mongrel' {
      include mongrel
    } else {
      include nginx
    }
{% endhighlight %}

In the above example, if the value of the variable `$server` is equal to `mongrel`, Puppet
will include the class `mongrel`, otherwise it will include the class `nginx`.

From version 2.6.0 and later an `elsif` construct was introduced into the language:

{% highlight ruby %}
    if $server == 'mongrel' {
      include mongrel
    } elsif $server == 'nginx' {
      include nginx
    } else {
      include thin
    }
{% endhighlight %}

Arithmetic expressions are also possible, for example:

{% highlight ruby %}
    if $ram > 1024 {
      $maxclient = 500
    }
{% endhighlight %}

In the previous example if the value of the variable `$ram` is
greater than `1024`,  Puppet will set the value of the `$maxclient` variable
to `500`.

"If" statements also support the use of regular expressions and "in" expressions. More complex expressions can also be made by combining arbitrary expressions with the
Boolean `and`, `or`, and `not` operators:

{% highlight ruby %}
    if ( $processor_count > 2 ) and (( $ram >= 16 * $gigabyte ) or ( $disksize > 1000 )) {
      include for_big_irons
    } else {
      include for_small_box
    }
{% endhighlight %}

See the Expressions section further down for more information on expressions.

### Virtual Resources

See [Virtual Resources](./virtual_resources.html).

Virtual resources are available in Puppet 0.20.0 and later.

Virtual resources are resources that are not sent to the client unless `realized`.

The syntax for a virtual resource is:

{% highlight ruby %}
    @user { 'luke': ensure => present }
{% endhighlight %}

The user luke is now defined virtually. To realize that definition,
you can use a `collection`:

{% highlight ruby %}
    User <| title == luke |>
{% endhighlight %}

This can be read as 'the user whose title is luke'.   This is equivalent to using
the `realize` function:

{% highlight ruby %}
    realize User['luke']
{% endhighlight %}

Realization could also use other criteria, such as realizing Users that match
a certain group, or using a metaparameter like 'tag'.

The motivation for this feature is somewhat complicated; please see
the [Virtual Resources](./virtual_resources.html) page for more information.

### Exported Resources

Exported resources are an extension of virtual resources used to
allow different hosts managed by Puppet to influence each other's
Puppet configuration.  This is described in detail on the [Exported Resources](./exported_resources.html) page.
As with virtual resources, new syntax was added to the language for this purpose.

The key syntactical difference between virtual and exported
resources is that the special sigils (@ and <| |\>) are doubled (@@
and <<| |\>\>) when referring to an exported resource.

Here is an example with exported resources that shares SSH keys
between clients:

{% highlight ruby %}
    class ssh {
      @@sshkey { $hostname: type => dsa, key => $sshdsakey }
      Sshkey <<| |>>
    }
{% endhighlight %}

In the above example, notice that fulfillment and exporting are used
together, so that any node that gets the 'sshkey' class will have
all the ssh keys of other hosts.  This could be done differently so
that the keys could be realized on different hosts.

To actually work, the `storeconfig` parameter must be set to
`true` in puppet.conf.  This allows configurations from client
to be stored on the central server.

The details of this feature are somewhat complicated; see
the [Exported Resources](./exported_resources.html)
page for more information.

### Reserved Words & Acceptable Characters

Variable names can include alphanumeric characters and underscores, and are case-sensitive.

Class names, module names, and the names of defined and custom resource types should be restricted to lowercase alphanumeric characters and underscores, and should begin with a lowercase letter; that is, they should match the expression `[a-z][a-z0-9_]*`. Although some names that violate these restrictions currently work, using them is not recommended.

Class and defined resource type names can use `::` as a namespace separator, which is both semantically useful and a means of directing the behavior of the module autoloader. The final segment of a [qualified variable](#qualified-variables) name must obey the restrictions on variable names, and the preceding segments must obey the restrictions on class names.

Parameters used in parameterized classes and defined resource types can include alphanumeric characters and underscores, cannot begin with an underscore, and are case-sensitive. In practice, they should be treated as though they were under the same restrictions as class names in order to maximize future compatibility.

There is no practical restriction on resource names.

Any word that the syntax uses for special meaning is
a reserved word, meaning you cannot use it for
variable or type names.   Words like `true`, `define`,
`inherits`, and `class` are all reserved. If you ever need to use a
reserved word as a value, be sure to quote it.

### Comments

Puppet supports two types of comments:

-   Unix shell style comments; they can either be on their own line or at
    the end of a line.
-   multi-line C-style comments (available in Puppet 0.24.7 and later)

Here is a shell style comment:

{% highlight ruby %}
    # this is a comment
{% endhighlight %}

You can see an example of a multi-line comment:

{% highlight ruby %}
    /*
    this is a comment
    */
{% endhighlight %}

Expressions
------------

Starting with version 0.24.6 the Puppet language supports arbitrary
expressions in `if` statement boolean tests and in the right hand
value of variable assignments.

Puppet expressions can be composed of:

-   boolean expressions, which are combination of other expressions
    combined by boolean operators (`and`, `or` and `not`)
-   comparison expressions, which consist of variables, numerical
    operands or other expressions combined with comparison operators (
    `==`, `!=`, `<`, `>`, `<=`, `>`, `>=`)
-   arithmetic expressions, which consists of variables, numerical
    operands or other expressions combined with the following
    arithmetic operators: `+`, `-`, `/`, `*`, `<<`, `>>`
-   in Puppet 0.25.0 and later, regular expression matches with the help of the
    regex match operator: `=~` and `!~`
-   in Puppet 2.6.0 and later, `in` expressions, which test whether the right operand contains the left operand. 

Expressions can be enclosed in parenthesis, `()`, to group
expressions and resolve operator ambiguity.

### Operator precedence

The Puppet operator precedence conforms to the standard precedence in
most systems, from highest to lowest:

    ! -> not
    * / -> times and divide
    - + -> minus, plus
    << >> -> left shift and right shift
    == != -> not equal, equal
    >= <= > < -> greater equal, less or equal, greater than, less than
    and
    or

### Expression examples

#### Comparison expressions

Comparison expressions include tests for equality using the `==`
expression:

{% highlight ruby %}
    if $variable == 'foo' {
      include bar
    } else {
      include foobar
    }
{% endhighlight %}

Here if `$variable` has a value of `foo`, Puppet will then include the `bar`
class, otherwise it will include the `foobar` class.

Here is another example shows the use of the `!=` ('not equal') comparison
operator:

{% highlight ruby %}
    if $variable != 'foo' {
      $othervariable = 'bar'
    } else {
      $othervariable = 'foobar'
    }
{% endhighlight %}

In our second example if `$variable` is not equal to a value of `foo`, Puppet will then set
the value of the `$othervariable` variable to `bar`, otherwise it will set the
`$othervariable` variable to `foobar`.

**Note that comparison of strings is case-insensitive.**

#### Arithmetic expressions

You can also perform a variety of arithmetic expressions, for
example:

{% highlight ruby %}
    $one = 1
    $one_thirty = 1.30
    $two = 2.034e-2

    $result = ((( $two + 2) / $one_thirty) + 4 * 5.45) - (6 << ($two + 4)) + (0x800 + -9)
{% endhighlight %}

#### Boolean expressions

Boolean expressions are also possible using `or`, `and` and `not`:

{% highlight ruby %}
    $one = 1
    $two = 2
    $var = ( $one < $two ) and ( $one + 1 == $two )
{% endhighlight %}

The exclamation mark (`!`) can be used as a synonym for `not.`

#### Regular expressions

In Puppet 0.25.0 and later, Puppet supports regular expression matching
using `=~` (match) and `!~` (not-match) for example:

{% highlight ruby %}
    if $host =~ /^www(\d+)\./ {
      notice('Welcome web server #$1')
    }
{% endhighlight %}

Like case and selectors, the regex match operators create limited
scope variables for each regex capture.  In the previous example,
`$1` will be replaced by the number following `www` in `$host`.
Those variables are valid only for the statements inside the
braces of the if clause.

#### "in" expressions

From Puppet 2.6.0, Puppet supports an "in" syntax.  This operator allows
you to find if the left operand is in the right one. The left operand must
be a string, but the right operand can be:

* a string
* an array
* a hash (the search is done on the keys)

This syntax can be used in any place where an expression is supported:

{% highlight ruby %}
    $eatme = 'eat'
    if $eatme in ['ate', 'eat'] {
    ...
    }

    $value = 'beat generation'
    if 'eat' in $value {
      notice('on the road')
    }
{% endhighlight %}

Like other expressions, "in" expressions can be combined or negated with boolean operators:

{% highlight ruby %}
    if ! ($eatme in ['ate', 'eat']) { ... }
{% endhighlight %}

### Backus Naur Form

We've already covered the list of operators, though if you wish to see it,
here's the available operators in Backus Naur Form:

    <exp> ::=  <exp> <arithop> <exp>
             | <exp> <boolop> <exp>
             | <exp> <compop> <exp>
             | <exp> <matchop> <regex>
             | ! <exp>
             | - <exp>
             | "(" <exp> ")"
             | <rightvalue>

    <arithop> ::= "+" | "-" | "/" | "*" | "<<" | ">>"
    <boolop>  ::= "and" | "or"
    <compop>  ::= "==" | "!=" | ">" | ">=" | "<=" | "<"
    <matchop>  ::= "=~" | "!~"

    <rightvalue> ::= <variable> | <function-call> | <literals>
    <literals> ::= <float> | <integer> | <hex-integer> | <octal-integer> | <quoted-string>
    <regex> ::= '/regex/'

Functions
---------

Puppet supports many built in functions; see the [Function Reference](/references/stable/function.html) for details --- see [Custom Functions](/guides/custom_functions.html) for information on how to create
your own custom functions.

Some functions can be used as a statement:

{% highlight ruby %}
    notice('Something weird is going on')
{% endhighlight %}

(The notice function above is an example of a function that will log on the server)

Or without parentheses:

{% highlight ruby %}
    notice 'Something weird is going on'
{% endhighlight %}

Some functions instead return a value:

{% highlight ruby %}
    file { '/my/file': content => template('mytemplate.erb') }
{% endhighlight %}

All functions run on the Puppet master, so you only have access to the file system and resources on that host from your functions. The only exception to this is that the value of any Facter facts that have been sent to the master from your clients are also at your disposal.  See the [Tools Guide](./tools.html) for more information about these components.

Importing Manifests
-------------------

Puppet has an `import` keyword for importing other manifests. **You should almost never use it,** as almost every use case for it has been replaced by the [module autoloader](./modules.html#module-autoloading). In particular, you should never use any import statements inside a module, as the behavior of import within autoloaded manifests is undefined. 

The `import` keyword does not insert Puppet code inline like a C preprocessor #include directive; instead, it adds all code in the requested file to the main scope. This means any code in these external manifests must be in a class, node statement, or defined type, or else it will be applied to all nodes:

{% highlight ruby %}
    # site.pp
    node kestrel.puppetlabs.lan {
        # Wrong wrong wrong!
        import nodes/kestrel.pp
    }
    
    # kestrel.pp
    include ntp
    include apache2
    # These two classes are outside any node statement, and will always be applied.
{% endhighlight %}

Files are only searched for within the same directory as the file doing the importing. Files can also be imported using globbing, as implemented by Ruby's `Dir.glob` method:

{% highlight ruby %}
    import 'nodes/*.pp'
    import 'packages/[a-z]*.pp'
{% endhighlight %}

Instead of importing manifests, you should organize all class manifests into [Modules](./modules.html). The one case where `import` is still useful is for maintaining a `nodes/` directory with one manifest per node and then placing an `import 'nodes/*.pp'` statement in `site.pp`. However, note that doing this can cause puppet master to [not notice edits to your node definitions](./troubleshooting.html#why-hasnt-my-new-node-configuration-been-noticed). 

Handling Compilation Errors
---------------------------

Puppet does not use manifests directly, it compiles them down to a internal format
that the clients can understand.

By default, when a manifest fails to compile, the previously compiled version of the Puppet
manifest is used instead.

This behavior is governed by a setting in `puppet.conf` called `usecacheonfailure`
and is set by default to `true`.

This may result in surprising behaviour if you are editing
complex configurations.

Running the Puppet client with `--no-usecacheonfailure` or with `--test`, or setting
`usecacheonfailure = false` in the configuration file, will disable
this behaviour.
