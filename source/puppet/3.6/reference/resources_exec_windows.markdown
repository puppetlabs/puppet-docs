---
layout: default
title: "Resource Tips and Examples: Exec on Windows"
toc: false
---

[package]: /references/3.6.latest/type.html#package
[exec]: /references/3.6.latest/type.html#exec


Puppet can execute binaries (exe, com, bat, etc.), and can log the child process output and exit status.

Since Puppet uses the same [`exec`][exec] resource type on both \*nix and Windows systems, there are a few Windows-specific caveats to keep in mind:

* If an extension for the `command` is not specified (for example, `ruby` instead of `ruby.exe`), Puppet will use the `PATHEXT` environment variable to resolve the appropriate binary. `PATHEXT` is a Windows-specific variable that lists the valid file extensions for executables.
* Windows allows negative exit codes in some odd cases, but the `exec` type doesn't recognize them and will display a very large positive number instead.
* Puppet does not support a shell provider for Windows, so if you want to execute shell built-ins (e.g. `echo`), you must provide a complete `cmd.exe` invocation as the command. (For example, `command => 'cmd.exe /c echo "foo"'`.) However, a Powershell provider is available as a plugin; [see "Optional Resource Types for Windows"](./resources_windows_optional.html).
* When executing inline Powershell scripts, you must specify the `remotesigned` execution policy as part of the `powershell.exe` invocation:

{% highlight ruby %}
    exec { 'test':
      command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
    }
{% endhighlight %}


## Errata

### Known Issues Prior to Puppet 3.4 / PE 3.2

Before Puppet 3.4 / Puppet Enterprise 3.2, Puppet would truncate the exit codes of `exec` resources if they were over 255. (For example, an exit code of 3090 would be reported as 194 --- i.e. 3090 mod 256.) In 3.4 and later, exit codes are reported accurately.
