---
layout: default
title: "Overview of Puppet on Windows"
---

[win_commands]: /puppet/latest/services_commands_windows.html
[win_agent]: /puppet/latest/services_agent_windows.html
[arch]: /puppet/latest/architecture.html
[the confdir]: /puppet/latest/dirs_confdir.html
[the vardir]: /puppet/latest/dirs_vardir.html

**Puppet runs on Microsoft Windows® and can manage Windows systems alongside \*nix systems.** This page will help get you oriented and ready to manage Windows systems with Puppet.


## Installing

To install open source Puppet on Windows, follow the instructions on the following pages, in order:

* [Pre-install tasks](/puppet/latest/install_pre.html)
* [Installation instructions](/puppet/latest/install_windows.html)


## Running

* Windows systems can run `puppet agent` and `puppet apply`, but they can't act as a Puppet master server.
* Puppet is available in 32- and 64-bit versions. Install the appropriate Puppet package for your version of Windows.
* Puppet usually runs with elevated privileges. If you want to run any of Puppet's commands interactively on systems with UAC, you need to start a command prompt by right-clicking and choosing "Run as administrator."
* Puppet's configuration and data are stored in different places on different Windows versions. For more details, see the Puppet reference manual pages on [the confdir][] and [the vardir][].

For more information, see:

* [Overview of Puppet's Architecture][arch], for more about puppet masters and puppet agents.
* [Running Puppet Commands on Windows][win_commands], for information on running commands interactively.
* [Puppet Agent on Windows][win_agent], for information on the puppet agent service's run environment.


## Writing manifests

In general, manifests written for Windows nodes work the same way as manifests written for \*nix nodes.

### Resource types

Some \*nix resource types aren't supported on Windows, and there are some Windows-only resource types.

The following core resource types can be managed on Windows:

* [file](/puppet/latest/type.html#file) ([tips for Windows](/puppet/latest/resources_file_windows.html))
* [user](/puppet/latest/type.html#user) ([tips for Windows](/puppet/latest/resources_user_group_windows.html))
* [group](/puppet/latest/type.html#group) ([tips for Windows](/puppet/latest/resources_user_group_windows.html))
* [scheduled_task](/puppet/latest/type.html#scheduledtask) ([tips for Windows](/puppet/latest/resources_scheduled_task_windows.html))
* [package](/puppet/latest/type.html#package) ([tips for Windows](/puppet/latest/resources_package_windows.html))
* [service](/puppet/latest/type.html#service) ([tips for Windows](/puppet/latest/resources_service.html))
* [exec](/puppet/latest/type.html#exec) ([tips for Windows](/puppet/latest/resources_exec_windows.html))
* [host](/puppet/latest/type.html#host)

Also, there are some popular [optional resource types for Windows.](/puppet/latest/resources_windows_optional.html)

### Handling file paths

Some resource types take file paths as attributes. On Windows, there are some extra things to take into account when writing file paths, including directory separators. For more info, see:

* [Handling File Paths on Windows](/puppet/latest/lang_windows_file_paths.html)

### Line endings

Windows systems generally use different line endings in text files than \*nix systems do. Puppet manifest files can use either kind of line ending.

There are a few subtleties of behavior when handling the content of managed files. For details, [see the note on line endings in the language reference.](/puppet/latest/lang_summary.html#line-endings-in-windows-text-files)

### Facts

Windows nodes with a default install of Puppet will include the following notable and identifying facts, which can be useful when writing manifests:

* `kernel => windows`
* `operatingsystem => windows`
* `osfamily => windows`
* `env_windows_installdir` --- This fact will contain the directory in which Puppet was installed.
* `id` --- This fact will be `<DOMAIN>\<USER NAME>`. You can use the user name to determine whether Puppet is running as a service or was triggered manually.


## Important Windows concepts for Unix admins

Windows differs from \*nix systems in many ways, several of which affect how Puppet works.


### Security context

On Unix, puppet is either running as root or not. On Windows, this maps to running with **elevated privileges** or not.

For more information, see the following pages in the Puppet reference manual:

* [Running Puppet Commands on Windows][win_commands], for information on running commands interactively.
* [Puppet Agent on Windows][win_agent], for information on the puppet agent service's run environment.


### File system redirection (Older versions of Puppet)

As of Puppet 3.7, the Puppet agent can run as either a 32- or a 64-bit process. This means that as long as you've installed the correct package for your version of Windows, file system redirection should no longer be an issue.

However, if you are using an earlier version of Puppet, file system redirection will still affect you. Please see [Language: Handling file paths on windows](/puppet/latest/lang_windows_file_paths.html) for how to safely handle file system redirection when running 32-bit Puppet on a 64-bit Windows system. The information about file system redirection applies to extensions as well.

>*Note*: By end of year 2016, running 32-bit Puppet agent on a 64-bit Windows system will be deprecated. Upgrade your Puppet installation to 64-bit by December 31, 2016.


### Developing extensions

If you're developing custom types and providers or writing custom facts, be aware that the <a href="http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx">File System Redirector</a> and the <a href="http://msdn.microsoft.com/en-us/library/aa384232(v=vs.85).aspx">Registry Redirector</a> will also affect these types, providers, and facts.


#### Registry redirection

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

