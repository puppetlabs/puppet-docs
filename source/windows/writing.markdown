---
layout: pe2experimental
title: "Writing Manifests for Windows"
nav: windows.html
---

<span class="versionnote">This documentation applies to Puppet ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>


**Puppet manages Windows nodes with Puppet manifests,** the same way it manages \*nix nodes. In the most common agent/master arrangement, these manifests are maintained on a puppet master server, which compiles them on request and serves the resulting catalogs to agent nodes. (Windows nodes can also compile their own configurations with the puppet apply subcommand.) 

Manifests that define Windows configurations **use the same Puppet language** as those meant for \*nix systems. The same modules can even be used



However, there are several differences. In summary, manifests 


## Overview

The 2.7.6 release of puppet adds support for running puppet agents on Microsoft Windows platforms. The scope of work completed includes the following:

* The following puppet applications:
    * apply
    * agent
    * resource
    * inspect
* Managing the following resource types: 
    * file
    * user
    * group
    * scheduled_task (new type; not cron)
    * package (MSI)
    * service
    * exec
    * host

Running a puppet master on Windows is not supported, nor are there plans to support it.

## Usage

This section describes the types of resources that can be managed using Puppet.

### file

Puppet can manage files and directories, including owner, group, permissions, and content. Symbolic links are not supported. For more information, see #8411, #9186, and #9938. Windows NTFS filesystems are case-preserving, but case-insensitive. So make sure to use the same case within a puppet manifest, and it is recommended that you always use forward slashes as the file separator character.


{% highlight ruby %}
    file { 'c:/mysql/my.ini':
      ensure => 'file',
      mode => '0660',
      owner => 'mysql',
      group => 'Administrators',
      source => 'N:/software/mysql/my.ini',
    }
{% endhighlight %}

In order to manage files that it does not own, puppet must be running as a member of the local Administrators group (on 2003) or with elevated privileges (2008). In doing so, puppet will be able to enable the `SE_RESTORE_NAME` and `SE_BACKUP_NAME` privileges that it requires to manage file permissions.

Puppet only supports modes where the owner permissions are a superset of the group, which is a superset of other. So 0640 and 0755 are supported, but 0460 is not. The sticky bit is supported for directories, so users can only delete files from a directory that they own.

On Windows, the owner of a securable object can be a group, e.g. owner => Administrators, and the group of a securable object can be a user, e.g. group => 'Administrator'. And the owner and group can be the same, but that can cause problems if you specify a mode where the owner and group classes are different, e.g. 0750, as puppet will map that to 0770, and report that the modes are out of sync each time it runs. For this reason, it is recommended that you don't set the owner and group to the same account.

The owner of a file/directory always has `FULL_CONTROL`. The modes for group and other classes are roughly mapped to `FILE_GENERIC_READ`, `FILE_GENERIC_WRITE`, `FILE_GENERIC_EXECUTE` access rights. The owner and group names are mapped to Windows SIDs and used when getting/setting the object's DACL. The 'Everyone' SID is used to represent the other class.

The source of a file can either be a local path, mapped drive, or puppet URL. In the latter case, puppet will apply a default owner, group and mode to files it sources from remote puppet masters.

Puppet manages file resources in binary mode on Windows. So it will not add '\r\n' line endings. If you require this, then you can add them explicitly in the content parameter or in the file from which puppet is sourcing.

### user

Puppet can create, edit, and delete local users. Puppet does not support managing domain user accounts. The comment, home, and password parameters can be managed, as well as groups the user is a member of. 
Passwords can only be specified in cleartext. Windows does not provide an API for setting the password hash.

The user SID is available as a read-only parameter. Attempting to set the parameter will fail (#11733)

User names are case-sensitive in puppet manifests, but insensitive on Windows (#9506). Make sure to consistently use the same case in manifests.

#### Security Identifiers (SID)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544`. When comparing two account names, puppet always first transforms account names into their canonical SID form and compares the SIDs instead.


### group

Puppet can create, edit, and delete local groups, and can manage the groups members. Puppet does not support managing domain group accounts.

The group SID is available as a read-only parameter. Attempting to set the parameter will fail (#11733)

Group names are case-sensitive in puppet manifests, but insensitive on Windows (#9506). Make sure to consistently use the same case in manifests.

Nested groups are not supported (group members must be users, not other groups)

### scheduled_task

Puppet can create, edit, and delete scheduled tasks. This includes the task name, enabled/disabled, command, arguments, working directory, user and password, and triggers. For more information, see #8414.

Puppet also uses v1.0 of Windows task scheduler interfaces, which constrains the set of supported trigger types. Specifically, puppet does not support "every X minutes" type triggers.


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

Make sure you are using version 0.2.1 or later of win32-taskscheduler gem. Otherwise, you may receive errors like the following:


    err: /Stage[main]//Scheduled_task[task_system]: Could not evaluate: The operation completed successfully.


### package

Puppet can install and remove MSI packages, including specifying package-specific install options, e.g. install directory. For more information, see #8412. The source parameter is required, and must refer to a local file, or a file from a mapped drive, from which puppet can install the package. Puppet URLs are not currently supported (see #11865).


{% highlight ruby %}
    package { 'mysql':
      ensure => installed,
      provider => 'msi',
      source => 'N:/packages/mysql-5.5.16-winx64.msi',
      install_options => { 'INSTALLDIR' => 'C:\mysql-5.5' },
    }
{% endhighlight %}

Note, the msi package provider uses msiexec to install packages. Any file-based arguments within the `install_options` parameter, e.g. INSTALLDIR, should use backslashes to msiexec. Using forward slashes confuses msiexec.

Currently, puppet can only manage packages that it installed. See #11868.

### service

Puppet can start, stop, enable, disable, list, query and configure services. It does not support configuring service dependencies, account to run as, or desktop interaction. For more information, see #8272.


{% highlight ruby %}
    service { 'mysql':
      ensure => 'running',
      enable => true,
    }
{% endhighlight %}

Use the short service name in puppet, e.g. wuauserv, not the display name, e.g. Automatic Updates

### exec

Puppet can execute binaries (exe, com, bat, etc) returning the child process output and exit status. If an extension is not specified, e.g. ruby, then puppet will use the PATHEXT environment variable to resolve the appropriate binary. For more information, see #8410.

Puppet does not support a shell provider, so if you want to execute shell built-ins, e.g. echo, then use 'cmd.exe /c echo "foo"'

By default, powershell enforces a `restricted` execution policy which prevents the execution of scripts. As such, make sure to specify the appropriate execution policy in the powershell command:


{% highlight ruby %}
    exec { 'test':
      command => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -executionpolicy remotesigned -file C:/test.ps1',
    }
{% endhighlight %}

### host

Puppet can manage the host file in the same way that is supported on Unix platforms. For more information, see #8644.
