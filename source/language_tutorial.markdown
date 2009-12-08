Language Tutorial
=================

The purpose of Puppet's language is to make it easy to specify the
resources you need to manage on the machines you're managing. The
language has been developed with a focus on making it easy to
handle all kinds of heterogeneity, whether that means different
resources for different hosts or different attributes for a similar
list of resources.

* * *

Resources
---------

Resources are fundamentally built from a type, a title, and a list
of attributes, with each resource type having a specific list of
supported attributes. You can find all of the supported resource
types, their valid attributes, and documentation for all of it in
the [Type Reference](types/). Here's a simple example
of a resource:

    file { "/etc/passwd":
        owner => root,
        group => root,
        mode  => 644,
    }

Any machine on which this snippet is executed will use it to verify
that the passwd file is configured as specified. The field before
the colon is the resource's `title`, which can be used to refer to
the resource in other parts of the configuration.

For simple resources that don't vary much, a single name is
sufficient. There are many resources, though, whose names vary from
one system to another; e.g., in the case of files, a single file
might have different paths on different machines. For these cases,
Puppet allows you to specify a local name in addition to the
title:

    file { "sshdconfig":
        name => $operatingsystem ? {
            solaris => "/usr/local/etc/ssh/sshd_config",
            default => "/etc/ssh/sshd_config",
        },
        owner => root,
        group => root,
        mode  => 644,
    }

We're using a symbolic title that's meaningful to humans, along
with literal names for different platforms that provide the right
file path. We can now use this symbolic name to build
relationships:

    service { "sshd":
        subscribe => File[sshdconfig],
    }

This will cause the `sshd` service to get restarted when the
`sshdconfig` file changes. You'll notice that when we reference a
resource we capitalise the name of the resource, for example
`File[sshdconfig]`.

From Puppet version 0.24.6 you can specify multiple relationships
like so:

    service { "sshd":
        require => File["sshdconfig", "sshconfig", "authorized_keys"]

It's important to note here that the language doesn't actually know
much about the resources it is managing; it knows the name and the
type, and it has a list of parameters, but those parameters mean
nothing in the language. If you provide a symbolic title to a given
resource, you should always use that single title in the language,
because otherwise the language will assume you are managing
separate resources, which might result in an error on the client:

    file { "sshdconfig":
        name  => "/usr/local/etc/ssh/sshd_config",
        owner => "root",
    }
    
    file { "/usr/local/etc/ssh/sshd_config":
        owner => "sshd",
    }

The Puppet parser does not know that these resource specifications
will attempt to manage the same resource, because they have
different titles. This will result in an error on the client when
the second resource tries to instantiate and it is found to
conflict with the first resource.

### Metaparameters

In addition to the attributes specific to each type Puppet also has
global attributes called metaparameters. Metaparameters are
parameters that work with any resource type; they are part of the
Puppet framework itself rather than being part of the
implementation of any given instance. Thus, any defined
metaparameter can be used with any instance in your manifest,
including defined components.

In the examples in the section above we used two metaparameters,
`subscribe` and `require`, both of which build relationships
between resources. You can see a full list of metaparameters in the
[Metaparameter Reference](metaparameters.html).

### Resource Defaults

Sometimes you need to specify a default parameter value for a set
of resources; Puppet provides a syntax for doing this, using a
capitalized resource specification that has no title:

    Exec { path => "/usr/bin:/bin:/usr/sbin:/sbin" }
    exec { "echo this works": }

The first statement in this snippet provides a default value for
`exec` resources, which require either fully qualified paths or a
path in which to look for the executable. Individual resources can
still specify a unique value if they need to, but at least now you
do not have to specify this value every time. This way you can
specify a single default path for your entire configuration, and
then override that value as necessary.

Defaults can be used for any resource type.

Note also that defaults are not global -- they only affect the
current scope and scopes below the current one. If you want a
default setting to affect your entire configuration, your only
choice currently is to specify them outside of any class.

### Resource Collections

There are two ways to combine multiple resources: Classes and
definitions. Classes model fundamental aspects of nodes, so they
are singletons -- they only ever get evaluated once per node.
Definitions, on the other hand, behave like custom types defined in
the language and are meant to be evaluated multiple times, with
different inputs each time.

#### Classes

Classes are introduced with the `class` keyword, and their contents
are wrapped in curly braces:

    class unix {
        file {
            "/etc/passwd": 
                owner => "root", 
                group => "root", 
                mode  => 644;
            "/etc/shadow": 
                owner => "root", 
                group => "root", 
                mode  => 440;
        }
    }

Classes also support a simple form of inheritance that allows
subclasses to override resources defined in parent classes. Only
one class can be inherited by a class:

    class freebsd inherits unix {
        File["/etc/passwd"] { group => wheel }
        File["/etc/shadow"] { group => wheel }
    }

Conversely, you can use the `undef` keyword when overriding to make
the child class act as if the value had never been set in the
parent:

    class freebsd inherits unix {
        File["/etc/passwd"] { group => undef }
    }

In this example, nodes which include the `unix` class will have the
password file forced to group wheel, while nodes including
`freebsd` would have the password file group ownership left
unmodified.

From Puppet version 0.24.6 you can specify multiple overrides like
so:

    class freebsd inherits unix {
        File["/etc/passwd","/etc/shadow"] { group => wheel }
    }

It is also possible (since version 0.23.1) to add values to
resource parameters using the `+>` ('plusignment') operator:

    class apache {
        service { "apache": require => Package["httpd"] }
    }
    
    class apache-ssl inherits apache {
        # host certificate is required for SSL to function
        Service[apache] { require +> File["apache.pem"] }
    }

The above effectively makes the `require` parameter in the
`apache-ssl` class equal to
`[Package["httpd"], File["apache.pem"]]`.

You can add multiple values by separating each value with commas:

    class apache {
        service { "apache": require => Package["httpd"] }
    }
    
    class apache-ssl inherits apache {
        Service[apache] { require +> [ File["apache.pem"], File["/etc/httpd/conf/httpd.conf"] ] }
    }

The above would make the `require` parameter in the `apache-ssl`
class equal to
`[Package["httpd"], File["apache.pem"], File["/etc/httpd/conf/httpd.conf"]]`.

Like resources, you can also create relationships with classes like
so:

    class apache {
        service { "apache": require => Class["squid"] }
    }

The above uses the `require` metaparameter to make the `apache`
class dependent on the `squid` class.

From Puppet version 0.24.6 you can specify multiple relationships
like so:

    class apache {
        service { "apache":
                      require => Class["squid", "xml", "jakarta"]

Classes are evaluated using the `include` function. If a class is
already evaluated, then `include` essentially does nothing.

##### Qualification Of Nested Classes

Puppet supports qualification of classes defined inside a class.
This allows you to use classes defined inside other classes, which
is basically a way to achieve modularity.

For example:

    class myclass {
    class nested {
        file { "/etc/passwd": 
        owner => "root", 
        group => "root", 
        mode  => 644;
        }
    }
    }
    
    class anotherclass {
    include myclass::nested
    }

In this example, the `nested` class inside `myclass` is included as
`myclass::nested` in `anotherclass`. Qualification is dependent on
the evaluation order of your classes. Class `myclass` must be
evaluated before class `anotherclass` for this example to work
properly.

#### Definitions

Definitions follow the same basic form as classes, but they are
introduced with the `define` keyword and they support arguments but
no inheritance:

    define svn_repo($path) {
        exec { "/usr/bin/svnadmin create $path/$title":
            unless => "/bin/test -d $path",
        }
    }
    
    svn_repo { puppet: path => "/var/svn" }

Note the use of `$title` here. Definitions can have both a name and
a title (as of 0.22.3) represented by the `$title` and `$name`
variables respectively. By default, `$title` and `$name` are set to
the same value, but you can set a `title` attribute and pass a
different name as a parameter. You can then use the two values
differently within your definition. It is important to note that
the `$title` and `$name` variables are only available for use
within definitions. You can't use them in classes or other
stand-alone resources.

Note that all defined types support automatically all
metaparameters. Therefore you can pass any later used parameters
like `$require` to a define, without any definition of it:

    define svn_repo($path) {
        exec {"create_repo_${name}": 
            command => "/usr/bin/svnadmin create $path/$title",
            unless => "/bin/test -d $path",
        }
        if $require {
            Exec["create_repo_${name}"]{
                require +> $require,
            }
        }
    }
    
    svn_repo { puppet: 
       path => "/var/svn",
       require => Package[subversion],
    }

#### Classes vs. Definitions

Classes and definitions are defined similarly (although classes do
not accept parameters), but they are used very differently.
Definitions are used to define reusable objects which will have
multiple instances on a given host, so they cannot include any
resources that will only have one instance, such as a package or a
root-level service. Classes, on the other hand, are guaranteed to
be singletons -- you can include them as many times as you want and
you'll only ever get one copy of the resources -- so they are
exactly meant to include these singleton objects.

Most often, services will be defined in a class, where the
service's package, configuration files, and running service will
all be defined in the class, because there will normally be one
copy of each on a given host. Definitions would be used to manage
resources like virtual hosts, of which you can have many, or to
encode some simple information in a reusable wrapper to save
typing.

#### Modules

You can combine collections of classes, definitions and resources
into modules. Modules are portable collections of configuration,
for example a module might contain all the resources required to
configure Postfix or Apache. You can find out about modules and
their structure on the Module Organisation, and find modules that might find useful in your own
configurations at the Puppet Modules page.

{MISSINGREFS}

### Nodes

Node definitions look just like classes, including supporting
inheritance, but they are special in that when a node connects to
the Puppet master daemon, its name will be looked for in the list
of defined nodes and the found specification will be evaluated for
that node.

Node names can be the short host name, or the fully qualified
domain name, although some names, especially fully qualified ones,
need to be quoted. See [below](#quoting) for the quoting rules:

    node "www.testing.com" {
       include common 
       include apache, squid
    }

The previous node definition creates a node called
`www.testing.com` and includes the `common`, `apache` and `squid`
classes. You can also specify multiple identical nodes by
separating each with a comma:

    node "www.testing.com", "www2.testing.com", "www3.testing.com" {
       include common 
       include apache, squid
    }

The previous examples creates three identical nodes:
`www.testing.com`, `www2.testing.com`, and `www3.testing.com`.

#### Matching Nodes with Regular Expressions

From version 0.25.0, regular expression matching is now possible in
node definitions:

    node /^www\d+$/ {
        include common
    }

This would match any host called `www` and ending with one or more
digits, for example `www1`, `www2`, etc:

    node /^(foo|bar)\.testing\.com$/ {
        include common
    }

This would match either host `foo` or `bar` in the testing.com
domain.

There are some simple rules for node regular expressions.

-   If there is a node without a regular expression that matches
    the current client connecting then use it
-   If no nodes without regular expressions match, then process any
    nodes with regular expressions and stop at hte first match.

#### Node Inheritance

Nodes support a limited inheritance model and like classes nodes
can only inherit from one other node:

    node "www2.testing.com" inherits "www.testing.com" {
        include loadbalancer
    }

In this node definition the `www2.testing.com` inherits any
configuration specified for the `www.testing.com` node in addition
to including the `loadbalancer` class.

You can also specify a node named `default`, which will be used if
no directly matching node is found.

#### External Nodes

As an alternative to nodes defined on your manifests you can also
make use of node definitions from external sources including files,
databases and LDAP servers. There is documentation for ExternalNodes
and LDAPNodes..

{MISSINGREFS}

## Language Features

In order to specify resources correctly, you need language features
beyond specification and grouping, so Puppet's language provides
common functionality in this area. The language is still a simple
language, and it makes no attempt to be Turing-complete or any such
thing, but it is usually sufficient to get the job done.

### Quoting

You probably noticed above that most strings are not quoted. Most
Puppet configurations consist of parameter values, so it makes
sense to skip quotes for simple strings. Any alphanumeric string
starting with a letter, plus the `-` character, can leave out
quotes. However,
[Puppet Best Practice](http://www.reductivelabs.com/trac/puppet/wiki/PuppetBestPractice)
dictates the use of quoted values for any non-native value (see
[Best Practice::Syntax and Formatting](http://www.reductivelabs.com/trac/puppet/wiki/PuppetBestPractice#syntax-and-formatting)).

Single-quoted strings will not do any variable interpolation,
double-quoted strings will. Variables in strings can be bracketed
with `{}` for further clarification:

    $value = "${one}${two}"

To put a quote character or `$` in a quoted string where it would
normally have a special meaning, precede it with `\`. For an actual
`\`, use `\\`.

### Capitalization

Like much of Puppet's language, capitalization is influenced by
Ruby. In general you would use capitalisation in the following
contexts:

-   Referencing: when you want to reference a resource, usually
    from another resource such as a `require` metaparameter, you have
    to capitalize the name of the resource, for example,
    `require => File[sshdconfig]`.

-   Setting default attribute values: Resource Defaults.

-   Inheritance: allows subclasses to override resources defined in
    parent classes (needs referencing)

{MISSINGREFS}

### Documentation

From Puppet version 0.24.7 you can generate automated documentation
from resources, classes and modules using the `puppetdoc` tool. You
can find more detail at the
[Puppet Manifest Documentation](http://www.reductivelabs.com/trac/puppet/wiki/PuppetManifestDocumentation)
page.

### Arrays

Arrays are defined in puppet using the following construct:

    [ "one", "two", "three" ]

Some type members, such as 'alias' in the
[host](http://www.reductivelabs.com/trac/puppet/wiki/TypeReference#host)
definition accept arrays as their value. A host resource with
multiple aliases would look like this:

    host { "one.example.com":
        alias  => [ "satu", "dua", "tiga" ],
        ip     => "192.168.100.1",
        ensure => present,
    }

This would add a host 'one.example.com' to the hosts list with the
three aliases 'satu', 'dua', and 'tiga'.

Or, for example, if you want a resource to require multiple other
resources, the way to do this would be like this:

    resource { "baz":
        require  => [ Package["foo"], File["bar"] ],
    }

Another example for array usage is to call a custom defined
resource multiple times, like this:

    define php::pear() {
        package { "php-${name}": ensure => installed }
    }
    
    php::pear { ["ldap", "mysql", "ps", "snmp", "sqlite", "tidy", "xmlrpc"]: }

Of course, this can be used for native types as well:

    file { [ "foo", "bar", "foobar" ]:
        owner => root,
        group => root,
        mode  => 600,
    }

### Variables

Puppet supports variables like most other languages. Because we
wanted to skip quoting most strings, Puppet variables are denoted
with `$`:

    $content = "some content\n"
    
    file { "/tmp/testing": content => $content }

Puppet has a declarative language, which means that its scoping and
assignment rules are somewhat different than a normal imperative
language. The primary difference is that you cannot change the
value of a variable within a single scope, because that would rely
on file order to determine the value of the variable. This will
result in an error:

    $user = root
    file { "/etc/passwd":
        owner => $user,
    }
    $user = bin
    file { "/bin":
        owner   => $user,
        recurse => true,
    }

You will almost always find that you can avoid resetting variable
values using the built in conditionals:

    $group = $operatingsystem ? {
        solaris => "sysadmin",
        default => "wheel",
    }

Thus, within a single evaluation of the manifest, a variable may
only be assigned once. This does not precludes setting a variable
in non-overlapping scopes. For example, to set top-level
configuration values:

    node a {
        $setting = "this"
        include class_using_setting
    }
    node b {
        $setting = "that"
        include class_using_setting
    }

#### Variable Scope

Classes, components, and nodes introduce a new scope. Puppet is
currently dynamically scoped, which means that scope hierarchies
are created based on where the code is evaluated instead of where
the code is defined.

For example:

    $test = "top"
    class myclass {
        exec { "/bin/echo $test": logoutput => true }
    }
    
    class other {
        $test = "other"
        include myclass
    }
    
    include other

In this case, there's a top-level scope, a new scope for `other`,
and the a scope below that for `myclass`. When this code is
evaluated, `$test` evaluates to `other`, not `top`.

Variable scope can be confusing and you should read about some
[common misconceptions](http://reductivelabs.com/trac/puppet/wiki/FrequentlyAskedQuestions#common-misconceptions)
with regard to scoping.

#### Qualified Variables

Puppet supports qualification of variables inside a class. This
allows you to use variables defined in other classes.

For example:

    class myclass {
        $test = "content"
    }
    
    class anotherclass {
        $other = $myclass::test
    }

In this example, the value of the `$other` variable evaluates to
`content`. Qualified variables are read-only however and you can
not set a variable's value from other class.

Variable qualification is dependent on the evaluation order of your
classes. Class `myclass` must be evaluated before class
`anotherclass` for variables to be set correctly.

#### Facts as Variables

In addition to user-defined variables, the facts generated by
Facter are also available as variables. To use a fact as a variable
prefix the name of the fact with `$`. For example, the value of the
`operatingsystem` and `puppetversion` facts would be available as
the variables `$operatingsystem` and `$puppetversion`.

#### Variable Expressions

Starting with version 0.24.6, it is now possible to assign
arbitrary expressions to variables, for example:

    $inch_to_cm = 2.54
    $rack_length_cm = 19 * $inch_to_cm
    $gigabyte = 1024 * 1024 * 1024
    $can_update = ($ram_gb * $gigabyte) > 1 << 24

See the Expression section later on this page for further details
of the expressions that are now available.

#### Appending to Variables

Starting with version 0.24.6, the ability to append to variables is
also available:

    $ssh_users = [ 'myself', 'someone' ]
    
    class test {
       $ssh_users += ['someone_else']
    }

Here the `$ssh_users` variable contains an array with the elements
`myself` and `someone`. Using the variable append syntax, `+=`, we
added another element, `someone_else` to the array.

### Conditionals

Puppet currently supports two types of conditionals:

-   The *selector* which can only be used within resources to pick
    the correct value for an attribute, and
-   *statement conditionals* which can be used more widely in your
    manifests to include additional classes, define distinct sets of
    resources within a class, or make other structural decisions.

#### Selectors

The selector syntax works like a multi-valued trinary operator,
similar to C's `foo = bar ? 1 : 0` operator where `foo` will be set
to `1` if `bar` evaluates to true and `0` if `bar` is false.
Selectors are useful to specify a resource attribute or assign a
variable based on a fact or another variable. In addition to any
number of specified values, selectors also allow you to specify a
default if no value matches.

Let's look at a simple example of a selector at work:

    file { "/etc/config":
        owner => $operatingsystem ? {
            "sunos"   => "adm",
            "redhat"  => "bin",
            default => undef,
        },
    }

If the `$operatingsystem` fact returns `sunos` or `redhat` then the
ownership of the file is set to `adm` or `bin` respectively. Any
other result and the `owner` attribute will not be set, `undef`.
Remember to quote the comparators you're using in the selector as
the lack of quotes can toss syntax errors (see
[wiki:FrequentlyAskedQuestions\#id20 this FAQ entry] for an
example).

Selectors can also be used to assign variables:

    $owner = $operatingsystem ? {
        sunos   => "adm",
        redhat  => "bin",
        default => undef,
    }

Starting with version 0.25, selectors now support regular
expressions:

    $owner = $operatingsystem ? {
        /(redhat|debian)/   => "bin",
        default => undef,
    }

In this last example, if `$operatingsystem` matches either redhat
or debian, then `bin` will be the selected result.

Captures in selector regular expressions automatically creates some
limited scope variables (`$0` to `$n`):

    $system = $operatingsystem ? {
        /(redhat|debian)/   => "our system is $1",
        default => "our system is unknown",
    }

In this last example, `$1` will get replaced by the content of the
capture (here either `redhat` or `debian`).

The variable `$0` will contain the whole match.

#### Case Statement

`Case` is the first of puppet's two conditional statements, which
can be wrapped around any Puppet code to add decision-making logic
to your manifests. A common use for the `case` statement is to
apply different classes to a particular node based on its operating
system:

    case $operatingsystem {
        sunos:   { include solaris } # apply the solaris class
        redhat:  { include redhat  } # apply the redhat class
        default: { include generic } # apply the generic class
    }

Case statements can also specify multiple conditions, separating
each with a comma:

    case $hostname {
        jack,jill:      { include hill    } # apply the hill class
        humpty,dumpty:  { include wall    } # apply the wall class
        default:        { include generic } # apply the generic class
    }

Here, if the `$hostname` fact returns either `jack` or `jill` the
`hill` class would be included.

Starting with version 0.25, the `case` statement also supports
regular expression options:

    case $hostname {
        /^j(ack|ill)$/:   { include hill    } # apply the hill class
        /^[hd]umpty$/:    { include wall    } # apply the wall class
        default:          { include generic } # apply the generic class
    }

In this last example, if `$hostname` matches either `jack` or
`jill`, then the `hill` class will be included. But if `$hostname`
matches either `humpty` or `dumpty`, then the `wall` class will be
included.

As with selectors, regular expressions captures are available and
these creates limited scope variables `$0` to `$n`:

    case $hostname {
        /^j(ack|ill)$/:   { notice("Welcome $1!") } 
        default:          { notice("Welcome stranger") }
    }

In this last example, if `$host` is `jack` or `jill` then a notice
message will be printed with `$1` replaced by either `ack` or
`ill`.

#### If/Else Statement

Puppet's second conditional statement, `if/else` provides branching
options based on the value of some expression. In releases prior to
0.24.6 the `if` statement only provides a simple if/else structure
based on the existence of a variable:

    if $variable {
        file { "/some/file": ensure => present }
    } else {
        file { "/some/other/file": ensure => present }
    }

Starting with version 0.24.6, the `if` statement can now branch
based on a variable's value:

    if $server == "mongrel" {
        include mongrel
    } else {
        include nginx
    }

Here is the variable `$server` is equal to `mongrel` then include
the class `mongrel` otherwise include the class `nginx`.

Also possible are arithmetic expressions, for example:

    if $ram > 1024 {
        $maxclient = 500
    }

In the previous example if the value of the variable `$ram` is
greater than `1024` then set the value of the `$maxclient` variable
to `500`.

More complex expressions combining arithmetric expressions with the
Boolean operators `and`, `or`, or `not` are also possible, for
example:

    if ( $processor_count > 2 ) and (( $ram >= 16 * $gigabyte ) or ( $disksize > 1000 )) {
    include for_big_irons
    } else {
    include for_small_box
    }

See the Expression section later on this page for further details
of the expressions that are now available.

### Virtual Resources

As of 0.20.0, resources can be specified as virtual, meaning they
will not be sent to the client unless `realized`. This features
adds new syntax to the language. A simple example follows:

    @user { luke: ensure => present }

The user luke is now defined virtually. To realize that definition,
you can use a `collection`:

    User <| title == luke |>

Or the `realize` function:

    realize User[luke]

The motivation for this feature is somewhat complicated; please see
the virtual resources page for more information.

{MISSINGREFS}

### Exported Resources

Exported resources are an extension of virtual resources used to
allow different hosts managed by Puppet to influence each other's
Puppet configuration. As with virtual resources, new syntax was
added to the language for this purpose.

The key syntactical difference between virtual and exported
resources is that the special sigils (@ and <| |\>) are doubled (@@
and <<| |\>\>) when referring to an exported resource.

Here is an example with exported resources:

    class ssh {
    @@sshkey { $hostname: type => dsa, key => $sshdsakey }
        Sshkey <<| |>>
    }

To actually work, the `storeconfig` parameter must be set to
`true`.

The details of this feature are somewhat complicated; see
the exported resources page for more information.

{MISSINGREFS}

### Reserved words & Acceptable characters

Generally, any word that the syntax uses for special meaning is
probably also a reserved word, meaning you cannot use it for
variable or type names. Thus, words like `true`, `define`,
`inherits`, and `class` are all reserved. If you need to use a
reserved word as a value, just quote it.

You can use Aa-Zz, 0-9 and underscores in variables, resources and
class names. It is important to note that in Puppet releases prior
to 0.24.6 you cannot start a class name with a number.

### Comments

Puppet supports two types of comments:

-   sh-style comments; they can either be on their own line or at
    the end of a line (see the Conditionals example above).
-   multi-line comments (available from 0.24.7 onwards)

You can see an example of a multi-line comment:

    /*
    this is a comment
    */

Expressions
------------

Starting with version 0.24.6 the Puppet language supports arbitrary
expressions in `if` statement Boolean tests and in the right hand
value of variable assignments.

Puppet expressions can be composed of:

-   boolean expressions, which are combination of other expressions
    combined by boolean operators (`and`, `or` and `not`)
-   comparison expression, which consist of variable, numerical
    operands or other expressions combined with comparison operators (
    `==`, `!=`, `<`, `>`, `<=`, `>`, `>=`)
-   arithmetic expressions, which consists of variable, numerical
    operands or other expressions combined with the following
    arithmetic operators: `+`, `-`, `/`, `*`, `<<`, `>>`
-   and starting with 0.25, regexes matches with the help of the
    regex match operator: `=~` and `!~`

Expressions can be enclosed in parenthesis, `()`, to group
expressions and resolve operator ambiguity.

### Operator precedence

The Puppet operator precedence conforms to the standard precedence,
i.e. from the highest precedence to the lowest, hence:

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

::

> if $variable == "foo" {
> 
> > include bar
> 
> } else {
> :   include foobar
> 
> 
> }

Here if `$variable` has a value of `foo` then include the `bar`
class otherwise include the `foobar` class.

Another example shows the use of the `!=` or not equal comparison
operator:

    if $variable != "foo" {
        $othervariable = "bar"
    } else {
        $othervariable = "foobar"
    }

In our second example if `$variable` has a value of `foo` then set
the value the `$othervariable` variable to `bar` otherwise set the
`$othervariable` variable to a value of `foobar`.

#### Arithmetic expressions

You can also perform a variety of arithmetic expressions, for
example:

    $one = 1
    $one_thirty = 1.30
    $two = 2.034e-2
    
    
    $result = ((( $two + 2) / $one_thirty) + 4 * 5.45) - (6 << ($two + 4)) + (0x800 + -9)

#### Boolean expressions

Also possible are Boolean expressions using `or`, `and` and `not`,
for example:

    $one = 1
    $two = 2
    $var = ( $one < $two ) and ( $one + 1 == $two )

#### Regex expressions

Starting with 0.25, Puppet supports regex matching expressions
using `=~` (match) and `!~` (not-match) for example:

    if $host =~ /^www(\d+)\./ {
        notice("Welcome web server #$1")
    }

Like case and selectors, the regex match operators create limited
scope variables for each regex capture. In the previous example,
`$1` will be replaced by the number following `www` in `$host`.
Those variables are valid only for the statements in the if
clause.

### Backus Naur Form

The available operators in Backus Naur Form:

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
    <regex> ::= "/regex/"

Functions
---------

Puppet supports many built in functions; see the function reference for details and see
WritingYourOwnFunctions for information on how to create
your own custom functions. 

{MISSINGREFS}

Some functions can be used as a
statement:

    notice("Something weird is going on")

Or without parentheses:

    notice "Something weird is going on"

Some functions instead return a value:

    file { "/my/file": content => template("mytemplate.erb") }

NOTE: All functions run on the puppetmaster, so you only have access to the filesystem and resources on that host in your functions. The only exception to this is that any Facter facts that have been sent to the master from your clients are also at your disposal.

Importing Manifests
-------------------

Puppet has an `import` keyword for importing other manifests. Code
in those external manifests should always be stored in a `class` or
`definition` or it will be imported into the main scope and applied
to all nodes. Currently files are only searched for within the same
directory as the file doing the importing.

Files can also be imported using globbing, as implemented by Ruby's
`Dir.glob` method:

    import "classes/*.pp"
    import "packages/[a-z]*.pp"

Manifests should normally be organized into modules.

{MISSINGREFS}

Compilation Errors
------------------

By default, the server configuration
variable `usecacheonfailure` is set to `true`. This means
that when a manifest fails to compile, the old manifest is used
instead. This may result in surprising behaviour if you are editing
complex configurations. Running puppetd with
`--no-usecacheonfailure` or with `--test`, or setting
`usecacheonfailure = false` in the configuration file, will disable
this behaviour.

{MISSINGREFS}


