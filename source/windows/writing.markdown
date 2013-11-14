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


File Paths on Windows
-----

Windows file paths must be written in different ways at different times, due to various tools' conflicting rules for backslash use.

* Windows file system APIs accept both the backslash (`\`) and forwardslash (`/`) to separate directory and file components in a path.
* Some Windows programs only accept backslashes in file paths.
* \*nix shells and many programming languages --- including the Puppet language --- use the backslash as an [escape character](http://en.wikipedia.org/wiki/Escape_character).

As a result, any system that interacts with \*nix and Windows systems as equal peers will unavoidably have complicated behavior around backslashes.

The following guidelines will help you use backslashes safely in Windows file paths with Puppet.

### Forward Slashes vs. Backslashes

In many cases, you can use forward slashes instead of backslashes when specifying file paths.

Forward slashes **MUST** be used:

* In template paths passed to the `template` function. For example:

        file {'C:/warning.txt':
          ensure  => present,
          content => template('my_module/warning.erb'),
        }
* In Puppet URLs in a [`file`][file] resource's `source` attribute.

* When part of the `modulepath` configuration option, e.g. `puppet apply --modulepath="Z:/path/to/my/modules" "Z:/path/to/my/site.pp"` (This restriction applies only to versions of Puppet prior to 3.0.)

Forward slashes **SHOULD** be used in:

* The title or `path` attribute of a [`file`][file] resource
* The `source` attribute of a [`package`][package] resource
* Local paths in a [`file`][file] resource's `source` attribute
* The `command` of an [`exec`][exec] resource, unless the executable requires backslashes, e.g. cmd.exe

Forward slashes **MUST NOT** be used in:

* The `command` of a [`scheduled_task`][scheduledtask] resource.
* The `install_options` of a [`package`][package] resource.

#### The Rule

If Puppet itself is interpreting the file path, forward slashes are okay. If the file path is being passed directly to a Windows program, forward slashes may not be okay.

### Using Backslashes in Double-Quoted Strings

Puppet supports two kinds of string quoting. Strings surrounded by double quotes (`"`) allow variable interpretation and many escape sequences (including the common `\n` for a newline), so care must be taken to prevent backslashes from being mistaken for escape sequences.

When using backslashes in a double-quoted string, **you must always use two backslashes** for each literal backslash. There are no exceptions and no special cases.

### Using Backslashes in Single-Quoted Strings

Strings surrounded by single quotes (`'`) do not allow variable interpretation, and the only escape sequences permitted are `\'` (a literal single quote) and `\\` (a literal backslash).

Lone backslashes can usually be used in single-quoted strings. However:

* When a backslash occurs at the very end of a single-quoted string, a double backslash must be used instead of a single backslash. For example: `path => 'C:\Program Files(x86)\\'`
* When a literal double backslash is intended, a quadruple backslash must be used.

#### The Rule

In single-quoted strings:

* A double backslash always means a literal backslash.
* A single backslash usually means a literal backslash, unless it is followed by a single quote or another backslash.



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


Resource Types
-----

Puppet can manage the following resource types on Windows nodes:

### [`file`][file]

{% highlight ruby %}
    file { 'c:/mysql/my.ini':
      ensure => 'file',
      mode   => '0660',
      owner  => 'mysql',
      group  => 'Administrators',
      source => 'N:/software/mysql/my.ini',
    }
{% endhighlight %}

Puppet can manage files and directories, including owner, group, permissions, and content. Symbolic links are supported in Puppet 3.4.0 and later on Windows 2008 / Vista and later; for details, [see the notes in the type reference under `file`'s `ensure` attribute](/references/3.latest/type.html#file-attribute-ensure).

#### Naming Files

* Windows NTFS filesystems are case-preserving, but case-insensitive; Puppet is case-sensitive. Thus, you should be consistent in the case you use when referring to a file resource in multiple places in a manifest.

#### Required User Permissions

By default, Puppet's installer sets puppet agent to run as the Administrator user. If you want to run it as a different user (see ["Automated Installation" in the installing page](./installing.html#automated-installation)), you must ensure Puppet has the following permissions:

* In order to manage files that it does not own, Puppet must be running as a member of the local Administrators group (on Windows 2003) or with elevated privileges (Windows 7 and 2008). This gives Puppet the `SE_RESTORE_NAME` and `SE_BACKUP_NAME` privileges it requires to manage file permissions.
* To manage symlinks, Puppet's user also needs the "Create Symbolic Links" privilege, which the Administrators group has by default.

#### Managing File Permissions

* Permissions modes are set as though they were \*nix-like octal modes; Puppet translates these to the equivalent access controls on Windows.
    * The read, write, and execute permissions translate to the `FILE_GENERIC_READ`, `FILE_GENERIC_WRITE`, and `FILE_GENERIC_EXECUTE` access rights.
    * The owner of a file/directory always has the `FULL_CONTROL` access right.
    * The `Everyone` SID is used to represent users other than the owner and group.
* Puppet cannot set permission modes where the group has higher permissions than the owner, or other users have higher permissions than the owner or group. (That is, 0640 and 0755 are supported, but 0460 is not.) Directories on Windows can have the sticky bit, which makes it so users can only delete files if they own the containing directory.
* On Windows, the owner of a file can be a group (e.g. `owner => 'Administrators'`) and the group of a file can be a user (e.g. `group => 'Administrator'`). The owner and group can even be the same, but as that can cause problems when the mode gives different permissions to the owner and group (like `0750`), this is not recommended.
* Puppet does not currently manage ACLs on Windows, but Puppet Labs and the Puppet community are collaborating on a design for managing them as a new resource type. [See the in-progress ACLs proposal for more details.](https://github.com/puppetlabs/armatures/blob/master/arm-16.acls/index.md)
* When downloading a file from a puppet master with a `puppet:///` URI, Puppet will set the permissions mode to match that of the remote file. Be sure to set the proper mode on any remote files.

#### File Sources

* The `source` attribute of a file can be a puppet URL, a local path, or a path to a file on a mapped drive.

> #### Known Issues in Older Puppet Versions: pre-3.4.0
>
> * Prior to Puppet 3.4.0, if an `owner` or `group` are specified for a file, **you must also specify a `mode`.** Failing to do so can render a file inaccessible to Puppet. [See here for more details](./troubleshooting.html#file-pre-340).

### [`user`][user]

Puppet can create, edit, and delete local users. Puppet does not support managing domain user accounts, but can add (and remove) domain user accounts to local groups (in Puppet 3.4.0 and later).

* The `comment`, `home`, and `password` attributes can be managed, as well as groups to which the user belongs.
* Passwords can only be specified in cleartext. Windows does not provide an API for setting the password hash.
* The user SID is available as a read-only parameter. Attempting to set the parameter will fail
* User names are case-sensitive in Puppet manifests, but insensitive on Windows. Make sure to consistently use the same case in manifests.

#### Security Identifiers (SID)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544`. When comparing two account names, puppet always first transforms account names into their canonical SID form and compares the SIDs instead.


### [`group`][group]

Puppet can create, edit, and delete local groups, and can manage a group's members. Puppet does not support managing domain group accounts, but a local group can include both local and domain users as members.

* The group SID is available as a read-only parameter. Attempting to set the parameter will fail.
* Group names are case-sensitive in puppet manifests, but insensitive on Windows. Make sure to consistently use the same case in manifests.
* Group members can be users or groups. **However**, this is only supported in Puppet 3.4.0 and later.

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

When managing packages on Windows, you **must** specify a package file using the `source` attribute. The source can be a local file, a file on a mapped network drive, or a UNC path. Puppet URLs are not currently supported for the `package` type's `source` attribute, although you can use `file` resources to copy packages to the local system.

#### Examples

MSI example:

{% highlight ruby %}
    package { 'mysql':
      ensure          => '5.5.16',
      source          => 'N:/packages/mysql-5.5.16-winx64.msi',
      install_options => [ { 'INSTALLDIR' => 'C:\mysql-5.5' } ],
    }
{% endhighlight %}

Self-extracting EXE example:

{% highlight ruby %}
    package { "Git version 1.8.4-preview20130916":
     ensure   => installed,
     source   => 'C:\\code\\puppetlabs\\temp\\windowsexample\\Git-1.8.4-preview20130916.exe',
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

The Windows package provider also supports package-specific `install_options` (e.g. install directory) and `uninstall_options`. These options will vary across packages, so you'll need to see the documentation for the specific package you're installing. Options are specified as an array of hashes and/or strings. (MSI properties can be specified as hashes, with the name of the property as the key; you should use one hash per property. Command line flags to executable installers can be specified as strings, with one string per flag.)

Any file path arguments within the `install_options` attribute (such as `INSTALLDIR`) should use backslashes, not forward slashes. Be sure to escape your backslashes appropriately.

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
* Puppet does not support a shell provider for Windows, so if you want to execute shell built-ins (e.g. `echo`), you must provide a complete `cmd.exe` invocation as the command. (For example, `command => 'cmd.exe /c echo "foo"'`.)
* When executing Powershell scripts, you must specify the `remotesigned` execution policy as part of the `powershell.exe` invocation:

{% highlight ruby %}
    exec { 'test':
      command => 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
    }
{% endhighlight %}



### [`host`][host]

Puppet can manage entries in the hosts file in the same way that is supported on Unix platforms.
