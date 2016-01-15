---
layout: default
title: "Directories: The Vardir"
canonical: "/puppet/latest/reference/dirs_vardir.html"
---

[confdir]: ./dirs_confdir.html
[config_ref]: ./configuration.html

Puppet's `vardir` is the traditional `/var/lib/puppet` directory, although its actual location varies. It contains **dynamic and/or growing data** that Puppet creates automatically in the course of its normal operations. Some of this data can be mined for interesting analysis, or to integrate other tools with Puppet; other parts are just infrastructure and should be ignored by most or all users.

## Location

The location of Puppet's vardir is somewhat complex. The short version is that it's _usually_ at one of the following locations:

* `/var/opt/lib/pe-puppet`
* `/var/lib/puppet`
* `C:\ProgramData\PuppetLabs\puppet\var`

The actual default `vardir` depends on your user account, OS version, and Puppet distribution (Puppet Enterprise vs. open source). See the table for your operating system below. For details on system vs. user vardir behavior, see ["System and User Vardirs" below](#system-and-user-vardirs).

> **Note:** Puppet's vardir can be specified on the command line with the `--vardir` option, but it can't be set via puppet.conf. If `--vardir` isn't specified when a Puppet application is started, it will always use the default vardir location.

### \*nix Systems

On Linux and other Unix-like operating systems, Puppet Enterprise and open source Puppet use different system vardirs. The per-user vardir is the same, and is located inside the per-user [confdir][].

Puppet Distribution | User     | Vardir Location
--------------------|----------|-------------------------
Puppet Enterprise   | root     | `/var/opt/lib/pe-puppet`
Open source         | root     | `/var/lib/puppet`
(Both)              | non-root | `~/.puppet/var`

### Windows Systems

On Microsoft Windows, Puppet Enterprise and open source Puppet use the same directories. However, Windows 2003 uses a different system vardir than other supported Windows versions. (This is because the vardir is based on the `COMMON_APPDATA` folder, whose location changed to a simpler value in Windows 7 and 2008.)

The per-user vardir is the same, and is located inside the per-user [confdir][].

Windows Version               | User              | Vardir Location
------------------------------|-------------------|-----------------
7, 2008, & all later versions | Administrator     | `%PROGRAMDATA%\PuppetLabs\puppet\var` (defaults to `C:\ProgramData\PuppetLabs\puppet\var`)
2003                          | Administrator     | `%ALLUSERSPROFILE%\Application Data\PuppetLabs\puppet\var` (defaults to `C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet\var`)
(all)                         | non-Administrator | `%UserProfile%\.puppet\var` (defaults to `C:\Users\USER_NAME\.puppet\var` on 7+ and 2008+)

### System and User Vardirs

Depending on the run environment, Puppet will use either a system-wide vardir or a per-user vardir:

* When Puppet is running as a non-root user, it defaults to a vardir in that user's home directory.
* The system vardir is used when Puppet is running as root or Administrator, either directly or via `sudo`. (Puppet agent generally runs as root or Administrator when managing a system.)
    * The system vardir is also used when Puppet is started as root before switching users and dropping privileges, which is what a WEBrick Puppet master does. Note that when Puppet master is running as a Rack application, the `config.ru` file must explicitly set `--vardir` to the system vardir. The example `config.ru` file provided with the Puppet source does this.

The system vardir is the most common, since Puppet generally runs as a service with administrator privileges and the admin commands (like `puppet cert`) must be run with `sudo`.

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
* [`log` (`logdir`)][logdir]
    * [`http.log` (`httplog`)][httplog]
    * [`masterhttp.log` (`masterhttplog`)][masterhttplog]
    * [`puppetmaster.log` (`masterlog`)][masterlog]
    * [`puppetd.log` (`puppetdlog`)][puppetdlog]
* [`reports` (`reportdir`)][reportdir] --- When the `store` report is enabled, a Puppet master will store all reports received from agents as YAML files in this directory. These can be easily mined for analysis by an out-of-band process.
* [`rrd` (`rrddir`)][rrddir]
* [`run` (`rundir`)][rundir]
    * [`${run_mode}.pid` (`pidfile`)][pidfile]
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

[bucketdir]: ./configuration.html#bucketdir
[client_datadir]: ./configuration.html#clientdatadir
[clientbucketdir]: ./configuration.html#clientbucketdir
[clientyamldir]: ./configuration.html#clientyamldir
[devicedir]: ./configuration.html#devicedir
[factpath]: ./configuration.html#factpath
[pluginfactdest]: ./configuration.html#pluginfactdest
[libdir]: ./configuration.html#libdir
[plugindest]: ./configuration.html#plugindest
[module_working_dir]: ./configuration.html#moduleworkingdir
[module_skeleton_dir]: ./configuration.html#moduleskeletondir
[logdir]: ./configuration.html#logdir
[httplog]: ./configuration.html#httplog
[masterhttplog]: ./configuration.html#masterhttplog
[masterlog]: ./configuration.html#masterlog
[puppetdlog]: ./configuration.html#puppetdlog
[reportdir]: ./configuration.html#reportdir
[rrddir]: ./configuration.html#rrddir
[rundir]: ./configuration.html#rundir
[pidfile]: ./configuration.html#pidfile
[serverdatadir]: ./configuration.html#serverdatadir
[statedir]: ./configuration.html#statedir
[agent_catalog_run_lockfile]: ./configuration.html#agentcatalogrunlockfile
[agent_disabled_lockfile]: ./configuration.html#agentdisabledlockfile
[classfile]: ./configuration.html#classfile
[graphdir]: ./configuration.html#graphdir
[lastrunfile]: ./configuration.html#lastrunfile
[lastrunreport]: ./configuration.html#lastrunreport
[localconfig]: ./configuration.html#localconfig
[resourcefile]: ./configuration.html#resourcefile
[statefile]: ./configuration.html#statefile
[templatedir]: ./configuration.html#templatedir
[yamldir]: ./configuration.html#yamldir