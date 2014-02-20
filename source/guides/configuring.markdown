---
layout: default
title: Configuring Puppet
---

Configuring Puppet
==================

Puppet's behavior can be customized with a [rather large collection of settings][configref]. Most of these can be safely ignored, but you'll almost definitely have to modify some of them.

This document describes how Puppet's configuration settings work, and describes all of Puppet's auxiliary config files.

* * *

[environments]: ./environment.html
[configref]: /references/stable/configuration.html
[versioned]: /references/
[reports]: /guides/reporting.html
[plugins]: /guides/plugins_in_modules.html

Puppet's Settings
-----------------

Puppet is able to automatically generate a reference of all its config settings (`puppet doc --reference configuration`), and the documentation site includes [archived references for every recent version of Puppet][versioned]. You will generally want to consult the [the most recent stable version's reference][configref].

When retrieving the value for a given setting, Puppet follows a simple lookup path, stopping at the first value it finds. In order, it will check:

* Values specified on the command line
* Values in environment blocks in `puppet.conf`
* Values in run mode blocks in `puppet.conf`
* Values in the main block of `puppet.conf`
* The default values

The settings you'll have to interact with will vary a lot, depending on what you're doing with Puppet. But at the least, you should get familiar with the following:

* [`certname`](/references/stable/configuration.html#certname) --- The locally unique name for this node. If you aren't using DNS names to identify your nodes, you'll need to set it yourself.
* [`server`](/references/stable/configuration.html#server) --- The puppet master server to request configurations from. If your puppet master server isn't reachable at the default hostname of `puppet`, you'll need to set this yourself.
* [`pluginsync`](/references/stable/configuration.html#pluginsync) --- Whether to use [plugins from modules][plugins]. Most users should set this to true on all agent nodes.
* [`report`](/references/stable/configuration.html#report) --- Whether to send reports to the puppet master. Most users should set this to true on all agent nodes.
* [`reports`][reports] --- On the puppet master, which report handler(s) to use.
* [`modulepath`](/references/stable/configuration.html#modulepath) --- The search path for Puppet modules. Defaults to `/etc/puppet/modules:/usr/share/puppet/modules`.
* [`environment`](/references/stable/configuration.html#environment) --- On agent nodes, the [environment][environments] to request configuration in.
* [`node_terminus`](/references/stable/configuration.html#nodeterminus) --- How puppet master should get node definitions; if you use an ENC, you'll need to set this to "exec" on the master (or on all nodes if running in a standalone arrangement).
* [`external_nodes`](/references/stable/configuration.html#externalnodes) --- The script to run for node definitions (if `node_terminus` is set to "exec").
* [`confdir`](/references/stable/configuration.html#confdir) --- One of Puppet's main working directories, which usually contains config files, manifests, modules, and certificates.
* [`vardir`](/references/stable/configuration.html#vardir) --- Puppet's other main working directory, which usually contains cached data and configurations, reports, and file backups.

`puppet.conf`
------------

Puppet's main config file is `puppet.conf`, which is **located in Puppet's `confdir`.**

### Finding puppet.conf

#### Personal Confdirs

* When Puppet is not running as root (\*nix) or not running with elevated privileges (Windows), it will read its config files from the `.puppet` directory in the current user's home directory.

#### \*nix Systems

* Puppet Enterprise's confdir is `/etc/puppetlabs/puppet`.
* Most open source Puppet distributions use `/etc/puppet` as Puppet's confdir.
* If you are unsure where the confdir is, run `sudo puppet agent --configprint confdir` to locate it.

#### Windows Systems

On Windows, Puppet Enterprise and open source Puppet use the same confdir.

* On Windows 2003, Puppet's confdir is `%ALLUSERSPROFILE%\PuppetLabs\puppet\etc`. This is usually located on disk at `C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet\etc`.
* On Windows 7 and Windows 2008, Puppet's confdir is `%PROGRAMDATA%\PuppetLabs\puppet\etc`. This is usually located on disk at `C:\ProgramData\PuppetLabs\puppet\etc`.

> Note: On Windows systems, the puppet.conf file is allowed to use Windows-style CRLF line endings as well as \*nix-style LF line endings.

### File Format

`puppet.conf` uses an INI-like format, with `[config blocks]` containing indented groups of `setting = value` lines.  Comment lines `# start with an octothorpe`; partial-line comments are not allowed.

You can interpolate the value of a setting by using its name as a `$variable`. (Note that `$environment` has special behavior: most of the Puppet applications will interpolate their own environment, but puppet master will use the environment of the agent node it is serving.)

If a setting has multiple values, they should be a comma-separated list. "Path"-type settings made up of multiple directories should use the system path separator (colon, on most Unices).

Finally, for settings that accept only a single file or directory, you can set the owner, group, and/or mode by putting their desired states in curly braces after the value. **However,** you can only set the owner or group to two predefined values:

* `root` --- the root user or group should own the file.
* `service` --- the user or group that the Puppet service is running as should own the file. (This will be the value of the `user` and `group` settings, which, for a puppet master, default to `puppet`.)

Setting ownership and mode for file settings isn't supported on Windows.

Putting that all together:

    # a block:
    [main]
      # setting = value pairs:
      server = master.example.com
      certname = 005056c00008.localcloud.example.com

      # variable interpolation:
      rundir = $vardir/run
      modulepath = /etc/puppet/modules/$environment:/usr/share/puppet/modules
    [master]
      # a list:
      reports = store, http

      # a multi-directory modulepath:
      modulepath = /etc/puppet/modules:/usr/share/puppet/modules

      # setting owner and mode for a directory:
      vardir = /Volumes/zfs/vardir {owner = service, mode = 644}

### Config Blocks

Settings in different config blocks take effect under varying conditions. Settings in a more specific block can override those in a less specific block, as per the lookup path described above.

#### The `[main]` Block

The `[main]` config block is the least specific. Settings here are always effective, unless overridden by a more specific block.

#### `[agent]`, `[master]`, and `[user]` Blocks

These three blocks correspond to Puppet's run modes. Settings in `[agent]` will only be used by puppet agent; settings in `[master]` will be used by puppet master and puppet cert; and settings in `[user]` will only be used by puppet apply. The faces subcommands introduced in Puppet 2.7 default to the `user` run mode, but their mode can be changed at run time with the `--mode` option. Note that not every setting makes sense for every run mode, but specifying a setting in a block where it is irrelevant has no observable effect.

##### Notes on Puppet 0.25.5 and Older

Prior to Puppet 2.6, blocks were assigned by application name rather than by run mode; e.g. `[puppetd]`, `[puppetmasterd]`, `[puppet]`, and `[puppetca]`. Although these names still work, their use is deprecated, and they interact poorly with the modern run mode blocks. If you have an older config file and are using Puppet 2.6 or later, you should consider changing `[puppetd]` to `[agent]`, `[puppet]` to `[user]`, and combining `[puppetmasterd]` and `[puppetca]` into `[master]`.

#### Per-environment Blocks

Blocks named for [environments][] are the most specific, and can override settings in the run mode blocks. Only a small number of settings (specifically: `modulepath, manifest, manifestdir,` and `templatedir`) can be set in a per-environment block; any other settings will be ignored and read from a run mode or main block.

Like with the `$environment` variable, puppet master treats environments differently from the other run modes: instead of using the block corresponding to its own `environment` setting, it will use the block corresponding to each agent node's environment. The puppet master's own environment setting is effectively inert.

You may not create environments named `main`, `master`, `agent`, or `user`, as these are already taken by the primary config blocks.

Command-Line Options
--------------------

You can override any config setting at runtime by specifying it as a command-line option to almost any Puppet application. (Puppet doc is the main exception.)

Boolean settings are handled a little differently: use a bare option for a true value, and add a prefix of `no-` for false:

    # Equivalent to listen = true:
    $ puppet agent --listen
    # Equivalent to listen = false:
    $ puppet agent --no-listen

For non-boolean settings, just follow the option with the desired value:

    $ puppet agent --certname magpie.example.com
    # An equals sign is optional:
    $ puppet agent --certname=magpie.example.com

Inspecting Settings
-------------------

Puppet agent, apply, and master all accept the `--configprint <setting>` option, which makes them print their local value of the requested setting and exit. In Puppet 2.7, you can also use the `puppet config print <setting>` action, and view values in different run modes with the `--mode` flag. Either way, you can view all settings by passing `all` instead of a specific setting.

    $ puppet master --configprint modulepath
    # or:
    $ puppet config print modulepath --mode master

    /etc/puppet/modules:/usr/share/puppet/modules

Puppet agent, apply, and master also accept a `--genconfig` option, which behaves similarly to `--configprint all` but outputs a complete `puppet.conf` file, with descriptive comments for each setting, default values explicitly declared, and settings irrelevant to the requested run mode commented out. Having the documentation inline and the default values laid out explicitly can be helpful for setting up your config file, or it can be noisy and hard to work with; it comes down to personal taste.

You can also inspect settings for specific environments with the `--environment` option:

    $ puppet agent --environment testing --configprint modulepath
    /etc/puppet/testing/modules:/usr/share/puppet/modules

(As implied above, this doesn't work in the master run mode, since the master effectively has no environment.)

<!-- Protect inbound links to the old headers that were below. -->
<a id="authconf">
<a id="puppetdbconf">
<a id="routesyaml">
<a id="autosignconf">
<a id="deviceconf">
<a id="fileserverconf">
<a id="tagmailconf">

Other configuration files
-------------------------

In addition to the main configuration file, there are eight special-purpose config files you might need to interact with:

* [`auth.conf`](/puppet/latest/reference/config_file_auth.html)
* [`autosign.conf`](/puppet/latest/reference/config_file_autosign.html)
* [`csr_attributes.yaml`](/puppet/latest/reference/config_file_csr_attributes.html)
* [`device.conf`](/puppet/latest/reference/config_file_device.html)
* [`fileserver.conf`](/puppet/latest/reference/config_file_fileserver.html)
* [`puppetdb.conf`](/puppet/latest/reference/config_file_puppetdb.html)
* [`routes.yaml`](/puppet/latest/reference/config_file_routes.html)
* [`tagmail.conf`](/puppet/latest/reference/config_file_tagmail.html)
