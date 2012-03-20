---
layout: pe2experimental
title: "Installing Puppet on Windows"
nav: windows.html
---




### Supported Platforms
Puppet agent functionality is supported on the following Windows&#174; systems:

* Windows Server 2003 and 2003 R2
* Windows Server 2008 and 2008 R2
* Windows 7


### Considerations
Puppet and all of its necessary dependencies are packaged as a Windows-based installer (MSI) package. The package contains ruby, gems, facter and puppet. The package does not require ruby to be present on the system, and in fact, will not use or modify an existing ruby installation if one does exist.

The package must be installed with elevated privileges, as puppet itself must run with elevated privileges in order to make changes to system files and configuration.

During installation, the system PATH will not be modified, so the system will not need to be rebooted after installing puppet.

## Installation

Puppet can be installed using a GUI or from the command-line.

### GUI

See <https://github.com/puppetlabs/puppet_for_the_win/blob/master/README.markdown> for current screen shots for installing Puppet Enterprise, including shortcut icons.

### Command Line

Puppet can be installed unattended on the command line as follows:

    msiexec /qn /i puppet.msi

You can also specify `/l*v install.txt` to log the progress of the installation to a file.

The following public MSI properties can also be specified:

<table>
  <tr>
    <th>MSI Property</th>
    <th>Puppet Property</th>
    <th>Default Value</th>
  </tr>
  <tr>
    <td>INSTALLDIR</td>
    <td>n/a</td>
    <td>%PROGRAMFILES(x86)%\Puppet Labs\Puppet</td>
  </tr>
  <tr>
    <td>PUPPET_MASTER_SERVER</td>
    <td><a href="http://docs.puppetlabs.com/references/stable/configuration.html#server">server</a></td>
    <td>puppet</td>
  </tr>
  <tr>
    <td>PUPPET_CA_SERVER</td>
    <td><a href="http://docs.puppetlabs.com/references/stable/configuration.html#caserver">ca_server</a></td>
    <td>Value of PUPPET_MASTER_SERVER</td>
  </tr>
  <tr>
    <td>PUPPET_AGENT_CERTNAME</td>
    <td><a href="http://docs.puppetlabs.com/references/stable/configuration.html#certname">certname</a></td>
    <td>Value of facter fdqn (must be lowercase)</td>
  </tr>
</table>

<!--
MSI Property            | Puppet Property | Default Value
------------------------|-----------------|--------------
`INSTALLDIR`            | n/a             | `%PROGRAMFILES(x86)%\Puppet Labs\Puppet`
`PUPPET_MASTER_SERVER`  | `server`        | `puppet`
`PUPPET_CA_SERVER`      | `ca_server`     | Value of `PUPPET_MASTER_SERVER`
`PUPPET_AGENT_CERTNAME` | `certname`      | Value of facter fdqn (must be lowercase)
-->

For example:

    msiexec /qn puppet.msi PUPPET_MASTER_SERVER=puppet.acme.com

### Installation Directory
Puppet redistributes the 32-bit ruby application from rubyinstaller.org. During installation, puppet and its dependencies are installed by default into the standard `Program Files` directory for 32-bit applications. 

For FOSS, the default installation path is:

<table>
<tr>
<th>OS</th>
<th>Default Install Path</th>
</tr>
<tr>
<td>32-bit</td>
<td>C:\Program Files\Puppet Labs\Puppet</td>
</tr>
<tr>
<td>64-bit</td>
<td>C:\Program Files (x86)\Puppet Labs\Puppet</td>
</tr>
</table>

For PE, the default installation path is:

<table>
<tr>
<th>OS</th>
<th>Default Install Path</th>
</tr>
<tr>
<td>32-bit</td>
<td>C:\Program Files\Puppet Labs\Puppet Enterprise</td>
</tr>
<tr>
<td>64-bit</td>
<td>C:\Program Files (x86)\Puppet Labs\Puppet Enterprise</td>
</tr>
</table>

These directories can be resolved using the `PROGRAMFILES` environment variable on 32-bit versions of Windows, or using `PROGRAMFILES(X86)` on 64-bit.

Installation will create the following directory structure:

<table>
<tr>
<th>Directory</th>
<th>Description</th>
</tr>
<tr>
<td>bin</td>
<td>scripts to run puppet and facter</td>
</tr>
<tr>
<td>facter</td>
<td>facter source</td>
</tr>
<tr>
<td>misc</td>
<td>resources</td>
</tr>
<tr>
<td>puppet</td>
<td>puppet source</td>
</tr>
<tr>
<td>service</td>
<td>code to run as a service</td>
</tr>
<tr>
<td>sys</td>
<td>ruby and other tools</td>
</tr>
</table>

### Data Directory
Puppet stores data, e.g. puppet.conf, logs, catalogs, etc, in its data directory, the location of which depends on whether the user is running with elevated privileges or not. 

In a non-elevated context, puppet stores its data relative to ruby's `HOME` environment variable, which Ruby on Windows typically sets based on the `HOMEDRIVE` and `HOMEPATH` environment variables. For example, `C:\Users\<user>\.puppet`

In an elevated context, puppet stores its data in a directory relative to the [COMMON_APPDATA](http://msdn.microsoft.com/en-us/library/windows/desktop/bb762494\(v=vs.85\).aspx) well-known folder. This folder is specifically designed for storing per-machine data. Since CommonAppData directory is a system folder, it is hidden by default. See <http://support.microsoft.com/kb/812003> for steps to show system and hidden files and folders.

The location of this folder varies by OS:

<table>
<tr>
<th>OS</th>
<th>Path</th>
<th>Typical</th>
</tr>
<tr>
<td>2003</td>
<td>%ALLUSERSPROFILE%\Application Data\PuppetLabs</td>
<td>C:\Documents and Settings\All Users\Application Data\PuppetLabs</td>
</tr>
<tr>
<td>2008,7</td>
<td>%PROGRAMDATA%\PuppetLabs</td>
<td>C:\ProgramData\PuppetLabs</td>
</table>

The exact location of the directory can be obtained using the `ALLUSERSPROFILE` and `PROGRAMDATA` environment variables for the respective OS, or alternatively, the `Dir::COMMON_APPDATA` constant from the `win32-dir` ruby gem.

### Service
The installer will create a windows service to run the puppet agent every 30 minutes by default. The interval can be changed via the `runinterval` property in puppet.conf contained in puppet's data directory.

The service will automatically start when installation completes and whenever the system is rebooted. This behavior can be customized prior to installation by modifyng the MSI package or applying a transform (MST) to change the `ServiceType` value of the `ServiceControl` table. See <http://msdn.microsoft.com/en-us/library/windows/desktop/aa371637(v=vs.85).aspx>

After installation, the startup type can be configured using the Service Control Manager or from the command line:

<pre>
C:\>sc config puppet start= demand
[SC] ChangeServiceConfig SUCCESS
</pre>


## Upgrading
Puppet can be upgraded simply by installing a new version of the MSI package. During the upgrade process, any values specified during the last install, e.g. PUPPET_MASTER_SERVER, will be retrieved from the registry and displayed in the GUI. If any value is changed in the GUI or on the command line, then the new value will only be written to puppet.conf if the configuration setting does not exist in puppet.conf. In other words, the installer will not overwrite settings in puppet.conf, only create new entries.

During the upgrade process, the old service will be stopped, changes applied to the system, and the new service started.

## Uninstallation
Puppet can be uninstalled through Add/Remove Programs (ARP) or from the command line. In the latter case, you need to either have the original MSI or know the [ProductCode](http://msdn.microsoft.com/en-us/library/windows/desktop/aa370854(v=vs.85\).aspx) of the installed MSI.

    msiexec /qn /x [puppet.msi|product-code]

During an uninstall, the installation directory where puppet was installed will be removed, e.g. `C:\Program Files (x86)\Puppet Labs\Puppet`. In addition, the puppet service will be stopped and removed, and all registry keys relating to the service removed.

The data directory will be left behind, e.g. puppet.conf, ssl certificates and keys. To completely clean the system, the data directory should be deleted.

