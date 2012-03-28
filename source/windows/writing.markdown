---
layout: pe2experimental
title: "Writing Manifests for Windows"
nav: windows.html
---

<span class="versionnote">This documentation applies to Puppet ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>

[modules]: /puppet/2.7/reference/modules_fundamentals.html
[manifests]: /learning/manifests.html
[lang]: /guides/language_guide.html

[file]: /references/latest/type.html#file
[user]: /references/latest/type.html#user
[group]: /references/latest/type.html#group
[scheduled_task]: /references/latest/type.html#scheduled_task
[package]: /references/latest/type.html#package
[service]: /references/latest/type.html#service
[exec]: /references/latest/type.html#exec
[host]: /references/latest/type.html#host


Just as on \*nix systems, Puppet manages resources on Windows using manifests written in the [Puppet language][lang]. There are several major differences to be aware of when writing manifests that manage Windows resources:

* Windows uses the backslash as its directory separator character, and Ruby handles it differently in different circumstances. You should **learn when to use and when to avoid backslashes.**
* Most classes written for \*nix systems will not work on Windows nodes; if you are managing a mixed environment, you should **use conditionals and Windows-specific facts** to govern the behavior of your classes. 
* Puppet generally does the right thing with Windows line endings.
* Puppet supports a slightly different set of resource types on Windows.


File Paths on Windows
-----

Windows uses the backslash (`\`) as its directory separator character. Unfortunately, \*nix shells and many programming languages --- including the Puppet language --- use the backslash as an [escape character](http://en.wikipedia.org/wiki/Escape_character). The results are unavoidably complicated when using a system that interacts with \*nix and Windows systems as equal peers. 

The following guidelines will help you use backslashes safely in Windows file paths.

### Forward Slashes vs. Backslashes

In many cases, you can use forward slashes instead of backslashes when specifying file paths.

Forward slashes **MUST** be used in:

* Template paths passed to the `template` function. For example:

        file {'C:/warning.txt':
          ensure  => present,
          content => template('my_module/warning.erb'),
        }
* Puppet URLs in a [`file`][file] resource's `source` attribute.

Forward slashes **MAY** be used in:

* The title or `path` attribute of a [`file`][file] resource
* The `source` attribute of a [`package`][package] resource
* Local paths in a [`file`][file] resource's `source` attribute

Forward slashes **MUST NOT** be used in:

* The `command` of an [`exec`][exec] resource. <!-- TODO double-check this -->
* The `command` of a [`scheduled_task`][scheduled_task] resource.
* The `install_options` of a [`package`][package] resource.

#### The Rule

If Puppet itself is interpreting the file path, forward slashes are okay. If the file path is being passed directly to a Windows tool, forward slashes are not okay.

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
* `id` --- This fact will be `<HOSTNAME>\<USER NAME>`. You can use the user name to determine whether Puppet is running as a service or was triggered manually.


Line Endings in Windows Text Files
-----

Windows uses CRLF line endings instead of \*nix's LF line endings. However, in text files managed by Puppet, line endings generally behave as expected.

* If the contents of a file are specified with the `content` attribute, Puppet will automatically convert standard Unix newlines (`\n` or a literal line break) in the manifest or template to Windows newlines. <!-- TODO CHECK THIS, it may be wrong. -->
* If a file is being downloaded to a Windows node with the `source` attribute, Puppet will transfer the file in "binary" mode, leaving the original newlines untouched.



Resource Types
-----

Puppet can manage the following resource types on Windows nodes:

### [`file`][file]

{% highlight ruby %}
    file { 'c:/mysql/my.ini':
      ensure => 'file',
      mode => '0660',
      owner => 'mysql',
      group => 'Administrators',
      source => 'N:/software/mysql/my.ini',
    }
{% endhighlight %}

Puppet can manage files and directories, including owner, group, permissions, and content. Symbolic links are not supported. 

* Windows NTFS filesystems are case-preserving, but case-insensitive; Puppet is case-sensitive. Thus, you should be consistent in the case you use when referring to a file resource in multiple places in a manifest. 
* In order to manage files that it does not own, Puppet must be running as a member of the local Administrators group (on Windows 2003) or with elevated privileges (Windows 7 and 2008). This gives Puppet the `SE_RESTORE_NAME` and `SE_BACKUP_NAME` privileges it requires to manage file permissions.
* Permissions modes are set as though they were \*nix-like octal modes; Puppet translates these to the equivalent access controls on Windows.
    * The read, write, and execute permissions translate to the `FILE_GENERIC_READ`, `FILE_GENERIC_WRITE`, and `FILE_GENERIC_EXECUTE` access rights.
    * The owner of a file/directory always has the `FULL_CONTROL` access right.
    * The `Everyone` SID is used to represent users other than the owner and group.
* Puppet cannot set permission modes where the group has higher permissions than the owner, or other users have higher permissions than the owner or group. (That is, 0640 and 0755 are supported, but 0460 is not.) Directories on Windows can have the sticky bit, which makes it so users can only delete files if they own the containing directory.
* On Windows, the owner of a file can be a group (e.g. `owner => 'Administrators'`) and the group of a file can be a user (e.g. `group => 'Administrator'`). The owner and group can even be the same, but as that can cause problems when the mode gives different permissions to the owner and group (like `0750`), this is not recommended.
* The source of a file can be a puppet URL, a local path, or a path to a file on a mapped drive. 


### [`user`][user]

Puppet can create, edit, and delete local users. Puppet does not support managing domain user accounts. 

* The `comment`, `home`, and `password` attributes can be managed, as well as groups to which the user belongs.
* Passwords can only be specified in cleartext. Windows does not provide an API for setting the password hash.
* The user SID is available as a read-only parameter. Attempting to set the parameter will fail
* User names are case-sensitive in Puppet manifests, but insensitive on Windows. Make sure to consistently use the same case in manifests.

#### Security Identifiers (SID)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544`. When comparing two account names, puppet always first transforms account names into their canonical SID form and compares the SIDs instead.


### [`group`][group]

Puppet can create, edit, and delete local groups, and can manage a group's members. Puppet does not support managing domain group accounts.

* The group SID is available as a read-only parameter. Attempting to set the parameter will fail.
* Group names are case-sensitive in puppet manifests, but insensitive on Windows (#9506). Make sure to consistently use the same case in manifests.
* Nested groups are not supported. (Group members must be users, not other groups.)

### [`scheduled_task`][scheduled_task]

{% highlight ruby %}
    scheduled_task { 'Daily task':
      ensure    => present,
      enabled   => true,
      command   => 'C:\path\to\command.exe',
      arguments => '/flags /to /pass',
      trigger   => {
        schedule   => daily,
        every      => 2             # Defaults to 1
        start_date => '2011-08-31', # Defaults to 'today'
        start_time => '08:00',      # Must be specified
      }
    }
{% endhighlight %}

Puppet can create, edit, and delete scheduled tasks. It can manage the task name, the enabled/disabled status, the command, any arguments, the working directory, the user and password, and triggers. For more information, see [the reference documentation for the `scheduled_task` type][scheduled_task]. This is a Windows-only resource type.

* Puppet does not support "every X minutes" type triggers.


### [`package`][package]

{% highlight ruby %}
    package { 'mysql':
      ensure          => installed,
      provider        => 'msi',
      source          => 'N:/packages/mysql-5.5.16-winx64.msi',
      install_options => { 'INSTALLDIR' => 'C:\mysql-5.5' },
    }
{% endhighlight %}

Puppet can install and remove MSI packages, including specifying package-specific install options, e.g. install directory.

* The source parameter is required, and must refer to a local .msi file or a file from a mapped drive. You can distribute packages as `file` resources. Puppet URLs are not currently supported for the `package` type's `source` attribute.
* The `install_options` attribute is package-specific; refer to the documentation for the package you are trying to install. 
    * Any file path arguments within the `install_options` attribute (such as `INSTALLDIR`) should use backslashes, not forward slashes. 
* Currently, Puppet can only manage packages that it installed.

### [`service`][service]

{% highlight ruby %}
    service { 'mysql':
      ensure => 'running',
      enable => true,
    }
{% endhighlight %}

Puppet can start, stop, enable, disable, list, query and configure services. It does not support configuring service dependencies, account to run as, or desktop interaction.

* Use the short service name (e.g. `wuauserv`) in Puppet, not the display name (e.g. `Automatic Updates`).

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
