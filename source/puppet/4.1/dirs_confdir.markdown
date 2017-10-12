---
layout: default
title: "Directories: Config Directory (confdir)"
canonical: "/puppet/latest/dirs_confdir.html"
---

[listen]: ./configuration.html#listen

Puppet's `confdir` is the main directory for Puppet's configuration. It contains config files and SSL data.

## Location

Puppet's confdir can be found at one of the following locations:

* \*nix Systems: `/etc/puppetlabs/puppet`
* Windows: `C:\ProgramData\PuppetLabs\puppet\etc`
* non-root users: `~/.puppetlabs/etc/puppet`

When Puppet is running as either root, a Windows user with administrator privileges, or the `puppet` user, it will use a system-wide confdir. When running as a non-root user, it will use a confdir in that user's home directory.

The system confdir is what you usually want to use, since you will usually run Puppet's commands and services as root or `puppet`. (Note that admin commands like `puppet cert` must be run with `sudo` to use the same confdir as Puppet agent or Puppet master.)

> **Note:** When Puppet master is running as a Rack application, the `config.ru` file must explicitly set `--confdir` to the system confdir. The example `config.ru` file provided with the Puppet source does this.

### Configuration

Puppet's confdir can be specified on the command line with the `--confdir` option, but it can't be set via puppet.conf. (This is because it needs the `confdir` to even find the config file.) If `--confdir` isn't specified when a Puppet application is started, it will always use the default confdir location.

### Note about Windows 2003

The location of the system confdir is based on the `COMMON_APPDATA` folder, whose location changed to a simpler value in Windows 7 and 2008. So if you're using Windows 2003 the confdir will actually be located at `%ALLUSERSPROFILE%\Application Data\PuppetLabs\puppet\etc` (defaults to `C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet\etc`).

## Interpolation of `$confdir`

Since the value of the confdir is discovered before other settings, you can safely reference it (with the `$confdir` variable) in the value of any other setting in puppet.conf.

If you need to set nonstandard values for some settings, this allows you to avoid absolute paths and keep your Puppet-related files together.

## Contents

Puppet's confdir contains several config files and the SSL data. Their locations can be changed with settings, but most users should use the default layout.

Almost everything in the confdir has its own page of documentation.

Items labeled "master only" below may also be present on standalone Puppet apply nodes, since they act as both masters and agents.

### SSL Data

* [`ssl`](./dirs_ssldir.html) --- contains each node's certificate infrastructure. (All nodes.)

### Config Files

* [`puppet.conf`](./config_file_main.html) --- Puppet's main config file. (All nodes.)
* [`auth.conf`](./config_file_auth.html) --- access control rules for the Puppet master's network services. (Master only, unless [`listen`][listen] is enabled.)
* [`autosign.conf`](./config_file_autosign.html) --- a list of pre-approved certificate requests. (CA master only.)
* [`csr_attributes.yaml`](./config_file_csr_attributes.html) --- optional data to be inserted into new certificate requests. (All nodes.)
* [`device.conf`](./config_file_device.html) --- configuration for network devices managed by the `puppet device` command. (All nodes.)
* [`fileserver.conf`](./config_file_fileserver.html) --- configuration for additional fileserver mount points. (Master only.)
* [`hiera.yaml`](./config_file_hiera.html) --- configuration for the Hiera data lookup system. (Master only.)
* [`routes.yaml`](./config_file_routes.html) --- advanced configuration of indirector behavior. (Master only.)