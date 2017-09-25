---
title: "Hiera: Update classic Hiera function calls"
toc: false
---

[lookup_function]: ./hiera_use_function.html
[automatic]: ./hiera_automatic.html
[lookup_options]: ./hiera_merging.html

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are all deprecated, and will be removed in Puppet 6.

[The `lookup` function][lookup_function] is a complete replacement for all of these:

Hiera function                | Equivalent `lookup` call
------------------------------|-------------------------
`hiera('secure_server')`      | `lookup('secure_server')`
`hiera_array('ntp::servers')` | `lookup('ntp::servers', {merge => unique})`
`hiera_hash('users')`         | `lookup('users', {merge => hash})` or `lookup('users', {merge => deep})`
`hiera_include('classes')`    | `lookup('classes', {merge => unique}).include`

To make sure you're ready for Puppet 6 and beyond, revise your Puppet modules to replace the `hiera_*` functions with `lookup`. **This is purely to prepare for the future:** you can adopt all of Hiera 5's new features without updating these function calls.

While you're revising, consider refactoring some code to use [automatic class parameter lookup][automatic] instead of functions --- since automatic lookups [can now do unique and hash merges][lookup_options], the `hiera_array` and `hiera_hash` functions aren't as important as they used to be.
