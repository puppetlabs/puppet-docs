---
layout: default
title: "Code and data directory (codedir)"
---

[codedir]: ./configuration.html#codedir
[puppetserver_conf]: {{puppetserver}}/config_file_puppetserver.html

Puppet's `codedir` is the main directory for Puppet code and data. It contains environments (which contain your manifests and modules), a global modules directory for all environments, and your Hiera data.

{:.concept}
## Location

Puppet's codedir can be found at one of the following locations:

* \*nix Systems: `/etc/puppetlabs/code`
* Windows: `%PROGRAMDATA%\PuppetLabs\code` (usually `C:\ProgramData\PuppetLabs\code`)
* non-root users: `~/.puppetlabs/etc/code`

When Puppet is running as either root, a Windows user with administrator privileges, or the `puppet` user, it will use a system-wide codedir. When running as a non-root user, it will use a codedir in that user's home directory.

The system codedir is what you usually want to use, since you will usually run Puppet's commands and services as root or `puppet`. (Note that admin commands like `puppet module` must be run with `sudo` to use the same codedir as Puppet agent or Puppet master.)

> **Note:** When Puppet master is running as a Rack application, the `config.ru` file must explicitly set `--codedir` to the system codedir. The example `config.ru` file provided with the Puppet source does this.

{:.section}
### Configuration

The location of the codedir can be configured in puppet.conf with [the `codedir` setting][codedir], but note that Puppet Server doesn't use that setting; it has its own `jruby-puppet.master-code-dir` setting [in puppetserver.conf][puppetserver_conf]. If you're using a non-default codedir, _you must change both settings._

{:.concept}
## Interpolation of `$codedir`

Since the value of the codedir is discovered before other settings, you can safely reference it (with the `$codedir` variable) in the value of any other setting in puppet.conf:

    [master]
      environmentpath = $codedir/override_environments:$codedir/environments

If you need to set nonstandard values for some settings, this allows you to avoid absolute paths and keep your Puppet-related files together.

{:.concept}
### Contents

Puppet's codedir contains environments, modules, and Hiera data. Its contents are used by Puppet master and Puppet apply, but not by Puppet agent.

Almost everything in the codedir has its own page of documentation.

{:.section}
### Code and Data Directories

* [`environments`](./environments_configuring.html) --- contains alternate versions of the `modules` and `manifests` directories, to allow code changes to be tested on smaller sets of nodes before entering production.
* [`modules`](./dirs_modulepath.html) --- the main directory for Puppet's modules.