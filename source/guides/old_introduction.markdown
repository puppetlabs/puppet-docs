Introduction to Puppet
======================

* * *

Why Puppet Exists
-----------------

System administrators, or "sysadmins", have a long tradition of
writing simple tools to help them get their work done faster,
whether they work for a large organization maintaining hundreds or
thousands of machines or they just maintain a couple of machines
part time. Very little of this software ever gets published,
though, which means very little of it is ever reused and very
little of it ever develops into mature tools useful outside the
organization that wrote it. This, combined with the fact that
organizations rather than sysadmins usually retain the copyright
for these tools, means that most sysadmins start from scratch at
every new company, building ever-more-powerful systems based on ssh
and a `for` loop or something similar.

Puppet has been developed to help the sysadmin community move to
building and sharing mature tools that avoid the duplication of
everyone solving the same problem. It does so in two ways:

-   It provides a powerful framework to simplify the majority of
    the technical tasks that sysadmins need to perform
-   The sysadmin work is written as code in Puppet's custom
    language which is shareable just like any other code.

This means that your work as a sysadmin can get done much faster,
because you can have Puppet handle most or all of the details, and
you can download code from other sysadmins to help you get done
even faster. The majority of Puppet implementations use at least
one or two modules developed by someone else, and there are already
tens of recipes available in Puppet's [Patterns][^patterns]

Puppet As a Tool
----------------

The vast majority of Puppet's internals could be reused by other
projects, but it was written as a comprehensive configuration
management tool, although with close attention to keep the
different pieces decoupled. Puppet does everything possible to
enable you to use it however you like, but it has its own defaults
that it will prefer.

In particular, Puppet is usually used in a star formation, with all
of your clients talking to one or more central servers. Each client
contacts the server periodically (every half hour, by default),
gets its latest configuration, and makes sure it is in sync with
that configuration. Once done, it can send a report back to the
server indicating what, if anything, happened. This diagram shows
the data flow in a regular Puppet implementation:

![image](http://puppetlabs.com/images/Puppet_Star.png)

Puppet's functionality is built as a stack of separate layers, each
responsible for a fixed aspect of the system, with tight controls
on how information passes between layers:

![image](http://puppetlabs.com/images/Puppet_Layers.png)

To use Puppet effectively, you'll need to understand a bit about
each of these layers, how they relate to each other, and which
layer is responsible for a given aspect of Puppet's functionality.

Idempotency
-----------

One big difference between Puppet and most hand-rolled tools is
that Puppet configurations are idempotent, meaning they can safely
be run multiple times. Once you develop your configuration, your
machines will apply the configuration often -- by default, every 30
minutes -- and Puppet will only make any changes to the system if
the system state does not match the configured state.

This behaviour is provided by Puppet's Transactional layer. Puppet
does not yet have full transactional support -- transactions are
not recorded, and thus cannot be rolled back -- but the basics are
there, and they are what manage how changes happen to the system.
If you tell the transactional system to operate in no-op, or
dry-run, mode, using the `--noop` argument to one of the Puppet
tools, then the transaction will guarantee that no work happens on
your system. Similarly, if any changes do happen, the transaction
will guarantee that those specific changes are logged.

This way you can use Puppet to manage a machine throughout its
lifecycle -- from initial installation, to ongoing upgrades, and
finally to end-of-life, where you move services elsewhere. Unlike
system install tools like Sun's Jumpstart or Red Hat's Kickstart,
Puppet configurations can keep machines up to date for years,
rather than just building them correctly and never touching them
again. Because of this, Puppet users usually do just enough with
their host install tools to get Puppet running, then they use
Puppet to do everything else.

A Resource Abstraction Layer
----------------------------

Puppet's main goal is to allow you to focus on the system entities
you really care about, ignoring implementation details like command
names, arguments, and file formats -- your tools should treat all
users the same, whether the user is stored in NetInfo or
`/etc/passwd`, and you shouldn't have to care which local tools are
used to interact with the user store. We call these system entities
`resources`, and Puppet is developed around making it easy to
manage these resources and their relationships to each other.

### Providers

Puppet ships with many resource types (documented in the
[Type Guides](./types/) and [References](/references/)),
including all the basics like file, user, and package. The
implementation for these types often varies dramatically from one
platform to another, such as Mac OS X using DSLocal(NetInfo
pre-10.5, Leopard) for a user database, or the wide variety in
package formats supported by different platforms, so Puppet
supports multiple implementations per resource type (e.g., there
are currently 17 implementations of the package type). Puppet calls
these implementations `providers`, and it will normally choose an
appropriate default provider for your resource, based on your
platform or what providers are functional, although you can easily
override the chosen value.

### Modifying the System

Puppet resources are what are responsible for directly managing the
bits on disk. You cannot directly modify a system from the language
-- you must use the language to specify a resource, which then
modifies the system. This often results in a rethinking of typical
configuration tasks -- rather than tacking a couple of lines onto
the end of your `fstab`, you use the `mount` type to create a new
resource that knows how to modify the `fstab`, or NetInfo, or
wherever mount information is kept.

All resources are simple collections of attributes, some of which
change how the resource functions and some of which directly manage
the resource (these are called `properties`). For instance, users
have an attribute that determines whether creating a user also
creates the home directory -- this doesn't directly modify the
user, it just changes how the user is created. Most of the
attributes you'll care about are properties, though, which on the
user are things like the `uid`, `gid`, and home directory; when you
change these, they directly modify the system.

There is another special kind of attribute, those which work on all
resources. These are called `metaparams`, and include things like
the log level for the resource, whether the resource should be in
`noop` mode so it never modifies the system, and all of the
relationship handling.

#### Resource Relationships

Puppet's support for resource relationships is one of its key
features, since these relationships are used to determine the order
of execution when applying a configuration and they also are used
to determine whether a resource needs to respond to changes in
another resource.

If you specify that one resource, such as a service, depends on
another resource, such as a configuration file, then Puppet will
always guarantee that the required resource will get applied before
the requiring resource. This way you know you'll never try to start
your service until the correct configuration file is in place.

You can go one further and say that Puppet should restart the
service whenever the configuration file changes, so when you use
Puppet to manage both a service and its dependencies, you can
always be sure that the service is running the most recent code
against the most current configuration, for instance.

#### Exec Resources

Sometimes, there will not be a resource type already developed for
managing the resource you're interested in; for these cases, we
provide an `exec` resource type, which allows you to run external
commands, along with hooks to make the exec behave idempotently.
For instance, you can create an `exec` instance that creates a
Subversion repository using the `svnadmin` command, along with a
check that causes the command to only get run if the repository
does not already exist. Puppet's language lets you wrap these
`exec` resources so that they look more like normal resources and
are reusable; you would use an `svnrepo` resource, rather than
typing out the full `exec` command each time, in this case.

The Language
------------

### Resources

Puppet is all about managing resources, so the language focuses on
specifying those resources. The most basic statement is a single
resource specification:

    # Make sure the modes on the sudoers file are correct
    file { "/etc/sudoers": 
      owner => "root",
      group => "root",
      mode  => 644
    }

Here we've got the required elements for any resource: The type
(file), the title of the resource (`/etc/sudoers`), and the
attributes. Note that we have to quote the file path here, but any
word matching `[-\w]+` (meaning any alphanumeric word plus the `-`
character, such as `node-name` or `fake_w0rd`) does not need to be
quoted. Whitespace is largely irrelevant in Puppet.

We can also create multiple resources in one set of brackets by
separating the different resource instances with semicolons:

    file {
      "/etc/sudoers":
        owner => "root",
        group => "root",
        mode  => 644;
      "/usr/sbin/sudo":
        owner => "root",
        group => "root",
        mode  => 4111
    }

Trailing commas and trailing semicolons are perfectly acceptable.

#### Stopping Configuration Overlap

Puppet's interpreter will not let you manage the same resource from
multiple parts of your configuration. For instance, if two
different Puppet classes attempt to specify the same resource, then
you will get a parse error.

This is how Puppet ensures that two classes do not overlap, so you
can be confident that your class does not conflict with one
developed by your coworker or that you downloaded off the 'net.

Puppet's current mechanism for determining if two resources overlap
is by comparing the type and title: If two resources have the same
type and title, then they are considered to be the same resource.

### Classes

The next step up is to start associating resources; you would
normally have at least the `sudo` package installed, and you'd put
both the package and the configuration file into a class:

    class sudo {
      package { sudo: ensure => installed }
      file { 
        "/etc/sudoers":
          owner => "root",
          group => "root",
          mode  => 644;
        "/usr/sbin/sudo":
          owner => "root",
          group => "root",
          mode  => 4111
      }
    }

Then you can just call `include sudo` and both resources would get
applied.

#### Inheritance

Puppet supports a limited form of class inheritance, but it's only
useful for one thing: Subclasses can override resources defined in
parent classes, using a special override syntax. Here's a contrived
example:

    class base {
      file { "/my/file": content => template("base.erb") }
    }
    
    class sub inherits base {
      # override the content
      File["/my/file"] { content => template("other.erb") }
    } 

In the `sub` class above, the resource type (in this case `File`)
is capitalized. This means that we are referring to a type that has
already been declared. Using `file` instead would be illegal since
that would result in resource overlap.

A More Complicated Example: SSH
-------------------------------

Life isn't always this easy, though. Most packages have an
associated service, and there usually isn't much consistency in
names across platforms. For instance, nearly every Unix-like
variant these days has Secure Shell installed, but they all seem to
pick random names for both the package and the service. Also,
you're going to want to do more than just install the package,
you'll want to start the service:

    class ssh {
      package { ssh: ensure => installed }
      file { sshd_config:
        name => $operatingsystem ? {
          Darwin  => "/etc/sshd_config",
          Solaris => "/opt/csw/etc/ssh/sshd_config",
          default => "/etc/ssh/sshd_config"
        },
        source => "puppet://server.domain.com/files/ssh/sshd_config"
      }
      service { ssh:
        name => $operatingsystem ? {
          Solaris => openssh,
          default => ssh
        },
        ensure    => running,
        subscribe => [Package[ssh], File[sshd_config]]
      }
    }

### Facter Variables

We've introduced a couple of new things here. First is the
`$operatingsystem` variable. This variable is set, along with many
others, in the top-level scope by the parser, which gets the values
from [Facter](/projects/facter) -- you can get a list of all
available variables by just running the stand-alone `facter`
script, but you'll also want to know about `$ipaddress` and
`$hostname`, just to start.

### Selectors

Another new thing is the `? { ... }` syntax, which we call a
`selector` and is somewhat similar to the relatively common trinary
operator. This tests the variable before the `?`, and picks a
matching value from the provided list, or the `default` value if
nothing matches. This allows us to provide different values based
on the operating system, host name, or just about anything else we
want. Note that it is a parse error if no value matches. Also,
selectors (as of 0.22.2) are case-insensitive in their matching.

### Titles vs. Names

A somewhat weird thing here is that we're providing a second name
to some of our resources. Note that above I called the value before
the colon the resource's `title` -- this is the name by which you
know the resource, and it's how you refer to the resource when
setting up relationships. However, the computers aren't quite so
handy as you, so you have to tell them how to find the resource
locally. In that case, you provide a separate `name`, which
defaults to being the same as the title, and the resource uses the
name to modify the system but Puppet uses the title for everything
else.

### Resource Relationships

Lastly, we pull all this together by specifying a relationship
between our service and its package and configuration file. The
`File[sshd_config]` syntax is called a `resource reference`, and
it's used to uniquely refer to a resource. Note that the service
can just specify the title of the configuration file, it does not
need to specify the full path -- this is good, because otherwise
you'd have to use another selector, which would get old fast.

Other Language Features
-----------------------

### Truth

Nearly everything in Puppet is treated as a string, including
numbers and booleans, but if you use an unquoted `true` or `false`,
then Puppet will treat these as booleans (quote them if you want
them to be strings). These are useful as default values for
definitions, but they're also often used as values to resource
attributes.

### Variables

We've already seen the usage of variables, but of course you can
set them, also:

    $myvar = value

Puppet will refuse to allow you to assign to the same variable
twice in a given class or definition, because it will only ever use
the second value and your first value will get thrown away, since
all variable assignments are evaluated before any resource
specifications.

### More Conditionals

We've already seen `selectors`, which are useful for selecting
values, but Puppet also supports case statements, for when you want
to conditionally include entire resource specifications:

    case $operatingsystem {
    Darwin: { file { "/some/file": ensure => present } }
    default: { file { "/other/file": ensure => present } }
    }

As with selectors, case statements do case-insensitive matching.

There's also a simple `if/else` construct, which is basically just
a trimmed-down `case`:

    if $should {
      file { "/some/file": ensure => present }
    } else {
      file { "/other/file": ensure => present }
    }

From Puppet version 0.24.6 Puppet also supports comparison
operators.

### Arrays

Puppet has very limited support for arrays -- you can create them,
and pass them as values, but you can not modify them. They're
mostly useful for passing multiple values to an attribute, as above
in the SSH example, or in managing multiple similar resources at
once:

    user { [bin, adm]: ensure => present }

This is a simple short-hand for creating two user resources, one
for each item in the array.

### Functions

Puppet supports a simple function syntax, and all functions are
hard-wired as either statements, which do not return values, and
rvalue functions, which return values but are expected not to have
side effects:

    notice("This is a log message") # a statement
    
    $content = template("mytemplate.erb") # an rvalue

It ships with quite a few built-in functions, all of which are
documented in the
[function reference](functions/).
Some of the most useful ones are
\`include`` , which evaluates the named classes, and `template`, which
uses ERb_ to generate file contents.   It is often useful to create
your own custom functions, which is
very easy to do with Puppet.

{MISSINGREFS}

### Definitions

One of the most useful syntactical structures in Puppet are
definitions, which can be used to wrap multiple resources that
together act like a single resource, or possible to wrap a single
resource but with a different model so it's more clear what the
resource does.  For instance, Apache2 virtual hosts on Debian are very
simple to manage -- you drop the virtual host configuration into
`/etc/apache2/sites-available`, and then you link the file over
to `/etc/apache2/sites-enabled`.  You could duplicate this code for
every virtual host, but it's much easier and better to create a
definition to do this for you:

    define virtual_host($docroot, $ip, $order = 500, $ensure = "enabled") {
        $file = "/etc/sites-available/$name.conf"

        # The template fills in the docroot, ip, and name.
        file { $file:
            content => template("virtual_host.erb"),
            notify  => Service[apache]
        }
        file { "/etc/sites-enabled/$order-$name.conf":
            ensure => $ensure ? {
                enabled  => $file,
                disabled => absent
            }
        }
    }

Then you can use that definition and make it clear that even though
you're just creating files, you're really configuring a virtual host:

    virtual_host { "puppetlabs.com":
        order   => 100,
        ip      => "192.168.0.100",
        docroot => "/var/www/puppetlabs.com/htdocs"
    }

You could reuse this
definition for every virtual host on your network.  This is often used
to wrap one or more`exec`resources to make it more clear what is being
done.  For instance, here is a simple definition that creates
Subversion repositories:

    # Create a new subversion repository.
    define svnrepo($path) {
        exec { "create-svn-$name":
            command => "/usr/bin/svnadmin create $path/$name",
            creates => "$path/$name" # only run if this file does not exist
        }
    }  

Very simple, but then using it makes it immediately clear what
you're doing:

    svnrepo { puppet: path => "/var/lib/svn" }

Also, the definition can handle platform differences in a way that you
wouldn't want to do every time you created a repository.  Another
reason to wrap your duplicate resources in definitions is that
Puppet's interpreter can be used to verify that you aren't managing
the same resource in multiple places and can provide more meaningful
error messages if you are.  For instance, you could create different
Subversion repositories named `puppet` using `exec` and you'd never know
as long as they had different paths, but if you wrap that exec in a
definition and always use it to create your Subversion repositories,
this would throw a parse error and you'd catch it before you ever
deployed it.  

### Nodes

The last important language construct is the
node definition.  This works essentially exactly like the class
definition, including inheritance, except that instead of explicitly
loading a node, Puppet's interpreter does it for you when a node
connects.  The interpreter looks through the list of node definitions
for one matching the client name and evaluates the resulting
definition if it finds one.  You can also define a`default`node, which
will be used if an appropriate node definition cannot be found.  Note
that you can use fully qualified node names, but you must single quote
them.  You can also start the Puppet server with `--no-nodes` to
disable the use of the node definition; instead, the interpreter will
just evaluate all of the top level code, so you'd need to use
something like a case statement to determine what classes a given node
would get.

Language Tutorial
-----------------

For more information on the Puppet Language, read the [language
tutorial](language_tutorial.html), which covers the language in
more detail.

Reporting
---------

By default, clients do not send reports back to Puppet, but this can
be easily enabled by putting ``report = true` in `puppetd.conf`.

The reports that clients send back include every log message generated
during the transaction, along with some basic metrics like how many
resources are being managed, how many changed, how many failed, and
how many were restarted.

By default, the reports are stored on disk in YAML, so you can easily
write a simple Ruby script to process these reports and turn them into
summary web pages.  There are other reports described in the `report
reference`, including a report that stores the metrics in RRD_
database files.

Stand Alone
-----------

While Puppet is meant to be used client/server, it ships with a
stand-alone `puppet` interpreter.  This can be used to run simple
stand-alone Puppet scripts, or you can use it like Cfengine, where you
pull all of the configurations down and then compile them locally.
It's also very useful for initializing your Puppet server, since you
can start it with `--use-nodes` to have it use the node definitions;
you can create a Puppet configuration that will configure the server
entirely, and then use Puppet to configure itself. Mmm, self-reference.

Dynamism
--------

Wherever possible, Puppet automatically loads new code that you
write. You can create custom functions, resource types, providers,
reports, and much more, drop them into the right directory in your
Ruby search path, and start using them -- Puppet will load them
automatically.

Conclusion
----------

This is only meant as an introduction to the breadth of
functionality in Puppet, with a quick run-through of many of the
most useful idioms. There is comprehensive
[documentation](index.html),
and there are many [example patterns][^patterns]: to get you further
along. We're constantly working on the documentation, so if you have
any specific requests, send them to docs at
[puppetlabs.com](http://puppetlabs.com).

[^patterns]: http://puppetlabs.com/trac/puppet/wiki/Recipes
