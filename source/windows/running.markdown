---
layout: pe2experimental
title: "Running Puppet on Windows"
nav: windows.html
---





### Configuration
The installer will create a puppet.conf within puppet's data directory. Additional properties can be specified. Run `puppet configprint all` to see the list of possible properties. Note unlike Unix, the puppet service must be restarted when configuration changes are made.

### Service
The puppet service can be controlled via the Service Control Manager or from the command line. For example, to restart puppet:

    c:\>sc stop puppet && sc start puppet

The `sc.exe` utility can also be used to view or change the service configuration, or to launch puppet with arguments (the output of which will be written to puppet's log):

    c:\>sc start puppet --test --debug

### Logging
By default, puppet will log to a file, whose location is controlled by the [puppetdlog](http://docs.puppetlabs.com/references/stable/configuration.html#puppetdlog) configuration setting.

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



### Installation Directory
Puppet redistributes the 32-bit ruby application from rubyinstaller.org. During installation, puppet and its dependencies are installed by default into the standard `Program Files` directory for 32-bit applications. 

For FOSS, the default installation path is:


  OS   | Default Install Path
-------|---------------------
32-bit | `C:\Program Files\Puppet Labs\Puppet`
64-bit | `C:\Program Files (x86)\Puppet Labs\Puppet`


For PE, the default installation path is:


  OS   | Default Install Path
-------|--------------------
32-bit | `C:\Program Files\Puppet Labs\Puppet Enterprise`
64-bit | `C:\Program Files (x86)\Puppet Labs\Puppet Enterprise`


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