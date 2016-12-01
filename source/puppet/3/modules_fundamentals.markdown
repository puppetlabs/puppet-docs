---
layout: default
title: "Module Fundamentals"
canonical: "/puppet/latest/reference/modules_fundamentals.html"
---

[modulepath]: /puppet/latest/reference/configuration.html#modulepath
[installing]: ./modules_installing.html
[publishing]: ./modules_publishing.html
[documentation]: ./modules_documentation.html

[plugins]: /guides/plugins_in_modules.html

[classes]: ./lang_classes.html
[defined_types]: ./lang_defined_types.html
[enc]: /guides/external_nodes.html
[conf]: ./config_file_main.html
[environment]: /puppet/latest/reference/environments_classic.html
[templates]: /guides/templating.html

**Modules** are self-contained bundles of code and data. You can write your own modules or you can download pre-built modules from Puppet Labs' online collection, the Puppet Forge.

**Nearly all Puppet manifests belong in modules.** The sole exception is the main `site.pp` manifest, which contains site-wide and node-specific code.

**Every Puppet user should expect to write at least some of their own modules.**

* Continue reading to learn how to write and use Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Publishing Modules"][publishing] for how to publish your modules to the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.

## Using Modules

**Modules are how Puppet finds the classes and types it can use** --- it automatically loads any [class][classes] or [defined type][defined_types] stored in its modules. Within a manifest or from an [external node classifier (ENC)][enc], any of these classes or types can be declared by name:

~~~ ruby
# /etc/puppet/manifests/site.pp

node default {
  include apache

  class {'ntp':
    enable => false;
  }

  apache::vhost {'personal_site':
    port    => 80,
    docroot => '/var/www/personal',
    options => 'Indexes MultiViews',
  }
}
~~~

Likewise, Puppet can automatically load plugins (like custom native resource types or custom facts) from modules; see ["Using Plugins"][plugins] for more details.

To make a module available to Puppet, **place it in one of the directories in Puppet's [modulepath][].**

> ### The Modulepath
>
> **Note:** The `modulepath` is a list of directories separated by the system path-separator character. On 'nix systems, this is the colon (:), while Windows uses the semi-colon (;). The most common default modulepaths are:
>
> * `/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules` (for Puppet Enterprise)
> * `/etc/puppet/modules:/usr/share/puppet/modules` (for open source Puppet)
>
> Use `puppet config print modulepath` to see your currently configured modulepath.
>
>  If you want both puppet master and puppet apply to have access to the modules, set the modulepath in [puppet.conf][conf] to go to the `[main]` block. Modulepath is also one of the settings that can be different per [environment][].

You can easily install modules written by other users with the `puppet module` subcommand. [See "Installing Modules"][installing] for details.

## Module Layout

On disk, a module is simply **a directory tree with a specific, predictable structure:**

* MODULE NAME
    * manifests
    * files
    * templates
    * lib
    * tests
    * spec

### Example

This example module, named "`my_module`," shows the standard module layout in more detail:

* `my_module` --- This outermost directory's name matches the name of the module.
    * `manifests/` --- Contains all of the manifests in the module.
        * `init.pp` --- Contains a class definition. **This class's name must match the module's name.**
        * `other_class.pp` --- Contains a class named **`my_module::other_class`.**
        * `my_defined_type.pp` --- Contains a defined type named **`my_module::my_defined_type`.**
        * `implementation/` --- This directory's name affects the class names beneath it.
            * `foo.pp` --- Contains a class named **`my_module::implementation::foo`.**
            * `bar.pp` --- Contains a class named **`my_module::implementation::bar`.**
    * `files/` --- Contains static files, which managed nodes can download.
        * `service.conf` --- This file's URL would be **`puppet:///modules/my_module/service.conf`.**
    * `lib/` --- Contains plugins, like custom facts and custom resource types. See ["Using Plugins"][plugins] for more details.
    * `templates/` --- Contains templates, which the module's manifests can use. See ["Templates"][templates] for more details.
        * `component.erb` --- A manifest can render this template with `template('my_module/component.erb')`.
    * `tests/` --- Contains examples showing how to declare the module's classes and defined types.
        * `init.pp`
        * `other_class.pp` --- Each class or type should have an example in the tests directory.
    * `spec/` --- Contains spec tests for any plugins in the lib directory.

Each of the module's subdirectories has a specific function, as follows.

### Manifests

**Each manifest in a module's `manifests` folder should contain one class or defined type.** The file names of manifests **map predictably** to the names of the classes and defined types they contain.

`init.pp` is special and **always contains a class with the same name as the module.**

Every other manifest contains a class or defined type named as follows:

Name of module | :: | Other directories:: (if any) | Name of file (no extension)
---------------|----|------------------------------|----------------------------
 `my_module`   |`::`|                              | `other_class`
 `my_module`   |`::`|    `implementation::`        |     `foo`

Thus:

* `my_module::other_class` would be in the file `my_module/manifests/other_class.pp`
* `my_module::implementation::foo` would be in the file `my_module/manifests/implementation/foo.pp`

The double colon that divides the sections of a class's name is called the **namespace separator.**

### Allowed Module Names

Module names should only contain **lowercase letters, numbers, and underscores,** and should **begin with a lowercase letter;** that is, they should match the expression `[a-z][a-z0-9_]*`. Note that these are the same restrictions that apply to class names, but with the added restriction that module names cannot contain the namespace separator (`::`) as modules cannot be nested.

Although some names that violate these restrictions currently work, using them is not recommended.

Certain module names are disallowed:

* main
* settings

### Files

Files in a module's `files` directory are automatically served to agent nodes. They can be downloaded by using **puppet:/// URLs** in the `source` attribute of a [`file`][file] resource.

Puppet URLs work transparently in both agent/master mode and standalone mode; in either case, they will retrieve the correct file from a module.

[file]: /puppet/latest/reference/type.html#file

Puppet URLs are formatted as follows:

 Protocol | 3 slashes | "Modules"/ | Name of module/ |  Name of file
----------|-----------|------------|-----------------|---------------
`puppet:` |   `///`   | `modules/` |   `my_module/`  | `service.conf`

So `puppet:///modules/my_module/service.conf` would map to `my_module/files/service.conf`.

### Templates

Any ERB template (see ["Templates"][templates] for more details) can be rendered in a manifest with the `template` function. The output of the template is a simple string, which can be used as the content attribute of a [`file`][file] resource or as the value of a variable.

**The template function can look up templates identified by shorthand:**

Template function | (' | Name of module/ | Name of template | ')
------------------|----|-----------------|------------------|----
    `template`    |`('`|   `my_module/`  | `component.erb`  |`')`

So `template('my_module/component.erb')` would render the template `my_module/templates/component.erb`.

## Writing Modules

To write a module, simply write classes and defined types and place them in properly named manifest files as described above.

* [See here][classes] for more information on classes
* [See here][defined_types] for more information on defined types

## Best Practices

The [classes][], [defined types][defined_types], and [plugins][] in a module **should all be related,** and the module should aim to be **as self-contained as possible.**

Manifests in one module should never reference files or templates stored in another module.

Be wary of having classes declare classes from other modules, as this makes modules harder to redistribute. When possible, it's best to isolate "super-classes" that declare many other classes in a local "site" module.
