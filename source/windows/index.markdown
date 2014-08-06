---
layout: default
title: "Overview of Puppet on Windows"
---




[troubleshooting]: ./troubleshooting.html
[downloads]: http://downloads.puppetlabs.com/windows

[win_commands]: /puppet/latest/reference/services_commands_windows.html
[win_agent]: /puppet/latest/reference/services_agent_windows.html
[arch]: /puppet/latest/reference/architecture.html
[the confdir]: /puppet/latest/reference/dirs_confdir.html
[the vardir]: /puppet/latest/reference/dirs_vardir.html

**Puppet runs on Microsoft Windows® and can manage Windows systems alongside \*nix systems.** This page will help get you oriented and ready to manage Windows systems with Puppet.


Installing
-----

### Puppet Enterprise

To install Puppet Enterprise on Windows, [see the Puppet Enterprise manual's installation instructions.](/pe/latest/install_windows.html)

### Open Source

To install open source Puppet on Windows:

* Follow [the pre-install tasks](/guides/install_puppet/pre_install.html)
* [Download the installer][downloads]
* Follow [the installation instructions](/guides/install_puppet/install_windows.html)
* Follow [the post-install instructions](/guides/install_puppet/post_install.html#configure-a-puppet-agent-node)

Most post-install tasks are handled automatically on Windows, but you'll still need to sign the new node's certificate and assign classes to manage it.

### Supported Platforms

{% include platforms_windows.markdown %}

* * *

Running
-----

* Windows systems can run puppet agent and puppet apply, but they can't act as a puppet master server.
* Puppet runs as a 32-bit process.
* Puppet has to run with elevated privileges; on systems with UAC, it will request explicit elevation even when running as a member of the local Administrators group.
* Puppet's configuration and data are stored in different places on different Windows versions. For more details, see the Puppet reference manual pages on [the confdir][] and [the vardir][].

For more information, see:

* [Overview of Puppet's Architecture][arch], for more about puppet masters and puppet agents.
* [Running Puppet Commands on Windows][win_commands], for information on running commands interactively.
* [Puppet Agent on Windows][win_agent], for information on the puppet agent service's run environment.

* * *

Writing Manifests
-----

In general, manifests written for Windows nodes work the same way as manifests written for \*nix nodes.

### Resource Types

Some \*nix resource types aren't supported on Windows, and there are some Windows-only resource types.

The following core resource types can be managed on Windows:

* [file](/references/latest/type.html#file) ([tips for Windows](/puppet/latest/reference/resources_file_windows.html))
* [user](/references/latest/type.html#user) ([tips for Windows](/puppet/latest/reference/resources_user_group_windows.html))
* [group](/references/latest/type.html#group) ([tips for Windows](/puppet/latest/reference/resources_user_group_windows.html))
* [scheduled_task](/references/latest/type.html#scheduledtask) ([tips for Windows](/puppet/latest/reference/resources_scheduled_task_windows.html))
* [package](/references/latest/type.html#package) ([tips for Windows](/puppet/latest/reference/resources_package_windows.html))
* [service](/references/latest/type.html#service) ([tips for Windows](/puppet/latest/reference/resources_service.html))
* [exec](/references/latest/type.html#exec) ([tips for Windows](/puppet/latest/reference/resources_exec_windows.html))
* [host](/references/latest/type.html#host)

Also, there are some popular [optional resource types for Windows.](/puppet/latest/reference/resources_windows_optional.html)

### Handling File Paths

Some resource types take file paths as attributes. On Windows, there are some [special cases to take into account when writing file paths.](/puppet/latest/reference/lang_windows_file_paths.html)

### Line Endings

Windows systems generally use different line endings in text files than \*nix systems do. Puppet manifest files can use either kind of line ending.

There are a few subtleties of behavior when handling the content of managed files. For details, [see the note on line endings in the language reference.](/puppet/latest/reference/lang_summary.html#line-endings-in-windows-text-files)

### Facts

Windows nodes with a default install of Puppet will include the following notable and identifying facts, which can be useful when writing manifests:

* `kernel => windows`
* `operatingsystem => windows`
* `osfamily => windows`
* `env_windows_installdir` --- This fact will contain the directory in which Puppet was installed.
* `id` --- This fact will be `<DOMAIN>\<USER NAME>`. You can use the user name to determine whether Puppet is running as a service or was triggered manually.


* * *

Important Windows Concepts for Unix Admins
-----

Windows differs from \*nix systems in many ways, several of which affect how Puppet works.

### Security Context

On Unix, puppet is either running as root or not. On Windows, this maps to running with **elevated privileges** or not.

For more information, see the following pages in the Puppet reference manual:

* [Running Puppet Commands on Windows][win_commands], for information on running commands interactively.
* [Puppet Agent on Windows][win_agent], for information on the puppet agent service's run environment.

### File System Redirection in 64-bit Windows Versions

The Puppet agent process runs as a 32-bit process. When run on 64-bit versions of Windows, there are some issues to be aware of.

* The <a href="http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx">File System Redirector</a> will silently redirect all file system access to `%windir%\system32` to `%windir%\SysWOW64` instead. This can be an issue when trying to manage files in the system directory, e.g., IIS configuration files. In order to prevent redirection, you can use the `sysnative` alias, e.g. `C:\Windows\sysnative\inetsrv\config\application Host.config`.

    > Note: 64-bit Windows Server 2003 requires hotfix [KB942589](http://support.microsoft.com/kb/942589/en-us) to use the sysnative alias.

* The <a href="http://msdn.microsoft.com/en-us/library/aa384232(v=vs.85).aspx">Registry Redirector</a> performs a similar function with certain <a href="http://msdn.microsoft.com/en-us/library/aa384253(v=vs.85).aspx">registry keys</a>.



* * *

Troubleshooting
-----

The most common points of failure on Windows systems aren't the same as those on \*nix. For more details, see [Troubleshooting Puppet on Windows][troubleshooting].

