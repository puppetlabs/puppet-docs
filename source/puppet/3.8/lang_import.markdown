---
title: "Language: Importing Manifests"
layout: default
canonical: "/puppet/latest/reference/lang_import.html"
---

[site_manifest]: ./dirs_manifest.html
[modules]: ./modules_fundamentals.html
[enc]: /guides/external_nodes.html
[node_definition]: ./lang_node_definitions.html

Puppet's normal behavior is to compile a single manifest (the "[site manifest][site_manifest]") and autoload any referenced classes from [modules][] (optionally doing the same with a list of classes from an [ENC][]).

The `import` keyword causes Puppet to compile more than one manifest without autoloading from modules.

> Deprecation Notice
> -----
>
> The `import` keyword is deprecated. Using it will cause deprecation warnings to be logged on the Puppet master, and we plan to remove `import` completely in Puppet 4.
>
> ### What to Use Instead
>
> New users should avoid the `import` keyword, and existing users should stop using it. Instead, do the following:
>
> * To keep your [node definitions][node_definition] in separate files, [specify a directory as your main manifest][site_manifest].
> * To load classes and defined types, use [modules][].
>
> Together, these two features replace `import` completely.


Syntax
-----

~~~ ruby
    # /etc/puppetlabs/puppet/manifests/site.pp

    # import many manifest files with node definitions
    import 'nodes/*.pp'

    # import a single manifest file with node definitions
    import 'nodes.pp'
~~~

An import statement consists of the `import` keyword, followed by a literal quoted string with no variable interpolation.

The string provided must be a file path or file glob (as implemented by Ruby's `Dir.glob` method). These paths must resolve to one or more Puppet manifest (.pp) files.

If the file path or glob is not fully qualified, it will be resolved _relative to the manifest file in which the `import` statement is found._ Thus, the examples above assume that both the `nodes/` directory and the `nodes.pp` file are in the same `/etc/puppetlabs/puppet/manifests` directory as site.pp.

Behavior
-----

Import statements have the following characteristics:

* They read the contents of the requested file(s) and add their code to top scope
* They are processed before any other code in the manifest is parsed
* They cannot be contained by conditional structures or node/class definitions

These quirks mean **the location of an import statement in a manifest does not matter.** If an uncommented import statement exists anywhere in a manifest, it will always run (even if it looks like it shouldn't) and the code it imports will not be contained in any definition or conditional. The following example illustrates this:

~~~ ruby
    # /etc/puppetlabs/puppet/manifests/site.pp
    node 'kestrel.example.com' {
        import 'nodes/kestrel.pp'
    }

    # /etc/puppetlabs/puppet/manifests/nodes/kestrel.pp
    include ntp
    include apache2
~~~

This import statement looks like it should insert code INTO the node definition that contains it; instead, it will insert the code outside any node definition, and it will do so regardless of whether the node definition matches the current node. The `ntp` and `apache2` classes would be applied to every node.

### Implications and Best Practices

Due to the non-standard behavior of `import`, any imported file should only contain constructs like node definitions and class definitions, which can exist at top scope without necessarily executing on every node.

### Interactions With the Autoloader

The behavior of `import` within autoloaded manifests is **undefined,** and may vary randomly between minor versions of Puppet. You should never place `import` statements in modules; they should only exist in [site.pp][site_manifest].

### Inability to Reload

The Puppet master service monitors its main [site manifest][site_manifest] and modules and will reload the files whenever they are edited. However, because it only evaluates file globs when the parent file containing them is reloaded, it cannot tell when imported manifests have been changed.

Thus, if you use `import` statements, you must manually cause your files to be reloaded whenever you edit your imported manifests. You can do this by:

* Restarting the Puppet master
* Editing (or `touch`ing) site.pp to trigger a reload


