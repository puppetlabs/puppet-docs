---
layout: default
title: "Running Puppet's Commands on Windows"
---

[confdir]: ./dirs_confdir.html
[codedir]: ./dirs_codedir.html
[agent_service]: ./services_agent_windows.html
[facter]: /facter/latest
[puppet agent]: /references/4.2.latest/man/agent.html
[puppet apply]: /references/4.2.latest/man/apply.html
[puppet module]: /references/4.2.latest/man/module.html
[puppet resource]: /references/4.2.latest/man/resource.html
[puppet config]: /references/4.2.latest/man/config.html
[puppet help]: /references/4.2.latest/man/help.html
[puppet man]: /references/4.2.latest/man/man.html


Puppet was originally designed to run on \*nix systems, so its commands generally act the way \*nix admins expect.

Since Windows systems work differently, there are a few extra things to keep in mind when using Puppet's commands.

Supported Commands
-----

Not all of Puppet's commands work on Windows. Notably, Windows nodes can't run the Puppet master or Puppet cert commands.

The following commands are designed for use on Windows:

- [puppet agent][]
- [puppet apply][]
- [puppet module][]
- [puppet resource][]
- [puppet config][]
- [puppet help][]
- [puppet man][]

Running Puppet's Commands
-----

The installer adds Puppet's commands to the PATH. After installing, you can run them from any **command prompt (cmd.exe)** or **PowerShell prompt.**

You may have to open a new command prompt after installing; any processes that were already running before you ran the installer will not pick up the changed PATH value.

Running With Administrator Privileges
-----

You usually want to run Puppet's commands with administrator privileges.

Puppet has two privilege modes:

* Run with limited privileges, only manage certain resource types, and use a user-specific [confdir][] and [codedir][].
* Run with administrator privileges, manage the whole system, and use the system [confdir][] and [codedir][].

On \*nix systems, Puppet defaults to running with limited privileges (when not run by `root`) but can have its privileges raised with the standard `sudo` command.

Windows systems don't use `sudo`, so raising privileges works differently.

### Systems With UAC (Windows 2008+ / Vista+)

[uac]: ./images/uac.png
[rightclick]: ./images/run_as_admin.png
[admin_prompt]: ./images/windows_administrator_prompt.png

Newer versions of Windows manage security with User Account Control (UAC), which was added in Windows 2008 and Windows Vista. With UAC, most programs run by administrators will still have limited privileges. To get administrator privileges, the process has to request those privileges when it starts.

Thus, to run Puppet's commands in administrator mode, you must first start a command prompt or PowerShell window with administrator privileges.

To do this, right-click the Start Menu icon (or apps screen tile) and choose "Run as administrator" from the menu:

![The right click menu, with run as administrator highlighted][rightclick]

This will bring up a UAC confirmation dialog:

![UAC dialog][uac]

When the command prompt window opens, you'll notice that its title bar begins with "Administrator." This means Puppet commands run from that window can manage the whole system.

![A command prompt with Administrator in the title bar][admin_prompt]

### Systems Without UAC (Windows 2003)

On Windows 2003, Puppet's commands will always run with admin privileges if the user that runs them is a member of the local Administrators group. Otherwise, they will run with limited privileges.


The Puppet Start Menu Items
-----

[start_menu]: ./images/start_menu.png
[cfacter]: ./experiments_cfacter.html

Puppet's installer adds a folder of shortcut items to the Start Menu.

![Puppet's Start Menu items][start_menu]

These items aren't necessary to work with Puppet, since [puppet agent runs as a normal Windows service][agent_service] and the Puppet commands work from any command or PowerShell prompt. They're provided solely as conveniences.

The Start Menu items do the following:

### Run Facter

This shortcut automatically requests UAC elevation, then runs [Facter][] in a command prompt window with administrator privileges.

### Run CFacter

This shortcut automatically requests UAC elevation, then runs [CFacter][cfacter] in a command prompt window with administrator privileges.

### Run Puppet Agent

This shortcut automatically requests UAC elevation, then performs a single Puppet agent run in a command prompt window with administrator privileges.

### Start Command Prompt with Puppet

This shortcut starts a normal command prompt with the working directory set to Puppet's program directory. The command prompt's window icon is also set to the Puppet Labs logo.

This was useful in previous versions of Puppet, before the installer was revised to add Puppet's commands to the PATH, but it's no longer necessary.

Note that this shortcut **does not** automatically request UAC elevation; just like with a normal command prompt, you'll need to right-click the icon and choose "Run as administrator."

### Documentation

This folder contains several links to the Puppet Labs website.


