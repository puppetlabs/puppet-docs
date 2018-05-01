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
[declare]: {{puppet}}/lang_classes.html#declaring-classes


Modules are self-contained bundles of code and data with a specific directory structure. These reusable, shareable units of Puppet code are a basic building block for Puppet.

Modules must have a [valid name](#module-names) and be located in [modulepath][modulepath]. Puppet automatically loads all content from every module in the modulepath, making classes, defined types, and plug-ins (such as custom types or facts) available. To learn more about how to classes, defined types, and plug-ins, see the related topics.

You can download and install modules written by Puppet or the Puppet community from the Puppet Forge. Every Puppet user should also expect to write at least some of their own modules.


Related topics:

* [Installing modules][installing]
* [The Forge][forge]
* [Classes][classes]
* [Defined types][defined_types]
* [Module plug-ins][plugins]
* [Declaring classes and defined types][declare]
* [External node classifiers (ENC)][enc]
* [Using plug-ins][plugins]


{:.concept}
## Module structure

Modules have a specific directory structure that allows Puppet to find and automatically load classes, defined types, facts, custom types and providers, functions, and tasks. 

Modules must have a [valid name][module-names] and be installed in Puppet's [modulepath][]. You'll install modules with either the `puppet module` command or, if you're using code management, with a Puppetfile. See the related topic about installing modules for details.

Each module subdirectory has a specific function. Not all directories are required, but if used, they should be in the following structure.

* `<MODULE NAME>`
    * `manifests`
    * `files`
    * `templates`
    * `lib`
      * `facter`
      * `puppet`
        * `functions`
        * `parser/functions`
        * `type`
        * `provider`
    * `facts.d`
    * `examples`
    * `spec`
    * `functions`
    * `types`
    * `tasks`

Related topics: 

* [Classes][classes]
* [Defined types][defined_types]
* [Type aliases](./lang_type_aliases.html)

{:.example}
### Example

This example module, `my_module`, shows the standard module layout in more detail.

* `my_module`: The main module directory's name matches the name of the module.
    * `manifests/`: Contains all of the manifests in the module.
        * `init.pp`: Contains a class definition. The `init.pp` class, if used, is the main class of the module. This class's name must match the module's name.
        * `other_class.pp`: Contains a class named `my_module::other_class`.
        * `my_defined_type.pp`: Contains a defined type named `my_module::my_defined_type`.
        * `implementation/`: This directory's name affects the class names beneath it.
            * `foo.pp`: Contains a class named `my_module::implementation::foo`.
            * `bar.pp`: Contains a class named `my_module::implementation::bar`.
    * `files/`: Contains static files, which managed nodes can download.
        * `service.conf`: This file's `source =>` URL would be `puppet:///modules/my_module/service.conf`. Its contents can also be accessed with the `file` function: `content => file('my_module/service.conf')`.
    * `lib/`: Contains plug-ins, such as custom facts and custom resource types. These are used by both the Puppet master and the Puppet agent, and they are synced to all agent nodes in the environment on each Puppet run.
      * `facter`: Contains custom facts, written in Ruby.
      * `puppet`
        * `functions`: Contains functions written in Ruby for the modern `Puppet::Functions` API.
        * `parser/functions`: Contains functions written in Ruby for the legacy `Puppet::Parser::Functions` API.
        * `type` : Contains custom resource types written in the Puppet language.
        * `provider`: Contains custom resource providers written in the Puppet language.
    * `facts.d/`: Contains external facts, which are an alternative to Ruby-based custom facts. These are synced to all agent nodes, so they can submit values for those facts to the Puppet master.
    * `templates/`: Contains templates, which the module's manifests can use.
        * `component.erb`: A manifest can render this template with `template('my_module/component.erb')`.
        * `component.epp`: A manifest can render this template with `epp('my_module/component.epp')`.
    * `examples/`: Contains examples showing how to declare the module's classes and defined types.
        * `init.pp`
        * `other_example.pp`: Major use cases should have an example.
    * `spec/`: Contains spec tests for any plug-ins in the `lib` directory.
    * `functions`: Contains custom functions written in the Puppet language.
    * `types`: Contains resource type aliases.
    * `tasks`: Contains Puppet tasks, written in any language.

{:.section}
### Module names

Module names should contain only lowercase letters, numbers, and underscores, and should begin with a lowercase letter.

That is, module names should match the expression `[a-z][a-z0-9_]*`. Note that these are the same restrictions that apply to class names, but with the added restriction that module names cannot contain the namespace separator (`::`), because modules cannot be nested.

Certain module names are disallowed; see the list of [reserved words and names][reserved names].

{:.section}
### Manifests

Each manifest in a module's `manifests` folder should contain only one class or defined type. The file names of manifests map predictably to the names of the classes and defined types they contain.

The `init.pp` manifest is special and always contains a class with the same name as the module. You cannot name a class `init`.

Every other manifest contains a class or defined type named as follows:

Name of module | :: | Other directories:: (if any) | Name of file (no extension)
---------------|----|------------------------------|----------------------------
 `my_module`   |`::`|                              | `other_class`
 `my_module`   |`::`|    `implementation::`        |     `foo`

Thus:

* `my_module::other_class` is in the file `my_module/manifests/other_class.pp`
* `my_module::implementation::foo` is in the file `my_module/manifests/implementation/foo.pp`

The double colon that divides the sections of a class's name is called the *namespace separator.*

{:.section}
### Files in modules

You can serve files in a module's `files` directory to agent nodes.

Download files by using `puppet:///` URLs in the `source` attribute of a [`file`][file] resource. You can also access module files with [the `file` function][file_function]. This function takes a `<MODULE NAME>/<FILE NAME>` reference and returns the content of the requested file from the module's `files` directory.

Puppet URLs work the same for both `puppet agent` and `puppet apply`; in either case they retrieve the correct file from a module.

[file]: ./type.html#file

Puppet URLs are formatted as follows:

 Protocol | 3 slashes | "Modules"/ | Name of module/ |  Name of file
----------|-----------|------------|-----------------|---------------
`puppet:` |   `///`   | `modules/` |   `my_module/`  | `service.conf`

So `puppet:///modules/my_module/service.conf` would map to `my_module/files/service.conf`.

{:.section}
### Templates in modules

Any ERB or EPP template can be rendered in a manifest. Templates combine code, data, and literal text to produce a final rendered output. The template output is a string, which can be used as the content attribute of a `file` resource or as the value of a variable.

For ERB templates, which use Ruby, use the `template` function. For EPP templates, which use the Puppet language, use the `epp` function. See [templates][templates] for detailed information.

The `template` and `epp` functions can look up templates identified by shorthand:

Template function | (' | Name of module/ | Name of template | ')
------------------|----|-----------------|------------------|----
    `template`    |`('`|   `my_module/`  | `component.erb`  |`')`
    `epp`         |`('`|   `my_module/`  | `component.epp`  |`')`

So `template('my_module/component.erb')` renders the template `my_module/templates/component.erb`, and `epp('my_module/component.epp')` renders `my_module/templates/component.epp`.

See the [templates][templates] topic for more details.

{:.concept}
## Writing modules

Every Puppet user should expect to write at least some of their own modules. Modules must have a specific directory structure and include correctly formatted metadata. The Puppet Development Kit provides tools for writing, validating, and testing modules.

Puppet Development Kit creates a complete module skeleton and includes command line tools for creating classes, defined types, and tasks in your module.

To test your modules, use PDK to run unit tests and to validate your module's metadata, syntax, and style. 

PDK can be downloaded and installed on any development machine; a Puppet installation is not required. See the PDK documentation to get started.

> **Note:** The `puppet module generate` command is deprecated and will be removed in a future version of Puppet.

For help getting started writing modules, see our Beginner's guide to writing modules. For details on best practices and code style, see the Puppet Language Style Guide.

Related topics:

* [Puppet Development Kit][pdk]: A package of development and testing tools to help you create great modules.
* [Beginner's guide to writing modules](./bgtm.html)
* [Puppet Language Style Guide](./style_guide.html)
* [Publishing modules][publishing]
* [Documenting modules][documentation]

