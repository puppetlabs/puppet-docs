Extended Language Tutorial
==========================

After having read the [Language Tutorial](./language_tutorial.html) you
may be interested in further details of the Puppet language.  The
guide below will showcase some features, though you may also want
to read [Puppet Modules](./modules.html) for some real
world examples depending on your learning style.  This document
may trend more towards a programming language reference at times,
as compared with the main language tutorial; don't worry
if you don't grasp it all at once.  

* * *

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

    $value = "${one}${two}"

To put a quote character or `$` in a double-quoted string where it would
normally have a special meaning, precede it with an escaping `\`. For an actual `\`, use `\\`.

We recommend using single quotes for all strings that do not require variable interpolation. Use double quotes for those strings that require variable interpolation.

### Capitalization

Capitalization of resources is used in two major ways:

-   Referencing: when you want to reference an already declared resource, usually for dependency purposes, you have to capitalize the name of the resource, for example,
    `require => File[sshdconfig]`.

-   Inheritance.  when overwriting the resource settings of a parent class from a subclass, use the uppercase versions of the resource names.  Using the lowercase versions will result in an error.   See the inheritance section above for an example of this.

-   Setting default attribute values: Resource Defaults.  As mentioned prev    iously, using a capitalized resource with no 'title' works to set the d    efaults for that resource.  Our previous example was setting the defaul    t path for command executions.

### Arrays

As mentioned in the class and resource examples above, Puppet allows usage of arrays in various areas.  Arrays are defined in puppet look like this:

    [ 'one', 'two', 'three' ]

Several type members, such as 'alias' in the 'host' definition
definition accept arrays as their value. A host resource with
multiple aliases would look like this:

    host { 'one.example.com':
        alias  => [ 'satu', 'dua', 'tiga' ],
        ip     => '192.168.100.1',
        ensure => present,
    }

This would add a host 'one.example.com' to the hosts list with the
three aliases 'satu', 'dua', and 'tiga'.

Or, for example, if you want a resource to require multiple other
resources, the way to do this would be like this:

    resource { 'baz':
        require  => [ Package['foo'], File['bar'] ],
    }

Another example for array usage is to call a custom defined
resource multiple times, like this:

    define php::pear() {
        package { "`php-${name}": ensure => installed }
    }
    
    php::pear { ['ldap', 'mysql', 'ps', 'snmp', 'sqlite', 'tidy', 'xmlrpc']: }

Of course, this can be used for native types as well:

    file { [ 'foo', 'bar', 'foobar' ]:
        owner => root,
        group => root,
        mode  => 600,
    }

### Variables

Puppet supports variables like most other languages you may be familiar with.  Puppet variables are denoted with `$`:

    $content = 'some content\n'
    
    file { '/tmp/testing': content => $content }

Puppet language is a declarative language, which means that its scoping and
assignment rules are somewhat different than a normal imperative
language. The primary difference is that you cannot change the
value of a variable within a single scope, because that would rely
on order in the file to determine the value of the variable.  Order
does not matter in a declarative language.  Doing so will result in an error:

    $user = root
    file { '/etc/passwd':
        owner => $user,
    }
    $user = bin
    file { '/bin':
        owner   => $user,
        recurse => true,
    }

Rather than reassigning variables, instead use the built in conditionals:

    $group = $operatingsystem ? {
        solaris => 'sysadmin',
        default => 'wheel',
    }

A variable may only be assigned once.  However you still can set the same variable in non-overlapping scopes. For example, to set top-level
configuration values:

    node a {
        $setting = 'this'
        include class_using_setting
    }
    node b {
        $setting = 'that'
        include class_using_setting
    }

In the above example, both 'a' and "b" have different scopes, so this is
not reassignment of the same variable.

#### Variable Scope

Scoping may initially seem like a foreign concept, though in
reality it is pretty simple.   A scope defines where
a variable is valid.  Unlike early programming languages like BASIC,
variables are only valid and accessible in certain places in a
program.  Using the same variable name in different parts of
the language do not refer to the same value.

Classes, components, and nodes introduce a new scope. Puppet is
currently dynamically scoped, which means that scope hierarchies
are created based on where the code is evaluated instead of where
the code is defined.

For example:

    $test = 'top'
    class myclass {
        exec { "/bin/echo $test": logoutput => true }
    }
    
    class other {
        $test = 'other'
        include myclass
    }
    
    include other

In this case, there's a top-level scope, a new scope for `other`,
and the a scope below that for `myclass`. When this code is
evaluated, `$test` evaluates to `other`, not `top`.

#### Qualified Variables

Puppet supports qualification of variables inside a class. This
allows you to use variables defined in other classes.

For example:

    class myclass {
        $test = 'content'
    }
    
    class anotherclass {
        $other = $myclass::test
    }

In this example, the value of the `$other` variable evaluates to
`content`. Qualified variables are read-only -- you can
not set a variable's value from other class.

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

    $inch_to_cm = 2.54
    $rack_length_cm = 19 * $inch_to_cm
    $gigabyte = 1024 * 1024 * 1024
    $can_update = ($ram_gb * $gigabyte) > 1 << 24

See the Expression section later on this page for further details
of the expressions that are now available.

#### Appending to Variables

In Puppet 0.24.6 and later, values can be appended to array variables:

    $ssh_users = [ 'myself', 'someone' ]
    
    class test {
       $ssh_users += ['someone_else']
    }

Here the `$ssh_users` variable contains an array with the elements
`myself` and `someone`. Using the variable append syntax, `+=`, we
added another element, `someone_else` to the array.

### Conditionals

At some point you'll need to use a different value based on the value of a variable, or decide to not do something if a particular value is set.

Puppet currently supports two types of conditionals:

-   The *selector* which can only be used within resources to pick
    the correct value for an attribute, and
-   *statement conditionals* which can be used more widely in your
    manifests to include additional classes, define distinct sets of
    resources within a class, or make other structural decisions.

Case students do not return a value.   Selectors do.  That is the primary difference between them and why you would use one and not the other.

#### Selectors

If you're familiar with programming terms, The selector syntax works like a multi-valued trinary operator, similar to C's `foo = bar ? 1 : 0` operator where `foo` will be set to `1` if `bar` evaluates to true and `0` if `bar` is false. 

Selectors are useful to specify a resource attribute or assign a
variable based on a fact or another variable. In addition to any
number of specified values, selectors also allow you to specify a
default if no value matches.  Here's a simple example:

    file { '/etc/config':
        owner => $operatingsystem ? {
            'sunos'   => 'adm',
            'redhat'  => 'bin',
            default => undef,
        },
    }

If the `$operatingsystem` fact (sent up from 'facter') returns `sunos` or `redhat` then the ownership of the file is set to `adm` or `bin` respectively. Any other result and the `owner` attribute will not be set, because it is listed as `undef`.

Remember to quote the comparators you're using in the selector as
the lack of quotes can cause syntax errors.

Selectors can also be used in variable assignment:

    $owner = $operatingsystem ? {
        sunos   => 'adm',
        redhat  => 'bin',
        default => undef,
    }

In Puppet 0.25 and later, selectors can also be used with regular
expressions:

    $owner = $operatingsystem ? {
        /(redhat|debian)/   => 'bin',
        default => undef,
    }

In this last example, if `$operatingsystem` value matches either redhat
or debian, then `bin` will be the selected result, otherwise the owner
will not be set (`undef`).

Like Perl and some other languages with regular expression support, captures in selector regular expressions automatically create some
limited scope variables (`$0` to `$n`):

    $system = $operatingsystem ? {
        /(redhat|debian)/   => 'our system is $1',
        default => 'our system is unknown',
    }

In this last example, `$1` will get replaced by the content of the
capture (here either `redhat` or `debian`).

The variable `$0` will contain the whole match.

#### Case Statement

`Case` is the other form of Puppet's two conditional statements, which
can be wrapped around any Puppet code to add decision-making logic
to your manifests.  Case statements, unlike selectors, do not return a value.   A common use for the `case` statement is to apply different classes to a particular node based on its operating
system:

    case $operatingsystem {
        sunos:   { include solaris } # apply the solaris class
        redhat:  { include redhat  } # apply the redhat class
        default: { include generic } # apply the generic class
    }

Case statements can also specify multiple match conditions by separating
each with a comma:

    case $hostname {
        jack,jill:      { include hill    } # apply the hill class
        humpty,dumpty:  { include wall    } # apply the wall class
        default:        { include generic } # apply the generic class
    }

Here, if the `$hostname` fact returns either `jack` or `jill` the
`hill` class would be included.

In Puppet 0.25 and later, the `case` statement also supports
regular expressions:

    case $hostname {
        /^j(ack|ill)$/:   { include hill    } # apply the hill class
        /^[hd]umpty$/:    { include wall    } # apply the wall class
        default:          { include generic } # apply the generic class
    }

In this last example, if `$hostname` matches either `jack` or
`jill`, then the `hill` class will be included. But if `$hostname`
matches either `humpty` or `dumpty`, then the `wall` class will be
included.

As with selectors (see above), regular expressions captures are also available.
These create limited scope variables `$0` to `$n`:

    case $hostname {
        /^j(ack|ill)$/:   { notice('Welcome $1!') } 
        default:          { notice('Welcome stranger') }
    }

In this last example, if `$host` is `jack` or `jill` then a notice
message will be logged with `$1` replaced by either `ack` or
`ill`.  `$0` contains the whole match.

#### If/Else Statement

`if/else` provides branching options based on the truth value of a variable:

    if $variable {
        file { '/some/file': ensure => present }
    } else {
        file { '/some/other/file': ensure => present }
    }

In Puppet 0.24.6 and later, the `if` statement can also branch
based on the value of an expression:

    if $server == 'mongrel' {
        include mongrel
    } else {
        include nginx
    }

In the above example, if the value of the variable `$server` is equal to `mongrel`, Puppet
will include the class `mongrel`, otherwise it will include the class `nginx`.

Arithmetic expressions are also possible, for example:

    if $ram > 1024 {
        $maxclient = 500
    }

In the previous example if the value of the variable `$ram` is
greater than `1024`,  Puppet will set the value of the `$maxclient` variable
to `500`.

More complex expressions combining arithmetric expressions with the
Boolean operators `and`, `or`, or `not` are also possible:

    if ( $processor_count > 2 ) and (( $ram >= 16 * $gigabyte ) or ( $disksize > 1000 )) {
    include for_big_irons
    } else {
    include for_small_box
    }

See the Expression section further down for more information on expressions.

### Virtual Resources

See [Virtual Resources](./virtual_resources.html).

Virtual resources are available in Puppet 0.20.0 and later.

Virtual resources are resources that are not sent to the client unless `realized`. 

The syntax for a virtual resource is:

    @user { luke: ensure => present }

The user luke is now defined virtually. To realize that definition,
you can use a `collection`:

    User <| title == luke |>

This can be read as 'the user whose title is luke'.   This is equivalent to using
the `realize` function:

    realize User[luke]

Realization could also use other criteria, such as realizing Users that match
a certain group, or using a metaparameter like 'tag'.

The motivation for this feature is somewhat complicated; please see
the [Virtual Resources](./virtual_resources.html) page for more information.

### Exported Resources

Exported resources are an extension of virtual resources used to
allow different hosts managed by Puppet to influence each other's
Puppet configuration.  This is described in detail on the [Exported Resources](./exported_resources.html) page.  As with virtual resources, new syntax was added to the language for this purpose.

The key syntactical difference between virtual and exported
resources is that the special sigils (@ and <| |\>) are doubled (@@
and <<| |\>\>) when referring to an exported resource.

Here is an example with exported resources that shares SSH keys 
between clients:

    class ssh {
    @@sshkey { $hostname: type => dsa, key => $sshdsakey }
        Sshkey <<| |>>
    }

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

### Reserved words & Acceptable characters

You can use the characters A-Z, a-z, 0-9 and underscores in variables, resources and
class names.   In Puppet releases prior to 0.24.6, you cannot start a class name with a number.

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

    # this is a comment

You can see an example of a multi-line comment:

    /*
    this is a comment
    */

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
-   and in Puppet 0.25 and later, regular expression matches with the help of the
    regex match operator: `=~` and `!~`

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

    if $variable == 'foo' {
        include bar
    } else {
        include foobar
    }
{:puppet}

Here if `$variable` has a value of `foo`, Puppet will then include the `bar`
class, otherwise it will include the `foobar` class.

Here is another example shows the use of the `!=` ('not equal') comparison
operator:

    if $variable != 'foo' {
        $othervariable = 'bar'
    } else {
        $othervariable = 'foobar'
    }
{:puppet}

In our second example if `$variable` has a value of `foo`, Puppet will then set
the value of the `$othervariable` variable to `bar`, otherwise it will set the
`$othervariable` variable to `foobar`.

#### Arithmetic expressions

You can also perform a variety of arithmetic expressions, for
example:

    $one = 1
    $one_thirty = 1.30
    $two = 2.034e-2
        
    $result = ((( $two + 2) / $one_thirty) + 4 * 5.45) - (6 << ($two + 4)) + (0x800 + -9)
{:puppet}

#### Boolean expressions

Boolean expressions are also possible using `or`, `and` and `not`:

    $one = 1
    $two = 2
    $var = ( $one < $two ) and ( $one + 1 == $two )
{:puppet}

#### Regular expressions

In Puppet 0.25 and later, Puppet supports regular expression matching
using `=~` (match) and `!~` (not-match) for example:

    if $host =~ /^www(\d+)\./ {
        notice('Welcome web server #$1')
    }
{:puppet}

Like case and selectors, the regex match operators create limited
scope variables for each regex capture.  In the previous example,
`$1` will be replaced by the number following `www` in `$host`.
Those variables are valid only for the statements inside the 
braces of the if clause.

### Backus Naur Form

We've already covered the list of opeartors, though if you wish to see it, 
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

Puppet supports many built in functions; see the [Function Reference](/references/functions.html) for details -- see [Custom Functions](/custom_functions.html) for information on how to create
your own custom functions. 

Some functions can be used as a statement:

    notice('Something weird is going on')
{:puppet}

(The notice function above is an example of a function that will log on the server)

Or without parentheses:

    notice 'Something weird is going on'
{:puppet}

Some functions instead return a value:

    file { '/my/file': content => template('mytemplate.erb') }
{:puppet}

All functions run on the puppetmaster (central server), so you only have access to the filesystem and resources on that host from your functions. The only exception to this is that the value of any Facter facts that have been sent to the master from your clients are also at your disposal.  See the [Tools Guide](./tools.html) for more information about these components.

Importing Manifests
-------------------

Puppet has an `import` keyword for importing other manifests. Code
in those external manifests should always be stored in a `class` or
`definition` or it will be imported into the main scope and applied
to all nodes. Currently files are only searched for within the same
directory as the file doing the importing.

Files can also be imported using globbing, as implemented by Ruby's
`Dir.glob` method:

    import 'classes/*.pp'
    import 'packages/[a-z]*.pp'
{:puppet}

Best practices calls for organizing manifests into [Modules](./modules.html)

Handling Compilation Errors
---------------------------

Puppet does not use manifests directly, it compiles them down to a internal format
that the clients can understand.

By default, when a manifest fails to compile, the previously compiled version of the Puppet 
manifest is used instead.

This behavior is governed by a setting in puppet.conf -- it is 'usecacheonfailure'
and is set by default to 'true'.

This may result in surprising behaviour if you are editing
complex configurations. 

Running puppetd with `--no-usecacheonfailure` or with `--test`, or setting
`usecacheonfailure = false` in the configuration file, will disable
this behaviour.



