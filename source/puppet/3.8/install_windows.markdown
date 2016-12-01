---
layout: default
title: "Installing Puppet: Microsoft Windows"
---

[downloads]: https://downloads.puppetlabs.com/windows
[peinstall]: {{pe}}/install_windows.html
[pre_install]: ./pre_install.html
[puppet.conf]: /puppet/latest/reference/config_file_main.html
[environment]: /puppet/latest/reference/environments.html
[confdir]: /puppet/latest/reference/dirs_confdir.html
[vardir]: /puppet/latest/reference/dirs_vardir.html
[install-latest]: /puppet/latest/reference/install_pre.html

> #### **Note:** This document covers *open source* releases of Puppet version 3.8 and lower. For current versions, you should see instructions for [installing the latest version of Puppet][install-latest] or [installing Puppet Enterprise][peinstall].

First
-----

Before installing Puppet, review the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

{% include pup38_platforms_windows.markdown %}

To install on other operating systems, see the product navigation.

Step 1: Configure a Puppet Master Server
-----

Windows machines can't act as Puppet master servers. Before installing Puppet agent on any Windows nodes, install and configure a \*nix Puppet master and note its permanent hostname.

If you haven't done this yet, go back to the [pre-install tasks][pre_install], make any necessary decisions, and follow the install instructions and post-install tasks for your Puppet master's OS.

Step 2: Download Installer
-----

Windows installers for Puppet agent are available at [downloads.puppetlabs.com/windows][downloads]. You need the most recent Puppet 3.8 package for your OS's architecture:

-   64-bit versions of Windows Vista/2008 and higher should use `puppet-<VERSION>-x64.msi`.
-   32-bit versions of Windows, as well as the 64-bit version of Windows Server 2003, should use `puppet-<VERSION>.msi`.

These packages bundle all of Puppet's prerequisites, so you don't need to download anything else.

The list of Windows packages might include release candidates, whose filenames have something like `-rc1` after the version number. Only use these if you want to test upcoming Puppet versions.

Step 3: Install Puppet
-----

You can install Puppet [with a graphical wizard](#graphical-installation) or [on the command line](#automated-installation). If you install on the command line, you will have more configuration options.

### Graphical Installation

[server]: ./images/wizard_server.png

Double-click the MSI package you downloaded, and follow the graphical wizard. The installer must be run with elevated privileges. Installing Puppet does not require a system reboot.

During installation, you will be asked for the hostname of your puppet master server. This must be a \*nix node configured to act as a puppet master.

For standalone Puppet nodes that won't be connecting to a master, use the default hostname (`puppet`). You may also want to install on the command line and set the agent startup mode to `Disabled`.

![Puppet master hostname selection][server]

Once the installer finishes, Puppet will be installed, running, and at least partially configured. You should now [look at the post-install tasks](./post_install.html) --- many of them don't apply to Windows nodes, but you will need to sign node certificates and you may want to configure some additional settings.

### Automated Installation

Use the `msiexec` command to install the Puppet package:

    msiexec /qn /norestart /i puppet-<VERSION>.msi

If you don't specify any further options, this is the same as installing graphically with the default puppet master hostname (`puppet`).

You can specify `/l*v install.txt` to log the progress of the installation to a file.

You can also set several MSI properties to pre-configure Puppet as you install it. For example:

    msiexec /qn /norestart /i puppet.msi PUPPET_MASTER_SERVER=puppet.example.com

See the next heading for info about these MSI properties.

Once the installer finishes, Puppet will be installed, running, and at least partially configured. You should now [look at the post-install tasks](./post_install.html) --- many of them don't apply to Windows nodes, but you will need to sign node certificates and you may want to configure some additional settings.

### MSI Properties

These options are only available when installing Puppet on the command line (see above).

The following MSI properties are available:

MSI Property                                                   | Puppet Setting     | Introduced in
---------------------------------------------------------------|--------------------|-------------------------
[`INSTALLDIR`](#installdir)                                    | n/a                | Puppet 2.7.12 / PE 2.5.0
[`PUPPET_MASTER_SERVER`](#puppetmasterserver)                  | [`server`][s]      | Puppet 2.7.12 / PE 2.5.0
[`PUPPET_CA_SERVER`](#puppetcaserver)                          | [`ca_server`][c]   | Puppet 2.7.12 / PE 2.5.0
[`PUPPET_AGENT_CERTNAME`](#puppetagentcertname)                | [`certname`][r]    | Puppet 2.7.12 / PE 2.5.0
[`PUPPET_AGENT_ENVIRONMENT`](#puppetagentenvironment)          | [`environment`][e] | Puppet 3.3.1  / PE 3.1.0
[`PUPPET_AGENT_STARTUP_MODE`](#puppetagentstartupmode)         | n/a                | Puppet 3.4.0  / PE 3.2
[`PUPPET_AGENT_ACCOUNT_USER`](#puppetagentaccountuser)         | n/a                | Puppet 3.4.0  / PE 3.2
[`PUPPET_AGENT_ACCOUNT_PASSWORD`](#puppetagentaccountpassword) | n/a                | Puppet 3.4.0  / PE 3.2
[`PUPPET_AGENT_ACCOUNT_DOMAIN`](#puppetagentaccountdomain)     | n/a                | Puppet 3.4.0  / PE 3.2

[s]: /puppet/latest/reference/configuration.html#server
[c]: /puppet/latest/reference/configuration.html#caserver
[r]: /puppet/latest/reference/configuration.html#certname
[e]: /puppet/latest/reference/configuration.html#environment



#### `INSTALLDIR`

Where Puppet and its dependencies should be installed.

> **Note:** If you installed Puppet into a custom directory and are upgrading from a 32-bit version to a 64-bit version, you must re-specify the `INSTALLDIR` option when upgrading.
>
> If you are replacing 64-bit Puppet with a 32-bit version, you should **uninstall** Puppet before installing the new package. Be sure to re-specify any relevant MSI properties when re-installing.

Puppet's program directory contains the following subdirectories:

Directory | Description
----------|------------
bin       | scripts for running Puppet and Facter
facter    | Facter source
hiera     | Hiera source
misc      | resources
puppet    | Puppet source
service   | code to run puppet agent as a service
sys       | Ruby and other tools

**Default (Puppet 3.7+):**

When using the architecture-appropriate installer, Puppet will install into the following directories:

OS type                    | Default Install Path
---------------------------|--------------------------------------------
Most Windows Versions      | `C:\Program Files\Puppet Labs\Puppet`
Windows Server 2003 64-bit | `C:\Program Files (x86)\Puppet Labs\Puppet`

The Program Files directory can be located using the `PROGRAMFILES` environment variable. (On Windows Server 2003 64-bit, you should use the `PROGRAMFILES(X86)` variable instead.)


**Default (Puppet 3.6 and earlier):**

OS type  | Default Install Path
---------|---------------------
32-bit   | `C:\Program Files\Puppet Labs\Puppet`
64-bit   | `C:\Program Files (x86)\Puppet Labs\Puppet`

The Program Files directory can be located using the `PROGRAMFILES` environment variable on 32-bit versions of Windows or the `PROGRAMFILES(X86)` variable on 64-bit versions.

#### `PUPPET_MASTER_SERVER`

The hostname where the puppet master server can be reached. This will set a value for [the `server` setting][s] in the `[main]` section of [puppet.conf][].

**Default:** `puppet`

**Note:** If you set a _non-default_ value for this property, the installer will **replace** any existing value in puppet.conf. Also, the next time you upgrade, the installer will re-use your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `server` setting directly in puppet.conf; you should re-run the installer and set a new value there instead.

#### `PUPPET_CA_SERVER`

The hostname where the CA puppet master server can be reached, if you are using multiple masters and only one of them is acting as the CA. This will set a value for [the `ca_server` setting][c] in the `[main]` section of [puppet.conf][].

**Default:** the value of the `PUPPET_MASTER_SERVER` property

**Note:** If you set a _non-default_ value for this property, the installer will **replace** any existing value in puppet.conf. Also, the next time you upgrade, the installer will re-use your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `ca_server` setting directly in puppet.conf; you should re-run the installer and set a new value there instead.

#### `PUPPET_AGENT_CERTNAME`

The node's certificate name, and the name it uses when requesting catalogs. This will set a value for [the `certname` setting][r] in the `[main]` section of [puppet.conf][].

For best compatibility, you should limit the value of `certname` to only use lowercase letters, numbers, periods, underscores, and dashes. (That is, it should match `/\A[a-z0-9._-]+\Z/`.)

**Default:** the node's fully-qualified domain name, as discovered by `facter fqdn`.

**Note:** If you set a _non-default_ value for this property, the installer will **replace** any existing value in puppet.conf. Also, the next time you upgrade, the installer will re-use your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `certname` setting directly in puppet.conf; you should re-run the installer and set a new value there instead.

#### `PUPPET_AGENT_ENVIRONMENT`

The node's [environment][]. This will set a value for [the `environment` setting][e] in the `[main]` section of [puppet.conf][].

**Default:** `production`

**Note:** If you set a _non-default_ value for this property, the installer will **replace** any existing value in puppet.conf. Also, the next time you upgrade, the installer will re-use your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `environment` setting directly in puppet.conf; you should re-run the installer and set a new value there instead.

#### `PUPPET_AGENT_STARTUP_MODE`

Whether the puppet agent service should run (or be allowed to run). Allowed values:

* `Automatic` (**default**) --- puppet agent will start with Windows and stay running in the background.
* `Manual` --- puppet agent won't run by default, but can be started in the services console or with `net start` on the command line.
* `Disabled` --- puppet agent will be installed but disabled. You will have to change its start up type in the services console before you can start the service.


#### `PUPPET_AGENT_ACCOUNT_USER`

Which Windows user account the puppet agent service should use. This is important if puppet agent will need to access files on UNC shares, since the default `LocalSystem` account cannot access these network resources.

* This user account **must already exist,** and may be a local or domain user. (The installer will allow domain users even if they have not accessed this machine before.)
* If the user isn't already a local administrator, the installer will add it to the `Administrators` group.
* The installer will also grant [`Logon as Service`](http://msdn.microsoft.com/en-us/library/ms813948.aspx) to the user.

This property should be combined with `PUPPET_AGENT_ACCOUNT_PASSWORD` and `PUPPET_AGENT_ACCOUNT_DOMAIN`. For example, to assign the agent to a domain user `ExampleCorp\bob`, you would install with:

    msiexec /qn /norestart /i puppet-<VERSION>.msi PUPPET_AGENT_ACCOUNT_DOMAIN=ExampleCorp PUPPET_AGENT_ACCOUNT_USER=bob PUPPET_AGENT_ACCOUNT_PASSWORD=password

**Default:** `LocalSystem`

#### `PUPPET_AGENT_ACCOUNT_PASSWORD`

The password to use for puppet agent's user account. See the notes about users above.

**Default:** no value.

#### `PUPPET_AGENT_ACCOUNT_DOMAIN`

The domain of puppet agent's user account. See the notes about users above.

**Default:** `.`


### Upgrading

Be sure to read our [tips on upgrading](./upgrading.html) before upgrading your whole Puppet deployment.

#### Normal Upgrades

To upgrade to the latest version of Puppet, download the new MSI package and run the installer again. The installer will automatically restart the puppet agent service.

As noted above, there are several settings that will be remembered by the installer if they were set during the install. If you used those MSI properties in a previous installation and later changed those settings in puppet.conf, the new values will remain unless changed during the upgrade process.

> **Note:** If you installed Puppet into a custom directory and are upgrading to a different architecture, be sure to see the note above [in the `INSTALLDIR` section.](#installdir)

#### Downgrades

If you need to replace a 64-bit version of Puppet with a 32-bit version, you must **uninstall** Puppet before installing the new package. You must also uninstall if you are downgrading from 3.7 or later to 3.6 or earlier.

### Uninstalling

Puppet can be uninstalled through the "Add or Remove Programs" interface or from the command line.

To uninstall from the command line, you must have the original MSI file or know the <a href="http://msdn.microsoft.com/en-us/library/windows/desktop/aa370854(v=vs.85).aspx">ProductCode</a> of the installed MSI:

    msiexec /qn /norestart /x puppet-3.5.1.msi
    msiexec /qn /norestart /x <PRODUCT CODE>

Uninstalling will remove Puppet's program directory, the puppet agent service, and all related registry keys. It will leave the [confdir][] and [vardir][] intact, including any SSL keys. To completely remove Puppet from the system, the confdir and vardir can be manually deleted.

Next
----

Once the installer finishes, Puppet will be installed, running, and at least partially configured. You should now [look at the post-install tasks](./post_install.html) --- many of them don't apply to Windows nodes, but you will need to sign node certificates and you may want to configure some additional settings.

