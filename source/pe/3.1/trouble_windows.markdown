---
layout: default
title: "PE 3.1 » Troubleshooting » Windows"
subtitle: "Troubleshooting Puppet on Windows"
canonical: "/pe/latest/trouble_windows.html"
---

[datadirectory]: ./install_windows.html#data-directory


Puppet Enterprise supports Windows agents, for both the core Puppet configuration management features and the orchestration features.

Windows agents can have different problems and symptoms than \*nix agents. This page outlines some of the more common issues and their solutions.

## Tips

### Process Explorer

We recommend installing [Process Explorer](http://en.wikipedia.org/wiki/Process_Explorer) and configuring it to replace Task Manager. This will make debugging significantly easier.

### Logging

As of Puppet 2.7.x, messages from the `puppetd` log file are available via the Windows Event Viewer (choose "Windows Logs" > "Application"). To enable debugging, stop the puppet service and restart it as:

    c:\>sc stop puppet && sc start puppet --debug --trace

Puppet's windows service component also writes to the `windows.log` within the same `log` directory and can be used to debug issues with the service.

## Common Issues

### Installation

The Puppet MSI package will not overwrite an existing entry in the puppet.conf file.  As a result, if you uninstall the package, then reinstall the package using a different puppet master hostname, Puppet won't actually apply the new value if the previous value still exists in [`<data directory>`][datadirectory]`\etc\puppet.conf`.

In general, we've taken the approach of preserving configuration data on the system when doing an upgrade, uninstall or reinstall.

To fully clean out a system make sure to delete the [`<data directory>`][datadirectory].

Similarly, the MSI will not overwrite the custom facts written to the `PuppetLabs\facter\facts.d` directory.

### Unattended installation

Puppet may fail to install when trying to perform an unattended install from the command line, e.g.

    msiexec /qn /i puppet.msi

To get troubleshooting data, specify an installation log, e.g. /l*v install.txt. Look in the log for entries like the following:

    MSI (s) (7C:D0) [17:24:15:870]: Rejecting product '{D07C45E2-A53E-4D7B-844F-F8F608AFF7C8}': Non-assigned apps are disabled for non-admin users.
    MSI (s) (7C:D0) [17:24:15:870]: Note: 1: 1708
    MSI (s) (7C:D0) [17:24:15:870]: Product: Puppet -- Installation failed.
    MSI (s) (7C:D0) [17:24:15:870]: Windows Installer installed the product. Product Name: Puppet. Product Version: 2.7.12. Product Language: 1033. Manufacturer: Puppet Labs. Installation success or error status: 1625.
    MSI (s) (7C:D0) [17:24:15:870]: MainEngineThread is returning 1625
    MSI (s) (7C:08) [17:24:15:870]: No System Restore sequence number for this installation.
    Info 1625.This installation is forbidden by system policy. Contact your system administrator.

If you see entries like this you know you don't have sufficient privileges to install puppet. Make sure to launch `cmd.exe` with the `Run as Administrator` option selected, and try again.

## File Paths

### Path Separator

Make sure to use a semi-colon (;) as the path separator on Windows, e.g., `modulepath=path1;path2`

### File Separator

[backslashes]: /windows/writing.html#file-paths-on-windows

In most resource attributes, the Puppet language accepts either forward- or backslashes as the file separator. However, some attributes absolutely require forward slashes, and some attributes absolutely require backslashes. [See the relevant section of Writing Manifests for Windows][backslashes] for more information.

### Backslashes

When backslashes are double-quoted("), they **must** be escaped. When single-quoted ('), they **may** be escaped. For example, these are valid file resources:

    file { 'c:\path\to\file.txt': }
    file { 'c:\\path\\to\\file.txt': }
    file { "c:\\path\\to\\file.txt": }

But this is an invalid path, because \p, \t, \f will be interpreted as escape sequences:

    file { "c:\path\to\file.txt": }

### UNC Paths

UNC paths are not currently supported. However, the path can be mapped as a network drive and accessed that way.

### Case-insensitivity

Several resources are case-insensitive on Windows (file, user, group). When establishing dependencies among resources, make sure to specify the case consistently. Otherwise, puppet may not be able to resolve dependencies correctly. For example, applying the following manifest will fail, because puppet does not recognize that FOOBAR and foobar are the same user:

    file { 'c:\foo\bar':
      ensure => directory,
      owner => 'FOOBAR'
    }
    user { 'foobar':
      ensure => present
    }
    ...
    err: /Stage[main]//File[c:\foo\bar]: Could not evaluate: Could not find user FOOBAR

### Diffs

Puppet does not show diffs on Windows (e.g., `puppet agent --show_diff`) unless a third-party diff utility has been installed (e.g., msys, gnudiff, cygwin, etc) and the `diff` property has been set appropriately.

## Resource Errors and Quirks

### File

If the owner and/or group are specified in a file resource on Windows, the mode must also be specified. So this is okay:

    file { 'c:/path/to/file.bat':
      ensure => present,
      owner => 'Administrator',
      group => 'Administrators',
      mode => 0770
    }

But this is not:

    file { 'c:/path/to/file.bat':
      ensure => present,
      owner => 'Administrator',
      group => 'Adminstrators',
    }

The latter case will remove any permissions the Administrators group previously had to the file, resulting in the effective permissions of 0700. And since puppet runs as a service under the "SYSTEM" account, not "Administrator," Puppet itself will not be able to manage the file the next time it runs!

To get out of this state, have Puppet execute the following (with an exec resource) to reset the file permissions:

    takeown /f c:/path/to/file.bat && icacls c:/path/to/file.bat /reset

### Exec

When declaring a Windows exec resource, the path to the resource typically depends on the %WINDIR% environment variable. Since this may vary from system to system, you can use the `path` fact in the exec resource:

    exec { 'cmd.exe /c echo hello world':
      path => $::path
    }

### Shell Builtins

Puppet does not currently support a shell provider on Windows, so executing shell builtins directly will fail:

    exec { 'echo foo':
      path => 'c:\windows\system32;c:\windows'
    }
    ...
    err: /Stage[main]//Exec[echo foo]/returns: change from notrun to 0 failed: Could not find command 'echo'

Instead, wrap the builtin in `cmd.exe`:

    exec { 'cmd.exe /c echo foo':
      path => 'c:\windows\system32;c:\windows'
    }

Or, better still, use the tip from above:

    exec { 'cmd.exe /c echo foo':
      path => $::path
    }

### Powershell

By default, powershell enforces a restricted execution policy which prevents the execution of scripts. Consequently, make sure to specify the appropriate execution policy in the powershell command:

    exec { 'test':
      command => 'powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
      path => $::path
    }

### Package

The source of an MSI package must be a file on either a local filesystem or on a network mapped drive. It does not support URI-based sources, though you can achieve a similar result by defining a file whose source is the puppet master and then defining a package whose source is the local file.

### Service

Windows services support a short name and a display name. Make sure to use the short name in puppet manifests. For example use `wuauserv`, not `Automatic Updates`. You can use `sc query` to get a list of services and their various names.

## Error Messages

* "`Error: Could not connect via HTTPS to https://forge.puppetlabs.com / Unable to verify the SSL certificate / The certificate may not be signed by a valid CA / The CA bundle included with OpenSSL may not be valid or up to date`"

    This can occur when you run the `puppet module` subcommand on newly provisioned Windows nodes.

    The Puppet Forge uses an SSL certificate signed by the GeoTrust Global CA certificate. Newly provisioned Windows nodes may not have that CA in their root CA store yet.

    To resolve this and enable the `puppet module` subcommand on Windows nodes, do _one_ of the following:

    * Run Windows Update and fetch all available updates, then visit <https://forge.puppetlabs.com> in your web browser. The web browser will notice that the GeoTrust CA is whitelisted for automatic download, and will add it to the root CA store.
    * Download the "GeoTrust Global CA" certificate from [GeoTrust's list of root certificates](https://www.geotrust.com/resources/root-certificates/) and manually install it by running `certutil -addstore Root GeoTrust_Global_CA.pem`.

* "`Service 'Puppet Agent' (puppet) failed to start. Verify that you have sufficient privileges to start system services.`"

    This can occur when installing puppet on a UAC system from a non-elevated account. Although the installer displays the UAC prompt to install puppet, it does not elevate when trying to start the service. Make sure to run from an elevated `cmd.exe` process when installing the MSI.

* "`Cannot run on Microsoft Windows without the sys-admin, win32-process, win32-dir, win32-service and win32-taskscheduler gems.`"

    Puppet requires the indicated Windows-specific gems, which can be installed using `gem install <gem>`

* "`err: /Stage[main]//Scheduled_task[task_system]: Could not evaluate: The operation completed successfully.`"

    This error can occur when using version < 0.2.1 of the win32-taskscheduler gem. Run `gem update win32-taskscheduler`

* "`err: /Stage[main]//Exec[C:/tmp/foo.exe]/returns: change from notrun to 0 failed: CreateProcess() failed: Access is denied.`"

    This error can occur when requesting an executable from a remote puppet master that cannot be executed. For a file to be executable on Windows, set the user/group executable bits accordingly on the puppet master (or alternatively, specify the mode of the file as it should exist on the Windows host):

        file { "C:/tmp/foo.exe":
          source => "puppet:///modules/foo/foo.exe",
        }

        exec { 'C:/tmp/foo.exe':
          logoutput => true
        }

* "`err: getaddrinfo: The storage control blocks were destroyed.`"

    This error can occur when the agent cannot resolve a DNS name into an IP address (for example the `server`, `ca_server`, etc properties). To verify that there is a DNS issue, check that you can run `nslookup <dns>`. If this fails, there is a problem with the DNS settings on the Windows agent (for example, the primary dns suffix is not set). See <http://technet.microsoft.com/en-us/library/cc959322.aspx>

* "`err: /Stage[main]//Group[mygroup]/members: change from     to Administrators failed: Add OLE error code:8007056B in <Unknown> <No Description> HRESULT error code:0x80020009 Exception occurred.`"

    This error will occur when attempting to add a group as a member of another local group, i.e. nesting groups. Although Active Directory supports <a href="http://msdn.microsoft.com/en-us/library/cc246068(v=prot.13).aspx">nested groups</a> for certain types of domain group accounts, Windows does not support nesting of local group accounts. As a result, you must only specify user accounts as members of a group.

* "`err: /Stage[main]//Package[7zip]/ensure: change from absent to present failed: Execution of 'msiexec.exe /qn /norestart /i "c:\\7z920.exe"' returned 1620: T h i s   i n s t a l l a t i o n   p a c k a g e   c o u l d   n o t   b e   o p e n e d .  C o n t a c t   t h e   a p p l i c a t i o n   v e n d o r   t o   v e r i f y   t h a t   t h i s   i s  a   v a l i d   W i n d o w s   I n s t a l l e r   p a c k a g e .`"

    This error can occur when attempting to install a non-MSI package. Puppet only supports MSI packages. To install non-MSI packages, use an exec resource with an `onlyif` parameter.

* "`err: Could not request certificate: The certificate retrieved from the master does not match the agent's private key.`"

    This error is usually a sign that the master has already issued a certificate to the agent. This can occur if the agent's SSL directory is deleted after it has retrieved a certificate from the master, or when running the agent in two different security contexts. For example, running puppet agent as a service and then trying to run `puppet agent` from the command line with non-elevated security. Specifically, this would happen if you've selected `Start Command Prompt with Puppet` but did not elevate privileges using `Run as Administrator`.

* "`err: Could not evaluate: Could not retrieve information from environment production source(s) puppet://puppet.domain.com/plugins.`"

    This error will be generated when a Windows agent does a pluginsync from the Puppet master server, when the latter does not contain any plugins. Note that pluginsync is enabled by default on Windows. This is a known bug in 2.7.x, see <https://projects.puppetlabs.com/issues/2244>.

* "`err: Could not send report: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed. This is often because the time is out of sync on the server or client.`"

    Windows agents that are part of an Active Directory domain should automatically have their time synchronized with AD. For agents that are not part of an AD domain, you may need to enable and add the Windows time service manually:

        w32tm /register
        net start w32time
        w32tm /config /manualpeerlist:<ntpserver> /syncfromflags:manual /update
        w32tm /resync

* "`err: You cannot service a running 64-bit operating system with a 32-bit version of DISM. Please use the version of DISM that corresponds to your computer's architecture.`"

    As described in the Installation Guide, 64-bit versions of windows will redirect all file system access from `%windir%\system32` to `%windir%\SysWOW64` instead. When attempting to configure Windows roles and features using `dism.exe`, make sure to use the 64-bit version. This can be done by executing `c:\windows\sysnative\dism.exe`, which will prevent file system redirection. See <https://projects.puppetlabs.com/issues/12980>

* "Error: Could not parse for environment production: Syntax error at '='; expected '}'"

    This error will usually occur if `puppet apply -e` is used from the command line and the supplied command is surrounded with single quotes ('), which will cause `cmd.exe` to interpret any `=>` in the command as a redirect. To solve this surround the command with double quotes (") instead. See <https://projects.puppetlabs.com/issues/20528>.

* * *

- [Next: Appendix: Release Notes](./appendix.html#release-notes)
