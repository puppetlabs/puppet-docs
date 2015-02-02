---
layout: default
title: The Puppet Language Style Guide
---

The Puppet Language Style Guide
===========

####Metadata

Puppet Language Style Guide: Version 2.0.0

Puppet: Version 3.7+ 

(Note: While the style guide maps to Puppet 3.7, many of its recommendations apply to Puppet 3.0.x and up.)


## 1. Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](http://www.faqs.org/rfcs/rfc2119.html).

Unless explicitly called out, everything discussed here applies specifically to Puppet (i.e. Puppet modules, Puppet classes, etc.). To save your eyes and our fingers, 'Puppet' will not be appended to every topic discussed.

## 2. Purpose

The purpose of this style guide is to promote consistent formatting across modules (from Puppet Labs and the community), which gives users and developers of Puppet modules a common pattern, design, and style to follow. Additionally, consistency in code and module structure makes continued development and contributions easier.

## 3. Guiding Principles

We can never cover every possible circumstance you might run into when developing Puppet code or creating a module. Eventually, a judgement call will be necessary. When that happens, keep in mind the following general principles:

1.  **Readability matters.**
    
    If you have to choose between two equally effective alternatives, pick the
    more readable one. While this is subjective, if you can read your
    own code three months from now, it's a great start.
    
2. **Scoping and simplicity are key.**

    When in doubt, err on the side of simplicity. A module should contain related resources that enable it to accomplish a task. If you describe the function of your module and you find yourself using the word ‘and,’ it’s time to split the module at the ‘and.’ You should have one goal, with all your classes and parameters focused on achieving it.

3. **Your module is a piece of software.**

    At least, you should treat it that way. When it comes to making decisions, choose the option that is easier to sustain in the long term.

## 4. Versioning

Your module must be versioned. We recommend (and use) [SemVer](http://semver.org/spec/v1.0.0.html); meaning for a version x.y.z., an increase in x indicates backwards incompatible changes or a complete rewrite, an increase in y indicates the addition of new features, and an increase in z indicates non-breaking bug fixes. 

This style guide is versioned using SemVer.

## 5. Spacing, Indentation, and Whitespace

Module manifests:

* Must use two-space soft tabs,
* Must not use literal tab characters,
* Must not contain trailing whitespace,
* Must have trailing commas after all resource attributes and parameter definitions,
* Should not exceed a 140-character line width,
* Should leave one empty line between resources, except when using dependency chains, and
* Should align hash rockets (`=>`) within blocks of attributes, remembering to arrange hashes for maximum readability first.

## 6. Quoting

* All strings must be enclosed in single quotes, unless they contain variables or single quotes.  
* Quoting is optional when the string is an enumerable set of options (such as present/absent).
* All variables must be enclosed in braces when interpolated in a string.  For example:

**Good:**

~~~
    "/etc/${file}.conf"
    "${::operatingsystem} is not supported by ${module_name}"
~~~

**Bad:**

~~~
    "/etc/$file.conf"
    "$::operatingsystem is not supported by $module_name"
~~~

* Variables standing by themselves should not be quoted, unless they are a resource title.  For example:

**Good:**

~~~
    mode => $my_mode
~~~

**Bad:**

~~~
    mode => "$my_mode"
    mode => "${my_mode}"
~~~

* Double quotes should be used rather than escaping when a string contains single quotes.

**Good:**  

~~~
warning("Class['apache'] parameter purge_vdir is deprecated in favor of purge_configs")
~~~

**Bad:**

~~~
warning('Class[\'apache\'] parameter purge_vdir is deprecated in favor of purge_configs')
~~~

## 7. Comments

You must use hash comments (`# This is a comment`). Comments should explain the **why**, not the **how**, of your code.

**Good:**

~~~
# Configures NTP
file { ‘/etc/ntp.conf’: … }
~~~

**Bad:**

~~~
/* Creates file /etc/ntp.conf */
file { ‘/etc/ntp.conf’: … }
~~~

## 8. Module Metadata

Every publicly available module must have metadata defined in the metadata.json file.  Your metadata should follow the below format:

~~~
    {
      "name": "examplecorp-mymodule",
      "version": "0.1.0",
      "author": "Pat",
      "license": "Apache-2.0",
      "summary": "A module for a thing",
      "source": "https://github.com/examplecorp/examplecorp-mymodule",
      "project_page": "https://github.com/examplecorp/examplecorp-mymodule",
      "issues_url": "https://github.com/examplecorp/examplecorp-mymodules/issues",
      "tags": ["things", "stuff"],
      "operatingsystem_support": [
        {
          "operatingsystem":"RedHat",
          "operatingsystemrelease": [
            "5.0",
            "6.0"
          ]
        },
        {
          "operatingsystem": "Ubuntu",
          "operatingsystemrelease": [ 
            "12.04",
           "10.04"
         ]
        }
      ],
      "dependencies": [
        { "name": "puppetlabs/stdlib", "version_requirement": ">= 3.2.0 <5.0.0" },
        { "name": "puppetlabs/firewall", "version_requirement": ">= 0.4.0 <5.0.0" },
      ]
    }
~~~
A more complete guide to the metadata.json format can be found in the [docs](http://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#write-a-metadatajson-file).

### 8.1 Dependencies

Hard dependencies must be declared explicitly in your module's metadata.json file. Soft dependencies should be called out in the README.md, and must not be enforced as a hard requirement in your metadata.json. A soft dependency is a dependency that is only required in a specific set of use cases. (As an example, see the [rabbitmq module](https://github.com/puppetlabs/puppetlabs-rabbitmq#module-dependencies).)

Your hard dependency declarations should not be unbounded.

## 9. Resources

### 9.1. Resource Names

All resource titles must be quoted. If you are using an array of titles you must quote each title in the array, but cannot quote the array itself.

**Good:**

~~~
    package { 'openssh': ensure => present }
~~~

**Bad:**

~~~
    package { openssh: ensure => present }
~~~

### 9.2. Arrow Alignment

All of the hash rockets (`=>`) in a resource's attribute/value list should
be aligned. The hash rockets should be placed one space ahead of the longest
attribute name. Nested blocks must be indented by two spaces, and hash rockets within a nested block should be aligned (one space ahead of the longest attribute name).
 

**Good:**

~~~
    exec { 'hambone':
      path => '/usr/bin',
      cwd  => '/tmp',
    }

    exec { 'test':
      subscribe   => File['/etc/test'],
      refreshonly => true,
    }

    myresource { ‘test’:
      ensure => present,
      myhash => {
        ‘myhash_key1’ => ‘value1’,
        ‘key2’        => ‘value2’,
      },
    }
~~~

**Bad:**

~~~
    exec { 'hambone':
      path  => '/usr/bin',
      cwd => '/tmp',
    }

    exec { 'test':
      subscribe => File['/etc/test'],
      refreshonly => true,
    }
~~~

### 9.3. Attribute Ordering

If a resource declaration includes an `ensure` attribute, it should be the
first attribute specified so a user can quickly see if the resource is being created or deleted.

**Good:**

~~~
    file { '/tmp/readme.txt':
      ensure => file,
      owner  => '0',
      group  => '0',
      mode   => '0644',
    }
~~~


### 9.4. Resource Arrangement

Within a manifest, resources should be grouped by logical relationship to each other, rather than by resource type. Semicolons must not be used to declare multiple resources within a set of curly braces.

**Good:**

~~~
    file { '/tmp/dir':
      ensure => directory,
    }

    file { ‘/tmp/dir/a’:
      content => ‘a’,
    }

    file { '/tmp/dir2':
      ensure => directory,
    }

    file { '/tmp/dir2/b':
      content => ‘b’,
    }
~~~

**Bad:**

~~~
    file { '/tmp/dir':
      ensure => directory,
    }

    file { '/tmp/dir2':
      ensure => directory,
    }
    
    file { ‘/tmp/dir/a’:
      content => ‘a’,
    }

    file { '/tmp/dir2/b':
      content => ‘b’,
    }
~~~

### 9.5. Symbolic Links

Symbolic links must be declared with an ensure value of `ensure => link` and explicitly specify a value for the `target` attribute. Doing so more explicitly informs the user that a link is being created.

**Good:**

~~~
    file { '/var/log/syslog':
      ensure => link,
      target => '/var/log/messages',
    }
~~~

**Bad:**

~~~
    file { '/var/log/syslog':
      ensure => '/var/log/messages',
    }
~~~

### 9.6. File Modes

* POSIX numeric notation must be represented as 4 digits.
* POSIX symbolic notation must be a string.
* You should not use file mode with Windows; instead use the [acl module](https://forge.puppetlabs.com/puppetlabs/acl).
* You should use numeric notation whenever possible.

**Good:**

~~~
    file { '/var/log/syslog':
      ensure => file,
      mode   => '0644',
    }

    file { '/var/log/syslog':
      ensure => file,
      mode   => 'u=rw,g=r,o=r',
    }
~~~

**Bad:**

~~~
    file { '/var/log/syslog':
      ensure => present,
      mode   => 644,
    }
~~~

### 9.7. Resource Defaults

Resource defaults should be used in a very controlled manner and should only
be declared at the edges of your manifest ecosystem. Specifically, they may be declared:

* At top scope in site.pp, or
* In a class which is guaranteed to never declare or be inherited by 
a class or define from another module.

This is due to the way resource defaults propagate through dynamic scope, which can have 
unpredictable effects far away from where the default was declared.

**Good:**

~~~
    # /etc/puppetlabs/puppet/manifests/site.pp:
    File {
      owner => 'root',
      group => '0',
      mode  => '0644',
    }
~~~

**Bad:**

~~~
    # /etc/puppetlabs/puppet/modules/apache/manifests/init.pp
    File {
      owner => 'nobody',
      group => 'nogroup',
      mode  => '0600',
    }

    concat { $config_file_path:
      notify  => Class['Apache::Service'],
      require => Package['httpd'],
    }
~~~

## 10. Classes and Defines

### 10.1. Separate Files

All classes and resource type definitions (defines) must be separate files in the `manifests` directory of the module. 

**Good:**

~~~
    # /etc/puppetlabs/puppet/modules/apache/manifests

    # init.pp
      class apache { }
    # ssl.pp
      class apache::ssl { }
    # virtual_host.pp
      define apache::virtual_host () { }
~~~

Separating classes and defines into separate files is functionally identical to declaring them in init.pp, but has the benefit of highlighting the structure of the module and making the function and structure more legible.

### 10.2. Internal Organization of Classes and Defines

Classes and defines must be structured to accomplish one task. Below is a line-by-line general layout of what lines of code should come first, second, and so on. 

1. First line: Name of class or type.
1. Following lines, if applicable: Define parameters.
1. Next lines: Should validate* any parameters and fail catalog compilation if any
    parameters are invalid. (See [ntp](https://github.com/puppetlabs/puppetlabs-ntp/blob/3.3.0/manifests/init.pp#L28-L49) for an example.)
1. Next lines, if applicable: Should declare local variables and perform variable munging.
1. Next lines: Should declare resource defaults.
1. Next lines:  Should override resources if necessary.
1. Next lines: Should declare resources in the order they need to be processed.
1. Last lines: Should declare relationships to other classes or defines. (For example: `Class['apache'] -> Class['local_yum']`.)

We recommend that the last two items -- declared resources and declared relationships to other classes/defines -- not occur in the same class or type. For more on relationship declarations, [see below](#104-chaining-arrow-syntax).

The following example follows the recommended style:

~~~
    class myservice (
      $service_ensure = 'running',
      $package_list   = undef,
    ) {

      if $service_ensure in [ ‘running’, ‘stopped’ ] {
        $_ensure = $service_ensure
      } else {
        fail('ensure parameter must be running or stopped')
      }

      if $package_list {
        $_package_list = $package_list
       } else {
        case $::operatingsystem {
          ‘centos’: {
            $_package_list = 'myservice-centos-package'
          }
          ‘solaris’: {
            $_package_list = [ ‘myservice-solaris-package1’, ‘myservice-solaris-package2’ ]
          }
          default: {
            fail("Module ${module_name} does not support ${::operatingsystem}")
          }
        }
      }

      $variable = 'something'

      Package { ensure => present, }

      File { 
        owner => '0',
        group => '0',
        mode  => '0644',
     }

      package { $_package_list: }

      file { "/tmp/${variable}":
        ensure => present,
      }

      service { 'myservice':
        ensure    => $_service_ensure,
        hasstatus => true,
      }
    }
~~~

### 10.3. Public and Private

We recommend that you split your module into public and private classes and defines where possible. Public classes or defines should contain the parts of the module meant to be configured or customized by the user, while private classes should contain things you do not expect the user to change via parameters. Separating into public and private classes/defines helps build reusable and readable code.

You should help indicate to the user which classes are which by both calling out the public classes in the README and making sure all public classes have complete [comments](#7-comments).

>Note: As of stdlib 4.4.0, there is a `private` function that will cause a failure if a private class is called externally. You can use this to enforce the privacy of private classes.

### 10.4. Chaining Arrow Syntax

Most of the time, use [relationship metaparameters](https://docs.puppetlabs.com/puppet/latest/reference/lang_relationships.html#relationship-metaparameters) rather than [chaining arrows](https://docs.puppetlabs.com/puppet/latest/reference/lang_relationships.html#chaining-arrows). When you have many [interdependent or order-specific items](https://github.com/puppetlabs/puppetlabs-mysql/blob/3.1.0/manifests/server.pp#L64-L72), chaining syntax may be used.  Chaining arrows must be used left to right.

**Good:** 

    Package['httpd'] -> Service['httpd']

**Bad:**

    Service['httpd'] <- Package['httpd']

### 10.5. Nested Classes or Defines

Classes and defined resource types must not be defined within other classes or defined types. Classes and defines should be declared as close to node scope as possible. If you have a class or define which requires another class or define, graceful failures must be in place if those required classes or defines are not declared elsewhere. 

**Very Bad:**

~~~
    class apache {
      class ssl { ... }
    }
~~~

**Also Very Bad:**

~~~
    class apache {
      define config() { ... }
    }
~~~

### 10.6. Display Order of Parameters

In parameterized class and define declarations, required parameters must be listed before optional parameters (i.e., parameters with defaults).

**Good:**

~~~
class dhcp (
  $dnsdomain,
  $nameservers,
  $default_lease_time = 3600,
  $max_lease_time     = 86400
) {}

~~~

**Bad:**

~~~
    class ntp (
      $options   = "iburst",
      $servers,
      $multicast = false
    ) {}
~~~

### 10.7 Parameter defaults

When writing a module that accepts class and define parameters, appropriate defaults should be provided for optional parameters. Establishing good defaults gives the end user the option of not explicitly specifying the parameter when declaring the class or define. Provided defaults should be specified with the parameter and not inside the class/define.

**Good:**

~~~
class ntp(
  $server = $ntp::params::server,
) inherits ntp::params {

    notify { 'ntp':
      message => "server=[$server]",
    }

}
~~~

**Bad:**

~~~
    class ntp(
      $server = undef,
    ) {

      include ntp::params

      if $server {
        $_server = $server
      } else {
        $_server = $::ntp::params::server
      }


      notify { 'ntp':
        message => "server=[$_server]",
      }

    }
~~~

>Note: We recommend using [inheritance](#111-class-inheritance) for class parameter defaults.

When creating parameter defaults, you:

* Must use fully qualified namespace variables when pulling the value from the module params class. This avoids namespace collisions. See [Namespacing Variables](#131-namespacing-variables) for more information.
* Should use the `_` prefix to indicate a scope local variable for maintainability over time.

### 10.8 Exported Resources
Exported resources should be opt-in rather than opt-out. Your module should not be written to use exported resources to function by default unless it is expressly required. When using exported resources, you should name the property `collect_exported`.

Exported resources should be exported and collected selectively using a [search expression](https://docs.puppetlabs.com/puppet/3.7/reference/lang_collectors.html#search-expressions), ideally allowing user-defined tags as parameters so tags can be used to selectively collect by environment or custom fact.

**Good:**

~~~
define haproxy::frontend (
  $ports            = undef,
  $ipaddress        = [$::ipaddress],
  $bind             = undef,
  $mode             = undef,
  $collect_exported = false,
  $options          = {
    'option'  => [
      'tcplog',
    ],
  },
) { … }
~~~

## 11. Classes

### 11.1. Class Inheritance

Inheritance can be used within a module, but must not be used across module
namespaces. Cross-module dependencies should be satisfied in a more portable
way, such as with include statements or relationship declarations.

**Good:**

~~~
    class ssh { ... }

    class ssh::client inherits ssh { ... }

    class ssh::server inherits ssh { ... }
~~~

**Bad:**

~~~
    class ssh inherits server { ... }

    class ssh::client inherits workstation { ... }

    class wordpress inherits apache { ... }
~~~

Generally, inheritance should be avoided when alternatives are viable. For
example, rather than using inheritance to override relationships in an existing
class when stopping a service, consider using a single class with an `ensure`
parameter and conditional relationship declarations. For instance,

~~~
    class bluetooth (
      $ensure      = ‘present’,
      $autoupgrade = false,
    ) {
       # Validate class parameter inputs. (Fail early and fail hard)

       if ! ($ensure in [ ‘present’, ‘absent’ ]) {
         fail(‘bluetooth ensure parameter must be absent or present’)
       }

       if ! ($autoupgrade in [ true, false ]) {
         fail(‘bluetooth autoupgrade parameter must be true or false’)
       }

       # Set local variables based on the desired state

       if $ensure == ‘present’ {
         $service_enable = true
         $service_ensure = ‘running’
         if $autoupgrade {
           $package_ensure = ‘latest’
         } else {
           $package_ensure = ‘present’
         }
       } else {
         $service_enable = false
         $service_ensure = ‘stopped’
         $package_ensure = ‘absent’
       }

       # Declare resources without any relationships in this section

       package { [ ‘bluez-libs’, ‘bluez-utils’]:
         ensure => $package_ensure,
       }

       service { ‘hidd’:
         enable         => $service_enable,
         ensure         => $service_ensure,
         status         => ‘source /etc/init.d/functions; status hidd’,
         hasstatus      => true,
         hasrestart     => true,
      }

      # Finally, declare relations based on desired behavior

      if $ensure == ‘present’ {
        Package[‘bluez-libs’]  -> Package[‘bluez-utils’]
        Package[‘bluez-libs’]  ~> Service[‘hidd’]
        Package[‘bluez-utils’] ~> Service[‘hidd’]
      } else {
        Service[‘hidd’]        -> Package[‘bluez-utils’]
        Package[‘bluez-utils’] -> Package[‘bluez-libs’]
      }
    }
~~~

Remember:

Class inheritance should only be used for `myclass::params` parameter defaults. Other use cases can be accomplished through the addition of parameters or conditional logic. 

### 11.2 A Note About Publicly Available Modules

Although the `include` function technically allows multiple declarations of classes, using it in publicly available modules can result in non-deterministic scoping issues due to the way parent scopes are assigned.


## 12. Defined Resource Types (Defines)

### 12.1. Uniqueness

Since defined resource types (defines) can have multiple instances, resource names must have a unique variable to avoid duplicate declarations.

## 13. Variables

### 13.1. Namespacing Variables

You must scope all variables except for local or inherited variables. Scope inherited variables, when appropriate, for clarity. You should not mask/shadow inherited variables.

You should avoid accidental scoping issues by explicitly specifying empty namespaces when using top-scope variables, including facts.

**Good:**

~~~
    $::operatingsystem
~~~

**Bad:**

~~~
    $operatingsystem
~~~

### 13.2. Variable Format

When defining variables you must only use numbers, lowercase letters, and
underscores. You should not use camelCasing, as it introduces inconsistency in style. You must also not use dashes, as they are not syntactically valid.

**Good:**

~~~
$foo_bar
$some_long_variable
$foo_bar123
~~~

**Bad:**

~~~
$fooBar
$someLongVariable
$foo-bar123
~~~

## 14. Conditionals

### 14.1. Keep Resource Declarations Simple

We recommend not mixing conditionals with resource declarations. When you use conditionals for data assignment, you should separate conditional code from the
resource declarations.

**Good:**

~~~
    $file_mode = $::operatingsystem ? {
      ‘debian’ => '0007',
      ‘redhat’ => '0776',
       default => ‘0700’,
    }

    file { '/tmp/readme.txt':
      ensure  => file,
      content => "Hello World\n",
      mode    => $file_mode,
    }
~~~

**Bad:**

~~~
    file { '/tmp/readme.txt':
      ensure  => file,
      content => "Hello World\n",
      mode    => $::operatingsystem ? {
        ‘debian’ => '0777',
        ‘redhat’ => '0776',
        default  => ‘0700’,
      }
    }
~~~

### 14.2. Defaults for Case Statements and Selectors

Case statements must have default cases. If you want the default case to be "do nothing," you must include it as an explicit `default: {}` for clarity's sake.

Case and selector values must be quoted.

Selectors should omit default selections only if you explicitly want catalog compilation to fail when no value matches.


**Good:**

~~~
    case $::operatingsystem {
      ‘centos’: {
        $version = '1.2.3'
      }
      ‘solaris’: {
        $version = '3.2.1'
      }
      default: {
        fail("Module ${module_name} is not supported on ${::operatingsystem}")
      }
    }
~~~

When setting the default case, keep in mind that the default case should cause the catalog compilation to fail if the resulting behavior cannot be predicted on the platforms the module was built to be used on.

## 15. Hiera

You should avoid using calls to Hiera functions in modules meant for public consumption, because not all users have implemented Hiera. Instead, we recommend using parameters that can be overridden with Hiera.

## 16. Examples

Major use cases for your module should have corresponding example manifests in the module's /examples directory.

    modulepath/apache/examples/{usecase}.pp

The example manifest should provide a clear example of how to declare the class or defined resource type. The example manifest should also declare any classes required by the corresponding class to ensure `puppet apply` works in a limited, standalone manner.

## 17. Module Documentation

All publicly available modules should include the documentation covered below.

### 17.1 README

Your module should have a README in .md (or .markdown) format. READMEs help users of your module get the full benefit of your work. There is a [Puppet Labs README template](https://docs.puppetlabs.com/puppet/latest/reference/READMEtemplate.txt) available for your use; it can also be obtained by running `puppet module generate` (available in Puppet 3.6 and above). Using the .md/.markdown format allows your README to be parsed and displayed by both GitHub and the Puppet Forge.

If you are prolific with your in-code comments, you can use `puppet doc` up until Puppet 4 is released. If you're currently using the future parser, you might want to check out [strings](https://github.com/puppetlabs/puppetlabs-strings), the replacement for `puppet doc` that (only) works with the future parser. 

There's an entire [guide](https://docs.puppetlabs.com/puppet/latest/reference/modules_documentation.html) to writing a great README, but overall you should:

* Call out what your module does.
* Note any part of a user's system the module might impact (e.g. "This module will overwrite everything in animportantfile.conf.").
* List all of the classes, defines, types, providers, and parameters the user might need to configure with a brief description, the default values (if any), and what the valid options are.

### 17.2 CHANGELOG

Your module should have a CHANGELOG in .md (or .markdown) format. Your CHANGELOG should: 

* Have entries for each release. 
* List bugfixes and features included in the release. 
* Specifically call out backwards-incompatible changes

## 18. Contributing

When contributing back to someone else's module, you must keep to the main intent. If you find that the modifications you are making really addresses some entirely separate task or software, create a new module.

When contributing new parameters or resources, you should organize them by:
* order-dependency
* required before optional
* alphabetically (where applicable)  

## 19. Verifying style

This guide helps development of puppet-lint and puppet-metadata-lint[.](http://fc09.deviantart.net/fs70/i/2012/232/0/a/welcome_to_the_internet__please_follow_me_by_sharpwriter-d5buwfu.jpg)
