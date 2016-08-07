---
layout: default
title: "Resource tips and examples: Exec on Windows"
---

[package]: ./type.html#package
[exec]: ./type.html#exec


Puppet can execute binaries (exe, com, bat, etc.), and can log the child process output and exit status. To ensure the resource is idempotent, specify one of the `creates`, `onlyif`, or `unless` attributes.

Since Puppet uses the same [`exec`][exec] resource type on both \*nix and Windows systems, there are a few Windows-specific caveats to keep in mind.

## Command extensions

If a file extension for the `command` is not specified (for example, `ruby` instead of `ruby.exe`), Puppet will use the `PATHEXT` environment variable to resolve the appropriate binary. `PATHEXT` is a Windows-specific variable that lists the valid file extensions for executables.

## Exit codes

On Windows, **most** exit codes should be integers between 0 and 2147483647.

Larger exit codes on Windows can behave inconsistently across different tools. The Win32 APIs define exit codes as 32-bit unsigned integers, but both the cmd.exe shell and the .NET runtime cast them to signed integers. This means some tools will report negative numbers for exit codes above 2147483647. (For example, cmd.exe reports 4294967295 as -1.) Since Puppet uses the GetExitCodeProcess Win32 API, it will report the very large number instead of the negative number, which might not be what you expect if you got the exit code from a cmd.exe session.

Microsoft recommends against using negative/very large exit codes, and you should avoid them when possible. To convert a negative exit code to the positive one Puppet will use, subtract it from 4294967296.

## Shell built-ins

Puppet does not support a shell provider for Windows, so if you want to execute shell built-ins (e.g. `echo`), you must provide a complete `cmd.exe` invocation as the command. (For example, `command => 'cmd.exe /c echo "foo"'`.) When using `cmd.exe` and specifying a file path in the command line, be sure to use backslashes. (For example, `'cmd.exe /c type c:\path\to\file.txt'`.) If you use forward slashes, `cmd.exe` will error.

## The Optional PowerShell Exec Provider

An optional PowerShell exec provider is available as a plugin and is is particularly helpful if you need to run PowerShell commands easily from within Puppet. To use it, install:

* [The puppetlabs/powershell module](https://forge.puppetlabs.com/puppetlabs/powershell)

## Inline PowerShell scripts

If you choose to execute PowerShell scripts using Puppet's default `exec` provider on Windows, you must specify the `remotesigned` execution policy as part of the `powershell.exe` invocation:

``` puppet
exec { 'test':
  command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
}
```
