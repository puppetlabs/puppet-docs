---
layout: pe2experimental
title: "Troubleshooting Puppet on Windows"
nav: windows.html
---

## Tips
### Process Explorer
Install [Process Explorer](http://en.wikipedia.org/wiki/Process_Explorer) and configure it to replace Task Manager, you'll be glad you did.

### Logging
By default, Puppet agent logs to a file `var\log\puppetd.log` within Puppet's data directory, e.g. `C:\ProgramData\PuppetLabs\puppet\var\log\puppetd.log`. You can find this value by using the `Start Command Prompt with Puppet` shortcut, right-clicking, and selecting `Run as Administrator`. Then type: `puppet agent --configprint puppetdlog`. The `Run as Administrator` option is important, so that puppet will print the puppetdlog configuration setting when running with elevated privileges, i.e. the same privileges as puppet when running as a service under the `LocalSystem` account.

## Common Issues
### Installation
The Puppet MSI package will not overwrite an existing entry in the puppet.conf.  As a result, if you uninstall the package, then reinstall the package using a different puppet master hostname, Puppet won't actually apply the new value if the previous value exists in the `puppet.conf` file when the package is installed a second time.

In general, we've taken the approach of preserving configuration data on the system when doing an upgrade, un-install or re-install.

To fully clean out a system make sure to delete the `PuppetLabs` folder (see above).

Similarly, the MSI will not overwrite the custom facts written to the `PuppetLabs\facter\facts.d` directory.

It should be noted, the use of the [createLine](https://github.com/puppetlabs/puppet_for_the_win/blob/master/wix/puppet.wxs#L184) attribute implements the behavior of not replacing existing keys.  We could change this to overwrite existing keys in the facts or puppet.conf file if need be based on customer feedback.

### Unattended installation

Puppet may fail to install when trying to perform an unattended install from the command line, e.g.

<pre>
msiexec /qn /i puppet.msi
</pre>

To troubleshoot, specify an installation log, e.g. /l*v install.txt. If you see entries like the following in the log:

<pre>
MSI (s) (7C:D0) [17:24:15:870]: Rejecting product '{D07C45E2-A53E-4D7B-844F-F8F608AFF7C8}': Non-assigned apps are disabled for non-admin users.
MSI (s) (7C:D0) [17:24:15:870]: Note: 1: 1708 
MSI (s) (7C:D0) [17:24:15:870]: Product: Puppet -- Installation failed.
MSI (s) (7C:D0) [17:24:15:870]: Windows Installer installed the product. Product Name: Puppet. Product Version: 2.7.12. Product Language: 1033. Manufacturer: Puppet Labs. Installation success or error status: 1625.
MSI (s) (7C:D0) [17:24:15:870]: MainEngineThread is returning 1625
MSI (s) (7C:08) [17:24:15:870]: No System Restore sequence number for this installation.
Info 1625.This installation is forbidden by system policy. Contact your system administrator.
</pre>

Then you know you don't have sufficient privileges to install puppet. Make sure to launch `cmd.exe` with the `Run as Administrator` option, and try again.

## File Paths
### Path Separator
Make sure to use semi-colon as the path separator on Windows, e.g. `modulepath=path1;path2`

### File Separator
Ruby accepts either forward or backslashes as the file separator. It is recommended that you consistently use <b>backslashes</b>. This is especially true for exec and package resources, because certain Windows applications (msiexec.exe) and shell built-ins (type, mkdir, etc) will fail with forward slashes. For example, this will fail:
<pre>
cmd.exe /c type c:/autoexec.bat
</pre>

But this will succeed:
<pre>
cmd.exe /c type c:\autoexec.bat
</pre>

### Backslashes
When backslashes are double-quoted, they <b>must</b> be escaped. When single-quoted, they <b>may</b> be escaped. For example, these are valid file resources:
<pre>
file { 'c:\path\to\file.txt': }
file { 'c:\\path\\to\\file.txt': }
file { "c:\\path\\to\\file.txt": }
</pre>

But this is an invalid path, because \p, \t, \f are interpreted as escape sequences:
<pre>
file { "c:\path\to\file.txt": }
</pre>

### UNC Paths

UNC paths are not currently supported, however, the path can be mapped as a network drive and accessed that way.

### Case-insensitivity
Several resources are case-insensitive on Windows (file, user, group). When establishing dependencies among resources, make sure to specify the case consistently. Otherwise, puppet may not be able to resolve dependencies correctly. For example, applying this manifest will fail, because puppet does not recognize that FOOBAR and foobar are the same user:
<pre>
file { 'c:\foo\bar':
  ensure => directory, 
  owner => 'FOOBAR'
}
user { 'foobar':
  ensure => present
}
...
err: /Stage[main]//File[c:\foo\bar]: Could not evaluate: Could not find user FOOBAR
</pre>

### Diffs
Puppet does not show diffs on Windows, e.g. `puppet agent --show_diffs`, unless a third-party diff utility has been installed (msys, gnudiff, cygwin, etc) and the `diff` property set appropriately.

## Providers
### Exec
When declaring a Windows exec resource, the path to the resource typically depends on the %WINDIR% environment variable. Since this may vary from system to system, you can use the `path` fact in the exec resource:

<pre>
exec { 'cmd.exe /c echo hello world':
  path => $::path
}
</pre>

### Shell Builtins
Puppet does not currently support a shell provider on Windows, so executing shell built-ins directly will fail:
<pre>
exec { 'echo foo': 
  path => 'c:\windows\system32;c:\windows'
}
...
err: /Stage[main]//Exec[echo foo]/returns: change from notrun to 0 failed: Could not find command 'echo'
</pre>

Instead, wrap the built-in in cmd.exe:
<pre>
exec { 'cmd.exe /c echo foo': 
  path => 'c:\windows\system32;c:\windows'
}
</pre>

Even better, use the tip from above:
<pre>
exec { 'cmd.exe /c echo foo': 
  path => $::path
}
</pre>

### Powershell
By default, powershell enforces a restricted execution policy which prevents the execution of scripts. As such, make sure to specify the appropriate execution policy in the powershell command:

<pre>
exec { 'test':
  command => 'powershell.exe -executionpolicy remotesigned -file C:\test.ps1',
  path => $::path
}
</pre>

### Package
The source of an MSI package must either be a file on a local filesystem or network mapped drive. It does not support URI-based sources, though you can achieve a similar result by define a file whose source is the puppet master, and the define a package whose source is the local file.

### Service
Windows services support a short name and a display name. Make sure to use the short name in puppet manifests. For example `wuauserv`, not `Automatic Updates`. You can use `sc query` to get a list of services and their various names.

## Error Messages

* Cannot run on Microsoft Windows without the sys-admin, win32-process, win32-dir, win32-service and win32-taskscheduler gems

    Puppet requires the specified Windows-specific gems, which can be installed using `gem install <gem>`

* err: /Stage[main]//Scheduled_task[task_system]: Could not evaluate: The operation completed successfully.

    This error can occur when using version < 0.2.1 of the win32-taskscheduler gem. Run `gem update win32-taskscheduler`

* err: /Stage[main]//Exec[C:/tmp/foo.exe]/returns: change from notrun to 0 failed: CreateProcess() failed: Access is denied.

    This error can occur when sourcing an executable from a remote puppet master that is not executable. If a file should be executable on Windows, make sure to set the user/group executable bits accordingly on the puppet master (or alternatively, specify the mode of the file as it should exist on the Windows host):

    <pre>
    file { "C:/tmp/foo.exe":
      source => "puppet:///modules/foo/foo.exe",
    }

    exec { 'C:/tmp/foo.exe':
      logoutput => true
    }
    </pre>

* err: getaddrinfo: The storage control blocks were destroyed.

    This error can occur when the agent cannot resolve a DNS name into an IP address. For example the `server`, `ca_server`, etc properties. To verify, make sure you can run the following `nslookup <dns>`. If this fails, then there is a problem with the DNS settings on the Windows agent. Examples include the primary dns suffix not being set. See <http://technet.microsoft.com/en-us/library/cc959322.aspx>
    
* err: /Stage[main]//Group[mygroup]/members: change from  to Administrators failed: Add OLE error code:8007056B in <Unknown> <No Description> HRESULT error code:0x80020009 Exception occurred.

    This error will occur when attempting to add a group as a member of another local group, i.e. nesting groups. Although Active Directory supports [nested groups](http://msdn.microsoft.com/en-us/library/cc246068(v=prot.13\).aspx) for certain types of domain group accounts, Windows does not support nesting of local group accounts. As a result, you must only specify user accounts as members of a group.

* err: /Stage[main]//Package[7zip]/ensure: change from absent to present failed: Execution of 'msiexec.exe /qn /norestart /i "c:\\7z920.exe"' returned 1620: T h i s   i n s t a l l a t i o n   p a c k a g e   c o u l d   n o t   b e   o p e n e d .  C o n t a c t   t h e   a p p l i c a t i o n   v e n d o r   t o   v e r i f y   t h a t   t h i s   i s  a   v a l i d   W i n d o w s   I n s t a l l e r   p a c k a g e .

    This error can occur when attempting to install a non-MSI package. Puppet only supports MSI packages. To install non-MSI packages, use an exec resource with an onlyif parameter.

* err: Could not request certificate: The certificate retrieved from the master does not match the agent's private key.

    This error is usually a sign that the master has already issued a certificate to the agent. This can occur if the agent's SSL directory is deleted after it has retrieved a certificate from the master, or when running the agent in two different security contexts. For example, if puppet agent is running as a service, and then trying to run `puppet agent` from the command line in a non-elevated security context. Specifically, if you've selected `Start Command Prompt with Puppet` but did not elevate privileges using `Run as Administrator`.

* err: Could not evaluate: Could not retrieve information from environment production source(s) puppet://puppet.domain.com/plugins

    This error will be generated when a Windows agent does a pluginsync from the Puppet master server, where the latter does not contain any plugins. Note pluginsync is enabled by default on Windows. This is a known bug in 2.7.x, see <https://projects.puppetlabs.com/issues/2244>.

* err: Could not send report: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed. This is often because the time is out of sync on the server or client.

    Windows agents that are part of an Active Directory domain should automatically have their time synchronized with AD. For agents that are not part of an Active Directory domain, you may need to enable and the Windows time service manually:
    
    <pre>
    w32tm /register
    net start w32time
    w32tm /config /manualpeerlist:<ntpserver> /syncfromflags:manual /update
    </pre>

* err: You cannot service a running 64-bit operating system with a 32-bit version of DISM. Please use the version of DISM that corresponds to your computer's architecture.

    As described in the Installation Guide, 64-bit versions of windows will redirect all file system access from `%windir%\system32` to `%windir%\SysWOW64` instead. When attempting to configure Windows roles and features using `dism.exe`, make sure to use the 64-bit version. This can be done by executing `c:\windows\sysnative\dism.exe`, which will prevent file system redirection. See <https://projects.puppetlabs.com/issues/12980>