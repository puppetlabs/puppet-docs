---
layout: default
title: "Overview of Puppet on Windows"
---




[running]: ./running.html
[troubleshooting]: ./troubleshooting.html
[downloads]: http://downloads.puppetlabs.com/windows


**Puppet runs on Microsoft Windows® and can manage Windows systems alongside \*nix systems.** This page will help get you oriented and ready to manage Windows systems with Puppet.

General Notes
-----

Windows systems can:

* Run the puppet agent service, to fetch configurations from a \*nix puppet master and apply them.
* Run the puppet apply command, to locally compile and apply configurations.

They can't act as a puppet master server.

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

### Puppet Subcommands and Services

Windows nodes can run the following Puppet subcommands:

* **Puppet agent,** to fetch configurations from a puppet master and apply them
    * The agent functions as a standard Windows service, and agent runs can also be triggered manually.
    * Windows nodes can connect to any *nix puppet master server running Puppet 2.7.6 or higher.
* **Puppet apply,** to apply configurations from local manifest files
* **Puppet resource,** to directly manipulate system resources

Because the installer doesn't alter the system's PATH variable, you must choose *Start Command Prompt with Puppet* from the Start menu to run Puppet commands manually.

Windows nodes can't act as puppet masters or certificate authorities, and most of the ancillary Puppet subcommands aren't supported on Windows.

### Puppet's Environment on Windows

* Puppet runs as a 32-bit process.
* Puppet has to run with elevated privileges; on systems with UAC, it will request explicit elevation even when running as a member of the local Administrators group.
* Puppet's configuration and data are stored in `%ALLUSERSPROFILE%\Application Data\PuppetLabs` on Windows 2003, and in `%PROGRAMDATA%\PuppetLabs` on Windows 7 and 2008.


### More

For full details, see [Running Puppet on Windows][running].


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

Troubleshooting
-----

The most common points of failure on Windows systems aren't the same as those on *nix. For full details, see [Troubleshooting Puppet on Windows][troubleshooting].

