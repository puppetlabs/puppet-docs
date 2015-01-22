---
layout: default
title: Style Guide
---

Style Guide
===========

* * *

**Style Guide Metadata**

Version 1.1.2

## 1. Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](http://www.faqs.org/rfcs/rfc2119.html).

## 2. Puppet Version

This style guide is largely specific to Puppet versions 2.6.x; some of its
recommendations are based on some language features that became
available in version 2.6.0 and later.

## 3. Why a Style Guide?

Puppet Labs develops modules for customers and the community, and these modules
should represent the best known practice for module design and style. Since
these modules are developed by many people across the organisation, a central
reference was needed to ensure a consistent pattern, design, and style.

## 4. General Philosophies

No style manual can cover every possible circumstance. When a judgement call
becomes necessary, keep in mind the following general ideas:

1.  **Readability matters.**
    If you have to choose between two equally effective alternatives, pick the
    more readable one. This is, of course, subjective, but if you can read your
    own code three months from now, that's a great start.
2.  **Inheritance should be avoided.**
    In general, inheritance leads to code that is harder to read.
    Most use cases for inheritance can be replaced by exposing class
    parameters that can be used to configure resource attributes. See
    the [Class Inheritance](#class-inheritance) section for more details.
3.  **Modules must work with an ENC without requiring one.**
    An internal survey yielded near consensus that an ENC should not be
    required.  At the same time, every module we write should work well
    with an ENC.
4.  **Classes should generally not declare other classes.**
    Declare classes as close to node scope as possible. Classes which require
    other classes should not directly declare them and should instead allow the
    system to fail if they are not declared by some other means. (Although the
    include function allows multiple declarations of classes, it can result in
    non-deterministic scoping issues due to the way parent scopes are assigned.
    We might revisit this philosophy in the future if class multi-declarations
    can be made deterministic, but for now, be conservative with declarations.)

## 5. Module Metadata

Every module must have Metadata defined in the Modulefile data file
and outputted as the metadata.json file.  The following Metadata
should be provided for all modules:

    name 'myuser-mymodule'
    version '0.0.1'
    author 'Author of the module - for shared modules this is Puppet Labs'
    summary 'One line description of the module'
    description 'Longer description of the module including an example'
    license 'The license the module is release under - generally GPLv2 or Apache'
    project_page 'The URL where the module source is located'
    dependency 'otheruser/othermodule', '>= 1.2.3'

A more complete guide to the Modulefile format can be found in the [puppet-module-tool README](https://github.com/puppetlabs/puppet-module-tool/blob/master/README.markdown).

### 5.1. Style Versioning

This style guide will be versioned, which will allow modules to comply
with a specific version of the style guide.

A future version of the puppet-module tool may permit the relevant style guide version to be embedded as metadata in the Modulefile, and the metadata in turn may be used for automated linting.

## 6. Spacing, Indentation, & Whitespace

Module manifests complying with this style guide:

* Must use two-space soft tabs
* Must not use literal tab characters
* Must not contain trailing white space
* Should not exceed an 80 character line width
* Should align fat comma arrows (`=>`) within blocks of attributes

## 7. Comments

Although the Puppet language allows multiple comment types, we prefer
hash/octothorpe comments (`# This is a comment`) because they're generally the
most visible to text editors and other code lexers.

1.  Should use `# ...` for comments
2.  Should not use `// ...` or `/* ... */` for comments

## 8. Quoting

All strings that do not contain variables should be enclosed in
single quotes.  Double quotes should be used when variable interpolation is
required.  Double quotes may also be used to make a string more readable when
it contains single quotes.  Quoting is optional when the string is an
alphanumeric bare word and is not a resource title.

All variables should be enclosed in braces when interpolated in a
string.  For example:

**Good:**

{% highlight ruby %}
    "/etc/${file}.conf"
    "${::operatingsystem} is not supported by ${module_name}"
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    "/etc/$file.conf"
    "$::operatingsystem is not supported by $module_name"
{% endhighlight %}

Variables standing by themselves should not be quoted.  For example:

**Good:**

{% highlight ruby %}
    mode => $my_mode
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    mode => "$my_mode"
    mode => "${my_mode}"
{% endhighlight %}

## 9. Resources

### 9.1. Resource Names

All resource titles should be quoted. (Puppet
supports unquoted resource titles if they do not contain spaces or
hyphens, but you should avoid them in the interest of consistent look-and-feel.)

**Good:**

{% highlight ruby %}
    package { 'openssh': ensure => present }
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    package { openssh: ensure => present }
{% endhighlight %}

### 9.2. Arrow Alignment

All of the fat comma arrows (`=>`) in a resource's attribute/value list should
be aligned. The arrows should be placed one space ahead of the longest
attribute name.

**Good:**

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

**Bad:**

{% highlight ruby %}
    exec { 'blah':
      path  => '/usr/bin',
      cwd   => '/tmp',
    }

    exec { 'test':
      subscribe => File['/etc/test'],
      refreshonly => true,
    }
{% endhighlight %}

### 9.3. Attribute Ordering

If a resource declaration includes an `ensure` attribute, it should be the
first attribute specified.

**Good:**

{% highlight ruby %}
    file { '/tmp/readme.txt':
      ensure => file,
      owner  => '0',
      group  => '0',
      mode   => '0644',
    }
{% endhighlight %}

(This recommendation is solely in the interest of readability, as Puppet
ignores attribute order when syncing resources.)

### 9.4. Compression

Within a given manifest, resources should be grouped by logical relationship to
each other, rather than by resource type. Use of the semicolon syntax to
declare multiple resources within a set of curly braces is not recommended,
except in the rare cases where it would improve readability.

**Good:**

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

**Bad:**

{% highlight ruby %}
    file {
      '/tmp/a':
        content => 'a';
      '/tmp/b':
        content => 'b';
    }

    exec {
      'change contents of a':
        command => 'sed -i.bak s/b/B/g /tmp/a';
      'change contents of b":
        command => 'sed -i.bak s/b/B/g /tmp/b';
    }
{% endhighlight %}

### 9.5. Symbolic Links

In the interest of clarity, symbolic links should be declared by using an
ensure value of `ensure => link` and explicitly specifying a value for the
`target` attribute. Using a path to the target as the ensure value is not
recommended.

**Good:**

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => link,
      target => '/var/log/messages',
    }
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => '/var/log/messages',
    }
{% endhighlight %}

### 9.6. File Modes

File modes should be represented as 4 digits rather than 3.

In addition, file modes should be specified as single-quoted strings instead of bare word 
numbers.

**Good:**

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => present,
      mode   => '0644',
    }
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    file { '/var/log/syslog':
      ensure => present,
      mode   => 644,
    }
{% endhighlight %}

### 9.7. Resource Defaults

Resource defaults should be used in a very controlled manner, and should only
be declared at the edges of your manifest ecosystem. Specifically, they may be declared:

* At top scope in site.pp
* In a class which is guaranteed to never declare another class and never be inherited by 
another class.

This is due to the way resource defaults propagate through dynamic scope, which can have 
unpredictable effects far away from where the default was declared.

**Good:**

{% highlight ruby %}
    # /etc/puppetlabs/puppet/manifests/site.pp:
    File {
      mode  => '0644',
      owner => 'root',
      group => 'root',
    }
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    # /etc/puppetlabs/puppet/modules/ssh/manifests/init.pp
    File {
      mode  => '0600',
      owner => 'nobody',
      group => 'nogroup',
    }

    class { 'ssh::client':
      ensure => present,
    }
{% endhighlight %}

## 10. Conditionals

### 10.1. Keep Resource Declarations Simple

You should not intermingle conditionals with resource declarations. When using
conditionals for data assignment, you should separate conditional code from the
resource declarations.

**Good:**

{% highlight ruby %}
    $file_mode = $::operatingsystem ? {
      debian => '0007',
      redhat => '0776',
      fedora => '0007',
    }

    file { '/tmp/readme.txt':
       content => 'Hello World\n',
       mode    => $file_mode,
    }
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    file { '/tmp/readme.txt':
      mode => $::operatingsystem ? {
        debian => '0777',
        redhat => '0776',
        fedora => '0007',
      }
    }
{% endhighlight %}

### 10.2. Defaults for Case Statements and Selectors

Case statements should have default cases. Additionally, the default case should fail the
catalog compilation when the resulting behavior cannot be predicted on the
majority of platforms the module will be used on. If you want the default case to be "do nothing," include it as an explicit `default: {}` for clarity's sake.

For selectors, default selections should only be omitted if you explicitly want
catalog compilation to fail when no value matches.

The following example follows the recommended style:

{% highlight ruby %}
    case $::operatingsystem {
      centos: {
        $version = '1.2.3'
      }
      solaris: {
        $version = '3.2.1'
      }
      default: {
        fail("Module ${module_name} is not supported on ${::operatingsystem}")
      }
    }
{% endhighlight %}

## 11. Classes

### 11.1. Separate Files

All classes and resource type definitions must be in separate files in the
`manifests` directory of their module. For example:

{% highlight ruby %}
    # /etc/puppetlabs/puppet/modules/apache/manifests

    # init.pp
      class apache { }
    # ssl.pp
      class apache::ssl { }
    # virtual_host.pp
      define apache::virtual_host () { }
{% endhighlight %}

This is functionally identical to declaring all classes and defines in init.pp,
but highlights the structure of the module and makes everything more legible.

### 11.2. Internal Organization of a Class

Classes should be organised with a consistent structure and style.  In the
below list there is an implicit statement of "should be at this relative
location" for each of these items.  The word "may" should be interpreted as "If
there are any X's they should be here".

1. Should define the class and parameters
2. Should validate any class parameters and fail catalog compilation if any
    parameters are invalid
3. Should default any validated parameters to the most general case
4. May declare local variables
5. May declare relationships to other classes `Class['apache'] -> Class['local_yum']`
6. May override resources
7. May declare resource defaults
8. May declare resources; resources of defined and custom types should go before those of core types
9. May declare resource relationships inside of conditionals

The following example follows the recommended style:

{% highlight ruby %}
    class myservice($ensure='running') {

      if $ensure in [ running, stopped ] {
        $_ensure = $ensure
      } else {
        fail('ensure parameter must be running or stopped')
      }

      case $::operatingsystem {
        centos: {
          $package_list = 'openssh-server'
        }
        solaris: {
          $package_list = [ SUNWsshr, SUNWsshu ]
        }
        default: {
          fail("Module ${module_name} does not support ${::operatingsystem}")
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
        ensure    => $_ensure,
        hasstatus => true,
      }
    }
{% endhighlight %}

### 11.3. Relationship Declarations

Relationship declarations with the chaining syntax should only be used in the
"left to right" direction.

**Good:** 

    Package['httpd'] -> Service['httpd']

**Bad:**

    Service['httpd'] <- Package['httpd']

When possible, you should prefer metaparameters to relationship declarations.
One example where metaparameters aren't desirable is when subclassing would be
necessary to override behavior; in this situation, relationship declarations
inside of conditionals should be used.

### 11.4. Classes and Defined Resource Types Within Classes

Classes and defined resource types must not be defined within other classes.

**Bad:**

{% highlight ruby %}
    class apache {
      class ssl { ... }
    }
{% endhighlight %}

**Also bad:**

{% highlight ruby %}
    class apache {
      define config() { ... }
    }
{% endhighlight %}

### 11.5. Class Inheritance

Inheritance may be used within a module, but must not be used across module
namespaces. Cross-module dependencies should be satisfied in a more portable
way that doesn't violate the concept of modularity, such as with include
statements or relationship declarations.

**Good:**

{% highlight ruby %}
    class ssh { ... }

    class ssh::client inherits ssh { ... }

    class ssh::server inherits ssh { ... }

    class ssh::server::solaris inherits ssh::server { ... }
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    class ssh inherits server { ... }

    class ssh::client inherits workstation { ... }

    class wordpress inherits apache { ... }
{% endhighlight %}

Inheritance in general should be avoided when alternatives are viable.  For
example, instead of using inheritance to override relationships in an existing
class when stopping a service, consider using a single class with an ensure
parameter and conditional relationship declarations:

{% highlight ruby %}
    class bluetooth($ensure=present, $autoupgrade=false) {
       # Validate class parameter inputs. (Fail early and fail hard)

       if ! ($ensure in [ 'present', 'absent' ]) {
         fail('bluetooth ensure parameter must be absent or present')
       }

       if ! ($autoupgrade in [ true, false ]) {
         fail('bluetooth autoupgrade parameter must be true or false')
       }

       # Set local variables based on the desired state

       if $ensure == 'present' {
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

       package { [ 'bluez-libs', 'bluez-utils']:
         ensure => $package_ensure,
       }

       service { 'hidd':
         enable         => $service_enable,
         ensure         => $service_ensure,
         status         => 'source /etc/init.d/functions; status hidd',
         hasstatus      => true,
         hasrestart     => true,
      }

      # Finally, declare relations based on desired behavior

      if $ensure == 'present' {
        Package['bluez-libs']  -> Package['bluez-utils']
        Package['bluez-libs']  ~> Service['hidd']
        Package['bluez-utils'] ~> Service['hidd']
      } else {
        Service['hidd']        -> Package['bluez-utils']
        Package['bluez-utils'] -> Package['bluez-libs']
      }
    }
{% endhighlight %}

(This example makes several assumptions and is based on an example provided in
the Puppet Master training for managing bluetooth.)

In summary:

* Class inheritance is only useful for overriding resource attributes; any
  other use case is better accomplished with other methods.
* If you just need to override relationship metaparameters, you should use a single class with conditional relationship declarations instead of inheritance.
* In many cases, even other attributes (e.g. ensure and enable) may have their behavior changed with variables and conditional logic instead of inheritance.

### 11.6. Namespacing Variables

When using top-scope variables, including facts, Puppet modules should
explicitly specify the empty namespace to prevent accidental scoping issues.

**Good:**

{% highlight ruby %}
    $::operatingsystem
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    $operatingsystem
{% endhighlight %}

### 11.7. Variable format

When defining variables you should only use letters, numbers and
underscores. You should specifically not make use of dashes.

**Good:**

{% highlight ruby %}
    $foo_bar123
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    $foo-bar123
{% endhighlight %}

### 11.8. Display Order of Class Parameters

In parameterized class and defined resource type declarations, parameters that
are required should be listed before optional parameters (i.e. parameters with
defaults).

**Good:**

{% highlight ruby %}
    class ntp (
      $servers,
      $options   = 'iburst',
      $multicast = false
    ) {}
{% endhighlight %}

**Bad:**

{% highlight ruby %}
    class ntp (
      $options   = 'iburst',
      $servers,
      $multicast = false
    ) {}
{% endhighlight %}

### 11.9 Class parameter defaults

When writing a module that accepts class parameters sane defaults SHOULD be
provided for optional parameters to allow the end user the option of not
explicitly specifying the parameter when declaring the class.

For example:

{% highlight ruby %}
    class ntp(
      $server = 'UNSET'
    ) {

      include ntp::params

      $_server = $server ? {
        'UNSET' => $::ntp::params::server,
        default => $server,
      }

      notify { 'ntp':
        message => "server=[$_server]",
      }

    }
{% endhighlight %}

The reason this class is declared in this manner is to be fully compatible with
all Puppet 2.6.x versions.  The following alternative method SHOULD NOT be used
because it is not compatible with Puppet 2.6.2 and earlier.

{% highlight ruby %}
class ntp(
  $server = $ntp::params::server
) inherits ntp::params {

    notify { 'ntp':
      message => "server=[$server]",
    }

}
{% endhighlight %}

Other SHOULD recommendations:

 * SHOULD use the `_` preffix to indicate a scope local variable for
   maintainability over time.
 * SHOULD use fully qualified namespace variables when pulling the value
   from the module params class to avoid namespace collisions.
 * SHOULD declare the params class so the end user does not have to for the
   module to function properly.

This recommended pattern may be relaxed when Puppet 2.7 is more widely adopted
and module compatibility with as many versions of 2.6.x is no longer a primary
concern.

This diff illustrates the changes between these two commonly used patterns and
how to switch from one to the other.

{% highlight diff %}
    diff --git a/manifests/init.pp b/manifests/init.pp
    index c16c3a0..7923ccb 100644
    --- a/manifests/init.pp
    +++ b/manifests/init.pp
    @@ -12,9 +12,14 @@
     #
     class paramstest (
       $mandatory,
    -  $param = $paramstest::params::param
    -) inherits paramstest::params {
    +  $param = 'UNSET'
    +) {
    +  include paramstest::params
    +  $\_param = $param ? {
    +    'UNSET' => $::paramstest::params::param,
    +    default => $param,
    +  }
       notify { 'TEST':
    -    message => " param=[$param] mandatory=[$mandatory]",
    +    message => " param=[$\_param] mandatory=[$mandatory]",
       }
     }
{% endhighlight %}

## 12. Tests

All manifests should have a corresponding test manifest in the module's `tests`
directory.

    modulepath/apache/manifests/{init,ssl}.pp
    modulepath/apache/tests/{init,ssl}.pp

The test manifest should provide a clear example of how to declare the class or
defined resource type.  In addition, the test manifest should also declare any
classes required by the corresponding class to ensure `puppet apply` works in a
limited, stand alone manner.

## 13. Puppet Doc

Classes and defined resource types should be documented inline using
[RDoc markup](http://links.puppetlabs.com/rdoc_markup).  These inline
documentation comments are important because online documentation can then be
easily generated using the
[puppet doc](http://links.puppetlabs.com/puppet_manifest_documentation)
command.

For classes:

{% highlight ruby %}
    # == Class: example_class
    #
    # Full description of class example_class here.
    #
    # === Parameters
    #
    # Document parameters here.
    #
    # [*ntp_servers*]
    #   Explanation of what this parameter affects and what it defaults to.
    #   e.g. "Specify one or more upstream ntp servers as an array."
    #
    # === Variables
    #
    # Here you should define a list of variables that this module would require.
    #
    # [*enc_ntp_servers*]
    #   Explanation of how this variable affects the funtion of this class and if it
    #   has a default. e.g. "The parameter enc_ntp_servers must be set by the
    #   External Node Classifier as a comma separated list of hostnames." (Note,
    #   global variables should not be used in preference to class parameters  as of
    #   Puppet 2.6.)
    #
    # === Examples
    #
    #  class { 'example_class':
    #    ntp_servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
    #  }
    #
    # === Authors
    #
    # Author Name <author@example.com>
    #
    # === Copyright
    #
    # Copyright 2011 Your name here, unless otherwise noted.
    #
    class example_class {

    }
{% endhighlight %}

For defined resources:

{% highlight ruby %}
    # == Define: example_resource
    #
    # Full description of defined resource type example_resource here.
    #
    # === Parameters
    #
    # Document parameters here
    #
    # [*namevar*]
    #   If there is a parameter that defaults to the value of the title string
    #   when not explicitly set, you must always say so.  This parameter can be
    #   referred to as a "namevar," since it's functionally equivalent to the
    #   namevar of a core resource type.
    #
    # [*basedir*]
    #   Description of this variable.  For example, "This parameter sets the
    #   base directory for this resource type.  It should not contain a trailing
    #   slash."
    #
    # === Examples
    #
    # Provide some examples on how to use this type:
    #
    #   example_class::example_resource { 'namevar':
    #     basedir => '/tmp/src',
    #   }
    #
    # === Authors
    #
    # Author Name <author@example.com>
    #
    # === Copyright
    #
    # Copyright 2011 Your name here, unless otherwise noted.
    #
    define example_class::example_resource($basedir) {

    }
{% endhighlight %}

This will allow documentation to be automatically extracted with the puppet doc
tool.
