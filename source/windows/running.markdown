---
layout: pe2experimental
title: "Running Puppet on Windows"
nav: windows.html
---

[datadirectory]: ./installing.html#data-directory
[puppetconf]: /guides/configuring.html#puppetconf


<span class="versionnote">This documentation applies to Puppet ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>


Running Puppet
-----

* **Puppet agent runs automatically, with no further configuration needed.**
    * As with any \*nix Puppet node, you must sign the node's certificate request on the puppet master before it can fetch configurations.
* For manual tasks, a shortcut named **"Start Command Prompt with Puppet"** is available in the Start Menu. This shortcut starts a `cmd.exe` window with the `PATH` and `RUBYLIB` environment variables pre-set to enable the Puppet tools. 

    **This command window will have elevated privileges,** and should be used with care. Starting the window will ask for UAC confirmation on Windows 7 or 2008 systems: <!-- todo confirm one last time -->
    
    ![UAC dialog](./images/uac.png)


### Fetching Configurations from a Puppet Master

**Puppet on Windows will regularly fetch configurations from a puppet master with no further configuration needed.** The puppet agent service created by the installer will fetch and apply a configuration every 30 minutes, contacting the puppet master that was specified during installation. 

#### Running Puppet Agent Interactively

You can trigger a puppet agent run at any time with the "Run Puppet Agent" Start Menu item. This will show the status of the run as it happens in a command prompt window. 

**Triggering an agent run requires elevated privileges,** and will ask for UAC confirmation on Windows 7 or 2008 systems.

#### Configuring the Agent Service

By default, the puppet agent service starts automatically at boot, runs every 30 minutes, and contacts the puppet master specified during installation.

* To start, stop, or disable the service, use the Services control panel item
* You can also use the `sc.exe` command to manage the puppet agent service. To make the service not start on boot:

        C:\>sc config puppet start= demand
        [SC] ChangeServiceConfig SUCCESS

    To restart the service:

        c:\>sc stop puppet && sc start puppet
    
    To change the arguments used when triggering a puppet agent run (this example changes the level of detail that gets written to Puppet's logs):
    
        c:\>sc start puppet --test --debug

* To change how often the agent runs, change the [`runinterval`](/references/latest/configuration.html#runinterval) setting in [puppet.conf][puppetconf].
* To change which puppet master the agent contacts, change the [`server`](/references/latest/configuration.html#server) setting in [puppet.conf][puppetconf].

> Note: **You must restart the puppet agent service after making any changes to Puppet's config file.** Restart the service using the Services control panel item.

### Applying Manifests Locally

[man_apply]: /man/apply.html

The puppet apply subcommand accepts a [puppet manifest](/learning/manifests.html) file, and immediately compiles and applies a configuration from it:

    C:\> puppet apply my_manifest.pp

This allows you to manage nodes with Puppet without a central puppet master server, by having every node manage its own configuration. 

To use puppet apply, you must use the **"Start Command Prompt with Puppet"** item in the Start Menu. This will open a command prompt window in which `puppet apply` commands can be issued. 

To use puppet apply effectively, you should distribute your Puppet modules to each agent node and copy them into the [`modulepath`](/references/latest/configuration.html#modulepath). This allows the small manifests written for puppet apply to easily assign complicated pre-existing classes to the node. 

> Note: The `modulepath` on Windows is [`<data directory>`][datadirectory]`\etc\modules`.

To learn more about using modules, see [Module Fundamentals](/puppet/2.7/reference/modules_fundamentals.html) or [Learning Puppet](/learning/modules1.html).

<!-- TODO: Need to know how to apply manifests as a scheduled task, given that the tools aren't in the system $PATH. -->

### Interactively Modifying Puppet Resources

[man_resource]: /man/resource.html

The puppet resource subcommand can interactively view and modify a system's state using Puppet's resource types. (For example, it can be used as an alternate interface for creating or modifying user accounts.)

To run puppet resource, you must use the **"Start Command Prompt with Puppet"** item in the Start Menu. This will open a command prompt window in which `puppet resource` commands can be issued. 

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

### Running Facter

When writing manifests for Windows nodes, it can be helpful to see a test system's actual fact data. Use the **"Run Facter"** Start Menu item to do this. 

Configuring Puppet
-----

Puppet's main `puppet.conf` configuration file can be found at [`<data directory>`][datadirectory]`\etc\puppet.conf`. 

* See [Configuring Puppet](/guides/configuring.html) for more details about Puppet's main config file. (Puppet's secondary config files are not used on Windows.)
* See [the configuration reference](/references/latest/configuration.html) for a complete list of `puppet.conf` settings. 
* In a command window opened with the **"Start Command Prompt with Puppet"** Start Menu item, you can use `puppet --configprint <SETTING>` to see the current value of any setting.

> Note: **You must restart the puppet agent service after making any changes to Puppet's config file.** Restart the service using the Services control panel item.


Important Windows Concepts for Unix Admins
-----

Windows differs from \*nix systems in many ways, several of which affect how Puppet works. 

### Security Context

On Unix, puppet is either running as root or not. On Windows, this maps to running with **elevated privileges** or not.

Puppet agent typically runs as a service under the LocalSystem account, and thus always has elevated privileges. When running puppet from the command line or from a script or scheduled task, you should be aware of User Account Control restrictions that may cause Puppet to run without elevated privileges. 

If Puppet is accidentally run in a non-elevated security context, it will use a different data directory (specifically, the `.puppet` directory in the current user's home directory) and will try to request a second SSL certificate; this will fail if the puppet agent service has already requested one, and can interfere with the agent service if it somehow happens before the agent service has received a certificate. 

* On systems without UAC (i.e. Windows 2003), users in the local Administrators group will typically run all commands with elevated privileges. 
* On systems with UAC (i.e. Windows 7 and 2008), you must explicitly elevate privileges, even when running as a member of the local Administrators group. Puppet's start menu items (`Run Puppet Agent`, `Run Facter`, and `Start Command Prompt with Puppet`) automatically request privilege elevation when run. <!-- todo check this, because I'm pretty sure start command prompt does this now but the pre-docs didn't catch up. -->




### File System Redirection in 64-bit Windows Versions

The Puppet agent process runs as a 32-bit process. When run on 64-bit versions of Windows, there are some issues to be aware of.

* The [File System Redirector](http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85\).aspx) will silently redirect all file system access to `%windir%\system32` to `%windir%\SysWOW64` instead. This can be an issue when trying to manage files in the system directory, e.g. IIS configuration files. In order to prevent redirection, you can use the `sysnative` alias, e.g. `C:\Windows\sysnative\inetsrv\config\application Host.config`. 

    > Note: 64-bit Windows Server 2003 requires hotfix [KB942589](http://support.microsoft.com/kb/942589/en-us) to use the sysnative alias.

* The [Registry Redirector](http://msdn.microsoft.com/en-us/library/aa384232(v=vs.85\).aspx) performs a similar function with certain [registry keys](http://msdn.microsoft.com/en-us/library/aa384253(v=vs.85\).aspx).



