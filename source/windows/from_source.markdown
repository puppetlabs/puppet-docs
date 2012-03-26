---
layout: pe2experimental
nav: windows.html
title: "Running Puppet From Source on Windows"
---


[datadirectory]: ./installing.html#data-directory


<span class="versionnote">This documentation applies to Puppet versions ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>

> Note: **Nearly all users should install Puppet from Puppet Labs' installer packages,** which are provided free of charge. [See here for download links and more information](./installing.html). The following procedures are only for advanced users involved in Puppet's development. 


## Prerequisites

### Platforms

Puppet Enterprise supports Windows 7, Server 2008, 2008 R2, Server 2003, and 2003 R2.

### Ruby

Only Ruby version 1.8.7 is currently supported. It is available from [rubyinstaller.org](http://rubyinstaller.org/downloads)

Puppet does not require Cygwin, Powershell, or any other non-standard shells; it can be run from Windows' default `cmd.exe` terminal.

### Required Gems

Puppet on Windows requires the following gems be installed:

* sys-admin
* win32-process
* win32-dir
* win32-service (>=0.7.1)
* win32-taskscheduler (>= 0.2.1)

To install them all in two commands:

    C:\>gem install sys-admin win32-process win32-dir win32-taskscheduler --no-rdoc --no-ri
    C:\>gem install win32-service --platform=mswin32 --no-rdoc --no-ri --version 0.7.1

(Since win32-service includes native code, you should install it with the `--platform=mswin32` option. Otherwise, `gem` will need to compile the extensions at install time, which has additional dependencies and can be time-consuming.)

## Installation

Obtain zip files of the latest Puppet and Facter source code by clicking the "Downloads" button on their GitHub pages or by checking out a copy of their repositories.

* [Puppet](https://github.com/puppetlabs/puppet)
* [Facter](https://github.com/puppetlabs/facter)

Then, unzip each archive into a temporary directory and run their `install.rb` scripts. You do not need to modify your `RUBYLIB` or `PATH` environment variables prior to running the install scripts.

    C:\>ruby install.rb

> Note: When installed from source, Puppet does not install itself as an NT service. Use the [standard installer packages](./installing.html) if you want to run Puppet as a service.

> Note: The location of Puppet's data directory varies depending on the Windows version. [See this explanation from the installer documentation][datadirectory] to find the data directory on your version. 

> Note: When installed from source, Puppet does not change the system's `PATH` or `RUBYLIB` variables, nor does it provide Start menu shortcuts for opening a terminal with these variables set. You will need to set them yourself before running Puppet. <!-- todo double check this -->

### User Account Control ###

In general, puppet must be running in an account that is a member of the local Administrators group in order to make changes to the system, (e.g., change file ownership, modify `/etc/hosts`, etc.). On systems where User Account Control (UAC) is enabled, such as Windows 7 and 2008, Puppet must be running with explicitly elevated privileges. **It will not ask for elevation automatically; you must specifically start your `cmd.exe` terminal window with elevated privileges on these platforms.** See [this blog post (unaffiliated with Puppet Labs)](http://blog.didierstevens.com/2008/05/26/quickpost-restricted-tokens-and-uac/) for more information about UAC.

## Development Tools and Tasks

### Gems

If you're developing Puppet, you'll need to install the rspec, rake, and mocha gems in order to run the tests. 

    gem install rspec rake mocha --no-rdoc --no-ri

### Git

In addtion, you will likely need the current version of [MSYS GIT](http://code.google.com/p/msysgit/downloads/list). You will also want to set the following in your git config so that you don't create unnecessary mode bit changes when editing files on Windows:

    git config core.filemode false

### Source

The source code for Puppet and Facter is available in Puppet Labs' repositories on GitHub:

* [Puppet](https://github.com/puppetlabs/puppet)
* [Facter](https://github.com/puppetlabs/facter)

### Testing

Nearly all of the rspec tests are known to work on Windows, with a few exceptions (e.g. due to the lack of a mount provider on Windows). To run the rspec tests on Windows, execute the following command:

    C:\>rspec --tag ~fails_on_windows spec

