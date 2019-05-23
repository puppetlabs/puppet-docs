---
layout: default
title: "Directories: Config directory (confdir)"
---

[puppetserver_conf]: {{puppetserver}}/config_file_puppetserver.html

Puppet's `confdir` is the main directory for Puppet's configuration. It contains config files and SSL data.

{:.concept}
## Location

Puppet's confdir can be found at one of the following locations:

* \*nix Systems: `/etc/puppetlabs/puppet`
* Windows: `%PROGRAMDATA%\PuppetLabs\puppet\etc` (usually `C:\ProgramData\PuppetLabs\puppet\etc`)
* non-root users: `~/.puppetlabs/etc/puppet`

When Puppet is running as either root, a Windows user with administrator privileges, or the `puppet` user, it will use a system-wide confdir. When running as a non-root user, it will use a confdir in that user's home directory.

The system confdir is what you usually want to use, since you will usually run Puppet's commands and services as root or `puppet`. (Note that admin commands like `puppet cert` must be run with `sudo` to use the same confdir as Puppet agent or Puppet master.)

> **Note:** When Puppet master is running as a Rack application, the `config.ru` file must explicitly set `--confdir` to the system confdir. The example `config.ru` file provided with the Puppet source does this.

{:.section}
### Configuration

Puppet's confdir can be specified on the command line with the `--confdir` option, but it can't be set via puppet.conf. (This is because it needs the `confdir` to even find the config file.) If `--confdir` isn't specified when a Puppet application is started, it will always use the default confdir location.

Puppet Server uses the `jruby-puppet.master-conf-dir` setting [in puppetserver.conf][puppetserver_conf] to configure its confdir. Note that if you're using a non-default confdir, you must also specify `--confdir` whenever you run commands like `puppet module` or `puppet cert` to ensure they use the same directories as Puppet Server.

{:.concept}
## Interpolation of `$confdir`

Since the value of the confdir is discovered before other settings, you can safely reference it (with the `$confdir` variable) in the value of any other setting in puppet.conf.

If you need to set nonstandard values for some settings, this allows you to avoid absolute paths and keep your Puppet-related files together.

{:.concept}
## Contents

Puppet's confdir contains several config files and the SSL data. Their locations can be changed with settings, but most users should use the default layout.

Almost everything in the confdir has its own page of documentation.

Items labeled "master only" below can also be present on standalone Puppet apply nodes, since they act as both masters and agents.

{:.section}
### SSL Data

* [`ssl`](./dirs_ssldir.html) --- contains each node's certificate infrastructure. (All nodes.)

{:.section}
### Config files

* [`puppet.conf`](./config_file_main.html) --- Puppet's main config file. (Any node.)
* [`auth.conf`](./config_file_auth.html) --- access control rules for the Puppet master's network services. (Master only.)
* [`autosign.conf`](./config_file_autosign.html) --- a list of pre-approved certificate requests. (CA master only.)
* [`csr_attributes.yaml`](./config_file_csr_attributes.html) --- optional data to be inserted into new certificate requests. (Any node.)
* [`device.conf`](./config_file_device.html) --- configuration for network devices managed by the `puppet device` command. (Any node acting as an intermediary to configure network devices.)
* [`fileserver.conf`](./config_file_fileserver.html) --- configuration for additional fileserver mount points. (Master only.)
* [`hiera.yaml`](./hiera_config_yaml_5.html) --- global configuration for the Hiera data lookup system. Note that environments and modules can have their own hiera.yaml files. (Master, or standalone nodes running Puppet apply.)
   > To provide backward compatibility for Puppet versions 4.0 to 4.4, if a `hiera.yaml` file exists in the global [codedir][codedir], it takes precedence over the `hiera.yaml` in the global confdir. For Puppet to honor the `hiera.yaml` in the confdir, there must be no `hiera.yaml` file in the codedir.
* [`routes.yaml`](./config_file_routes.html) --- advanced configuration of indirector behavior. (Master only.)
