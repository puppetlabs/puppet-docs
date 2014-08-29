---
layout: default
title: "Deprecated Language Features"
---


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

## Matching Numbers With Regular Expressions

### Now

Currently, Puppet allows matching with a =~ against non-string values.

### In Puppet 4.0

Puppet 4.0 will not match a regexp against anything but a string.

### Detecting and Updating

Puppet 3.7 does not give a deprecation warning, but if you enable the future parser, any regexp matched against a non-string value will cause an error.

### Context

The ability to match a regexp against a non-string value was inconsistent, so we have removed it.

* [PUP-1782: Deprecation warning when attempt to match a number with a regexp in 3.x](https://tickets.puppetlabs.com/browse/PUP-1782)

## The `search` Function [TO DO PLEASE NICK]

### Now
 
The `search` functions allow a scope to expand the set of searched namespaces to find something referenced.
[I JUST COPIED THIS AND DON'T TRULY UNDERSTAND HOW TO EXPLAIN IT]

this one's complicated. It's related to relative namespacing. you can skip it if it's incomprehensible.

### In Puppet 4.0
The `search` function no longer ... [DOES THAT... I **KIND OF** GET IT BUT I CAN'T EXPLAIN IT. ]

### Detecting and Updating

If you use this function, Puppet gives a deprecation warning:
    Warning: The 'search' function is deprecated. See http://links.puppetlabs.com/search-function-deprecation

### Context

* [PUP-1852: deprecate the 'search' function](https://tickets.puppetlabs.com/browse/PUP-1852)

## Variable Names Beginning With Capital Letters

### Now
Variable names can begin with either uppercase or lowercase letters.

### In Puppet 4.0
Variable names cannot begin with uppercase letters.

### Detecting and Updating

Puppet 3.7 does not give deprecation warnings for this issue. If you turn on the future parser, you will get errors for variables starting with capital letters.

### Context

When variable names start with capital letters, it can cause problems with variable references and, in some cases, type references, so we've removed the ability to capitalize variable names. 

* [PUP-1808: Deprecate variables with an initial capital letter](https://tickets.puppetlabs.com/browse/PUP-1808)

## Class Names Containing Hyphens

### Now

Class names can contain hyphens, even though the documentation says that they are prohibited, and you can't reference variables inside classes that are named this way.

### In Puppet 4.0

Class names containing hyphens are actually prohibited.

### Detecting and Updating

Puppet 3.7 does not give a deprecation warning for this, but if you enable the future parser, any hyphenated class names will cause an error.

### Context

Hyphenated class names behaved inconsistently, so we have removed the ability to use hyphens in class names.

* [PUP-2034: Add depreciation warning for hyphenated class names](https://tickets.puppetlabs.com/browse/PUP-2034)

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

Node inheritance often causes ambiguous or counterintuitive behavior. More effective reuse can be achieved using classes and defined types.

* [PUP-2557: Deprecate and remove node inheritance](https://tickets.puppetlabs.com/browse/PUP-2557)

## Importing Manifests

### Now

Import statements can be used to compile more than one manifest without autoloading for modules.

### In Puppet 4.0

The `import` keyword has been removed completely and manifests can no longer be imported.

### Detecting and Updating

Use of the `import` keyword in Puppet 3.6 and later causes a deprecation warning:

    Warning: The use of 'import' is deprecated at 1. See http://links.puppetlabs.com/puppet-import-deprecation

### Context

The behavior of `import` within autoloaded manifests was undefined and could vary randomly. 

* [PUP-866: Deprecate "import"](https://tickets.puppetlabs.com/browse/PUP-866)

## Mutating Arrays and Hashes

### Now

You can change the contents of arrays and hashes in Puppet code and in templates.

### In Puppet 4.0

You cannot change the contents of arrays and hashes.

### Detecting and Updating

    Warning: The use of mutating operations on Array/Hash is deprecated at 1. See http://links.puppetlabs.com/puppet-mutation-deprecation

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

The Ruby DSL sometimes behaved erratically, so we've implemented some of the most-used Ruby abilities --- such as [iteration](./experiments_lambdas.html) --- in the Puppet DSL. 

* [PUP-987: Remove Ruby DSL support](https://tickets.puppetlabs.com/browse/PUP-987)

