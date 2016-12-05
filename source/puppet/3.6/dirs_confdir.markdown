---
layout: default
title: "Directories: The Main Config Directory (Confdir)"
canonical: "/puppet/latest/reference/dirs_confdir.html"
---

[listen]: ./configuration.html#listen



Puppet's `confdir` is the traditional `/etc/puppet` directory, although its actual location varies. It contains **most of Puppet's configuration and data.** By default, Puppet's config files, manifest directory, primary module directory, and (sometimes) SSL directory all reside in the confdir.

In short, it is the most important directory in Puppet. All Puppet users must interact with multiple files and directories in the confdir.

## Location

The location of Puppet's confdir is somewhat complex. The short version is that it's _usually_ at one of the following locations:

* `/etc/puppetlabs/puppet`
* `/etc/puppet`
* `C:\ProgramData\PuppetLabs\puppet\etc`

The actual default `confdir` depends on your user account, OS version, and Puppet distribution (Puppet Enterprise vs. open source). See the table for your operating system below to locate your actual confdir. For details on system vs. user confdir behavior, see ["System and User Confdirs" below](#system-and-user-confdirs).

> **Note:** Puppet's confdir can be specified on the command line with the `--confdir` option, but it can't be set via puppet.conf. (This is because it needs the `confdir` to even find the config file.) If `--confdir` isn't specified when a Puppet application is started, it will always use the default confdir location.

### \*nix Systems

On Linux and other Unix-like operating systems, Puppet Enterprise and open source Puppet use different system confdirs. The per-user confdir is the same.

Puppet Distribution | User     | Confdir Location
--------------------|----------|-------------------------
Puppet Enterprise   | root     | `/etc/puppetlabs/puppet`
Open source         | root     | `/etc/puppet`
(Both)              | non-root | `~/.puppet`

### Windows Systems

On Microsoft Windows, Puppet Enterprise and open source Puppet use the same directories. However, Windows 2003 uses a different system confdir than other supported Windows versions. (This is because the confdir is based on the `COMMON_APPDATA` folder, whose location changed to a simpler value in Windows 7 and 2008.)

Windows Version               | User              | Confdir Location
------------------------------|-------------------|-----------------
7, 2008, & all later versions | Administrator     | `%PROGRAMDATA%\PuppetLabs\puppet\etc` (defaults to `C:\ProgramData\PuppetLabs\puppet\etc`)
2003                          | Administrator     | `%ALLUSERSPROFILE%\Application Data\PuppetLabs\puppet\etc` (defaults to `C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet\etc`)
(All)                         | non-Administrator | `%UserProfile%\.puppet` (defaults to `C:\Users\USER_NAME\.puppet` on 7+ and 2008+)

### System and User Confdirs

Depending on the run environment, Puppet will use either a system-wide confdir or a per-user confdir:

* When Puppet is running as a non-root user, it defaults to a confdir in that user's home directory.
* The system confdir is used when Puppet is running as root or Administrator, either directly or via `sudo`. (Puppet agent generally runs as root or Administrator when managing a system.)
    * The system confdir is also used when Puppet is started as root before switching users and dropping privileges, which is what a WEBrick puppet master does. Note that when puppet master is running as a Rack application, the `config.ru` file must explicitly set `--confdir` to the system confdir. The example `config.ru` file provided with the Puppet source does this.

The system confdir is the most common, since Puppet generally runs as a service with administrator privileges and the admin commands (like `puppet cert`) must be run with `sudo`.

## Interpolation of `$confdir`

Since the value of the confdir is discovered before other settings, you can safely reference it (with the `$confdir` variable) in the value of any other setting in puppet.conf or on the command line:

    [master]
      modulepath = $confdir/patched_modules:$confdir/modules:/usr/share/puppet/modules

If you need to set nonstandard values for some settings, this allows you to avoid absolute paths and keep your Puppet-related files together.

## Contents

Puppet's confdir contains several config files and several directories of data and Puppet code. Their locations can be changed with settings, but most users should use the default layout.

Since the contents of the confdir are Puppet's most important files, each one has its own page of documentation.

Items labeled "master only" below may also be present on standalone puppet apply nodes, since they act as both masters and agents.

### Code and Data Directories

* [`modules`](./dirs_modulepath.html) --- the main directory for Puppet's modules. (Master only.)
* [`manifests`](./dirs_manifest.html) --- contains the main starting point for catalog compilation. (Master only.)
* [`environments`](./dirs_environments.html) --- contains alternate versions of the `modules` and `manifests` directories, to allow code changes to be tested on smaller sets of nodes before entering production. (Master only.)
* [`ssl`](./dirs_ssldir.html) --- contains each node's certificate infrastructure. (All nodes.)

### Config Files

* [`puppet.conf`](./config_file_main.html) --- Puppet's main config file. (All nodes.)
* [`auth.conf`](./config_file_auth.html) --- access control rules for the puppet master's network services. (Master only, unless [`listen`][listen] is enabled.)
* [`autosign.conf`](./config_file_autosign.html) --- a list of pre-approved certificate requests. (CA master only.)
* [`csr_attributes.yaml`](./config_file_csr_attributes.html) --- optional data to be inserted into new certificate requests. (All nodes.)
* [`device.conf`](./config_file_device.html) --- configuration for network devices managed by the `puppet device` command. (All nodes.)
* [`fileserver.conf`](./config_file_fileserver.html) --- configuration for additional fileserver mount points. (Master only.)
* [`hiera.yaml`](./config_file_hiera.html) --- configuration for the Hiera data lookup system. (Master only.)
* [`routes.yaml`](./config_file_routes.html) --- advanced configuration of indirector behavior. (Master only.)
* [`tagmail.conf`](./config_file_tagmail.html) --- instructions for mailing important Puppet events to administrators. (Master only.)

