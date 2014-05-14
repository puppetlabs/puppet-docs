---
layout: default
nav: windows.html
title: "Running Puppet From Source on Windows"
---


[confdir]: /puppet/latest/reference/dirs_confdir.html
[vardir]: /puppet/latest/reference/dirs_vardir.html

<span class="versionnote">This documentation applies to Puppet versions ≥ 2.7.6 and Puppet Enterprise ≥ 2.5. Earlier versions may behave differently.</span>

> Note: **Nearly all users should install Puppet from Puppet Labs' installer packages,** which are provided free of charge. [See here for download links and more information](/guides/install_puppet/install_windows.html). The following procedures are only for advanced users involved in Puppet's development.


## Prerequisites

* Make sure you are running a supported version of Windows. See [the main list of supported Windows versions](/guides/platforms.html#windows) for details.
* On Windows, Puppet requires Ruby 1.9.3 or 1.8.7. Ruby is available from [rubyinstaller.org](http://rubyinstaller.org/downloads).
* To automatically manage Puppet's dependencies, you will also need to install [Bundler](http://bundler.io/). You can usually do this by running `gem install bundler` in a command prompt window.
* To access the Puppet source code, you will need Git. You should use [the "msysgit" packages](http://msysgit.github.io/) to install Git on Windows. You will also want to set the following in your Git config so that you don't create unnecessary mode bit changes when editing files on Windows:

        git config core.filemode false

Puppet does not require Cygwin, Powershell, or any other non-standard shells; it can be run from Windows' default `cmd.exe` terminal.


## Installation

### Step 1: Clone the Puppet Source Code; Choose a Branch

    C:>cd work
    C:\work>git clone git://github.com/puppetlabs/puppet.git
    C:\work>cd puppet

By default, this will leave you running the `master` branch, which contains code for the next unreleased version of Puppet. This may or may not be what you want.

[gitpuppet]: https://github.com/puppetlabs/puppet

Most development happens on either the `master` (for the next major or minor version) or `stable` (for patch releases for the current minor version) branches. Released versions are tagged with their version number; release candidates are tagged with their version number and a suffix like `-rc1`. [Explore the repository on GitHub][gitpuppet] to find the branch or tag you want, then run:

     C:\work\puppet>git checkout origin/<BRANCH NAME>

...to switch to it. You can also check out:

* Released versions, by version number:

        C:\work\puppet>git checkout 2.7.12
* Specific commits anywhere on any branch:

        C:\work\puppet>git checkout 2d51b64

Teaching the complete use of Git is beyond the scope of this guide.

### Step 2: Manage Dependencies

To install Puppet's dependencies, run:

    C:\work\puppet>bundle install


## Running Puppet

At this point, you can run Puppet by running `bundle exec puppet` from within the source directory. The standard subcommands are available, and standard configuration will apply. (For example to do a single agent run with a puppet master at `puppet.example.com`, run:

    C:\work\puppet>bundle exec puppet agent --test --server puppet.example.com

### Notes

When running from source, Puppet does not install itself as an NT service. Use the [standard installer packages](/guides/install_puppet/install_windows.html) if you want to run Puppet as a service.

The location of Puppet's data directories varies depending on the Windows version. See the reference pages on the [confdir][] and [vardir][] for more information about where Puppet's data is located.

When installed from source, Puppet does not change the system's `PATH` or `RUBYLIB` variables, nor does it provide Start menu shortcuts for opening a terminal with these variables set. You will need to set them yourself before running Puppet. <!-- todo double check this -->

### User Account Control ###

In general, Puppet must be running in an account that is a member of the local Administrators group in order to make changes to the system, (e.g., change file ownership, modify `/etc/hosts`, etc.). On systems where User Account Control (UAC) is enabled, such as Windows 7 and 2008, Puppet must be running with explicitly elevated privileges. **It will not ask for elevation automatically; you must specifically start your `cmd.exe` terminal window with elevated privileges on these platforms.** See [this blog post (unaffiliated with Puppet Labs)](http://blog.didierstevens.com/2008/05/26/quickpost-restricted-tokens-and-uac/) for more information about UAC.


## Testing

Nearly all of the rspec tests are known to work on Windows, with a few exceptions (e.g. due to the lack of a mount provider on Windows). To run the rspec tests on Windows, execute the following command:

    C:\work\puppet>bundle exec rspec spec

