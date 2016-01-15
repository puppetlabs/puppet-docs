---
layout: default
title: "PE 3.1 » Installing » Windows Agents"
subtitle: "Installing Windows Agents"
canonical: "/pe/latest/install_windows.html"
---


[pedownloads]: http://info.puppetlabs.com/download-pe.html

> ![windows logo](./images/windows-logo-small.jpg) This chapter refers to Windows functionality. To install PE on \*nix nodes, see [Installing Puppet Enterprise](./install_basic.html).

For supported versions of Windows, [see the System Requirements page](./install_system_requirements.html#operating-system).

Windows nodes in Puppet Enterprise:

* Can fetch configurations from a puppet master and apply manifests locally
* Can respond to live management or orchestration commands
* Cannot serve as a puppet master, console, or database support server

See [the main Puppet on Windows documentation](/windows/) for details on [running Puppet on Windows](/windows/running.html) and [writing manifests for Windows](/windows/writing.html).

In particular, note that puppet *must* be run with elevated privileges (a.k.a., "Run as administrator"), as explained in this [section on Windows Security Context](/windows/running.html#security-context).

[running]: /windows/running.html

[startmenu]: ./images/windows/start_menu.png
[server]: ./images/windows/wizard_server.png

Installing Puppet
-----

To install Puppet Enterprise on a Windows node, simply [download][pedownloads] and run the installer, which is a standard Windows .msi package and will run as a graphical wizard. Alternately, you can run the installer unattended; [see "Automated Installation" below.](#automated-installation)

The installer must be run with elevated privileges. Installing Puppet **does not** require a system reboot.

The only information you need to specify during installation is **the hostname of your puppet master server:**

![Puppet master hostname selection][server]

### After Installation

Once the installer finishes:

* Puppet agent will be running as a Windows service, and will fetch and apply configurations every 30 minutes (by default). You can now assign classes to the node as normal; [see "Puppet: Assigning Configurations to Nodes" for more details](./puppet_assign_configurations.html). After the first puppet run, the MCollective service will also be running and the node can now be controlled with live management and orchestration. The puppet agent service and the MCollective service can be started and stopped independently using either the service control manager GUI or the command line `sc.exe` utility; see [Running Puppet on Windows](/windows/running.html#configuring-the-agent-service) for more details.
* The Start Menu will contain a Puppet folder, with shortcuts for running puppet agent manually, running Facter, and opening a command prompt for use with the Puppet tools. See [Running Puppet on Windows][running] for more details.

    ![Start Menu icons][startmenu]
* Puppet is automatically added to the machine's PATH environment variable. This means you can open any command line and call `puppet`, `facter` and the few other batch files that are in the `bin` directory of the [Puppet installation](#program-directory). This will also add necessary items for the Puppet environment to the shell, but only for the duration of execution of each of the particular commands.

Automated Installation
-----

For automated deployments, Puppet can be installed unattended on the command line as follows:

    msiexec /qn /i puppet.msi

You can also specify `/l*v install.txt` to log the progress of the installation to a file.

The following public MSI properties can also be specified:

 MSI Property                  | Puppet Setting    | Default Value
-------------------------------|-------------------|--------------
`INSTALLDIR`                   | n/a               | Version-dependent; [see below](#program-directory)
`PUPPET_MASTER_SERVER`         | [`server`][s]     | `puppet`
`PUPPET_CA_SERVER`             | [`ca_server`][c]  | Value of `PUPPET_MASTER_SERVER`
`PUPPET_AGENT_CERTNAME`        | [`certname`][r]   | Value of `facter fdqn` (must be lowercase)
`PUPPET_AGENT_ENVIRONMENT`     | [`environment`][e]| `production`

For example:

    msiexec /qn /i puppet.msi PUPPET_MASTER_SERVER=puppet.acme.com

**Note:** If a value for the `environment` variable already exists in puppet.conf, specifying it during installation will NOT override that value.

[s]: /puppet/3.3/reference/configuration.html#server
[c]: /puppet/3.3/reference/configuration.html#caserver
[r]: /puppet/3.3/reference/configuration.html#certname
[e]: /puppet/3.3/reference/configuration.html#environment

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

In order to provide a self-contained installation, the Puppet installer includes all of Puppet's dependencies, including Ruby, Gems, and Facter.  (Puppet redistributes the 32-bit Ruby application from [rubyinstaller.org](http://rubyinstaller.org). MCollective is also installed.

These prerequisites are used only for Puppet Enterprise components and do not interfere with other local copies of Ruby.


### Program Directory

Unless overridden during installation, Puppet and its dependencies are installed into the standard Program Files directory for 32-bit applications and the Program Files(x86) directory for 64-bit applications.

Puppet Enterprise's default installation path is:


OS type  | Default Install Path
---------|--------------------
32-bit   | `C:\Program Files\Puppet Labs\Puppet Enterprise`
64-bit   | `C:\Program Files (x86)\Puppet Labs\Puppet Enterprise`


The Program Files directory can be located using the `PROGRAMFILES` environment variable on 32-bit versions of Windows or the `PROGRAMFILES(X86)` variable on 64-bit versions.

Puppet's program directory contains the following subdirectories:

Directory           | Description
--------------------|--------------------------------------
bin                 | scripts for running Puppet and Facter
facter              | Facter source
hiera               | Hiera source
mcollective         | MCollective source
mcollective_plugins | plugins used by MCollective
misc                | resources
puppet              | Puppet source
service             | code to run puppet agent as a service
sys                 | Ruby and other tools


### Data Directory

Puppet Enterprise and its components store settings (`puppet.conf`), manifests, and generated data (like logs and catalogs) in the **data directory.** Puppet's data directory contains two subdirectories for the various components (facter, MCollective, etc.):

* `etc` (the `$confdir`) contains configuration files, manifests, certificates, and other important files
* `var` (the `$vardir`) contains generated data and logs

When run with elevated privileges --- Puppet's intended state --- the data directory is located in the [`COMMON_APPDATA`](http://msdn.microsoft.com/en-us/library/windows/desktop/bb762494\(v=vs.85\).aspx) folder. This folder's location varies by Windows version:

OS Version| Path                                            | Default
----------|-------------------------------------------------|---------
2003      | `%ALLUSERSPROFILE%\Application Data\PuppetLabs\puppet` | `C:\Documents and Settings\All Users\Application Data\PuppetLabs\`
7, 2008, 2012   | `%PROGRAMDATA%\PuppetLabs\`                      | `C:\ProgramData\PuppetLabs\`


Since the CommonAppData directory is a system folder, it is hidden by default. See <http://support.microsoft.com/kb/812003> for steps to show system and hidden files and folders.

If Puppet is run without elevated privileges, it will use a `.puppet` directory in the current user's home folder as its data directory. This may result in Puppet having unexpected settings.

### More

For more details about using Puppet on Windows, see:

* [Running Puppet on Windows][running]
* [Writing Manifests for Windows](/windows/writing.html)

* * *

- [Next: Upgrading](./install_upgrading.html)
