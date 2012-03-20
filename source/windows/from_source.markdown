---
layout: default
nav: windows.html
title: "Running Puppet From Source on Windows"
---

## Prerequisites

### Platforms

Windows 7, Server 2008, 2008 R2, Server 2003, and 2003 R2 are all supported.

### Ruby

Only ruby version 1.8.7 is currently supported, available from [rubyinstaller.org](http://rubyinstaller.org/downloads)

Puppet does not require Cygwin, Powershell, or any other non-standard shells; it can be run from Windows' default cmd.exe terminal.

### Gems

Puppet on Windows requires the following gems: 

* sys-admin
* win32-process
* win32-dir
* win32-service (>=0.7.1)
* win32-taskscheduler (>= 0.2.1)

So:

<pre>
gem install sys-admin win32-process win32-dir win32-taskscheduler --no-rdoc --no-ri
</pre>

Since win32-service includes native code, you should install it with the `--platform=mswin32` option by running:

<pre>
gem install win32-service --platform=mswin32 --no-rdoc --no-ri --version 0.7.1
</pre>

Otherwise, gem will need to compile the extensions at install time, which can be time-consuming and has additional dependencies. 

## Installation

Obtain zip files of the latest Puppet and Facter source code by clicking the "Downloads" button on their GitHub pages: 

* [Puppet](https://github.com/puppetlabs/puppet)
* [Facter](https://github.com/puppetlabs/facter)

Then, unzip each archive into a temporary directory and run their `install.rb` scripts. You do not need to modify your RUBYLIB or PATH environment variables prior to running the install scripts.

<pre>
ruby install.rb
</pre>

Puppet does not install itself as an NT service. However, the FOSS version of puppet is available as an MSI, and that will install puppet as a service.

### Settings

<i>This information now lives in the installation guide</i>

<del>
When running as an administrator on Windows, Puppet stores its configuration, logs, etc. relative to the CommonAppData directory, see [CSIDL_COMMON_APPDATA](http://msdn.microsoft.com/en-us/library/windows/desktop/bb762494\(v=vs.85\).aspx). On 2003, this is typically <code>C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet</code>. On 2008, this is typically <code>C:\ProgramData\PuppetLabs\puppet</code>. Note that the CommonAppData directory is hidden by default.
</del>
<del>
When running as a non-administrator on Windows, Puppet stores its configuration, logs, etc relative to %HOMEDRIVE%%HOMEPATH%\\.puppet, e.g. C:\Documents and Settings\\&lt;user&gt;\\.puppet
</del>
<del>
The settings files can be found under <code>PuppetLabs\puppet\etc</code>. The filebuckets, state files, YAML and so on can be found under <code>PuppetLabs\puppet\var</code>.
</del>

### User Account Control ###
<del>
In general, puppet must be running in an account that is a member of the local Administrators group in order to make changes to the system, e.g. change file ownership, modify `/etc/hosts`, etc. On systems where User Account Control (UAC) is enabled, such as Windows 2008, puppet must be running with elevated privileges. See <http://blog.didierstevens.com/2008/05/26/quickpost-restricted-tokens-and-uac/> for more information about UAC.
</del>

## Development

This section describes how to develop and test puppet on Windows.

### Gems

If you're developing Puppet, you'll need to install the rspec, rake, and mocha gems in order to run the tests. 

<pre>
gem install rspec rake mocha --no-rdoc --no-ri
</pre>

### Git

You will likely also need the current version of [MSYS GIT](http://code.google.com/p/msysgit/downloads/list). You will also want to set the following in your git config so that you don't create unnecessary mode bit changes when editing files on Windows:

<pre>
git config core.filemode false
</pre>

### Source

The puppet source is available in the Puppet Labs [puppet repo](https://github.com/puppetlabs/puppet) on Github. 

### Testing

Nearly all of the rspec tests are known to work on Windows, with a few exceptions, e.g. due to the lack of a mount provider on Windows. To run the rspec tests on Windows, do the following:

<pre>
rspec --tag ~fails_on_windows spec
</pre>

