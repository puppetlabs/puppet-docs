---
layout: default
title: "Future Module Fundamentals"
canonical: "/puppet/latest/reference/future_modules_fundamentals.html"
---

[modulepath]: ./dirs_modulepath.html
[installing]: ./modules_installing.html
[publishing]: ./modules_publishing.html
<!-- {% comment %} The below needs to be forked to a future version since documentation
process and tags has changed with the introduction of Puppet Strings {% endcomment %} -->
[documentation]: ./modules_documentation.html
<!-- {% comment %} The one below will get renamed to "using plugins" when we revise and move it into place. {% endcomment %} -->
[plugins]: /guides/plugins_in_modules.html

[external facts]: /facter/latest/custom_facts.html#external-facts
[custom facts]: /facter/latest/custom_facts.html
[classes]: ./lang_classes.html
[defined_types]: ./lang_defined_types.html
[enc]: /guides/external_nodes.html
[environment]: ./environments.html
[templates]: /guides/templating.html
[forge]: http://forge.puppetlabs.com
[file_function]: /references/3.7.latest/function.html#file

<!-- Information about 4x functions, and support for data in modules and environments is missing.
  -->
Puppet Modules
=====

**Modules** are self-contained bundles of code and data. You can write your own modules or you can download pre-built modules from [the Puppet Forge][forge].

**Nearly all Puppet manifests belong in modules.** The sole exception is the main `site.pp` manifest, which contains site-wide and node-specific code.

**Every Puppet user should expect to write at least some of their own modules.**

* Continue reading to learn how to write and use Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from [the Puppet Forge][forge].
* [See "Publishing Modules"][publishing] for how to publish your modules to the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.

Using Modules
-----

**Modules are how Puppet finds the classes and types it can use** --- it automatically loads any [class][classes] or [defined type][defined_types] stored in its modules. Within a manifest or from an [external node classifier (ENC)][enc], any of these classes or types can be declared by name:

{% highlight ruby %}
    # /etc/puppetlabs/puppet/site.pp

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
{% endhighlight %}

Likewise, Puppet can automatically load plugins (like custom native resource types or custom facts) from modules; see ["Using Plugins"][plugins] for more details.

To make a module available to Puppet, **place it in one of the directories in Puppet's [modulepath][].**

You can easily install modules written by other users with the `puppet module` subcommand. [See "Installing Modules"][installing] for details.


Module Layout
-----

On disk, a module is simply **a directory tree with a specific, predictable structure:**

* `<MODULE NAME>`
    * `manifests`
    * `files`
    * `templates`
    * `lib`
    * `facts.d`
    * `tests`
    * `spec`


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
        * `service.conf` --- This file's `source =>` URL would be **`puppet:///modules/my_module/service.conf`.** Its contents can also be accessed with the `file` function, like `content => file('my_module/service.conf')`.
    * `lib/` --- Contains plugins, like [custom facts][] and custom resource types. These will be used by both the puppet master server and the puppet agent service, and they'll be synced to all agent nodes whenever they request their configurations. See ["Using Plugins"][plugins] for more details.
    * `facts.d/` --- Contains [external facts][], which are an alternative to Ruby-based [custom facts][]. These will be synced to all agent nodes, so they can submit values for those facts to the puppet master. (Requires Facter 2.0.1 or later.)
    * `templates/` --- Contains templates, which the module's manifests can use. See ["Templates"][templates] for more details.
        * `component.erb` --- A manifest can render this template with `template('my_module/component.erb')`.
        * `component.epp` --- A manifest can render this template with `epp('my_module/component.epp')`.

    * `tests/` --- Contains examples showing how to declare the module's classes and defined types.
        * `init.pp`
        * `other_class.pp` --- Each class or type should have an example in the tests directory.
    * `spec/` --- Contains spec tests for any plugins in the lib directory.

Each of the module's subdirectories has a specific function, as follows.

### Manifests

**Each manifest in a module's `manifests` folder should contain one class or defined type.** The file names of manifests **map predictably** to the names of the classes and defined types they contain.

`init.pp` is special and **always contains a class with the same name as the module. You may not have a class named init.**

Every other manifest contains a class or defined type named as follows:

Name of module | :: | Other directories:: (if any) | Name of file (no extension)
---------------|----|------------------------------|----------------------------
 `my_module`   |`::`|                              | `other_class`
 `my_module`   |`::`|    `implementation::`        |     `foo`

Thus:

* `my_module::other_class` would be in the file `my_module/manifests/other_class.pp`
* `my_module::implementation::foo` would be in the file `my_module/manifests/implementation/foo.pp`

The double colon that divides the sections of a class's name is called the **namespace separator.**

### Autoloading Details

While it is recommended to have each named class or defined type in a separate file, it is possible to autoload them by including them in a manifest autoloaded for one of its parent namespaces.

{% highlight ruby %}
    # /etc/puppetlabs/puppet/site.pp

    node default {
      include my_module::abc::def
    }
    
    # my_module/abc.pp
    class my_module::abc {
      class def {
        notify { 'I am mymodule::abc::def': }
      }
    }
{% endhighlight %}


### Allowed Module Names

Module names should only contain **lowercase letters, numbers, and underscores,** and should **begin with a lowercase letter;** that is, they should match the expression `[a-z][a-z0-9_]*`. Note that these are the same restrictions that apply to class names, but with the added restriction that module names cannot contain the namespace separator (`::`) as modules cannot be nested.

Although some names that violate these restrictions currently work, using them is not recommended.

Certain module names are disallowed:

* main
* settings


### Files

Files in a module's `files` directory can be served to agent nodes. They can be downloaded by using **puppet:/// URLs** in the `source` attribute of a [`file`][file] resource.

You can also access module files with [the `file` function][file_function]. This function takes a `<MODULE NAME>/<FILE NAME>` reference, and returns the content of the requested file from the module's `files` directory.

Puppet URLs work transparently in both agent/master mode and standalone mode; in either case, they will retrieve the correct file from a module.

[file]: /references/stable/type.html#file

Puppet URLs are formatted as follows:

 Protocol | 3 slashes | "Modules"/ | Name of module/ |  Name of file
----------|-----------|------------|-----------------|---------------
`puppet:` |   `///`   | `modules/` |   `my_module/`  | `service.conf`

So `puppet:///modules/my_module/service.conf` would map to `my_module/files/service.conf`.

### Templates

Any ERB or EPP template (see ["Templates"][templates] for more details) can be rendered in a manifest with the `template` function for ERB templates (written in Ruby), and the `epp` function
for EPP templates (written in the Puppet Language). The output of the template is a simple string, which can be used as the content attribute of a [`file`][file] resource or as the value of a variable.

**The template and app functions can look up templates identified by shorthand:**

Template function | (' | Name of module/ | Name of template | ')
------------------|----|-----------------|------------------|----
    `template`    |`('`|   `my_module/`  | `component.erb`  |`')`
    `epp`         |`('`|   `my_module/`  | `component.epp`  |`')`

So `template('my_module/component.erb')` would render the template `my_module/templates/component.erb`, and `epp(mymodule/component.epp)` would render `component.epp`.


Writing Modules
-----

To write a module, we strongly suggest running `puppet module generate <USERNAME>-<MODULE NAME>`.

When you run the above command, the puppet module tool (PMT) will run a series of questions to gather metadata about your module and will create a basic module structure for you.

~~~
$ puppet module generate examplecorp-mymodule

We need to create a metadata.json file for this module.  Please answer the
following questions; if the question is not applicable to this module, feel free
to leave it blank.

Puppet uses Semantic Versioning (semver.org) to version modules.
What version is this module?  [0.1.0]
--> 0.1.0

Who wrote this module?  [examplecorp]
--> Pat

What license does this module code fall under?  [Apache 2.0]
--> Apache 2.0

How would you describe this module in a single sentence?
--> It examples with Puppet.

Where is this module's source code repository?
--> https://github.com/examplecorp/examplecorp-mymodule

Where can others go to learn more about this module?
--> https://forge.puppetlabs.com/examplecorp/mymodule

Where can others go to file issues about this module?
-->


{
  "name": "examplecorp-mymodule",
  "version": "0.1.0",
  "author": "Pat",
  "summary": "It examples with Puppet.",
  "license": "Apache 2.0",
  "source": "https://github.com/examplecorp/examplecorp-mymodule",
  "project_page": "(https://forge.puppetlabs.com/examplecorp/mymodule)",
  "issues_url": null,
  "dependencies": [
    {
      "name": "puppetlabs-stdlib",
      "version_range": ">= 1.0.0"
    }
  ]
}


About to generate this metadata; continue? [n/Y]
--> Y

Notice: Generating module at /Users/Pat/Development/examplecorp-mymodule...
Notice: Populating ERB templates...
Finished; module generated in examplecorp-mymodule.
examplecorp-mymodule/manifests
examplecorp-mymodule/manifests/init.pp
examplecorp-mymodule/metadata.json
examplecorp-mymodule/Rakefile
examplecorp-mymodule/README.md
examplecorp-mymodule/spec
examplecorp-mymodule/spec/classes
examplecorp-mymodule/spec/classes/init_spec.rb
examplecorp-mymodule/spec/spec_helper.rb
examplecorp-mymodule/tests
examplecorp-mymodule/tests/init.pp
~~~

For best practices about writing your module, please see the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html).

You also have the option of writing classes and defined types by hand and placing them in properly named manifest files as [described above](#module_layout). If you take this route, you **must** ensure that your metadata.json file is properly formatted or your module **will not work**.

* [See here][classes] for more information on classes
* [See here][defined_types] for more information on defined types


Tips
-----

The [classes][], [defined types][defined_types], and [plugins][] in a module **should all be related,** and the module should aim to be **as self-contained as possible.**

Manifests in one module should never reference files or templates stored in another module.

Be wary of having classes declare classes from other modules, as this makes modules harder to redistribute. When possible, it's best to isolate "super-classes" that declare many other classes in a local "site" module.
