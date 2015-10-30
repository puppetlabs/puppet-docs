---
layout: default
title: "Directories: The Cache Directory (vardir)"
canonical: "/puppet/latest/reference/dirs_vardir.html"
---

[confdir]: ./dirs_confdir.html
[config_ref]: /references/4.2.latest/configuration.html
[puppetserver_conf]: /puppetserver/2.1/configuration.html#puppetserverconf

Puppet's cache directory, sometimes called `vardir`, contains **dynamic and/or growing data** that Puppet creates automatically in the course of its normal operations. Some of this data can be mined for interesting analysis, or to integrate other tools with Puppet; other parts are just infrastructure and should be ignored by most or all users.

## Location

Puppet agent/apply and Puppet Server use different cache directories.

Puppet Server's cache directory defaults to:

* `/opt/puppetlabs/server/data/puppetserver`

The cache directory for Puppet agent and Puppet apply can be found at one of the following locations:

* \*nix Systems: `/var/opt/puppetlabs/puppet/cache`
* Windows: `C:\ProgramData\PuppetLabs\puppet\cache`
* non-root users: `~/.puppetlabs/opt/puppet/cache`

When Puppet is running as either root, a Windows user with administrator privileges, or the `puppet` user, it will use a system-wide cache directory. When running as a non-root user, it will use a cache directory in that user's home directory.

The system cache directory is what you usually want to use, since you will usually run Puppet's commands and services as root or `puppet`. (Note that admin commands like `puppet cert` must be run with `sudo` to use the same directories as Puppet agent or Puppet master.)

> **Note:** When Puppet master is running as a Rack application, the `config.ru` file must explicitly set `--vardir` to the system cache directory. The example `config.ru` file provided with the Puppet source does this.

### Configuration

Puppet's cache directory can be specified on the command line with the `--vardir` option, but it can't be set via puppet.conf. If `--vardir` isn't specified when a Puppet application is started, it will always use the default cache directory location.

Puppet Server uses the `jruby-puppet.master-var-dir` setting [in puppetserver.conf][puppetserver_conf] to configure its cache directory.

### Note about Windows 2003

The location of the system confdir is based on the `COMMON_APPDATA` folder, whose location changed to a simpler value in Windows 7 and 2008. So if you're using Windows 2003 the confdir will actually be located at `%ALLUSERSPROFILE%\Application Data\PuppetLabs\puppet\var` (defaults to `C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet\var`).

## Interpolation of `$vardir`

Since the value of the vardir is discovered before other settings, you can safely reference it (with the `$vardir` variable) in the value of any other setting in puppet.conf or on the command line:

    [main]
      ssldir = $vardir/ssl

If you need to set nonstandard values for some settings, this allows you to avoid absolute paths and keep your Puppet-related files together.


## Contents

The vardir contains several directories. Most of these subdirectories contain a variable amount of automatically generated data; some of them contain notable individual files. Some directories are used only by agent or master processes.

The default layout of the vardir is as follows. Most of the files and directories can have their locations changed with settings in puppet.conf. The link for each item goes to its description in the [configuration reference][config_ref].

* [`bucket` (`bucketdir`)][bucketdir]
* [`client_data` (`client_datadir`)][client_datadir]
* [`clientbucket` (`clientbucketdir`)][clientbucketdir]
* [`client_yaml` (`clientyamldir`)][clientyamldir]
* [`devices` (`devicedir`)][devicedir]
* [`lib/facter` (`factpath`)][factpath]
* [`facts` (`factpath`)][factpath]
* [`facts.d` (`pluginfactdest`)][pluginfactdest]
* [`lib` (`libdir`)][libdir] (also [plugindest][]) --- Puppet uses this as a cache for plugins (custom facts, types and providers, functions) synced from a Puppet master. It shouldn't be directly modified by the user. It can be safely deleted, and the plugins will be restored on the next Puppet run.
* [`puppet-module` (`module_working_dir`)][module_working_dir]
    * [`skeleton` (`module_skeleton_dir`)][module_skeleton_dir]
* [`reports` (`reportdir`)][reportdir] --- When the `store` report is enabled, a Puppet master will store all reports received from agents as YAML files in this directory. These can be easily mined for analysis by an out-of-band process.
* [`rrd` (`rrddir`)][rrddir]
* [`server_data` (`serverdatadir`)][serverdatadir]
* [`state` (`statedir`)][statedir]
    * [`agent_catalog_run.lock` (`agent_catalog_run_lockfile`)][agent_catalog_run_lockfile]
    * [`agent_disabled.lock` (`agent_disabled_lockfile`)][agent_disabled_lockfile]
    * [`classes.txt` (`classfile`)][classfile] --- This file is a favorite for external integration. It lists all of the classes assigned to this agent node.
    * [`graphs` (`graphdir`)][graphdir] --- Agent nodes write a set of .dot graph files to this directory when graphing is enabled. These graphs can be used to diagnose problems with catalog application, as well as to visualize the configuration catalog.
    * [`last_run_summary.yaml` (`lastrunfile`)][lastrunfile]
    * [`last_run_report.yaml` (`lastrunreport`)][lastrunreport]
    * [`localconfig` (`localconfig`)][localconfig]
    * [`resources.txt` (`resourcefile`)][resourcefile]
    * [`state.yaml` (`statefile`)][statefile]
* [`templates` (`templatedir`)][templatedir] --- This directory generally shouldn't be used; templates should be stored in modules.
* [`yaml` (`yamldir`)][yamldir]

[bucketdir]: /references/4.2.latest/configuration.html#bucketdir
[client_datadir]: /references/4.2.latest/configuration.html#clientdatadir
[clientbucketdir]: /references/4.2.latest/configuration.html#clientbucketdir
[clientyamldir]: /references/4.2.latest/configuration.html#clientyamldir
[devicedir]: /references/4.2.latest/configuration.html#devicedir
[factpath]: /references/4.2.latest/configuration.html#factpath
[pluginfactdest]: /references/4.2.latest/configuration.html#pluginfactdest
[libdir]: /references/4.2.latest/configuration.html#libdir
[plugindest]: /references/4.2.latest/configuration.html#plugindest
[module_working_dir]: /references/4.2.latest/configuration.html#moduleworkingdir
[module_skeleton_dir]: /references/4.2.latest/configuration.html#moduleskeletondir
[logdir]: /references/4.2.latest/configuration.html#logdir
[httplog]: /references/4.2.latest/configuration.html#httplog
[masterhttplog]: /references/4.2.latest/configuration.html#masterhttplog
[masterlog]: /references/4.2.latest/configuration.html#masterlog
[puppetdlog]: /references/4.2.latest/configuration.html#puppetdlog
[reportdir]: /references/4.2.latest/configuration.html#reportdir
[rrddir]: /references/4.2.latest/configuration.html#rrddir
[rundir]: /references/4.2.latest/configuration.html#rundir
[pidfile]: /references/4.2.latest/configuration.html#pidfile
[serverdatadir]: /references/4.2.latest/configuration.html#serverdatadir
[statedir]: /references/4.2.latest/configuration.html#statedir
[agent_catalog_run_lockfile]: /references/4.2.latest/configuration.html#agentcatalogrunlockfile
[agent_disabled_lockfile]: /references/4.2.latest/configuration.html#agentdisabledlockfile
[classfile]: /references/4.2.latest/configuration.html#classfile
[graphdir]: /references/4.2.latest/configuration.html#graphdir
[lastrunfile]: /references/4.2.latest/configuration.html#lastrunfile
[lastrunreport]: /references/4.2.latest/configuration.html#lastrunreport
[localconfig]: /references/4.2.latest/configuration.html#localconfig
[resourcefile]: /references/4.2.latest/configuration.html#resourcefile
[statefile]: /references/4.2.latest/configuration.html#statefile
[templatedir]: /references/4.2.latest/configuration.html#templatedir
[yamldir]: /references/4.2.latest/configuration.html#yamldir