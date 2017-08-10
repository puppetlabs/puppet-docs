---
layout: default
title: "Module fundamentals"
---

[modulepath]: ./dirs_modulepath.html
[installing]: ./modules_installing.html
[publishing]: ./modules_publishing.html
[documentation]: ./modules_documentation.html

[plugins]: ./plugins_in_modules.html

[external facts]: {{facter}}/custom_facts.html#external-facts
[custom facts]: {{facter}}/custom_facts.html
[classes]: ./lang_classes.html
[defined_types]: ./lang_defined_types.html
[enc]: ./nodes_external.html
[environment]: ./environments.html
[templates]: ./lang_template.html
[forge]: http://forge.puppetlabs.com
[file_function]: ./function.html#file
[reserved names]: ./lang_reserved.html
[pdk]: {{pdk}}/pdk.html

Modules are self-contained bundles of code and data. These reusable, shareable units of Puppet code are a basic building block for Puppet.

Nearly all Puppet manifests belong in modules. The sole exception is the main `site.pp` manifest, which contains site-wide and node-specific code.

Every Puppet user should expect to write at least some of their own modules. You can also download modules that other users have built from the Puppet Forge.

Related topics:

* [Installing modules][installing]: How to install pre-built modules from the Puppet Forge.
* [Publishing modules][publishing]: How to publish your modules to the Puppet Forge.
* [Using plug-ins][plugins]: How to arrange plug-ins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [Documenting modules][documentation]: A module README template and information on providing directions for your module.
* [Puppet Development Kit][pdk]: A package of development and testing tools to help you create great modules.

{:.concept}
## Using modules

Puppet uses modules to find the classes and types it can use --- it automatically loads any class or defined type stored in its modules.

Any of these classes or defined types can be declared by name within a manifest or from an external node classifier (ENC).

``` puppet
# /etc/puppetlabs/code/environments/production/manifests/site.pp

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
```

Likewise, Puppet can automatically load plug-ins (like custom native resource types or custom facts) from modules. See the related topic about using plug-ins for more details.

To make a module available to Puppet, place it in one of the directories in Puppet's [modulepath][], and make sure it has a [valid name](#allowed-module-names).

You can install modules written by other users with the `puppet module` subcommand. [See  the related topic about installing modules for details.

Related topics:

* [Classes][classes]
* [Defined types][defined_types]
* [Installing Modules][installing]
* [External node classifiers (ENC)][enc]
* [Using plug-ins][plugins]

{:.concept}
## Module layout

On disk, a module is a directory tree with a specific, predictable structure:

* `<MODULE NAME>`
    * `manifests`
    * `files`
    * `templates`
    * `lib`
    * `facts.d`
    * `examples`
    * `spec`
    * `functions`
    * `types`

{:.example}
### Example

This example module, `my_module`, shows the standard module layout in more detail:

* `my_module` --- This outermost directory's name matches the name of the module.
    * `manifests/` --- Contains all of the manifests in the module.
        * `init.pp` --- Contains a class definition. **This class's name must match the module's name.**
        * `other_class.pp` --- Contains a class named `my_module::other_class`.
        * `my_defined_type.pp` --- Contains a defined type named `my_module::my_defined_type`.
        * `implementation/` --- This directory's name affects the class names beneath it.
            * `foo.pp` --- Contains a class named `my_module::implementation::foo`.
            * `bar.pp` --- Contains a class named `my_module::implementation::bar`.
    * `files/` --- Contains static files, which managed nodes can download.
        * `service.conf` --- This file's `source =>` URL would be `puppet:///modules/my_module/service.conf`. Its contents can also be accessed with the `file` function, like `content => file('my_module/service.conf')`.
    * `lib/` --- Contains plug-ins, like custom facts and custom resource types. These are used by both the Puppet master server and the Puppet agent service, and they are synced to all agent nodes whenever they request their configurations.
    * `facts.d/` --- Contains [external facts][], which are an alternative to Ruby-based [custom facts][]. These will be synced to all agent nodes, so they can submit values for those facts to the Puppet master. (Requires Facter 2.0.1 or later.)
    * `templates/` --- Contains templates, which the module's manifests can use. See ["Templates"][templates] for more details.
        * `component.erb` --- A manifest can render this template with `template('my_module/component.erb')`.
        * `component.epp` --- A manifest can render this template with `epp('my_module/component.epp')`.
    * `examples/` --- Contains examples showing how to declare the module's classes and defined types.
        * `init.pp`
        * `other_example.pp` --- Major use cases should have an example.
    * `spec/` --- Contains spec tests for any plug-ins in the lib directory.
    * `functions/` --- Contains custom functions written in the Puppet language.
    * `types/` --- Contains type aliases.

Each of the module's subdirectories has a specific function.

{:.section}
### Manifests

Each manifest in a module's `manifests` folder should contain one class or defined type. The file names of manifests map predictably to the names of the classes and defined types they contain.

The `init.pp` manifest is special and always contains a class with the same name as the module. You cannot have a class named `init`.

Every other manifest contains a class or defined type named as follows:

Name of module | :: | Other directories:: (if any) | Name of file (no extension)
---------------|----|------------------------------|----------------------------
 `my_module`   |`::`|                              | `other_class`
 `my_module`   |`::`|    `implementation::`        |     `foo`

Thus:

* `my_module::other_class` would be in the file `my_module/manifests/other_class.pp`
* `my_module::implementation::foo` would be in the file `my_module/manifests/implementation/foo.pp`

The double colon that divides the sections of a class's name is called the *namespace separator.*

{:.section}
### Allowed module names

Module names should only contain lowercase letters, numbers, and underscores, and should begin with a lowercase letter.

That is, module names should match the expression `[a-z][a-z0-9_]*`. Note that these are the same restrictions that apply to class names, but with the added restriction that module names cannot contain the namespace separator (`::`) as modules cannot be nested.

Certain module names are disallowed; see the list of [reserved words and names][reserved names].

{:.section}
### Files in modules

Files in a module's `files` directory can be served to agent nodes. They can be downloaded by using `puppet:///` URLs in the `source` attribute of a [`file`][file] resource.

You can also access module files with [the `file` function][file_function]. This function takes a `<MODULE NAME>/<FILE NAME>` reference and returns the content of the requested file from the module's `files` directory.

Puppet URLs work transparently in both agent/master mode and standalone mode; in either case, they will retrieve the correct file from a module.

[file]: ./type.html#file

Puppet URLs are formatted as follows:

 Protocol | 3 slashes | "Modules"/ | Name of module/ |  Name of file
----------|-----------|------------|-----------------|---------------
`puppet:` |   `///`   | `modules/` |   `my_module/`  | `service.conf`

So `puppet:///modules/my_module/service.conf` would map to `my_module/files/service.conf`.

{:.section}
### Templates in modules

Any ERB or EPP template (see ["Templates"][templates] for more details) can be rendered in a manifest.

For ERB templates, which use Ruby, use the `template` function. For EPP templates, which use the Puppet language, use the `epp` function. The output of the template is a string, which can be used as the content attribute of a `file` resource or as the value of a variable.

The `template` and `epp` functions can look up templates identified by shorthand:

Template function | (' | Name of module/ | Name of template | ')
------------------|----|-----------------|------------------|----
    `template`    |`('`|   `my_module/`  | `component.erb`  |`')`
    `epp`         |`('`|   `my_module/`  | `component.epp`  |`')`

So `template('my_module/component.erb')` would render the template `my_module/templates/component.erb`, and `epp('my_module/component.epp')` would render `my_module/templates/component.epp`.

{:.concept}
## Writing modules

Modules must have a specific directory structure and include a `metadata.json` file. You can write a module manually, but it's usually easier to use either the Puppet Development Kit or the built-in `puppet module generate` command.

The Puppet Development Kit includes key development and testing tools, including a complete module skeleton and a command line tools to help you create, validate, and run unit tests on modules. PDK also includes all dependencies needed for its use. To get started with PDK, see the PDK documentation.

Puppet's built-in `puppet module generate` command can generate a basic module skeleton. To use the `puppet module generate` command, specify the full name of the module, in the format `username-modulename`. For example,`puppet module generate <USERNAME>-<MODULE NAME>.`

Both PDK and the `puppet module generate` command ask for metadata information to create a `metadata.json` file. You should have the following information ready:

* Your Puppet Forge username. If you don't have a Forge account, you can accept the default value for this question. If you create a Forge account later, edit the module metadata manually with the correct value. 
* Module version. We use and recommend semantic versioning for modules.
* The module author's name.
* The license under which your module is made available. This should be an identifier from [SPDX License List](https://spdx.org/licenses/).
* A one-sentence summary about your module.
* The URL to your module's source code repository, so that other users can contribute back to your module.
* The URL to a web site that offers full information about your module, if you have one..
* The URL to the public bug tracker for your module, if you have one.

Alternatively, you can manually write classes and defined types, placing them in properly named manifest files. However, if you take this route, you **must** ensure that your `metadata.json` file is properly formatted or your module **will not work**.

For help getting started writing your module, see our Beginner's guide to writing modules. For details on best practices and code style, see the Puppet Language Style Guide.

Related topics:

* [Classes][classes]
* [Defined types][defined_types]
* [Beginner's guide to writing modules](./bgtm.html)
* [Puppet Language Style Guide](./style_guide.html)
* [Puppet Development Kit][pdk]

