---
title: "Writing custom functions: Basics"
---

[catalog]: todo
[manifest]: todo
[call]: todo
[forge]: todo
[stdlib]: todo
[built-in]: todo
[functions]: todo
[module]: todo
[environment]: todo
[func_puppet]: todo
[lambda]: todo
[func_modern]: todo
[func_legacy]: todo
[future parser]: todo

## What are functions?

Functions are plugins used during [catalog compilation][catalog]. When a Puppet [manifest][] calls a function, that function runs and returns a value.

* Related documentation: [The Puppet language: Calling functions][call]

Most functions only produce values, but functions can also:

* Cause side effects that modify the [catalog][]. (For example, the `include` function adds classes to the catalog.)
* Evaluate a provided block of Puppet code, using their other arguments to determine how that code runs.

Most functions take one or more arguments, which determine their return value and the behavior of any side effects.

Puppet includes many built-in functions, and more are available in modules on the [Puppet Forge][forge], particularly in the [puppetlabs-stdlib][stdlib] module.

You can also write your own custom functions.

## Custom functions

If you need to manipulate data or talk to third-party services during [catalog compilation][catalog], and if the [built-in functions][built-in] (or functions from Forge modules) aren't sufficient, you can write new [functions][] for Puppet.

Custom functions work just like Puppet's built-in functions: you can call them during catalog compilation to produce a value (and sometimes cause side effects). You can use your custom functions locally, and you can also share them with other users.

To make a custom function available to Puppet, you must put it it a [module][] or in an [environment][], in the specific locations where Puppet expects to find functions.

Puppet offers three interfaces for writing custom functions:

Interface | Description
----------|------------
[The Puppet language][func_puppet]                                         | The easiest way to write functions, which you can use without knowing any Ruby. However, it's less powerful than the Ruby API: pure Puppet functions can only have one signature per function, and can't take a [lambda][] (block of Puppet code).
[The modern Ruby functions API][func_modern] (`Puppet::Functions`)         | The most powerful and flexible way to write functions. It requires some knowledge of Ruby.
[The legacy Ruby functions API][func_legacy] (`Puppet::Parser::Functions`) | **Avoid unless you must support Puppet 3.** This API has major problems, but it is the only way to fully support both Puppet 4.x and Puppet 3.x. (Note that Puppet 3.x can use the modern API when the [future parser][] is enabled.)

## Guidelines for writing custom functions

* Whenever possible, avoid causing side effects. "Side effects" are any effect other than producing a value; in the context of Puppet, it usually means modifying the catalog by adding classes or resources to it.
* In Ruby functions, it's sometimes possible to change the values of existing variables. Never do this. Everything else in Puppet relies on this never happening.
