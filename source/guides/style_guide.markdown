---
layout: default
title: Style Guide
---

Style Guide
===========

* * *

### Style Guide Metadata

Version 1.0

## Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in
this document are to be interpreted as described in
[RFC 2119](http://www.google.com/url?q=http://www.faqs.org/rfcs/rfc2119.html&sa=D&sntz=1&usg=AFQjCNHSKK-6ZHOhijUT4-3b9Bhi7FI0Ww).

## Puppet version

This style guide is largely specific to Puppet version 2.6.x and makes
recommendations based on some language features that are only 
available starting in version 2.6.0 and later.

## Why a Style Guide?

Puppet Labs develops modules for customers and the community.

These modules should represent the best practise in the
organisation for module design and style.  Since these modules are
designed by a number of people across the organisation this guide
is designed to ensure a consistent pattern, design and style is
adopted and maintained.

## General Philosophies

The following general ideas should be kept in mind when making
judgement calls about style.  The question "Does this block of
syntax conform to the style guide?" may very well be answered by
the following guidelines.

1.  **Readability matters.**
    There is a strong preference for code that is more readable when
    presented with alternatives that are more difficult to read.  Note,
    this is highly subjective, so this is by no means a hard and fast
    rule.  Please use your best judgement as to what "readable" means.
    If you can read your own code 3 months from now, that's a great start.
2.  **Inheritance should be avoided.**
    In general, inheritance leads to code that is harder to read.
    Most use cases for inheritance can be replaced by exposing class
    parameters that can be used to configure resource attributes. See
    the Class Inheritance section for more details.
3.  **Modules must not require an ENC.  Modules must operate with ENCs.**
    When surveyed, there was near consensus that an ENC should not be
    required.  At the same time, every module we write should work well
    with an ENC.
4.  **Classes should generally not declare other classes.**
    There is a strong preference to declare classes as
    close to node scope as possible. Classes which require other
    classes should not directly declare them and should instead allow
    the system to fail if they are not declared by some other means.
    (Note: The reason is because of the non-deterministic scoping
    issues.  If class multi-declarations result in deterministic
    behavior in the future, this philosophy may be revisited.)

## Module Metadata

Every module must have Metadata defined in the Modulefile data file
and outputted as the metadata.json file.  The following Metadata
should be provided for all modules.

    name 'myuser-mymodule'  
    version '0.0.1'
    author 'Author of the module - for shared modules this is Puppet Labs'
    summary 'One line description of the module'
    description 'Longer description of the module including an example'
    license 'The license the module is release under - generally GPLv2 or Apache'
    project_page 'The URL where the module source is located'  
    dependency 'otheruser-othermodule', '1.2.3'

### Versioning

The style guide must be version controlled, so that modules can be
compliant to a specific version of the style guide.

This meta information must be embedded in the
Modulefile.  Use the field named 'style_version' e.g.

    style_version "1.0"

## Spacing, Indentation, & Whitespace

Puppet Labs has some basic style rules for spacing, indentation and
whitespace.  These are:

1.  Must use 2 space soft tabs
2.  Must not use literal tabs
3.  Must not leave trailing white space
4.  Should not exceed 80 columns
5.  Should align fat commas

## Comments

Generally a `#` based comment is more readable using editors such as
vim.  The hash based comments are strongly preferable to C style
`/* ... */` and `// ...` comments.

1.  Should use `#` style comments
2.  Should not use `//` or `/*` `*/` comments

## Quoting

All strings that do not contain variables should be enclosed in
single quotes.  Double quotes should be used when interpolation is
required.  Quoting is optional when the string is an alphanumeric
bare word and not a resource title.

All variables should be enclosed in braces when interpolated in a
string.  For example:

{% highlight ruby %}
    "/etc/${file}.conf"
    "${operatingsystem} is not supported by ${module_name}"
{% endhighlight %}

Should not use the following styles:

{% highlight ruby %}
    "/etc/$file.conf"
    "$operatingsystem is not supported by $module_name"
{% endhighlight %}

Variables standing by themselves should not be enclosed in double
quotes.  For example:

{% highlight ruby %}
    mode => $my_mode
{% endhighlight %}

and should not use the following style:

{% highlight ruby %}
    mode => "$my_mode"
    mode => "${my_mode}"
{% endhighlight %}

## Resources

### Resource Names

All resource names (titles) should be quoted. Although Puppet
supports unquoted resource names if they do not contain spaces or
hyphens, placing all names in quotes allows for consistent
look-and-feel.

Should not use the syntax:

{% highlight ruby %}
    package { openssh: ensure => present }
{% endhighlight %}

Should use the syntax:

{% highlight ruby %}
    package { 'openssh': ensure => present }
{% endhighlight %}

### Arrow alignment

The arrow (`=>`) should be aligned at the column one space out from
the longest parameter. Not obvious in the above example is that the
arrow is only aligned per resource.

Therefore, the following is correct:

{% highlight ruby %}
    exec { 'blah':  
      path => '/usr/bin',  
      cwd  => '/tmp',
    }

    exec { 'test':  
      subscribe   => File['/etc/test'],  
      refreshonly => true,
    }
{% endhighlight %}

The following is incorrect:

{% highlight ruby %}
    exec { 'blah':  
     path => '/usr/bin',  
     cwd => '/tmp',
    }

    exec { 'test':  
      subscribe => File['/etc/test'],  
      refreshonly => true,
    }
{% endhighlight %}

### Parameter Ordering

Ensure should be the first parameter if it is specified in a
resource declaration.

1.  Ensure is often the most "essential" property and listing it
    first helps readability.
2.  Puppet internally does optimizations and always evaluates
    ensure first so that in the event ensure is set to absent it does
    not try to sync type/provider properties and it does this no matter
    where you define the ensure inside the resource block.  This
    recommendation is a readability recommendation only.

The following syntax is a recommended example:

{% highlight ruby %}
    file { '/tmp/foo':
      ensure => file,
      owner  => '0',
      group  => '0',
      mode   => '0644',
    }
{% endhighlight %}

### Compression

All resources of a given type should not be grouped together in a
given manifest

The following examples are NOT recommended:

{% highlight ruby %}
    file {
      "/tmp/a":
        content => "a";
      "/tmp/b":
        content => "b";
    }

    exec {
      "change contents of a":
        command => "sed -i.bak s/b/B/g /tmp/a";
      "change contents of b":
        command => "sed -i.bak s/b/B/g /tmp/b";
    }
{% endhighlight %}

The following examples are RECOMMENDED:

{% highlight ruby %}
    file { '/tmp/a':
      content => 'a',
    }

    exec { 'change contents of a':
      command => 'sed -i.bak s/a/A/g /tmp/a',
    }

    file { '/tmp/b':
      content => 'b',
    }

    exec { 'change contents of b':
      command => 'sed -i.bak s/b/B/g /tmp/b',
    }
{% endhighlight %}

### Symbolic Links

To make the intended behavior explicitly clear symbolic links
should be declared using the `ensure => link` property value rather
than a relative path to the target.  The following example is
recommended:

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => symlink,
      target => '/var/log/messages',
    }
{% endhighlight %}

### File modes

When specifying file modes in File resources the mode should be
represented as 4 digits, instead of 3, to make the mode explicit.

In addition, the mode should be specified in a single quoted
string instead of a bare word number.

Syntax should resemble:

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => present,
      mode   => '0644',
    }
{% endhighlight %}

Syntax should not resemble:

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => present,
      mode   => 644,
    }
{% endhighlight %}

### Resource defaults

Resource defaults should only be used in a very controlled manner,
restricted to the edges of your manifest ecosystem.  This is due to
the affect dynamic scope has on the default's definition and our
inability to track which resources it applies to reliably.

Correct:

{% highlight ruby %}
    # /etc/puppetlabs/puppet/manifests/site.pp:
    File {
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
    }
{% endhighlight %}

Incorrect:

{% highlight ruby %}
    # /etc/puppetlabs/puppet/modules/ssh/manifests/server/uk/foo.pp
    File {
      mode   => '0600',
      owner  => 'nobody',
      group  => 'nogroup',
    }
{% endhighlight %}

## Conditionals

### Keep resource declarations simple

You should not intermingle conditionals with your resource
declarations. When using conditionals for data assignment, you
should separate conditional code from the resource declarations.

The following examples are recommended:

{% highlight ruby %}
    $foo_mode = $operatingsystem ? {
      debian => '0007',
    }

    file { '/tmp/foo':
       mode => $foo_mode,
    }
{% endhighlight %}

The following examples are not recommended:

{% highlight ruby %}
    file { '/tmp/foo':
      mode => $operatingsystem ? {
        debian => '0777',
        redhat => '0776',
        fedora => '0007',
      }
    }
{% endhighlight %} 

### Defaults for case statements and selectors

Case statements should have default statements.

Hence both of these are valid.  In addition, the default case
should fail the catalog compilation when the resulting behavior
cannot be predicted on the majority of platforms the module will be
used on.

For selectors, the ommission of a default selection should only be
used if catalog compilation failure is explicitly desired in this
case.

The following example follows the recommended style:

{% highlight ruby %}
    case $operatingsystem {
      centos: {
        $version = '1.2.3'
      }
      solaris: {
        $version = '3.2.1'
      }
      default: {
        fail("Module $module_name is not supported on $operatingsystem")
      }
    }
{% endhighlight %}

## Classes

### Separate files

All classes and defines must be in separate files located in the
manifests directory of the given module, for example:

{% highlight ruby %}
    init.pp
      class foo { }
    bar.pp
      class foo::bar { }
    dostuff.pp
      define foo::dostuff () { }
{% endhighlight %}

### Internal Organization of a class

Classes should be organised with a consistent structure and style.
In the below list there is an implicit statement of "should be at this relative
location" for each of these items.  The word "may" should be
interpreted as "If there are any X's they should be here".

1.  Should define the class and parameters
2.  Should validate any class parameters and fail catalog compilation if any parameters are invalid 
3.  Should default any validated parameters to the most general case
4.  May declare local variables
5.  May declare relationships to other classes `Class['foo'] -> Class['bar']`
6.  May override resources
7.  May declare resource defaults
8.  May declare defined resource types
9.  May declare native types (Users, Groups, Services...)
10.  May declare other resources
11.  May declare Resource relationships inside of conditionals

The following example follows the recommended style:

{% highlight ruby %}
    class myservice($ensure='running') {

      if $ensure in [ running, stopped ] {
        $ensure_real = $ensure
      } else {
        fail('ensure parameter must be running or stopped')
      }

      case $operatingsystem {
        centos: {
          $package_list = 'openssh-server'
        }
        solaris: {
          $pacakge_list = [ SUNWsshr, SUNWsshu ]
        }
        default: {
          fail("module $module_name does not support $operatingsystem")
        }
      }

      $variable = 'something'

      Package { ensure => present, }

      File { owner => '0', group => '0', mode => '0644' }
  
      package { $package_list: }

      file { "/tmp/${variable}":
        ensure => present,
      }

      service { 'myservice':
        ensure    => $ensure_real,
        hasstatus => true,
      }
    }
{% endhighlight %}

### Relationship Declarations

Relationship declarations should only be used in the "left to
right" direction.  For example, the syntax `Service[foo] <- Package[bar]` should not be used, instead the syntax `Package[bar] -> Service[foo]` should be used.

Meta-parameters should be used in preference to relationship
declarations when possible.  An example when it is not possible is
when meta-parameters would require the use of subclasses to
override behavior.  In this situation, relationship
declarations inside of conditionals should be used.

### Classes within classes

Classes must not be defined within other classes.

This example shall not be followed:

{% highlight ruby %}
    class foo {
      class bar { ... }
    }
{% endhighlight %}

### Defines within classes

Resources must not be defined within classes.

The following example shall not be followed:

{% highlight ruby %}
    class foo {
      define bar() { ... }
    }
{% endhighlight %}

### Class Inheritance

Inheritance may only be used within a module and must not be used
across module name spaces. This is a result of:

1.  Portability - inheriting outside of the module
    breaks the idea of modules and limits our ability for portability
2.  inheritance outside of the module is indicative of code
    that should be refactored. In this instance you probably should be 
    using includes or parameterized classes

Inheritance should be avoided when alternatives are viable.  For
example, if inheritance is being used to override relationships
when stopping a service by overriding the relationship of a class
managing a running service, the code should be refactored to use a
single class with an ensure parameter and relationship declarations
inside of conditionals. An example of this follows. The example makes 
several assumptions and is based on an example provided in the Puppet 
Master training for managing bluetooth.

1.  Class inheritance is only useful for overriding resource
    parameters.
2.  The most commonly overridden parameters are relationship
    meta-parameters.
3.  Other parameters, e.g. ensure and enable may have behavior
    changed through the use of variables and conditional logic.

{% highlight ruby %}
    class bluetooth($ensure=present, $autoupgrade=false) {
       # Validate class parameter inputs. (Fail early and fail hard)

       if ! ($ensure in [ "present", "absent" ]) {
         fail("bluetooth ensure parameter must be absent or present")
       }

       if ! ($autoupgrade in [ true, false ]) {
         fail("bluetooth autoupgrade parameter must be true or false")
       }

       # Set local variables based on the desired state

       if $ensure == "present" {
         $service_enable = true
         $service_ensure = running
         if $autoupgrade == true {
           $package_ensure = latest
         } else {
           $package_ensure = present
         }
       } else {
         $service_enable = false
         $service_ensure = stopped
         $package_ensure = absent
       }

       # Declare resources without any relationships in this section

       package { [ "bluez-libs", "bluez-utils"]:
         ensure => $package_ensure,
       }

       service { hidd:
         enable         => $service_enable,
         ensure         => $service_ensure,
         status         => "source /etc/init.d/functions; status hidd",
         hasstatus      => true,
         hasrestart     => true,
      }

      # Finally, declare relations based on desired behavior

      if $ensure == "present" {
        Package["bluez-libs"]  -> Package["bluez-utils"]
        Package["bluez-libs"]  ~> Service[hidd]
        Package["bluez-utils"] ~> Service[hidd]
      } else {
        Service["hidd"]        -> Package["bluez-utils"]
        Package["bluez-utils"] -> Package["bluez-libs"]
      }
    }
{% endhighlight %}

In the event you cannot avoid inheritance then the following example may be used:

{% highlight ruby %}
    class ssh {
      ...
    }

    class ssh::client inherits ssh {
      ...
    }

    class ssh::server inherits ssh {
      ...
    }

    class ssh::server::solaris {
      ...
    }
{% endhighlight %}

The following examples must not be followed:

{% highlight ruby %}
    class ssh inherits server {
      ...
    }

    class ssh:client inherits workstation {
      ...
    }

    class wordpress inherits apache {
      ...
    }
{% endhighlight %}

### Name space variables

When using variables Puppet modules should access top scope
variables explicitly to prevent scoping issues.

{% highlight ruby %}
    $::operatingsystem, not $operatingsystem
{% endhighlight %}

### Specifying the order of class parameters

In parameterized classes, parameters that are required should be
specified before optional parameters (or parameters with defaults)

Example:

{% highlight ruby %}
    class foo (
      $one = 'default',
      $two,
      $three = 'default'
    ) {}
{% endhighlight %}

should be rewritten as

{% highlight ruby %}
    class foo (
      $two,
      $one = "default",
      $three = "default"
    ) {}
{% endhighlight %}

## Tests

All manifests should have a corresponding tests manifest, for
example the following manifests:

{% highlight ruby %}
    modulepath/foo/manifests/{init,foo}.pp
{% endhighlight %}

Should have matching tests:

{% highlight ruby %}
    modulepath/foo/tests/{init,foo}.pp
{% endhighlight %}

## Puppet Doc

For generation of decent looking Puppet documentation the following
conventions should be used.

As class headers:

{% highlight ruby %}
    # Full description of class here.
    #
    # == Parameters
    #
    # Document parameters here
    #
    # [*sample_bar*]
    #   Description of this variable.
    #
    # == Variables
    #
    # Here you should define a list of variables that this module would require.
    #
    # [*$foo_var*]
    #     Description of this variable
    #
    # == Examples
    #
    # Put some examples on how to use your class here.
    #
    #   $example_var = "blah"
    #   include example_class
    #
    # == Authors
    #
    # Author Name <author@domain.com\>
    #
    # == Copyright
    #
    # Copyright 2011 Company Name Inc, unless otherwise noted.
    #
    class example_class {
      ...
    }
{% endhighlight %}

For defined resources:

{% highlight ruby %}
    # Description of resource here
    #
    # == Parameters
    #
    # Document parameters here
    #
    # [*namevar*]
    #   Always document namevar
    #
    # [*sample_bar*]
    #   Description of this variable.
    #
    # == Examples
    #
    # Provide some examples on how to use this type:
    #
    #   example_class::example_resource{
    #     "namevar":
    #       sample_param => "value",
    #   }
    #
    define example_class::example_resource($example_var) {
      ...
    }
{% endhighlight %}

## The extlookup() function

Modules should avoid the use of extlookup() in favor of ENCs or other alternatives.
