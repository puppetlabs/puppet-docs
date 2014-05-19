---
layout: default
title: "Writing Manifests for Windows"
---

<span class="versionnote">This documentation applies to Puppet ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>

[modules]: /puppet/latest/reference/modules_fundamentals.html
[manifests]: /learning/manifests.html
[lang]: /puppet/latest/reference/lang_summary.html

[file]: /references/latest/type.html#file
[user]: /references/latest/type.html#user
[group]: /references/latest/type.html#group
[scheduledtask]: /references/latest/type.html#scheduledtask
[package]: /references/latest/type.html#package
[service]: /references/latest/type.html#service
[exec]: /references/latest/type.html#exec
[host]: /references/latest/type.html#host


Just as on \*nix systems, Puppet manages resources on Windows using manifests written in the [Puppet language][lang]. There are several major differences to be aware of when writing manifests that manage Windows resources:

* Windows primarily uses the backslash as its directory separator character, and Ruby handles it differently in different circumstances. You should **learn when to use and when to avoid backslashes.**
* Most classes written for \*nix systems will not work on Windows nodes; if you are managing a mixed environment, you should **use conditionals and Windows-specific facts** to govern the behavior of your classes.
* Puppet generally does the right thing with Windows line endings.
* Puppet supports a slightly different set of resource types on Windows.




Notable Windows Facts
-----

Windows nodes with a default install of Puppet will return the following notable facts, which can be useful when writing manifests:

### Identifying Facts

The following facts can help you determine whether a given machine is running Windows:

* `kernel => windows`
* `operatingsystem => windows`
* `osfamily => windows`

### Windows-Specific Facts

The following facts are either Windows-only, or have different values on Windows than on \*nix:

* `env_windows_installdir` --- This fact will contain the directory in which Puppet was installed.
* `id` --- This fact will be `<DOMAIN>\<USER NAME>`. You can use the user name to determine whether Puppet is running as a service or was triggered manually.


Line Endings in Windows Text Files
-----

Windows uses CRLF line endings instead of \*nix's LF line endings.

* If the contents of a file are specified with the `content` attribute, Puppet will write the content in "binary" mode. To create files with CRLF line endings, the `\r\n` escape sequence should be specified as part of the content.
* If a file is being downloaded to a Windows node with the `source` attribute, Puppet will transfer the file in "binary" mode, leaving the original newlines untouched.
* Non-`file` resource types that make partial edits to a system file (most notably the [`host`](/references/latest/type.html#host) type, which manages the `%windir%\system32\drivers\etc\hosts` file) manage their files in text mode, and will automatically translate between Windows and \*nix line endings.

    > Note: When writing your own resource types, you can get this behavior by using the `flat` filetype.


Core Resource Types
-----

By default, Puppet can manage the following resource types on Windows nodes:


### [`scheduled_task`][scheduledtask]

{% highlight ruby %}
    scheduled_task { 'Daily task':
      ensure    => present,
      enabled   => true,
      command   => 'C:\path\to\command.exe',
      arguments => '/flags /to /pass',
      trigger   => {
        schedule   => daily,
        every      => 2,            # Defaults to 1
        start_date => '2011-08-31', # Defaults to 'today'
        start_time => '08:00',      # Must be specified
      }
    }
{% endhighlight %}

Puppet can create, edit, and delete scheduled tasks. It can manage the task name, the enabled/disabled status, the command, any arguments, the working directory, the user and password, and triggers. For more information, see [the reference documentation for the `scheduled_task` type][scheduledtask]. This is a Windows-only resource type.

* Puppet does not support "every X minutes" type triggers.



### [`service`][service]

{% highlight ruby %}
    service { 'mysql':
      ensure => 'running',
      enable => true,
    }
{% endhighlight %}

Puppet can start, stop, enable, disable, list, query and configure services. It does not support configuring service dependencies, account to run as, or desktop interaction.

* Use the short service name (e.g. `wuauserv`) in Puppet, not the display name (e.g. `Automatic Updates`).
* Setting the `enable` attribute to `true` will assign a service the "Automatic" startup type; setting `enable` to `manual` will assign the "Manual" startup type.

### [`exec`][exec]

Puppet can execute binaries (exe, com, bat, etc.), and can log the child process output and exit status.

* If an extension for the `command` is not specified (for example, `ruby` instead of `ruby.exe`), Puppet will use the `PATHEXT` environment variable to resolve the appropriate binary. `PATHEXT` is a Windows-specific variable that lists the valid file extensions for executables.
* Puppet does not support a shell provider for Windows, so if you want to execute shell built-ins (e.g. `echo`), you must provide a complete `cmd.exe` invocation as the command. (For example, `command => 'cmd.exe /c echo "foo"'`.) However, a Powershell provider is available as a plugin; [see "Plugin Resource Types" below](#plugin-resource-types).
* When executing inline Powershell scripts, you must specify the `remotesigned` execution policy as part of the `powershell.exe` invocation:

{% highlight ruby %}
    exec { 'test':
      command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
    }
{% endhighlight %}

> #### Version Note: Exit Code Problems Prior to Puppet 3.4
>
> Before Puppet 3.4, Puppet would truncate the exit codes of `exec` resources if they were over 255. (For example, an exit code of 3090 would be reported as 194 --- i.e. 3090 mod 256.) In 3.4 and later, exit codes are reported accurately.

### [`host`][host]

Puppet can manage entries in the hosts file in the same way that is supported on Unix platforms.


Plugin Resource Types
-----

In addition to the resource types included with Puppet's core, you can install custom resource types as Puppet modules from [the Puppet Forge](http://forge.puppetlabs.com). This can let you manage other types of resources that are specific to Windows.

**Note that plugins from the Puppet Forge may not have the same amount of QA and test coverage as Puppet's core types.**

The best way to find new resource types is by [searching for "windows" on the Puppet Forge](http://forge.puppetlabs.com/modules?sort=rank&q=windows&pop) and exploring the results. You may also want to start with these modules:

* [puppetlabs/registry](http://forge.puppetlabs.com/puppetlabs/registry) --- A resource type for managing arbitrary registry keys.
* [puppetlabs/reboot](http://forge.puppetlabs.com/puppetlabs/reboot) --- A resource type for managing conditional reboots, which may be necessary for installing certain software.
* [puppetlabs/dism](http://forge.puppetlabs.com/puppetlabs/dism) --- A resource type for enabling and disabling Windows features (on Windows 7/2008 R2 and newer).
* [joshcooper/powershell](http://forge.puppetlabs.com/joshcooper/powershell) --- An alternate `exec` provider that can directly execute powershell commands.

