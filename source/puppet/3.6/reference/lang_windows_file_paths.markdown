---
layout: default
title: "Language: Handling File Paths on Windows"
---

[template]: /guides/templating.html
[scheduledtask]: /puppet/latest/reference/type.html#scheduledtask
[exec]: /puppet/latest/reference/type.html#exec
[package]: /puppet/latest/reference/type.html#package
[file]: /puppet/latest/reference/type.html#file

Several [resource types](./lang_resources.html) (including `file`, `exec`, and `package`) take file paths as values for various attributes.

When writing Puppet manifests to manage Windows systems, there are two extra issues to take into account when writing file paths: directory separators, and filesystem redirection.

## Filesystem Redirection

This version of Puppet always runs as a 32-bit process on Windows systems. On 64-bit versions of Windows, this means Puppet is affected by the <a href="http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx">File System Redirector</a>. This can be an issue when trying to manage files in the system directory, like IIS configuration files.

**When a Puppet resource accesses any files in the `%windir%\system32` directory, Windows will silently change the path to point to `%windir%\SysWOW64` instead.**

To prevent redirection, you should **use the `sysnative` alias** in place of `system32` whenever you need to access files in the system directory.

For example: `C:\Windows\sysnative\inetsrv\config\application Host.config` will always point to `C:\Windows\system32\inetsrv\config\application Host.config`, and never to `C:\Windows\SysWOW64\inetsrv\config\application Host.config`.

> Note: 64-bit Windows Server 2003 requires hotfix [KB942589](http://support.microsoft.com/kb/942589/en-us) to use the sysnative alias.

## Directory Separators

Windows traditionally uses the backslash (`\`) to separate directories in file paths. (For example, `C:\Program Files\PuppetLabs`.) However, the Puppet language also uses the backslash (`\`) as an escape character in [quoted strings.](./lang_datatypes.html#strings) This can make it awkward to write literal backslashes.

To complicate things further: the Windows file system APIs will accept **both** the backslash (`\`) and forward-slash (`/`) in file paths, but some Windows programs still only accept backslashes.

In short:

* Using forward-slashes in paths is easier, but sometimes you must use backslashes.
* When you use backslashes, you must pay extra attention to keep them from being suppressed by Puppet's string quoting.

The following guidelines will help you use backslashes safely in Windows file paths with Puppet.

### When to Use Each Kind of Slash

If Puppet itself is interpreting the file path, forward slashes are generally okay. If the file path is being passed directly to a Windows program, backslashes may be mandatory. If the file path is meant for the puppet master, forward-slashes may be mandatory.

The most notable instances of each kind of path are listed below.

#### Forward-Slashes Only

Forward slashes **MUST** be used in:

* [Template][] paths (e.g. `template('my_module/content.erb')`)
* `puppet:///` URLs

#### Forward- and Backslashes Both Allowed

You can choose which kind of slash to use in:

* The `path` attribute or title of a [`file`][file] resource

* Local paths in a [`file`][file] resource's `source` attribute
* The `command` of an [`exec`][exec] resource, unless the executable requires backslashes, e.g. cmd.exe

#### Backslashes Only

Backslashes **MUST** be used in:

* The `source` attribute of a [`package`][package] resource
* Any file paths included in the `command` of a [`scheduled_task`][scheduledtask] resource.
* Any file paths included in the `install_options` of a [`package`][package] resource.


### Using Backslashes in Double-Quoted Strings

Puppet supports two kinds of string quoting. See [the reference section about strings](/puppet/latest/reference/lang_datatypes.html#strings) for full details.

Strings surrounded by double quotes (`"`) allow many escape sequences that begin with backslashes. (For example, `\n` for a newline.) Any lone backslashes will be interpreted as part of an escape sequence.

When using backslashes in a double-quoted string, **you must always use two backslashes** for each literal backslash. There are no exceptions and no special cases.

Example:

    "C:\\Program Files\\PuppetLabs"

### Using Backslashes in Single-Quoted Strings

Strings surrounded by single quotes `'like this'` do not interpolate variables. Only one escape sequence is permitted: `\'` (a literal single quote). Line breaks within the string are interpreted as literal line breaks.

**Any** backslash (`\`) not followed by a single quote is interpreted as a literal backslash. This means there's no way to end a single-quoted string with a backslash; if you need to refer to a string like `C:\Program Files(x86)\`, you'll have to use a double-quote string instead.

> **Note:** This behavior is different when the `parser` setting is set to `future`. In the future parser, lone backslashes are literal backslashes unless followed by a single quote or another backslash. That is:
>
> * When a backslash occurs at the very end of a single-quoted string, a double backslash must be used instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
> * When a literal double backslash is intended, a quadruple backslash must be used.


## Errata

### Known Issues Prior to Puppet 3.0

In Puppet 2.7, there was one additional place where backslashes were not allowed: the `modulepath` setting required forward-slashes. For example: `puppet apply --modulepath="Z:/path/to/my/modules" "Z:/path/to/my/site.pp"`

This was fixed in Puppet 3.0 / Puppet Enterprise 3.0.
