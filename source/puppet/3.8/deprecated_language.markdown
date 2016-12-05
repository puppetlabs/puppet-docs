---
layout: default
title: "Deprecated Language Features"
---

[main manifest]: ./dirs_manifest.html

The following features of the Puppet language are deprecated, and will be removed in Puppet 4.0.

## Relative Resolution of Class Names

### Now

Puppet assumes class and defined type names are **relative** until proven otherwise. Thus, if the final namespace segment of a class in one module matches the name of another module, Puppet will sometimes load the wrong class. You can force the correct class to load by prepending `::` to it.

### In Puppet 4.0

Relative namespacing is fixed, and the workaround is no longer required.

### Detecting and Updating

Puppet 3.7 does not give a deprecation warning. You can enable the future parser to avoid relative namespace issues.

### Context

Relative name lookup was introduced in pre-module versions of Puppet and reflected an outdated assumption about how modules would be used. This turned out to be a bad idea.

* [PUP-121: Remove relative namespacing](https://tickets.puppetlabs.com/browse/PUP-121)

## Node Inheritance

### Now

You can use the `inherits` keyword to allow nodes to inherit definitions from other nodes.

### In Puppet 4.0

Node inheritance is completely removed.

### Detecting and Updating

As of Puppet 3.7, node inheritance causes a deprecation warning:

    Warning: Deprecation notice: Node inheritance is not supported in Puppet >= 4.0.0. See http://links.puppetlabs.com/puppet-node-inheritance-deprecation

In the future parser as of Puppet 3.7, node inheritance causes an error:

    Error: Node inheritance is not supported in Puppet >= 4.0.0. See http://links.puppetlabs.com/puppet-node-inheritance-deprecation at c:/vagrantshared/puppet/manifests/site.pp:12:22

### Context

Node inheritance often causes ambiguous or counterintuitive behavior. More effective code reuse can be achieved using classes and defined types.

* [PUP-2557: Deprecate and remove node inheritance](https://tickets.puppetlabs.com/browse/PUP-2557)

## Importing Manifests

### Now

You can use the `import` statement in the [main manifest][] to compile more than one manifest without autoloading the additional files from modules.

Since `import` statements can interfere with syntax checking individual manifest files, you can also use [the `ignoreimport` setting](/puppet/3.7/reference/configuration.html#ignoreimport) to block importing when using the `puppet parser validate` command.

### In Puppet 4.0

The `import` keyword has been removed completely and manifests can no longer be imported.

Additionally, the `ignoreimport` setting has been removed, since it's no longer necessary.

### Detecting and Updating

Use of the `import` keyword in Puppet 3.6 and later causes a deprecation warning:

    Warning: The use of 'import' is deprecated at 1. See http://links.puppetlabs.com/puppet-import-deprecation

If any of your commit hooks or CI tools use the `ignoreimport` setting, you should also see [the note on `ignoreimport`'s deprecation](./deprecated_settings.html#ignoreimport).

### Context

The `import` keyword predates Puppet's module system. Once modules were introduced, most of the use cases for `import` vanished. One use case remained (importing a directory of node-specific manifests into the [main manifest][]), but now that the main manifest can be a directory with any number of files, that last use case is gone. Since it's now a redundant way to do things, and can behave really oddly under certain circumstances, we're removing it.

* [PUP-866: Deprecate "import"](https://tickets.puppetlabs.com/browse/PUP-866)

## Matching Numbers With Regular Expressions

### Now

Currently, Puppet allows matching with a =~ against non-string values.

### In Puppet 4.0

Puppet 4.0 will not match a regexp against anything but a string.

### Detecting and Updating

Puppet 3.8 does not give a deprecation warning, but if you enable the future parser, any regexp matched against a non-string value will cause an error.

### Context

The ability to match a regexp against a non-string value was inconsistent, so we have removed it.

* [PUP-1782: Deprecation warning when attempt to match a number with a regexp in 3.x](https://tickets.puppetlabs.com/browse/PUP-1782)

## The `search` Function

### Now

The `search` function allows you to make relative namespacing even worse, by adding _additional_ namespaces that Puppet will attempt to tack onto any class or defined type names.

### In Puppet 4.0

The `search` function is removed, and would have no effect even if it were present.

### Detecting and Updating

If you use this function, Puppet gives a deprecation warning:

    Warning: The 'search' function is deprecated. See http://links.puppetlabs.com/search-function-deprecation

If you see this warning, stop using `search` and refer to all classes and defined types by their fully qualified names.

### Context

* [PUP-1852: deprecate the 'search' function](https://tickets.puppetlabs.com/browse/PUP-1852)

## Variable Names Beginning With Capital Letters

### Now

Variable names can begin with either uppercase or lowercase letters.

### In Puppet 4.0

Variable names cannot begin with uppercase letters.

### Detecting and Updating

Puppet 3.8 does not give deprecation warnings for this issue. If you turn on the future parser, you will get errors for variables starting with capital letters.

### Context

When variable names start with capital letters, it can potentially cause variable references to conflict with type references, so we've removed the ability to capitalize variable names.

* [PUP-1808: Deprecate variables with an initial capital letter](https://tickets.puppetlabs.com/browse/PUP-1808)

## Class Names Containing Hyphens

### Now

Class names can contain hyphens, even though the documentation says that they are prohibited, and you can't reference variables inside classes that are named this way.

### In Puppet 4.0

Class names containing hyphens are actually prohibited.

### Detecting and Updating

Puppet 3.8 does not give a deprecation warning for this, but if you enable the future parser, any hyphenated class names will cause an error.

### Context

Hyphenated class names behaved inconsistently, so we have removed the ability to use hyphens in class names.

* [PUP-2034: Add depreciation warning for hyphenated class names](https://tickets.puppetlabs.com/browse/PUP-2034)

## Mutating Arrays and Hashes

### Now

You can change the contents of already-defined arrays and hashes in Puppet code and in templates.

### In Puppet 4.0

You cannot change the contents of arrays and hashes.

### Detecting and Updating

If any of your code modifies an array or hash variable, Puppet will log the following deprecation warning:

    Warning: The use of mutating operations on Array/Hash is deprecated at 1. See http://links.puppetlabs.com/puppet-mutation-deprecation

If you are mutating data structures, you should change your code to create new values instead of modifying existing ones.

### Context

This behavior never should have been possible, and we have always considered it a bug.

## The Ruby DSL

### Now

The Ruby DSL is deprecated.

### In Puppet 4.0

Support for the Ruby DSL is completely removed.

### Detecting and Updating

Search the `manifests` directories of your modules for any files ending in `.rb` instead of `.pp`. Rewrite any code that uses the Ruby DSL in the Puppet language.

### Context

The Ruby DSL sometimes behaved erratically. When we attempted to improve it, we realized it was too heavyweight for what our users actually needed, so we've implemented some of the most-used Ruby abilities --- such as [iteration](./experiments_lambdas.html) --- in the Puppet DSL.

* [PUP-987: Remove Ruby DSL support](https://tickets.puppetlabs.com/browse/PUP-987)

