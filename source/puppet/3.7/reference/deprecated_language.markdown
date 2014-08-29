---
layout: default
title: "Deprecated Language Features"
---



The following features of the Puppet language are deprecated, and will be removed in Puppet 4.0.

## Relative Resolution of Class Names

### Now

aka relative namespacing.

### In Puppet 4.0

### Detecting and Updating

no deprecation warnings. you can turn on future parser to get the new behavior, and see if anything works different.

### Context

* [PUP-121: Remove relative namespacing](https://tickets.puppetlabs.com/browse/PUP-121)


## Matching Numbers With Regular Expressions

### Now

### In Puppet 4.0

### Detecting and Updating

See ticket for deprecation warning.

### Context

* [PUP-1782: Deprecation warning when attempt to match a number with a regexp in 3.x](https://tickets.puppetlabs.com/browse/PUP-1782)


## The `search` Function

### Now

this one's complicated. It's related to relative namespacing. you can skip it if it's incomprehensible.

### In Puppet 4.0

### Detecting and Updating

### Context

* [PUP-1852: deprecate the 'search' function](https://tickets.puppetlabs.com/browse/PUP-1852)


## Variable Names Beginning With Capital Letters

### Now

### In Puppet 4.0

### Detecting and Updating

No deprecation warnings. You can turn on the future parser and see if it blows up.

### Context

* [PUP-1808: Deprecate variables with an initial capital letter](https://tickets.puppetlabs.com/browse/PUP-1808)

## Class Names Containing Hyphens

### Now

You can use class names with hyphens, even though the docs prohibit them and you can't access variables from those classes.

### In Puppet 4.0

### Detecting and Updating

No warning. turn on the future parser to check.

### Context

* [PUP-2034: Add depreciation warning for hyphenated class names](https://tickets.puppetlabs.com/browse/PUP-2034)

## Node Inheritance

### Now

### In Puppet 4.0

### Detecting and Updating

a warning in current parser:

    Warning: Deprecation notice: Node inheritance is not supported in Puppet >= 4.0.0. See http://links.puppetlabs.com/puppet-node-inheritance-deprecation

errors out in future parser.

    Error: Node inheritance is not supported in Puppet >= 4.0.0. See http://links.puppetlabs.com/puppet-node-inheritance-deprecation at c:/vagrantshared/puppet/manifests/site.pp:12:22

### Context

* [PUP-2557: Deprecate and remove node inheritance](https://tickets.puppetlabs.com/browse/PUP-2557)

## Importing Manifests

### Now

### In Puppet 4.0

### Detecting and Updating

warning:

    Warning: The use of 'import' is deprecated at 1. See http://links.puppetlabs.com/puppet-import-deprecation

### Context

* [PUP-866: Deprecate "import"](https://tickets.puppetlabs.com/browse/PUP-866)

## Mutating Arrays and Hashes

### Now

You can change the contents of arrays and hashes in Puppet code and in templates.

### In Puppet 4.0

You can't.

### Detecting and Updating

Not sure.

### Context

I don't have a ticket, but basically this never should have been possible and we considered it a bug from the get-go.

## The Ruby DSL

### Now

### In Puppet 4.0

### Detecting and Updating

Search the `manifests` directories of your modules for any files ending in `.rb` instead of `.pp`. Rewrite any code that uses the Ruby DSL in the Puppet language.

### Context

* [PUP-987: Remove Ruby DSL support](https://tickets.puppetlabs.com/browse/PUP-987)

