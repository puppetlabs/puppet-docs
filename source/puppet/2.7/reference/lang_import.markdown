---
title: "Language: Importing Manifests"
layout: default
canonical: "/puppet/latest/reference/lang_import.html"
---


[site_manifest]: ./lang_summary.html#files
[modules]: ./modules_fundamentals.html
[enc]: /guides/external_nodes.html
[node_definition]: ./lang_node_definitions.html

Puppet's normal behavior is to compile a single manifest (the "[site manifest][site_manifest]") and autoload any referenced classes from [modules][] (optionally doing the same with a list of classes from an [ENC][]). 

The `import` keyword causes Puppet to compile more than one manifest without autoloading from modules. 

> #### Aside: Best Practices
> 
> You should generally **avoid the `import` keyword.** It was introduced to the language before modules existed, and was rendered mostly obsolete once Puppet could autoload classes and defined types from modules. Mixing `import` and modules can often cause bizarre results.
> 
> The one modern use for importing is to allow [node definitions][node_definition] to be stored in several files. However, note that this requires you to restart the puppet master or edit site.pp whenever you edit your nodes. 

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

The puppet master service monitors its main [site manifest][site_manifest] and modules and will reload the files whenever they are edited. However, because it only evaluates file globs when the parent file containing them is reloaded, it cannot tell when imported manifests have been changed. 

Thus, if you use `import` statements, you must manually cause your files to be reloaded whenever you edit your imported manifests. You can do this by:

* Restarting the puppet master
* Editing (or `touch`ing) site.pp to trigger a reload


