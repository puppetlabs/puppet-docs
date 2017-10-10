---
layout: default
title: The Puppet Language Style Guide
---

The Puppet Language Style Guide
===========

#### Metadata

Puppet: Version 4.0+

This style guide applies to Puppet 4 and later. Puppet 3 is no longer supported, but this style guide includes some Puppet 3 guidelines for those who need to maintain older code.

## 1. Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](http://www.faqs.org/rfcs/rfc2119.html).

Unless explicitly called out, everything discussed here applies specifically to Puppet (that is, Puppet modules, Puppet classes, etc.). The name 'Puppet' is not appended to every topic discussed.

## 2. Purpose

The purpose of this style guide is to promote consistent formatting in the Puppet Language, especially across modules, giving users and developers of Puppet modules a common pattern, design, and style to follow. Additionally, consistency in code and module structure makes continued development and contributions easier.

We recommend using [puppet-lint](http://puppet-lint.com/) and [metadata-json-lint](https://github.com/voxpupuli/metadata-json-lint) within your module to check for compliance with the style guide.

## 3. Guiding principles

We can never cover every circumstance you might run into when developing Puppet code. When you need to make a judgement call, keep in mind these general principles:

1.  **Readability matters.**
    
    If you have to choose between two equal alternatives, pick the more readable one. This is subjective, but if you can read your own code three months from now, it's a great start. In particular, code that generates readable diffs is highly preferred.
    
2. **Scoping and simplicity are key.**

    When in doubt, err on the side of simplicity. A module should contain related resources that enable it to accomplish a task. If you describe the function of your module and you find yourself using the word "and," consider splitting the module. You should have one goal, with all your classes and parameters focused on achieving it.

3. **Your module is a piece of software.**

    At least, you should treat it that way. When it comes to making decisions, choose the option that is easier to maintain in the long term.

## 4. Versioning

Your module must be versioned. We recommend [SemVer](http://semver.org/spec/v1.0.0.html); meaning that for a version x.y.z., an increase in x indicates backwards incompatible changes or a complete rewrite, an increase in y indicates the non-breaking addition of new features, and an increase in z indicates non-breaking bug fixes. 

## 5. Spacing, indentation, and whitespace

Module manifests:

* Must use two-space soft tabs,
* Must not use literal tab characters,
* Must not contain trailing whitespace,
* Must include trailing commas after all resource attributes and parameter definitions,
* Must end the last line with a new line,
* Must use one space between the resource type and opening brace, one space between the opening brace and the title, and no spaces between the title and colon.

  **Good**:

  ```
file { '/tmp/foo':
  ```

  **Bad**:

  ```
  # space between title and colon
  file { '/tmp/foo' :
  
  # no spaces
  file{'/tmp/foo':

  # too many spaces
  file     { '/tmp/foo':
  ```

* Should not exceed a 140-character line width, except where such a limit would be impractical,
* Should leave one empty line between resources, except when using dependency chains, and
* May align hash rockets (`=>`) within blocks of attributes, one space after the longest resource key, arranging hashes for maximum readability first.

### 5.1: Arrays and hashes

To increase readability of arrays and hashes, it is almost always beneficial to break up the elements on separate lines. Use a single line only if that results in overall better readability of the construct where it appears, such as when it is very short. When breaking arrays and hashes, they should have:

* Each element on its on line,
* Each new element line indented one level,
* First and last lines used only for the syntax of that data type.

**Good**:

```
# array with multiple elements on multiple lines
service { 'foo':
  require => [
    File['foo_config'],
    File['foo_sysconfig'],
  ],
}

# hash with multiple elements on multiple lines
$myhash = {
  key       => 'some value',
  other_key => 'some other value',
}
```

**Bad**:

```
# array with multiple elements on same line
service { 'foo':
  require => [ File['foo_config'], File['foo_sysconfig'], ],
}

# hash with multiple elements on same line
$myhash = { key => 'some value', other_key => 'some other value', }

# array with multiple elements on different lines, but syntax and element share a line
service { 'foo':
  require => [ File['foo_config'],
    File['foo_sysconfig'],
  ],
}

# hash with multiple elements on different lines, but syntax and element share a line
$myhash = { key => 'some value',
  other_key     => 'some other value',
}

# array with indention of elements past one stop
service { 'foo':
  require => [
              File['foo_config'],
              File['foo_sysconfig'],
  ],
}
```

## 6. Quoting

* All strings must be enclosed in single quotes, unless the string:
  * Contains variables.
  * Contains single quotes.
  * Contains escaped characters not supported by single-quoted strings.
  * Is an enumerable set of options, such as present/absent, in which case the single quotes are optional.
* All variables must be enclosed in braces when interpolated in a string. For example:

  **Good:**

  ```
    "/etc/${file}.conf"
    "${::operatingsystem} is not supported by ${module_name}"
  ```

  **Bad:**

  ```
    "/etc/$file.conf"
    "$::operatingsystem is not supported by $module_name"
  ```

* Double quotes should be used rather than escaping when a string contains single quotes, unless that would require an inconvenient amount of additional escaping.

  **Good:**  

  ```
warning("Class['apache'] parameter purge_vdir is deprecated in favor of purge_configs")
  ```

  **Bad:**

  ```
warning('Class[\'apache\'] parameter purge_vdir is deprecated in favor of purge_configs')
  ```

### 6.1. Escape characters

Puppet uses backslash as an escape character. For both single- and double-quoted strings, escape the backslash to remove this special meaning: `\\` This means that for every backslash you want to include in the resulting string, use two backslashes. As an example, to include two literal backslashes in the string, you would use four backslashes in total.

Do not rely on unrecognized escaped characters as a method for including the backslash and the character following it.

Unicode character escapes using fewer than 4 hex digits, as in `\u040`, results in a backslash followed by the string `u040`. (This also causes a warning for the unrecognized escape.) To use a number of hex digits not equal to 4, use the longer `u{digits}` format.

## 7. Comments

Comments must be hash comments (`# This is a comment`), not `/* */` comments. Comments should explain the **why**, not the **how**, of your code.

**Good:**

```
# Configures NTP
file { '/etc/ntp.conf': … }
```

**Bad:**

```
/* Creates file /etc/ntp.conf */
file { '/etc/ntp.conf': … }
```

### 7.1 Documentation comments

Documentation comments for Puppet Strings should be included for each of your classes, defined types, functions, and resource types and providers. See the [documentation section](#documenting-puppet-code) of this guide for complete documentation recommendations. If used, documentation comments must precede the name of the element.

## 8. Module metadata

Every module must have metadata defined in the metadata.json file.  Your metadata should follow the below format:

```
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
```

A more complete guide to the metadata.json format can be found in the [docs](http://docs.puppet.com/puppet/latest/modules_publishing.html#write-a-metadatajson-file).

### 8.1 Dependencies

Hard dependencies must be declared explicitly in your module's metadata.json file. Soft dependencies should be called out in the README.md, and must not be enforced as a hard requirement in your metadata.json. A soft dependency is a dependency that is only required in a specific set of use cases. (As an example, see the [rabbitmq module](https://forge.puppet.com/puppetlabs/rabbitmq#module-dependencies).)

Your hard dependency declarations should not be unbounded.

## 9. Resources

### 9.1. Resource names

All resource names or titles must be quoted. If you are using an array of titles you must quote each title in the array, but cannot quote the array itself.

**Good:**

```
    package { 'openssh': ensure => present }
```

**Bad:**

```
    package { openssh: ensure => present }
```

These quoting requirements do not apply to expressions that evaluate to strings.

### 9.2. Arrow alignment

Hash rockets (`=>`) in a resource's attribute/value list may
be aligned. The hash rockets should be placed one space ahead of the longest
attribute name. Nested blocks must be indented by two spaces, and hash rockets within a nested block may be aligned (one space ahead of the longest attribute name).
 

**Good:**

```
    exec { 'hambone':
      path => '/usr/bin',
      cwd  => '/tmp',
    }

    exec { 'test':
      subscribe   => File['/etc/test'],
      refreshonly => true,
    }

    myresource { 'test':
      ensure => present,
      myhash => {
        'myhash_key1' => 'value1',
        'key2'        => 'value2',
      },
    }
```

**Bad:**

```
    exec { 'hambone':
    path  => '/usr/bin',
    cwd => '/tmp',
    }
```

### 9.3. Attribute ordering

If a resource declaration includes an `ensure` attribute, it should be the
first attribute specified so that a user can quickly see if the resource is being created or deleted.

**Good:**

```
    file { '/tmp/readme.txt':
      ensure => file,
      owner  => '0',
      group  => '0',
      mode   => '0644',
    }
```

When using the special attribute `*` (asterisk or splat character) in addition to other attributes, splat should be ordered last so that it is easy to see. You may not include multiple splats in the same body.

**Good**:

```
$file_ownership = {
  "owner" => "root",
  "group" => "wheel",
  "mode"  => "0644",
}

file { "/etc/passwd":
  ensure => file,
  *      => $file_ownership,
}
```

### 9.4. Resource arrangement

Within a manifest, resources should be grouped by logical relationship to each other, rather than by resource type.

**Good:**

```
    file { '/tmp/dir':
      ensure => directory,
    }

    file { '/tmp/dir/a':
      content => 'a',
    }

    file { '/tmp/dir2':
      ensure => directory,
    }

    file { '/tmp/dir2/b':
      content => 'b',
    }
```

**Bad:**

```
    file { '/tmp/dir':
      ensure => directory,
    }

    file { '/tmp/dir2':
      ensure => directory,
    }
    
    file { '/tmp/dir/a':
      content => 'a',
    }

    file { '/tmp/dir2/b':
      content => 'b',
    }
```

Semicolon-separated multiple resource bodies should be used only in conjunction with a local default body.

**Good:**

```
$defaults = { < hash of defaults > }

file {
  default : 
    * => $defaults ;

  '/tmp/foo' :
   content => "foos content"
}
```

**Good: Repeated pattern with defaults:**

```
$defaults = { < hash of defaults > }

file {
  default : 
    * => $defaults ;

  '/tmp/motd' :
   content => "message of the day" ;

  '/tmp/motd_tomorrow' :
   content => "tomorrows message of the day" ;
}
```

**Bad: Unrelated resources grouped:**

```
file {
  '/tmp/foo':
    owner => 'admin',
    mode => '0644',
    contents => 'this is the content';

  '/opt/myapp:
    owner => 'myapp-admin',
    mode => '0644'
    source => 'puppet://<someurl>';
  
# etc
```

You cannot set any attribute more than once for a given resource; if you try, Puppet raises a compilation error. This means:

* If you use a hash to set attributes for a resource, you cannot set a different, explicit value for any of those attributes. (For example, if mode is present in the hash, you can’t also set mode => "0644" in that resource body.)
* You can’t use the `*` attribute multiple times in one resource body, because `*` itself acts like an attribute.
* To use some attributes from a hash and override others, either use a hash to set per-expression defaults, or use the `+` (merging) operator to combine attributes from two hashes (with the right-hand hash overriding the left-hand one).

### 9.5. Symbolic links

Symbolic links must be declared with an ensure value of `ensure => link` and explicitly specify a value for the `target` attribute. Doing so more explicitly informs the user that a link is being created.

**Good:**

```
    file { '/var/log/syslog':
      ensure => link,
      target => '/var/log/messages',
    }
```

**Bad:**

```
    file { '/var/log/syslog':
      ensure => '/var/log/messages',
    }
```

### 9.6. File modes

* POSIX numeric notation must be represented as 4 digits.
* POSIX symbolic notation must be a string.
* You should not use file mode with Windows; instead use the [acl module](https://forge.puppet.com/puppetlabs/acl).
* You should use numeric notation whenever possible.
* The file mode attribute should always be a quoted string, never an integer.

**Good:**

```
file { '/var/log/syslog':
      ensure => file,
      mode   => '0644',
  }
```

**Bad:**

```
    file { '/var/log/syslog':
      ensure => present,
      mode   => 644,
    }
```

#### 9.6.5 Multiple resources

Multiple resources declared in a single block should be used only when there is also a default set of options for the resource type.

**Good**:

```
file {
  default :
    ensure => 'file'
    mode   => '0666' ;
 
  '/foo' :
    user => root;
 
  '/bar' :
    user => staff;
}
 
# Give the defaults a name if used several times
$our_default_file_attributes = { 
  'mode' => '0666', 
  'ensure' => 'file', 
}
 
file {
  default :
    * => $our_default_file_attributes ;
 
  '/foo' :
    user => root;
 
  '/bar' :
    user => staff;
}
  
 
# spell out "magic" iteration
[ '/foo', '/bar' ].each | $path | {
 
  file { $path :
    ensure => 'file',
  }
}
 
# spell out "magic" iteration
$array_of_paths.each | $path |  {
 
  file { $path :
    ensure => 'file',
  }
}
```

**Bad**:

```

file {
  '/foo':
    user     => root,
    ensure => 'file',
    mode => '0666' ;
 
  '/bar':
    user     => staff,
    ensure => 'file',
    mode => '0774' ;
}
 
file { ['/foo', '/bar']:
  ensure => 'file',
}
 
file { $array_of_paths :
  ensure => 'file',
}
```

### 9.7 Legacy style defaults

Avoid legacy style defaults. If you do use them, they should occur only at top scope in your site manifest. This is because resource defaults propagate through dynamic scope, which can have unpredictable effects far away from where the default was declared.

**Acceptable**:

```
# site.pp:
 
Package {
  provider => 'zypper',
}
```

**Bad**:

```
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
```

### 9.8 Resource attribute indentation and alignment

Resource attributes must be uniformly indented in one stop from the title.

**Good**:

```
file { '/foo':
  ensure => 'file',
  owner  => 'root',
}
```

**Bad**:

```
# too many levels of indentation
file { '/foo':
    ensure => 'file',
    owner  => 'root',
}

# no indentation
file { '/foo':
ensure => 'file',
owner  => 'root',
}

# improper and non-uniform indentation
file { '/foo':
  ensure => 'file',
   owner => 'root',
}

# indented the wrong direction
  file { '/foo':
ensure => 'file',
owner  => 'root',
  }
```

For multiple bodies, each title should be on its own line, and be indented. You may align all arrows across the bodies, but arrow alignment is not required if alignment per body is more readable.

```
file {
  default:
    * => $local_defaults;
 
  '/foo':
    ensure => 'file'
    owner  => root
}
```

## 10. Classes and defined types

### 10.1. Separate files

All classes and resource type definitions (defined types) must be separate files in the `manifests` directory of the module. Each separate file in the manifest directory of the module should contain nothing other than the class or resource type definition.

**Good:**

```
    # /etc/puppetlabs/puppet/modules/apache/manifests

    # init.pp
      class apache { }
    # ssl.pp
      class apache::ssl { }
    # virtual_host.pp
      define apache::virtual_host () { }
```

Separating classes and defined types into separate files is functionally identical to declaring them in init.pp, but has the benefit of highlighting the structure of the module and making the function and structure more legible.

When a resource or include statement is placed outside of a class, node definition, or defined type, it is included in all catalogs. This can have undesired effects and is not always easy to detect.

**Good:**

```
#manifests/init.pp:
class { 'foo':
  include bar
}
```

**Bad:**

```
#manifests/init.pp:
class { 'foo':
...
}
include bar
```

### 10.2. Internal organization of classes and defined types

Classes and defined types must be structured to accomplish one task. Below is a line-by-line general layout of what lines of code should come first, second, and so on. 

Documentation [comments](#documentation-comments) for Puppet Strings should be included for each class or defined type. See the [documentation section](#documenting-puppet-code) of this guide for complete documentation recommendations. If used, documentation comments must precede the name of the element.

1. First line: Name of class or type.
1. Following lines, if applicable: Define parameters. Parameters should be [typed](https://docs.puppet.com/puppet/latest/lang_data_type.html#language:-data-types:-data-type-syntax).
1. Next lines: Includes and validation come after parameters are defined. Includes may come before or after validation, but should be grouped separately, with all includes and requires in one group and all validations in another. 
   * Validations should validate any parameters and fail catalog compilation if any
    parameters are invalid. (See [ntp](https://github.com/puppetlabs/puppetlabs-ntp/blob/3.3.0/manifests/init.pp#L28-L49) for an example.)
1. Next lines, if applicable: Should declare local variables and perform variable munging.
1. Next lines: Should declare resource defaults.
1. Next lines:  Should override resources if necessary.

The following examples follows the recommended style:

In init.pp:

```
# The `myservice` class installs packages, ensures the state of 'myservice', and creates 
# a tempfile with given content. If the tempfile contents contains digits,
# they are filtered out.
#
# @param service_ensure the wanted state of services
# @param package_list the list of packages to install, at least one must be given, or an 
# error of unsupported 'os' is raised
# @param tempfile_contents the text to be included in the tempfile, all digits are 
# filtered out if present
#
class myservice (
  Enum['running', 'stopped'] $service_ensure,
  String                     $tempfile_contents,
  Optional[Array[String[1]]] $package_list = undef,
) {
 
  # Example of additional assertion with a better error message than just saying that
  # there was a type mismatch for $package_list.
  #
  # The list can be "not given", or have an empty list of packages to install
  # Here an assertion is made that the list is an Array of at least one String, and that 
  # the String is at least one character long.
  #
  assert_type(Array[String[1], 1], $package_list) | $expected, $actual | {
    fail("Module ${module_name} does not support ${facts['os']['name']} as the list of packages is of type ${actual}"
  }
 
  package { $package_list :
    ensure => present
  }
 
  file { "/tmp/${variable}":
    ensure   => present,
    contents => regsubst($tempfile_contents, '\d', '', 'G'),
    owner    => '0',
    group    => '0',
    mode     => '0644',
  }
 
  service { 'myservice':
    ensure    => $service_ensure,
    hasstatus => true,
  }
 
  Package[$package_list] -> Service['myservice']
}
```
 
In module's `hiera.yaml`:
 
```
---
version: 5
defaults:
  data_hash: yaml_data
 
# The default values can be merged if you want to extend with additional packages
# If not, use 'default_hierarchy' instead of 'hierarchy'
#
hierarchy:
  - name: "Per Operating System"
    path: "os/%{os.name}.yaml"
  - name: "Common"
    path: "common.yaml"
```
 
In module `data/common.yaml`:

```
myservice::service_ensure: running
```
 
In module `data/os/centos.yaml`:

```
myservice::package_list:
  - 'myservice-centos-package'
```
 
In module `data/os/solaris.yaml`:

```
myservice::package_list:
  - 'myservice-solaris-package1'
  - 'myservice-solaris-package2'
```

### 10.3. Public and private

We recommend that you split your module into public and private classes and defined types where possible. Public classes or defined types should contain the parts of the module meant to be configured or customized by the user, while private classes should contain things you do not expect the user to change via parameters. Separating into public and private classes or defined types helps build reusable and readable code.

You should help indicate to the user which classes are which by making sure all public classes have complete [comments](#comments) and denoting public and private classes in your documentation. Use the documentation tags "@api private" and "@api public" to make this clear.

### 10.4. Chaining arrow syntax

Most of the time, use [relationship metaparameters](https://docs.puppet.com/puppet/latest/lang_relationships.html#relationship-metaparameters) rather than [chaining arrows](https://docs.puppet.com/puppet/latest/lang_relationships.html#chaining-arrows). When you have many [interdependent or order-specific items](https://github.com/puppetlabs/puppetlabs-mysql/blob/3.1.0/manifests/server.pp#L64-L72), chaining syntax may be used. A chain operator should appear on the same line as its right-hand operand. Chaining arrows must be used left to right.

**Good:** 

```
Package['httpd'] -> Service['httpd']
```

**Bad:**

```
# arrows are not all pointing to the right
Service['httpd'] <- Package['httpd']
 
# must be all on one line
Service['httpd'] <-
Package['httpd']
```

### 10.5. Nested classes or defined types

Classes and defined resource types must not be defined within other classes or defined types. Classes and defined types should be declared as close to node scope as possible. If you have a class or defined type which requires another class or defined type, graceful failures must be in place if those required classes or defined types are not declared elsewhere. 


**Very Bad:**

```
    class apache {
      class ssl { ... }
    }
```

**Also Very Bad:**

```
    class apache {
      define config() { ... }
    }
```

### 10.6. Display order of parameters

In parameterized class and defined type declarations, required parameters must be listed before optional parameters (that is, parameters with defaults). Required parameters are parameters which are not set to anything, including undef. For example, parameters such as passwords or IP addresses might not have reasonable default values.

**Good:**

```
class dhcp (
  $dnsdomain,
  $nameservers,
  $default_lease_time = 3600,
  $max_lease_time     = 86400
) {}

```

**Bad:**

```
    class ntp (
      $options   = "iburst",
      $servers,
      $multicast = false
    ) {}
```

### 10.7 Parameter defaults

Adding default values to the parameters in classes and defined types makes your module easier to use. As of Puppet 4.9.0, use Hiera data in the module and rely on automatic parameter lookup for class parameters. For versions earlier than Puppet 4.9.0, use the "params.pp" pattern. In simple cases, you can also specify the default values directly in the class or defined type.

Take care to declare the data type of parameters, as this provides automatic type assertions.

**Good:**

```
# parameter defaults provided via APL > puppet 4.9.0
class my_module(
  String $source,
  String $config )  {
  # body of class
}
```

with a `hiera.yaml` in the root of the module:

```
---
version: 5
default_hierarchy: 
  - name: "defaults"
    path:   "defaults.yaml"
    data_hash: yaml_data
```

and with the file `data/defaults.yaml`:

```
mymodule::source: 'default source value'
mymodule::config: 'default config value'
```

This places the values in the defaults hierarchy, which means that the defaults are not merged into overriding values. If you want to merge the defaults into those values, change the `default_hierarchy` to `hierarchy`.

**Puppet 4.8 and earlier**:

```
# using params.pp pattern < Puppet 4.9.0
class my_module(
  String $source = $mymodule::params::source,
  String $config  = $mymodule::params::config)  {
  # body of class
}
```

### 10.8 Exported resources

Exported resources should be opt-in rather than opt-out. Your module should not be written to use exported resources to function by default unless it is expressly required. When using exported resources, you should name the property `collect_exported`.

Exported resources should be exported and collected selectively using a [search expression](https://docs.puppet.com/puppet/3.7/lang_collectors.html#search-expressions), ideally allowing user-defined tags as parameters so tags can be used to selectively collect by environment or custom fact.

**Good:**

```
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
```

## 11. Classes

### 11.1. Class inheritance

Class inheritance should not be used. Use data binding instead of params.pp pattern. Inheritance should only be used for params.pp, which is not recommended in Puppet 4.

For maintaining older modules, inheritance can be used, but must not be used across module
namespaces. Cross-module dependencies should be satisfied in a more portable way, such as with include statements or relationship declarations. Class inheritance should only be used for `myclass::params` parameter defaults. Other use cases can be accomplished through the addition of parameters or conditional logic. 


**Good:**

```
    class ssh { ... }

    class ssh::client inherits ssh { ... }

    class ssh::server inherits ssh { ... }
```

**Bad:**

```
    class ssh inherits server { ... }

    class ssh::client inherits workstation { ... }

    class wordpress inherits apache { ... }
```


### 11.2 About publicly available modules

When declaring classes in publicly available modules, you should use `include`, `contain`, or `require` rather than class resource declaration. This avoids duplicate class declarations and vendor lock-in.

## 12. Defined resource types 

### 12.1. Uniqueness

Since defined resource types can have multiple instances, resource names must have a unique variable to avoid duplicate declarations.

**Good:**

```puppet
define apache::listen {
  $listen_addr_port = $name

  # Template uses: $listen_addr_port
  concat::fragment { "Listen ${listen_addr_port}":
    ensure  => present,
    target  => $::apache::ports_file,
    content => template('apache/listen.erb'),
  }
}
```

**Bad:**

```
define apache::listen {
  # Template uses: $name
  concat::fragment { 'Listen port':
    ensure  => present,
    target  => $::apache::ports_file,
    content => template('apache/listen.erb'),
  }
}
```

## 13. Variables

## 13.1 Referencing facts

When referencing facts, prefer the `$facts` hash to plain top-scope variables (such as `$::operatingsystem`). Although plain top-scope variables are easier to write, the `$facts` hash is clearer, easier to read, and distinguishes facts from other top-scope variables.

### 13.2. Namespacing variables

When referencing top-scope variables other than facts, explicitly specify absolute namespaces for clarity and improved readability. This includes top-scope variables set by the node classifier and in the main manifest.
 
This is not necessary for:
 
* the `$facts` hash.
* the `$trusted` hash.
* the `$server_facts` hash.

These special variable names are protected; because you cannot create local variables with these names, they always refer to top-scope variables.

**Good:**

```
    $facts[::operatingsystem]
```

**Bad:**

```
    $::operatingsystem
```

**Very Bad**

```
    $operatingsystem
```

### 13.3. Variable format

When defining variables you must only use numbers, lowercase letters, and underscores. Do not use uppercased letters within a word, such as "CamelCase", as it introduces inconsistency in style. You must not use dashes, as they are not syntactically valid.

**Good:**

```
$foo_bar
$some_long_variable
$foo_bar123
```

**Bad:**

```
$fooBar
$someLongVariable
$foo-bar123
```



## 14. Conditionals

### 14.1. Keep resource declarations simple

We recommend not mixing conditionals with resource declarations. When you use conditionals for data assignment, you should separate conditional code from the resource declarations.

**Good:**

```
    $file_mode = $::operatingsystem ? {
      'debian' => '0007',
      'redhat' => '0776',
       default => '0700',
    }

    file { '/tmp/readme.txt':
      ensure  => file,
      content => "Hello World\n",
      mode    => $file_mode,
    }
```

**Bad:**

```
    file { '/tmp/readme.txt':
      ensure  => file,
      content => "Hello World\n",
      mode    => $::operatingsystem ? {
        'debian' => '0777',
        'redhat' => '0776',
        default  => '0700',
      }
    }
```

### 14.2. Defaults for case statements and selectors

Case statements must have default cases. If you want the default case to be "do nothing," you must include it as an explicit `default: {}` for clarity's sake.

Case and selector values must be quoted.

Selectors should omit default selections only if you explicitly want catalog compilation to fail when no value matches.


**Good:**

```
    case $::operatingsystem {
      'centos': {
        $version = '1.2.3'
      }
      'solaris': {
        $version = '3.2.1'
      }
      default: {
        fail("Module ${module_name} is not supported on ${::operatingsystem}")
      }
    }
```

When setting the default case, keep in mind that the default case should cause the catalog compilation to fail if the resulting behavior cannot be predicted on the platforms the module was built to be used on.

## 15. Hiera

You should avoid using calls to Hiera functions in modules meant for public consumption, because not all users have implemented Hiera. Instead, we recommend using parameters that can be overridden with Hiera.

## 16. Examples

Major use cases for your module should have corresponding example manifests in the module's /examples directory.

    modulepath/apache/examples/{usecase}.pp

The example manifest should provide a clear example of how to declare the class or defined resource type. The example manifest should also declare any classes required by the corresponding class to ensure `puppet apply` works in a limited, standalone manner.

## 17. Module documentation

All publicly available modules should include the documentation covered below.

### 17.1 README

Your module should have a README in .md (or .markdown) format. READMEs help users of your module get the full benefit of your work. The [Puppet README template](https://docs.puppet.com/puppet/latest/READMEtemplate.txt) offers a basic format you can use. If you create modules with `puppet module generate`, the generated README includes the template. Using the .md/.markdown format allows your README to be parsed and displayed by Puppet Strings, GitHub, and the Puppet Forge.

There's an entire [guide](https://docs.puppet.com/puppet/latest/modules_documentation.html) to writing a great README, but overall your README should:

* Summarize what your module does.
* Note any setup requirements or limitations (such as "This module requires the puppetlabs-apache module and only works on Ubuntu.").
* Note any part of a user's system the module might impact (for example, "This module overwrites everything in animportantfile.conf.").
* Describe how to customize and configure the module.
* Include usage examples and code samples for the common use cases for your module.

### 17.2 Documenting Puppet code

Use [Puppet Strings](https://github.com/puppetlabs/puppet-strings) code comments to document your Puppet classes, defined types, functions, and resource types and providers. Strings processes the README and comments from your code into HTML or JSON format documentation. This allows you and your users to generate detailed documentation for your module.

Include comments for each element (classes, functions, defined types, parameters, and so on) in your module. If used, comments must precede the code for that element. See [Puppet Strings](https://github.com/puppetlabs/puppet-strings) documentation for details on usage, installation, and correctly writing documentation comments. Comments should contain the following information, arranged in this order:

* A description giving an overview of what the element does.
* Any additional information about valid values that is not clear from the data type. (For example, if the data type is [String], but the value must be a path.)
* The default value, if any for that element.

Multiline descriptions must be uniformly indented by at least one space.

For example:

```puppet
# @param config_epp Specifies a file to act as a EPP template for the config file.
#  Valid options: a path (absolute, or relative to the module path). Example value: 
#  'ntp/ntp.conf.epp'. A validation error is thrown if you supply both this param **and**
#  the `config_template` param.
```


If you do not include Strings code comments, you should include a Reference section in your README with a complete list of all classes, types, providers, defined types, and parameters that the user can configure. Include a brief description, the valid options, and the default values (if any).

### 17.2 CHANGELOG

Your module should have a CHANGELOG in .md (or .markdown) format. Your CHANGELOG should: 

* Have entries for each release. 
* List bugfixes and features included in the release. 
* Specifically call out backwards-incompatible changes

## 18. Verification and testing

We recommend [puppet-lint](http://puppet-lint.com/) and [metadata-json-lint](https://github.com/voxpupuli/metadata-json-lint) for checking your module's style compliance. For testing your module, we recommend rspec. See [rspec-puppet](https://github.com/rodjek/rspec-puppet/#rspec-tests-for-your-puppet-manifests--modules) for information on writing rspec tests for Puppet.

