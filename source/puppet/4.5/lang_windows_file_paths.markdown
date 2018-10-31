---
layout: default
title: "Language: Handling file paths on Windows"
canonical: "/puppet/latest/lang_windows_file_paths.html"
---

[template]: ./lang_template.html
[scheduledtask]: ./type.html#scheduledtask
[exec]: ./type.html#exec
[package]: ./type.html#package
[file]: ./type.html#file

Several [resource types](./lang_resources.html) (including `file`, `exec`, and `package`) take file paths as values for various attributes.

When writing Puppet manifests to manage Windows systems, there are two extra issues to take into account when writing file paths: directory separators and file system redirection.

## Directory separators

Windows traditionally uses the backslash (`\`) to separate directories in file paths. (For example, `C:\Program Files\PuppetLabs`.) However, the Puppet language also uses the backslash (`\`) as an escape character in [quoted strings.](./lang_data_string.html) This can make it awkward to write literal backslashes.

To complicate things further: the Windows file system APIs will accept **both** the backslash (`\`) and forward-slash (`/`) in file paths, but some Windows programs still only accept backslashes.

In short:

* Using forward-slashes in paths is easier, but sometimes you must use backslashes.
* When you use backslashes, you must pay extra attention to keep them from being suppressed by Puppet's string quoting.

The following guidelines will help you use backslashes safely in Windows file paths with Puppet.

### When to use each kind of slash

If Puppet itself is interpreting the file path, forward slashes are generally okay. If the file path is being passed directly to a Windows program, backslashes may be mandatory. If the file path is meant for the Puppet master, forward-slashes may be mandatory.

The most notable instances of each kind of path are listed below.

#### Forward-slashes only

Forward slashes **MUST** be used in:

* [Template][] paths (e.g. `template('my_module/content.erb')`)
* `puppet:///` URLs

#### Forward- and backslashes both allowed

You can choose which kind of slash to use in:

* The `path` attribute or title of a [`file`][file] resource
* The `source` attribute of a [`package`][package] resource
* Local paths in a [`file`][file] resource's `source` attribute
* The `command` of an [`exec`][exec] resource, unless the executable requires backslashes, e.g. cmd.exe

#### Backslashes only

Backslashes **MUST** be used in:

* Any file paths included in the `command` of a [`scheduled_task`][scheduledtask] resource.
* Any file paths included in the `install_options` of a [`package`][package] resource.


### Using backslashes in double-quoted strings

Puppet supports two kinds of string quoting. See [the reference section about strings](/puppet/latest/lang_data_string.html) for full details.

Strings surrounded by double quotes (`"`) allow many escape sequences that begin with backslashes. (For example, `\n` for a newline.) Any lone backslashes will be interpreted as part of an escape sequence.

When using backslashes in a double-quoted string, **you must always use two backslashes** for each literal backslash. There are no exceptions and no special cases.

Example:

    "C:\\Program Files\\PuppetLabs"

### Using backslashes in single-quoted strings

Strings surrounded by single quotes `'like this'` do not interpolate variables. Only one escape sequence is permitted: `\'` (a literal single quote). Line breaks within the string are interpreted as literal line breaks.

**Any** backslash (`\`) not followed by a single quote is interpreted as a literal backslash. This means there's no way to end a single-quoted string with a backslash; if you need to refer to a string like `C:\Program Files(x86)\`, you'll have to use a double-quote string instead.

> **Note:** This behavior is different when the `parser` setting is set to `future`. In the future parser, lone backslashes are literal backslashes unless followed by a single quote or another backslash. That is:
>
> * When a backslash occurs at the very end of a single-quoted string, a double backslash must be used instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
> * When a literal double backslash is intended, a quadruple backslash must be used.


## File system redirection (when running 32-Bit Puppet on 64-Bit Windows)

Managing files in the `C:\Windows\system32` directory can be problematic. The short version is:

* If you are using **Puppet 3.7.3 or later,** use [the `$system32` fact]({{facter}}/core_facts.html#system32) whenever you need to access the `system32` directory. Easy and reliable.
* If you are using **Puppet 3.7.0 through 3.7.2** but are only using architecture-appropriate packages (32-bit on 32-bit systems, and 64-bit on 64-bit systems), you can access the `system32` directory directly. As soon as is practical, you should upgrade to 3.7.3 and start using the `$system32` fact.
* If you are using **Puppet 3.7.0 through 3.7.2** and are installing the 32-bit package on 64-bit systems, continue reading.

### Summary

If you are running a 32-bit Puppet package on a 64-bit version of Windows, Windows will redirect Puppet's access to the `C:\Windows\system32` directory into `C:\Windows\SysWOW64`. You will need to watch out for this and compensate.

### Details

As of Puppet 3.7, file system redirection is not an issue, **as long as you are running the architecture-appropriate Puppet version on a recent version of Windows.** (That is: Windows Server 2008 and higher, or Windows Vista and higher.)

However, if you are **running a 32-bit version of Puppet on a 64-bit version of Windows,** the <a href="http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx">File System Redirector</a> will silently redirect all file system access of the `%windir%\system32` directory to `%windir%\SysWOW64` instead. This can be an issue when trying to manage files in the system directory, such as IIS configuration files.

Additionally, the `ProgramFiles` environment variable resolves to `C:\Program Files\` in a 64-bit native application, and `C:\Program Files (x86)\` in a 32-bit process running on a 64-bit version of Windows.

There are two cases where you might be dealing with mixed Puppet/Windows architectures:

* You deliberately installed a 32-bit package on a 64-bit system, to maintain compatibility for certain modules until you're able to update their code for 64-bit Puppet.
* You are writing code that must support older versions of Puppet, which did not have 64-bit packages available.

### Compensating for redirection

In Puppet code, the easy way to access `system32` is to use [the `$system32` fact,]({{facter}}/core_facts.html#system32) available in **Puppet 3.7.3 and later.** It automatically compensates for file system redirection wherever necessary.

Prior to 3.7.3, you can manually compensate. On systems affected by file system redirection, you can use the `sysnative` alias in place of `system32` whenever you need to access files in the system directory. (For example: `C:\Windows\sysnative\inetsrv\config\application Host.config` will point to `C:\Windows\system32\inetsrv\config\application Host.config`, not `C:\Windows\SysWOW64\inetsrv\config\application Host.config`.)

**However,** note that `sysnative` is **only** a valid path when used within a 32-bit process running on a 64-bit Windows version. It **does not exist** when running an architecture-appropriate Puppet package. This means you can't simply use `sysnative` everywhere to access the correct files; you'll need to use different file paths depending on Puppet's run environment.

Prior to 3.7.3, there's no easy way for Puppet manifests to detect whether `sysnative` is available or necessary. Authors of public modules can choose to only support 3.7.3+, or can ship a renamed version of the `$system32` fact to support older versions. Private users can predict the mix of OS versions and architectures where their code will be run, and simply do the right thing for that environment.

One consideration for `exec` when you can't use `$system32` is to use `path =>` and set it appropriately, the first search path item first followed by others in the order you want them searched in. For instance, if you want to always use the 64-bit version of `cmd.exe` you can use:

``` puppet
exec { '64_bit_cmd':
  path    => "c:\\windows\\sysnative;c:\\windows\\system32;$::path",
  command => 'cmd.exe /c echo process is %PROCESSOR_ARCHITECTURE%',
}
```

If you always instead would rather always get a 32-bit process if it is available, you should set path more like the following:

``` puppet
exec { '32_bit_cmd':
  path    => "c:\\windows\\sysWOW64;c:\\windows\\system32;$::path",
  command => 'cmd.exe /c echo process is %PROCESSOR_ARCHITECTURE%',
}
```

Finally, it's possible to automatically detect which directory to use in Ruby plugin code. Do something like [this example from the puppetlabs/powershell module](https://github.com/puppetlabs/puppetlabs-powershell/blob/master/lib/puppet/provider/exec/powershell.rb#L6-L13):

``` ruby
commands :powershell =>
  if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
  "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
  elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
  "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
  else
  'powershell.exe'
  end
```
