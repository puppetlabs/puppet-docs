---
layout: pe2experimental
title: "Running Puppet on Windows"
nav: windows.html
---

[datadirectory]: ./installing.html#data-directory
[puppetconf]: /guides/configuring.html#puppetconf

Running Puppet
-----

* Puppet's main functions run automatically, with no further configuration needed. 
* For manual tasks, a shortcut named "Start Command Prompt with Puppet" is available in the Start Menu. This shortcut starts a `cmd.exe` window with the `PATH` and `RUBYLIB` environment variables pre-set to enable the Puppet tools. 


### Fetching Configurations from a Puppet Master

**Puppet on Windows will regularly fetch configurations from a puppet master with no further configuration needed.** The puppet agent service created by the installer will fetch and apply a configuration every 30 minutes, contacting the puppet master that was specified during installation. 

#### Configuring the Agent Service

By default, the puppet agent service starts automatically at boot, runs every 30 minutes, and contacts the puppet master specified during installation.

* To disable the service, use the Services control panel item or the `sc.exe` command:

        C:\>sc config puppet start= demand
        [SC] ChangeServiceConfig SUCCESS

* The `sc.exe` utility can also be used to restart the service...

        c:\>sc stop puppet && sc start puppet
    
    ...or to launch puppet agent with arguments:
    
        c:\>sc start puppet --test --debug
    
    (The example above changes the level of detail that gets written to Puppet's logs.)

* To change how often the agent runs, change the [`runinterval`](/references/latest/configuration.html#runinterval) setting in [puppet.conf][puppetconf].
* To change which puppet master Puppet contacts, change the [`server`](/references/latest/configuration.html#server) setting in [puppet.conf][puppetconf].

> Note: **You must restart the puppet agent service after making any changes to Puppet's config file.** Restart the service using the Services control panel item.

### Applying Manifests Locally

[man_apply]: /man/apply.html

The puppet apply subcommand accepts a [puppet manifest](/learning/manifests.html) file, and immediately compiles and applies a configuration from it:

    C:\> puppet apply my_manifest.pp

This allows you to manage nodes with Puppet without a central puppet master server, by having every node manage its own configuration. 

To use puppet apply, you must use the **"Start Command Prompt with Puppet"** item in the Start Menu. This will open a command prompt window in which `puppet apply` commands can be issued. 

To use puppet apply effectively, you should distribute your Puppet modules to each agent node and copy them into the [`modulepath`](/references/latest/configuration.html#modulepath). This allows the small manifests written for puppet apply to easily assign complicated pre-existing classes to the node. 

> Note: The `modulepath` on Windows is [`data directory`][datadirectory]`\etc\modules`.

To learn more about using modules, see [Module Fundamentals](/puppet/2.7/reference/modules_fundamentals.html) or [Learning Puppet](/learning/modules1.html).

<!-- TODO: Need to know how to apply manifests as a scheduled task, given that the tools aren't in the system $PATH. -->

### Interactively Modifying Puppet Resources

[man_resource]: /man/resource.html

The puppet resource subcommand can interactively view and modify a system's state using Puppet's resource types. (For example, it can be used as an alternate interface for creating or modifying user accounts.)

To use puppet resource, you must use the **"Start Command Prompt with Puppet"** item in the Start Menu. This will open a command prompt window in which `puppet resource` commands can be issued. 

The standard format of a puppet resource command is:

    C:\> puppet resource <TYPE> <NAME> <ATTRIBUTE=VALUE> <ATTRIBUTE=VALUE>

Specifying `attribute=value` pairs will modify the resource; leaving them off will print the resource's current state. Leaving out the resource name will list every resource of the specified type. 

* The resources puppet resource can use are the same as those available for Windows manifests; see [Writing Manifests for Windows](./writing.html) for more details.
* [See the puppet resource man page][man_resource] for more details about the puppet resource subcommand. 

### Submitting Inspect Reports

Puppet Enterprise's compliance features use the puppet inspect subcommand to submit inspect reports, which are then analyzed by PE's console. 

**Windows nodes running Puppet Enterprise send compliance reports automatically; no additional configuration is required.**

* Regular inspect reports are enabled by the `pe_compliance` class, which is applied to every PE node via the default group in the console. New nodes will begin submitting inspect reports after performing their first puppet agent run. 
* The contents of a node's inspect reports are governed by the compliance classes in use at the site; [see the compliance documentation for more details.][compliance_manifests]


[compliance_manifests]: /pe/2.5/compliance_using.html#writing-compliance-manifests


Configuring Puppet
-----

Puppet's main `puppet.conf` configuration file can be found at [`data directory`][datadirectory]`\etc\puppet.conf`. 

* See [Configuring Puppet](/guides/configuring.html) for more details about Puppet's config files.
* See [the configuration reference](/references/latest/configuration.html) for a complete list of `puppet.conf` settings. 
* In a command window opened with the **"Start Command Prompt with Puppet"** item in the Start Menu, you can use `puppet --configprint <SETTING>` to see the current value of any setting.

> Note: **You must restart the puppet agent service after making any changes to Puppet's config file.** Restart the service using the Services control panel item.


The Windows Ecosystem
-----


 



-------






### Logging
By default, puppet will log to a file, whose location is controlled by the [`puppetdlog`](/references/latest/configuration.html#puppetdlog) configuration setting.

The service logs to a file to `windows.log` within the same directory as the `puppetdlog` file.

Puppet does not currently support logging to the Windows event log.

### Interactive 
Facter and Puppet can be run interactively by selecting the `Run Facter` or `Run Puppet Agent` menu items, respectively, from the Windows Start Menu. Selecting these items will create a console windows and display the output of each process.

On UAC-enabled systems, e.g. 2008, you will be prompted to allow these process to elevate privileges. 

Nick, see <https://github.com/puppetlabs/puppet_for_the_win/blob/master/README.markdown> for Interactive and UAC Integration screen shots.

### Puppet Command Prompt
A shortcut named "Start Command Prompt with Puppet" will be created in the Start Menu. This shortcut automates the process of starting cmd.exe and manually setting the PATH and RUBYLIB environment variables.

<b>Note</b>, the process does not run with elevated privileges, unless you explicitly right-click and select `Run as Administrator`. Running puppet agent from this command prompt in a non-elevated security context can interfere with the puppet agent process running as a service, e.g. attempting to request a second SSL certificate with the same certificate name as the puppet service. 

Nick, see <https://github.com/puppetlabs/puppet_for_the_win/blob/master/README.markdown> for Command Prompt screen shot




## Windows Concepts

### 64-bit Operating Systems

The Puppet agent process runs as a 32-bit process. When run on 64-bit versions of Windows, there are some issues to be aware of.

The [File System Redirector](http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85\).aspx) will silently redirect all file system access to `%windir%\system32` to `%windir%\SysWOW64` instead. This can be an issue when trying to manage files in the system directory, e.g. IIS configuration files. In order to prevent redirection, you can use the `sysnative` alias, e.g. `C:\Windows\sysnative\inetsrv\config\application Host.config`. Note, 64-bit Windows Server 2003 requires hotfix [KB942589](http://support.microsoft.com/kb/942589/en-us) to use sysnative.

The [Registry Redirector](http://msdn.microsoft.com/en-us/library/aa384232(v=vs.85\).aspx) performs a similar function with certain [registry keys](http://msdn.microsoft.com/en-us/library/aa384253(v=vs.85\).aspx).

### Security Identifiers (SID)

On Windows, user and group account names can take multiple forms, e.g. `Administrators`, `<host>\Administrators`, `BUILTIN\Administrators`, `S-1-5-32-544`. When comparing two account names, e.g. user resource, puppet always first transforms account names into their canonical SID form, and compares SIDs instead.

### Security Context

On Unix, puppet is either running as root or not. On Windows, these concepts map to running with elevated privileges or not.

Puppet typically runs as a service under the LocalSystem account, and thus always has elevated privileges.

When running puppet from the command line or programmatically, you should be aware of User Account Control restrictions that may cause puppet to not run with elevated privileges. For example, running puppet agent from the command line in a non-elevated security context, will cause puppet to use a different data directory, and as a result, puppet will try to request a second SSL certificate, which will fail if the puppet agent running as a service has already requested one.

On systems without UAC, i.e. 2003, if you are a member of the local Administrators group, then you are typically running with elevated privileges.

On systems with UAC, i.e. 7, 2008, you must explicitly elevate privileges, even when running as a member of the local Administrators group. Puppet provides shortcuts to faciliate this process, e.g. `Run Puppet Agent`, `Run Facter`. However, note that the `Start Command Prompt with Puppet` shortcut does not elevate privileges.