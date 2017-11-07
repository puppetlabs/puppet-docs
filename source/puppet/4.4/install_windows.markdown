---
layout: default
title: "Installing Puppet Agent: Microsoft Windows"
canonical: "/puppet/latest/install_windows.html"
---

[downloads]: https://downloads.puppetlabs.com/windows/
[peinstall]: {{pe}}/install_windows.html
[pre_install]: ./install_pre.html
[where]: ./whered_it_go.html
[puppet.conf]: ./config_file_main.html
[environment]: ./environments.html
[confdir]: ./dirs_confdir.html
[codedir]: ./dirs_codedir.html
[vardir]: ./dirs_vardir.html
[server_install]: {{puppetserver}}/install_from_packages.html

> **Note:** These instructions describe how to install the open source Puppet agent software on OS X.
>
> -   To install the Puppet Enterprise agent on supported operating systems, see [its documentation]({{pe}}/install_agents.html).
> -   To install the open source agent on Linux distributions that don't have official packages, review [Puppet's prerequisites](./system_requirements.html#platforms-without-packages).
> -   To install the open source agent on Windows operating systems, see the [Windows installation instructions](./install_windows.html).
> -   To install the open source agent on Linux distributions, see the [Linux installation instructions](./install_linux.html).
> -   To install open source Puppet Server on a Puppet master, see [its documentation][server_install].

## Make sure you're ready

Before installing Puppet agent on any nodes, complete the [pre-install tasks](./install_pre.html) and [install Puppet Server][server_install] on your designated Puppet master.

> **Note:** Puppet 4 changes the locations for many of the most important files and directories. If you're familiar with Puppet 3 and earlier, read [a summary of the changes][where] and refer to the [full specification of Puppet directories](https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md).

## Review supported versions

Puppet agent is distributed in a package that includes all of Puppet's prerequisites. You don't need to download anything else to install Puppet agent on a node. These packages are tied to a [Puppet Collection][puppet_collections] (PC), which is a set of Puppet 4 software designed and tested to work well together.

{% include pup44_platforms_windows.markdown %}

> **Deprecation Note:** Puppet 4.2 deprecated Windows Server 2003 and 2003 R2. The Windows installation packages for `puppet-agent` 1.4.0 and newer, which contains Puppet 4.4, won't install on those versions of Windows Server.

## Download the Windows `puppet-agent` package

Go to <https://downloads.puppetlabs.com/windows/> and download the most recent Windows Installer (MSI) package for your system's architecture.

-   64-bit versions of Windows can use `puppet-agent-<VERSION>-x64.msi` (recommended) or `puppet-agent-<VERSION>-x86.msi`.
-   32-bit versions of Windows _must_ use `puppet-agent-<VERSION>-x86.msi`.

The list of Windows packages might include release candidates, with filenames that include something like `-rc1` after the version number. Use these only if you want to test upcoming Puppet versions.

>**Note:** As of January 2016, Puppet dual-signs `puppet-agent` packages. You may see a warning from your browser saying the signature is corrupt or invalid.
>
> ![invalid or corrupt](./images/windows_invalid_signature.jpg)
>
> If you want to verify the package is dual-signed, right-click on the MSI, and select **Properties**. Navigate to the **Digital Signatures** tab and you should see the following:
>
> ![Puppet Package Properties](./images/windows_package_signatures.png)

## Install Puppet

You can install Puppet [with a graphical wizard](#graphical-installation) or [on the command line](#automated-installation). The command-line installer provides more configuration options.

### Graphical installation

[server]: ./images/wizard_server.png

To install Puppet agent using the graphical wizard:

1.  Double-click the MSI package you downloaded to launch the wizard.

    > **Note:** The installer requires elevated privileges. Installing Puppet does not require a system reboot.

    Follow the wizard's instructions to continue the installation.

2.  During the installation, the wizard requests your Puppet master's hostname. This must be the hostname of a \*nix node configured to act as a Puppet master.

    For standalone Puppet nodes that won't connect to a master, use the default hostname (`puppet`). In this case, you might want to use the [command-line installer](#automated-installation) instead so you can set the agent startup mode to `Disabled`.

    ![Puppet master hostname selection][server]

    Once the installation is complete, the Puppet service will be running and at least partially configured.

### Automated installation

To install Puppet agent from the command line, or to automate installation, use the `msiexec` command to install the Puppet package.

    msiexec /qn /norestart /i puppet-agent-<VERSION>-x64.msi

If you don't specify any further options, this is the same as [installing graphically](#graphical-installation) with the default Puppet master hostname (`puppet`).

> **Note:** You can optionally specify `/l*v install.txt` when running the installer in order to log the installation's progress to a file.
>
> You can also set several MSI properties to pre-configure Puppet as you install it. For example:
>
>     msiexec /qn /norestart /i puppet-agent-<VERSION>-x64.msi PUPPET_MASTER_SERVER=puppet.example.com
>
> See [the MSI Properties section](#msi-properties) for information about these MSI properties.

Once the installation is complete, the Puppet service will be running and at least partially configured.

### MSI properties

These options are available only when [installing Puppet on the command line](#automated-installation).

| MSI Property                                                   | Puppet Setting     | Introduced in            |
|----------------------------------------------------------------|--------------------|--------------------------|
| [`INSTALLDIR`](#installdir)                                    | n/a                | Puppet 2.7.12 / PE 2.5.0 |
| [`PUPPET_MASTER_SERVER`](#puppetmasterserver)                  | [`server`][s]      | Puppet 2.7.12 / PE 2.5.0 |
| [`PUPPET_CA_SERVER`](#puppetcaserver)                          | [`ca_server`][c]   | Puppet 2.7.12 / PE 2.5.0 |
| [`PUPPET_AGENT_CERTNAME`](#puppetagentcertname)                | [`certname`][r]    | Puppet 2.7.12 / PE 2.5.0 |
| [`PUPPET_AGENT_ENVIRONMENT`](#puppetagentenvironment)          | [`environment`][e] | Puppet 3.3.1  / PE 3.1.0 |
| [`PUPPET_AGENT_STARTUP_MODE`](#puppetagentstartupmode)         | n/a                | Puppet 3.4.0  / PE 3.2   |
| [`PUPPET_AGENT_ACCOUNT_USER`](#puppetagentaccountuser)         | n/a                | Puppet 3.4.0  / PE 3.2   |
| [`PUPPET_AGENT_ACCOUNT_PASSWORD`](#puppetagentaccountpassword) | n/a                | Puppet 3.4.0  / PE 3.2   |
| [`PUPPET_AGENT_ACCOUNT_DOMAIN`](#puppetagentaccountdomain)     | n/a                | Puppet 3.4.0  / PE 3.2   |

[s]: ./configuration.html#server
[c]: ./configuration.html#caserver
[r]: ./configuration.html#certname
[e]: ./configuration.html#environment

#### `INSTALLDIR`

The path where Puppet and its dependencies should be installed.

> **Note:** If you installed Puppet into a custom directory and are upgrading from a 32-bit version to a 64-bit version, you must re-specify the `INSTALLDIR` option when upgrading.
>
> If you are replacing 64-bit Puppet with a 32-bit version, you should **uninstall** Puppet before installing the new package. Be sure to re-specify any relevant MSI properties when re-installing.

Puppet's program directory contains the following subdirectories:

| Directory   | Description                           |
|-------------|---------------------------------------|
| bin         | Scripts for running Puppet and Facter |
| facter      | Facter source                         |
| hiera       | Hiera source                          |
| mcollective | MCollective source                    |
| misc        | Resources                             |
| puppet      | Puppet source                         |
| service     | code to run Puppet agent as a service |
| sys         | Ruby and other tools                  |

**Default:**

When using the architecture-appropriate installer, Puppet installs into `C:\Program Files\Puppet Labs\Puppet`.

If you install the x86 package on a 64-bit system, it installs into `C:\Program Files (x86)\Puppet Labs\Puppet`.

#### `PUPPET_MASTER_SERVER`

The hostname where the Puppet master server can be reached. This sets a value for the [`server` setting][s] in the `[main]` section of [puppet.conf][].

**Default:** `puppet`

> **Note:** If you set a _non-default_ value for this property, the installer **replaces** any existing value in [puppet.conf][]. Also, the next time you upgrade, the installer re-uses your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `server` setting directly in [puppet.conf][]; you should re-run the installer and set a new value there instead.

#### `PUPPET_CA_SERVER`

The hostname where the CA Puppet master server can be reached, if you are using multiple masters and only one of them is acting as the CA. This sets a value for [the `ca_server` setting][c] in the `[main]` section of [puppet.conf][].

**Default:** the value of the `PUPPET_MASTER_SERVER` property

> **Note:** If you set a _non-default_ value for this property, the installer **replace** any existing value in [puppet.conf][]. Also, the next time you upgrade, the installer re-uses your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `ca_server` setting directly in [puppet.conf][]; you should re-run the installer and set a new value there instead.

#### `PUPPET_AGENT_CERTNAME`

The node's certificate name, and the name it uses when requesting catalogs. This sets a value for the [`certname` setting][r] in the `[main]` section of [puppet.conf][].

For best compatibility, you should limit the value of `certname` to only use lowercase letters, numbers, periods, underscores, and dashes. (That is, it should match `/\A[a-z0-9._-]+\Z/`.)

**Default:** the node's fully-qualified domain name, as discovered by `facter fqdn`.

> **Note:** If you set a _non-default_ value for this property, the installer **replaces** any existing value in [puppet.conf][]. Also, the next time you upgrade, the installer re-uses your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `certname` setting directly in [puppet.conf][]; you should re-run the installer and set a new value there instead.

#### `PUPPET_AGENT_ENVIRONMENT`

The node's [environment][]. This sets a value for [the `environment` setting][e] in the `[main]` section of [puppet.conf][].

**Default:** `production`

> **Note:** If you set a _non-default_ value for this property, the installer **replaces** any existing value in [puppet.conf][]. Also, the next time you upgrade, the installer re-uses your previous value for this property unless you set a new value on the command line. So if you've used this property once, you shouldn't change the `environment` setting directly in [puppet.conf][]; you should re-run the installer and set a new value there instead.

#### `PUPPET_AGENT_STARTUP_MODE`

Whether the Puppet agent service should run (or be allowed to run). Allowed values:

-   `Automatic` (**default**): Puppet agent starts with Windows and stays running in the background.
-   `Manual`: Puppet agent won't run by default, but can be started in the services console or with `net start` on the command line.
-   `Disabled`: Puppet agent is installed but disabled. You must change its startup type in the services console before you can start the service.

#### `PUPPET_AGENT_ACCOUNT_USER`

Which Windows user account the Puppet agent service should use. This is important if the Puppet agent needs to access files on UNC shares, since the default `LocalSystem` account cannot access these network resources.

-   This user account **must already exist,** and can be a local or domain user. (The installer allows domain users even if they haven't accessed this machine before.)
-   If the user isn't already a local administrator, the installer adds it to the `Administrators` group.
-   The installer also grants the [`Logon as Service`](https://msdn.microsoft.com/en-us/library/ms813948.aspx) privilege to the user.

This property should be combined with [`PUPPET_AGENT_ACCOUNT_PASSWORD`](#puppetagentaccountpassword) and [`PUPPET_AGENT_ACCOUNT_DOMAIN`](#puppetagentaccountdomain). For example, to assign the agent to a domain user `ExampleCorp\bob`, install with:

    msiexec /qn /norestart /i puppet-agent-<VERSION>-x64.msi PUPPET_AGENT_ACCOUNT_DOMAIN=ExampleCorp PUPPET_AGENT_ACCOUNT_USER=bob PUPPET_AGENT_ACCOUNT_PASSWORD=password

**Default:** `LocalSystem`

#### `PUPPET_AGENT_ACCOUNT_PASSWORD`

The password to use for the Puppet agent's user account. See the notes under [`PUPPET_AGENT_ACCOUNT_USER`](#puppetagentaccountuser).

**Default:** no value.

#### `PUPPET_AGENT_ACCOUNT_DOMAIN`

The domain of the Puppet agent's user account. See the notes under [`PUPPET_AGENT_ACCOUNT_USER`](#puppetagentaccountuser).

**Default:** `.`

#### Downgrades

If you need to replace a 64-bit version of Puppet with a 32-bit version, you must **uninstall** Puppet before installing the new package.

### Uninstalling

You can uninstall Puppet through the "Add or Remove Programs" interface or from the command line.

To uninstall Puppet from the command line, you must have the original MSI file or know the [ProductCode](https://msdn.microsoft.com/en-us/library/windows/desktop/aa370854.aspx) of the installed MSI:

    msiexec /qn /norestart /x puppet-agent-1.4.2-x64.msi
    msiexec /qn /norestart /x <PRODUCT CODE>

When you uninstall Puppet, the uninstaller removes Puppet's program directory, the Puppet agent service, and all related registry keys. It leaves the [confdir][], [codedir][], and [vardir][] intact, including any SSL keys. To completely remove Puppet from the system, manually delete the confdir, codedir, and vardir.
