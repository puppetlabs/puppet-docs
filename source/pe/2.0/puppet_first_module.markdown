---
layout: default
title: "PE 2.0 » Puppet » Your First Module"
canonical: "/pe/latest/quick_writing_nix.html"
---

* * *

&larr; [Puppet: Overview](./puppet_overview.html) --- [Index](./) --- [Puppet: Assigning a Class to a Node](./puppet_classifying.html) &rarr;

* * *

Puppet For New Users: Your First Module
=====

Where Modules Live
-----

All of your modules belong in `/etc/puppetlabs/puppet/modules`. Puppet Enterprise's built-in modules are stored in `/opt/puppet/share/puppet/modules`.

Module Structure
-----

Modules are directory trees that look like this:

- `core_permissions/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `core_permissions` class)
        - `webserver.pp` (contains the `core_permissions::webserver` class)

File names map to class names in a predictable way: `init.pp` will contain a class with the same name as the module, `<NAME>.pp` will contain a class called `<MODULE NAME>::<NAME>`, and `<NAME>/<OTHER NAME>.pp` will contain `<MODULE NAME>::<NAME>::<OTHER NAME>`. [See here for more about the rules for autoloading classes](/learning/modules1.html#manifests-namespacing-and-autoloading).

Modules can use directories other than `manifests` to do many interesting things, but your first one doesn't need them.

Class Structure
-----

Manifests in a module should contain [class definitions](/learning/modules1.html#classes). Class definitions in the Puppet language look like this:

~~~ ruby
    class core_permissions {
      # Comment
      ... resource declarations ...
    }
~~~

Resource Declarations
-----

Classes should contain [resource declarations](/learning/manifests.html#resource-declarations), which look like this:

~~~ ruby
    file {'/etc/fstab':
      ensure => present,
      mode   => 0644,
      owner  => 'root',
      group  => 'root',
    }
~~~

Resources have: 

* A **type** ("file")
* A **title** ("/etc/fstab")
* ...and a series of **attribute** ("mode") / **value** ("0644") pairs.

Note especially:

* The colon after the title
* The comma after each attribute/value pair

...as resource declarations will break without them.

Every resource type also has one attribute (called the "namevar") that will default to the title; with the file type, the namevar is "path." See the [core types cheat sheet](/puppet_core_types_cheatsheet.pdf) for a quick reference to the most common resource types. 

Your First Complete Module
-----

To put it all together, here's how to make your first module:

    # mkdir -p /etc/puppetlabs/puppet/modules/core_permissions/manifests
    # vi /etc/puppetlabs/puppet/modules/core_permissions/manifests/init.pp

Paste the following code into the `init.pp` file:

~~~ ruby
    class core_permissions {
      file {'/etc/fstab':
        ensure => present,
        mode   => 0644,
        owner  => 'root',
        group  => 'root',
      }
      
      file {'/etc/passwd':
        ensure => present,
        mode   => 0644,
        owner  => 'root',
        group  => 'root',
      }
      
      file {'/etc/crontab':
        ensure => present,
        mode   => 0644,
        owner  => 'root',
        group  => 'root',
      }
    }
~~~

This creates a class called `core_permissions`, which manages the ownership and mode of three important files. On any that node that has this class applied to it, an accidental or malicious change in these files' permissions would be **reverted to the specified state within the next half-hour,** and a report of the change would appear on that node's page in the console.

Remember that creating the module won't automatically assign the class to any nodes --- it just makes the class available.

* * *

&larr; [Puppet: Overview](./puppet_overview.html) --- [Index](./) --- [Puppet: Assigning a Class to a Node](./puppet_classifying.html) &rarr;

* * *

