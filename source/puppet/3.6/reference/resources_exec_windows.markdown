---
layout: default
title: "Resource Tips and Examples: Exec on Windows"
---

[package]: ./type.html#package
[exec]: ./type.html#exec


Puppet can execute binaries (exe, com, bat, etc.), and can log the child process output and exit status.

Since Puppet uses the same [`exec`][exec] resource type on both \*nix and Windows systems, there are a few Windows-specific caveats to keep in mind.

## Command Extensions

If a file extension for the `command` is not specified (for example, `ruby` instead of `ruby.exe`), Puppet will use the `PATHEXT` environment variable to resolve the appropriate binary. `PATHEXT` is a Windows-specific variable that lists the valid file extensions for executables.

## Exit Codes

On Windows, **most** exit codes should be integers between 0 and 2147483647.

Larger exit codes on Windows can behave inconsistently across different tools. The Win32 APIs define exit codes as 32-bit unsigned integers, but both the cmd.exe shell and the .NET runtime cast them to signed integers. This means some tools will report negative numbers for exit codes above 2147483647. (For example, cmd.exe reports 4294967295 as -1.) Since Puppet uses the plain Win32 APIs, it will report the very large number instead of the negative number, which might not be what you expect if you got the exit code from a cmd.exe session.

Microsoft recommends against using negative/very large exit codes, and you should avoid them when possible. To convert a negative exit code to the positive one Puppet will use, subtract it from 4294967296.

## Shell Built-ins

Puppet does not support a shell provider for Windows, so if you want to execute shell built-ins (e.g. `echo`), you must provide a complete `cmd.exe` invocation as the command. (For example, `command => 'cmd.exe /c echo "foo"'`.)

## The Optional PowerShell Exec Provider

An optional PowerShell exec provider is available as a plugin. To use it, install:

* [The puppetlabs/powershell module](https://forge.puppetlabs.com/puppetlabs/powershell)

## Inline PowerShell Scripts

When executing inline Powershell scripts, you must specify the `remotesigned` execution policy as part of the `powershell.exe` invocation:

~~~ ruby
    exec { 'test':
      command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
    }
~~~


## Errata

### Known Issues Prior to Puppet 3.4 / PE 3.2

Before Puppet 3.4 / Puppet Enterprise 3.2, Puppet would truncate the exit codes of `exec` resources if they were over 255. (For example, an exit code of 3090 would be reported as 194 --- i.e. 3090 mod 256.) In 3.4 and later, exit codes are reported accurately.
