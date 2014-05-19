---
layout: default
title: "Windows: Handling File Paths"
---

[template]: /guides/templating.html
[scheduledtask]: /references/latest/type.html#scheduledtask
[exec]: /references/latest/type.html#exec
[package]: /references/latest/type.html#package
[file]: /references/latest/type.html#file

When writing Puppet manifests to manage Windows systems, you'll have to be somewhat flexible about the way you write file paths. It's more complex than it is on \*nix systems, for a few reasons:

* The Puppet language uses the backslash (`\`) as an escape character in quoted strings. This means writing literal backslashes can be awkward.
* Windows traditionally uses the backslash (`\`) to separate directories in file paths. (E.g. `C:\Program Files\PuppetLabs`)
* The Windows file system APIs will accept both the backslash (`\`) and forward-slash (`/`) in file paths...
* ...but some Windows programs still only accept backslashes.

In short: Using forward-slashes in paths is easier, but sometimes you just have to use backslashes. When you use backslashes, you have to pay extra attention to keep them from being suppressed by Puppet's string quoting.

The following guidelines will help you use backslashes safely in Windows file paths with Puppet.

## When to Use Each Kind of Slash

If Puppet itself is interpreting the file path, forward slashes are generally okay. If the file path is being passed directly to a Windows program, backslashes may be mandatory. If the file path is meant for the puppet master, forward-slashes may be mandatory. The most notable instances of each kind of path are listed below.

### Forward-Slashes Only

Forward slashes **MUST** be used in:

* [Template][] paths (e.g. `template('my_module/content.erb')`)
* `puppet:///` URLs

### Forward- and Backslashes Both Allowed

You can choose which kind of slash to use in:

* The `path` attribute or title of a [`file`][file] resource
* The `source` attribute of a [`package`][package] resource
* Local paths in a [`file`][file] resource's `source` attribute
* The `command` of an [`exec`][exec] resource, unless the executable requires backslashes, e.g. cmd.exe

### Backslashes Only

Backslashes **MUST** be used in:

* The `command` of a [`scheduled_task`][scheduledtask] resource.
* The `install_options` of a [`package`][package] resource.



## Using Backslashes in Double-Quoted Strings

Puppet supports two kinds of string quoting. See [the reference section about strings](/puppet/latest/reference/lang_datatypes.html#strings) for full details.

Strings surrounded by double quotes (`"`) allow many escape sequences that begin with backslashes. (For example, `\n` for a newline.) Any lone backslashes will be interpreted as part of an escape sequence.

When using backslashes in a double-quoted string, **you must always use two backslashes** for each literal backslash. There are no exceptions and no special cases.

Example:

    "C:\\Program Files\\PuppetLabs"

## Using Backslashes in Single-Quoted Strings

Strings surrounded by single quotes (`'`) allow only two escape sequences: `\'` (a literal single quote) and `\\` (a literal backslash).

Lone backslashes can usually be used in single-quoted strings. However:

* When a backslash occurs at the very end of a single-quoted string, a double backslash must be used instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
* When a literal double backslash is intended, a quadruple backslash must be used.

### The Rule

In single-quoted strings:

* A double backslash always means a literal backslash.
* A single backslash _usually_ means a literal backslash, unless it is followed by a single quote or another backslash.


## Errata

In Puppet 2.7, there was one additional place where backslashes were not allowed: the `modulepath` setting required forward-slashes. For example: `puppet apply --modulepath="Z:/path/to/my/modules" "Z:/path/to/my/site.pp"`

This was fixed in Puppet 3.0.
