---
layout: pe2experimental
title: "Puppet on Windows"
nav: windows.html
---

<span class="versionnote">This documentation applies to Puppet ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>

**Puppet runs on Microsoft Windows®, and can manage Windows systems alongside \*nix systems.** These pages explain how to install and run Puppet on Windows, and describe how it differs from Puppet on *nix. 


[from_source]: ./from_source.html
[installing]: ./installing.html
[running]: ./running.html
[troubleshooting]: ./troubleshooting.html
[writing]: ./writing.html


[downloads]: <!-- TODO -->
[pedownloads]: <!-- todo -->

[Installing][]
-----

Puppet Labs provides pre-built standalone .msi packages for installing Puppet on Windows. 

### Downloads

* [For Puppet Enterprise][pedownloads]
* [For open source Puppet][downloads]

### Supported Platforms

Puppet runs on the following Windows versions:

* Windows Server 2003 and 2003 R2
* Windows Server 2008 and 2008 R2
* Windows 7

### More

For full details, see [Installing Puppet on Windows][installing]. 

* * * 

[Running][]
-----

### Puppet Subcommands and Services

Windows nodes can run the following Puppet subcommands:

* **Puppet agent,** to fetch configurations from a puppet master and apply them
    * The agent functions as a standard Windows service, and agent runs can also be triggered manually.
    * Windows nodes can connect to any *nix puppet master server running Puppet 2.7.6 or higher.
* **Puppet apply,** to apply configurations from local manifest files
* **Puppet resource,** to directly manipulate system resources
* **Puppet inspect,** to send audit reports for compliance purposes

You must choose "Start Command Prompt with Puppet" from the start menu to run Puppet commands manually, as the installer doesn't alter the system's PATH variable.

Windows nodes can't act as puppet masters or certificate authorities, and most of the ancillary Puppet subcommands aren't supported on Windows. 

### Puppet's Environment on Windows

* Puppet runs as a 32-bit process.
* Puppet has to run with elevated privileges; on systems with UAC, it will request explicit elevation even when running as a member of the local Administrators group.
* Puppet's configuration and data are stored in `%ALLUSERSPROFILE%\Application Data\PuppetLabs` on Windows 2003, and in `%PROGRAMDATA%\PuppetLabs` on Windows 7 and 2008. 


### More

For full details, see [Running Puppet on Windows][running].


* * * 

[Writing Manifests for Windows][writing]
-----

### Resource Types

Some \*nix resource types aren't supported on Windows, and there are some Windows-only resource types. 

The following resource types can be managed on Windows:

* [file](/references/latest/type.html#file)
* [user](/references/latest/type.html#user)
* [group](/references/latest/type.html#group)
* [scheduled_task](/references/latest/type.html#scheduledtask) (Windows-only)
* [package](/references/latest/type.html#package)
* [service](/references/latest/type.html#service)
* [exec](/references/latest/type.html#exec)
* [host](/references/latest/type.html#host)

### More

For full details, see [Writing Manifests for Windows][writing].


* * * 

[Troubleshooting][]
-----

The most common points of failure on Windows systems aren't the same as those on *nix. For full details, see [Troubleshooting Puppet on Windows][troubleshooting].

* * * 

[For Developers and Testers][from_source]
-----

To test pre-release features, or to hack and improve Puppet on Windows, you can run Puppet from source. This requires a fairly specific version of Ruby, and several important gems. For full details, see [Running Puppet from Source on Windows][from_source].

