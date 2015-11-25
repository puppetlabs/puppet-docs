---
layout: default
title: "Overview of Puppet on Windows"
---




[troubleshooting]: ./troubleshooting.html

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

To install open source Puppet on Windows, follow the instructions on the following pages, in order:

* [Pre-install tasks](puppet/latest/reference/install_pre.html)
* [Installation instructions](puppet/latest/reference/install_windows.html)

* * *

Running
-----

* Windows systems can run puppet agent and puppet apply, but they can't act as a puppet master server.
* Puppet is available in 32- and 64-bit versions. Install the appropriate Puppet package for your version of Windows. (Note that Windows Server 2003 requires 32-bit Puppet.)
* Puppet should usually run with elevated privileges. If you want to run any of Puppet's commands interactively on systems with UAC, you'll have to start a command prompt by right-clicking and choosing "Run as administrator."
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

Some resource types take file paths as attributes. On Windows, there are some extra things to take into account when writing file paths, including directory separators. For more info, see:

* [Handling File Paths on Windows](/puppet/latest/reference/lang_windows_file_paths.html)

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

### File System Redirection (Windows Server 2003 or older versions of Puppet)

As of Puppet 3.7, the Puppet agent can run as either a 32- or a 64-bit process. This means that as long as you've installed the correct package for your version of Windows, file system redirection should no longer be an issue.

However, if you are running Windows Server 2003, which is incompatible with 64-bit Puppet, or if you are using an earlier version of Puppet, file system redirection will still affect you. Please see [Language: Handling File Paths on Windows](/puppet/latest/reference/lang_windows_file_paths.html) for how to safely handle file system redirection when running 32-bit Puppet on a 64-bit Windows system. Note that the information about file system redirection applies to extensions as well.

###Developing Extensions

If you're developing custom types and providers or writing custom facts, be aware that the <a href="http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx">File System Redirector</a> and the <a href="http://msdn.microsoft.com/en-us/library/aa384232(v=vs.85).aspx">Registry Redirector</a> will also affect these types, providers, and facts.

#### Registry Redirection

If you need to access registry keys in the native 64-bit registry space, you'll need to make sure you opt out of redirection. Here's an example of avoiding redirection in a custom fact:

~~~ ruby
    Facter.add(:myfact) do
      confine :kernel => :windows
      setcode do
        require 'win32/registry'

        value = nil
        hive = Win32::Registry::HKEY_CLASSES_ROOT
        hive.open('SOFTWARE\Somewhere\SomeValue',  Win32::Registry::KEY_READ | 0x100) do |reg|
          value = reg['SomeValue']
        end
        value
      end
    end
~~~

The addition of `| 0x100` ensures the registry is opened without redirection so you can access the keys you expect to access. For more information, see <a href="http://msdn.microsoft.com/en-us/library/aa384232(v=vs.85).aspx">Microsoft’s MSDN Reference on registry redirection.</a>


* * *

Troubleshooting
-----

The most common points of failure on Windows systems aren't the same as those on \*nix. For more details, see:

* [Troubleshooting Puppet on Windows][troubleshooting].

