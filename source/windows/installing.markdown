---
layout: default
title: "Installing Puppet on Windows"
nav: windows.html
---

<span class="versionnote">This documentation applies to Puppet versions ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>

[downloads]: http://downloads.puppetlabs.com/windows
[pedownloads]: http://info.puppetlabs.com/download-pe.html

Before Installing
-----

### Downloads

Download the Puppet installer for Windows here:

* [Puppet Enterprise Windows installer][pedownloads]
* [Standard Windows installer][downloads]

If you are using Puppet Enterprise, use the PE-specific installer; otherwise, use the standard installer.

### Supported Platforms

Puppet runs on the following versions of Windows:

{% include platforms_windows.markdown %}

The Puppet installer bundles all of Puppet's prerequisites. There are no additional software requirements.

### Puppet Master Requirements

Windows nodes cannot serve as puppet master servers.

* If your Windows nodes will be fetching configurations from a puppet master, you will need a \*nix server to run as puppet master at your site.
* If your Windows nodes will be compiling and applying configurations locally with puppet apply, you should disable the puppet agent service on them after installing Puppet. See [Running Puppet on Windows](./running.html) for details on how to stop the service.

> Version note for PE users: Your puppet master should be running PE 2.5 or later. On PE 2.0, the `pe_mcollective` and `pe_accounts` modules cause run failures on Windows nodes. If you wish to run Windows agents but have a PE 2.0 puppet master, you can do one of the following:
>
> * [Upgrade your master to PE 2.5 or later](/pe/latest/install_upgrading.html)
> * Remove those modules from the console's default group
> * Manually hack those modules to be inert on Windows.



[running]: ./running.html

[server]: ./images/wizard_server.png
[startmenu]: ./images/start_menu.png

Installing Puppet
-----

To install Puppet, simply download and run the installer, which is a standard Windows .msi package and will run as a graphical wizard. Alternately, you can run the installer unattended; [see "Automated Installation" below.](#automated-installation)

The installer must be run with elevated privileges. Installing Puppet **does not** require a system reboot.

The only information you need to specify during installation is **the hostname of your puppet master server:** (If you are using puppet apply for node configuration instead of a puppet master, you can just enter some dummy text here.)

Note that you can download and install Puppet Enterprise on up to ten nodes at no charge. No licence key is needed to run PE on up to ten nodes.

![Puppet master hostname selection][server]

### After Installation

Once the installer finishes:

* Puppet agent will be running as a Windows service, and will fetch and apply configurations every 30 minutes (by default). You can now assign classes to the node on your puppet master or console server. The puppet agent service can be started and stopped with the Service Control Manager or the `sc.exe` utility; see [Running Puppet on Windows](./running.html#configuring-the-agent-service) for more details.
* The Start menu will contain a Puppet folder, with shortcuts for running puppet agent manually, running Facter, and opening a command prompt for use with the Puppet tools. See [Running Puppet on Windows][running] for more details. The Start menu folder also contains documentation links.

    ![Start Menu icons][startmenu]
* Starting with version 3.3.1 of Puppet and 3.1.0 of Puppet Enterprise, Puppet is automatically added to the machine's PATH environment variable. This means you can open any command line and call `puppet`, `facter` and the few other batch files that are in the `bin` directory of the [Puppet installation](#program-directory). This will also add necessary items for the Puppet environment to the shell, but only for the duration of execution of each of the particular commands.

Automated Installation
-----

For automated deployments, Puppet can be installed unattended on the command line as follows:

    msiexec /qn /i puppet.msi

You can also specify `/l*v install.txt` to log the progress of the installation to a file.

The following public MSI properties can also be specified:

Minimum Version      | MSI Property                  | Puppet Setting    | Default Value
---------------------|-------------------------------|-------------------|--------------
2.7.12 / PE 2.5.0    |`INSTALLDIR`                   | n/a               | Version-dependent; [see below](#program-directory)
2.7.12 / PE 2.5.0    |`PUPPET_MASTER_SERVER`         | [`server`][s]     | `puppet`
2.7.12 / PE 2.5.0    |`PUPPET_CA_SERVER`             | [`ca_server`][c]  | Value of `PUPPET_MASTER_SERVER`
2.7.12 / PE 2.5.0    |`PUPPET_AGENT_CERTNAME`        | [`certname`][r]   | Value of `facter fdqn` (must be lowercase)
3.3.1  / PE 3.1.0    |`PUPPET_AGENT_ENVIRONMENT`     | [`environment`][e]| `production`
3.4.0  / pending     |`PUPPET_AGENT_STARTUP_MODE`    | n/a               | `Automatic`; [see startup mode](#agent-startup-mode)
3.4.0  / pending     |`PUPPET_AGENT_ACCOUNT_USER`    | n/a               | `LocalSystem`; [see agent account](#agent-account)
3.4.0  / pending     |`PUPPET_AGENT_ACCOUNT_PASSWORD`| n/a               | No Value; [see agent account](#agent-account)
3.4.0  / pending     |`PUPPET_AGENT_ACCOUNT_DOMAIN`  | n/a               | `.`; [see agent account](#agent-account)

For example:

    msiexec /qn /i puppet.msi PUPPET_MASTER_SERVER=puppet.acme.com

### Modifying puppet.conf With MSI Properties

If values for Puppet settings are specified with MSI properties during an install or upgrade, the installer will set them in the `[main]` section of puppet.conf.

**Starting with Puppet 3.4.0,** the installer will replace existing values in puppet.conf if a new value is provided on the command line. Additionally, if a value has been provided on the command line once, it will be remembered in the registry and future upgrades will re-set it in puppet.conf if necessary. This means that if you need to change the `server`, `ca_server`, `certname`, or `environment` settings after setting them via the installer, you should do so by running the installer on the command line again with new values. This "memory effect" doesn't happen with the default values for the MSI properties; it only happens if a value is explicitly set.


[s]: /references/latest/configuration.html#server
[c]: /references/latest/configuration.html#caserver
[r]: /references/latest/configuration.html#certname
[e]: /references/latest/configuration.html#environment

Upgrading
-----

Puppet can be upgraded by installing a new version of the MSI package. No extra steps are required, and the installer will handle stopping and re-starting the puppet agent service.

When upgrading, the installer will not replace any settings in the main puppet.conf configuration file, but it can add previously unspecified settings if they are provided on the command line.

Uninstalling
-----

Puppet can be uninstalled through Windows' standard "Add or Remove Programs" interface or from the command line.

To uninstall from the command line, you must have the original MSI file or know the <a href="http://msdn.microsoft.com/en-us/library/windows/desktop/aa370854(v=vs.85).aspx">ProductCode</a> of the installed MSI:

    msiexec /qn /x [puppet.msi|product-code]

Uninstalling will remove Puppet's program directory, the puppet agent service, and all related registry keys. It will leave the [data directory](#data-directory) intact, including any SSL keys. To completely remove Puppet from the system, the data directory can be manually deleted.


Installation Details
-----

### What Gets Installed

In order to provide a self-contained installation, the Puppet installer includes all of Puppet's dependencies, including Ruby, Gems, and Facter. (Puppet redistributes the 32-bit Ruby application from [rubyinstaller.org](http://rubyinstaller.org)).

These prerequisites are used only for Puppet and do not interfere with other local copies of Ruby.


### Program Directory

Unless overridden during installation, Puppet and its dependencies are installed into the standard Program Files directory for 32-bit applications and the Program Files(x86) directory for 64-bit applications.

For Puppet Enterprise, the default installation path is:


OS type  | Default Install Path
---------|--------------------
32-bit   | `C:\Program Files\Puppet Labs\Puppet Enterprise`
64-bit   | `C:\Program Files (x86)\Puppet Labs\Puppet Enterprise`


For open source Puppet, the default installation path is:


OS type  | Default Install Path
---------|---------------------
32-bit   | `C:\Program Files\Puppet Labs\Puppet`
64-bit   | `C:\Program Files (x86)\Puppet Labs\Puppet`


The Program Files directory can be located using the `PROGRAMFILES` environment variable on 32-bit versions of Windows or the `PROGRAMFILES(X86)` variable on 64-bit versions.

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

### Agent Startup Mode

The agent is set to `Automatic` startup by default, but allows for you to pass `Manual` or `Disabled` as well.

 * `Automatic` means that the Puppet agent will start with windows and be running all the time in the background. This is the what you would choose when you want to run Puppet with a master.
 * `Manual` means that the agent will start up only when it is started in the services console or through `net start` on the command line. Typically this used in advanced usages of Puppet.
 * `Disabled` means that the agent will be installed but disabled and will not be able to start in the services console (unless you change the start up type in the services console first). This is desirable when you want to install puppet but you only want to invoke it as you specify and not use it with a master.

### Agent Account

By default, Puppet installs the agent with the built in `SYSTEM` account. This account does not have access to the network, therefore it is suggested that another account that has network access be specified. The account must be an existing account. In the case of a domain user, the account does not need to have accessed the box. If this account is not a local administrator and it is specified as part of the install, it will be added to the `Administrators` group on that particular node. The account will also be granted [`Logon as Service`](http://msdn.microsoft.com/en-us/library/ms813948.aspx) as part of the installation process. As an example, if you wanted to set the agent account to a domain user `AbcCorp\bob` you would call the installer from the command line appending the following items: `PUPPET_AGENT_ACCOUNT_DOMAIN=AbcCorp PUPPET_AGENT_ACCOUNT_USER=bob PUPPET_AGENT_ACCOUNT_PASSWORD=password`.

### Data Directory

Puppet stores its settings (`puppet.conf`), manifests, and generated data (like logs and catalogs) in its **data directory.** Puppet's data directory contains two subdirectories:

* `etc` (the `$confdir`) contains configuration files, manifests, certificates, and other important files
* `var` (the `$vardir`) contains generated data and logs

When run with elevated privileges, the data directory is located in `COMMON_APPDATA\PuppetLabs\puppet`; see below for more about the `COMMON_APPDATA` folder. When run without elevated privileges, the data directory will be a `.puppet` directory in the current user's home folder. Puppet on Windows should usually be run **with** elevated privileges.

#### The `COMMON_APPDATA` Folder

Windows' <a href="http://msdn.microsoft.com/en-us/library/windows/desktop/bb762494(v=vs.85).aspx"><code>COMMON_APPDATA</code></a> folder contains non-roaming application data for all users. Its location varies by Windows version:

OS Version| Path                                 | Default
----------|--------------------------------------|-----------------
7+, 2008+ | `%PROGRAMDATA%`                      | `C:\ProgramData`
2003      | `%ALLUSERSPROFILE%\Application Data` | `C:\Documents and Settings\All Users\Application Data`

Since the CommonAppData directory is a system folder, it is hidden by default. See <http://support.microsoft.com/kb/812003> for steps to show system and hidden files and folders.



### More

For more details about using Puppet on Windows, see:

* [Running Puppet on Windows][running]
* [Writing Manifests for Windows](./writing.html)
