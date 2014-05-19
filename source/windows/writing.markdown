---
layout: default
title: "Writing Manifests for Windows"
nav: windows.html
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


### [`package`][package]

Puppet can install and remove two types of packages on Windows:

* MSI packages
* Executable installers

Both of these use the default `windows` package provider. (There is an older `msi` provider included, but it is deprecated as of Puppet 3.0.)

When managing packages using the `windows` package provider, you **must** specify a package file using the `source` attribute. The source can be a local file, a file on a mapped network drive, or a UNC path. Puppet URLs are not currently supported for the `package` type's `source` attribute, although you can use `file` resources to copy packages to the local system.

#### Examples

MSI example:

{% highlight ruby %}
    package { 'mysql':
      ensure          => '5.5.16',
      source          => 'N:\packages\mysql-5.5.16-winx64.msi',
      install_options => ['INSTALLDIR=C:\mysql-5.5'],
    }
{% endhighlight %}

Executable installer example:

{% highlight ruby %}
    package { "Git version 1.8.4-preview20130916":
     ensure          => installed,
     source          => 'C:\code\puppetlabs\temp\windowsexample\Git-1.8.4-preview20130916.exe',
     install_options => ['/VERYSILENT']
    }
{% endhighlight %}

#### Package Names

The title (or `name`) of the package must match the value of the package's `DisplayName` property in the registry, which is also the value displayed in the "Add/Remove Programs" or "Programs and Features" control panel. If the provided name and installed name don't match, Puppet will believe the package is not installed and try to install it again.

The easiest way to copy a package's name is to:

* Install the package on an example system
* Run `puppet resource package` to see a list of installed packages
* Locate the package you just installed, and copy the name that `puppet resource` reported for it

Some packages (Git is a notable example) will change their display names with every version released. In these cases, you must update the name or title whenever you change the package `source`.

#### Install and Uninstall Options

The Windows package provider also supports package-specific `install_options` (e.g. install directory) and `uninstall_options`. These options will vary across packages, so you'll need to see the documentation for the specific package you're installing. Options are specified as an array of strings and/or hashes.

MSI properties can be specified as an array of strings following the 'property=key' pattern; you should use one string per property. Command line flags to executable installers can be specified as an array of strings, with one string per flag.

Any file path arguments within the `install_options` attribute (such as `INSTALLDIR`) should use backslashes, not forward slashes. Be sure to escape your backslashes appropriately. It's a good idea to use the hash notation for file path arguments since they may contain spaces, for example:

{% highlight ruby %}
install_options => [ '/S', { 'INSTALLDIR' => "${packagedir}" } ]
{% endhighlight %}

#### Versioning and Upgrades

The Windows package provider is versionable (as of Puppet 3.4.0). This means the `ensure => 'version'` syntax may be used, where `'version'` may be an identifier like `'1.2.3.4'`.  Note that this version string must exactly match what the package file reports itself as; if it does not, Puppet will determine the package is out of date and will attempt to reinstall. You can use `puppet resource package` to see the currently reported versions for all packages on a given system.

Versioning can interact with the package name, since some packages (Git, e.g.) change their DisplayName with each version. Thus, in practice, you'll need a combination of two ways to handle versions:

* If a package's name is the same for all versions and you want to change the version you're managing on your nodes, change the source file and set `ensure => 'new version'` on the resource.
* If a package's name changes with each version, change the source file and update the resource's title or `name` to the new name. You can leave `ensure` set to `present`; Puppet will upgrade the package if the installed name doesn't match the desired one.

Finally: Setting `ensure => latest` (which requires the `upgradeable` feature) doesn't work on Windows, as it doesn't support the sort of central package repositories you see on most Linuxes.

> #### Versioning Workarounds in pre-3.4.0
>
> Prior to Puppet 3.4.0, you couldn't specify package versions in the `ensure` attribute. This meant that upgrades worked fine for packages that changed their name with every version, but there wasn't an easy way to upgrade packages with stable names.
>
> A workaround was to specify the package's PackageCode as the name/title, instead of using the DisplayName. The PackageCode is a GUID that's unique per MSI file. To find the PackageCode from an MSI, you can use Orca, or you can get to it programmatically with Ruby:
>
> 	require 'win32ole'
> 	installer = WIN32OLE.new('WindowsInstaller.Installer')
> 	db = installer.OpenDatabase(path, 0) # where 'path' is the path to the MSI
> 	puts db.SummaryInformation.Property(9)


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

