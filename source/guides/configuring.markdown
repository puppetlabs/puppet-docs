---
layout: legacy
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

Other configuration files
-------------------------

In addition to the main configuration file, there are five special-purpose config files you might need to interact with: `auth.conf`, `fileserver.conf`, `tagmail.conf`, `autosign.conf`, and `device.conf`.

### `auth.conf`

**[See the `auth.conf` documentation for more details about this file](./rest_auth_conf.html).**

Access to Puppet's HTTP API is configured in `auth.conf`, the location of which is determined by the `rest_authconfig` setting. (Default: `/etc/puppet/auth.conf`.) It consists of a series of ACL stanzas, and behaves quite differently from `puppet.conf`.

    # Example auth.conf:

    path /
    auth true
    environment override
    allow magpie.example.com

    path /certificate_status
    auth true
    environment production
    allow magpie.example.com

    path /facts
    method save
    auth true
    allow magpie.example.com

    path /facts
    auth true
    method find, search
    allow magpie.example.com, dashboard.example.com, finch.example.com

### `puppetdb.conf`

The `puppetdb.conf` file contains the hostname and port of the [PuppetDB](/puppetdb/latest/) server. It is only used if you are using PuppetDB and have [connected your puppet master to it](/puppetdb/latest/connect_puppet_master.html).

This file uses the same ini-like format as `puppet.conf`, but only uses a `[main]` block and only has two settings (`server` and `port`):

    [main]
    server = puppetdb.example.com
    port = 8081

See the [PuppetDB manual](/puppetdb/latest/) for more information.


### `routes.yaml`

This file overrides configuration settings involving indirector termini, and allows termini to be set in greater detail than `puppet.conf` allows.

This file should be a YAML hash. Each top level key should be the name of a run mode (master, agent, user), and its value should be another hash. Each key of these second-level hashes should be the name of an indirection, and its value should be another hash. The only keys allowed in these third-level hashes are `terminus` and `cache`. The value of each of these keys should be the name of a valid terminus for the indirection.

Example:

    ---
    master:
      facts:
        terminus: puppetdb
        cache: yaml

### `autosign.conf`

The `autosign.conf` file (located at `/etc/puppet/autosign.conf` by default, and configurable with the `autosign` setting) is a list of certnames or domain name globs (one per line) whose certificate requests will automatically be signed.

    rebuilt.example.com
    *.scratch.example.com
    *.local

Note that domain name globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully-qualified domain name. (That is, if your certnames don't look like FQDNs, you can't use `autosign.conf` to full effect.

Since any host can provide any certname, autosigning should only be used with great care, and only in situations where you essentially trust any computer able to connect to the puppet master.

### `device.conf`

Puppet device, added in Puppet 2.7, configures network hardware using a catalog downloaded from the puppet master; in order to function, it requires that the relevant devices be configured in `/etc/puppet/device.conf` (configurable with the `deviceconfig` setting).

`device.conf` is organized in INI-like blocks, with one block per device:

    [device certname]
        type <type>
        url <url>
    [router6.example.com]
        type cisco
        url ssh://admin:password@ef03c87a.local

### `fileserver.conf`

By default, `fileserver.conf` isn't necessary, provided that you only need to serve files from modules. If you want to create additional fileserver mount points, you can do so in `/etc/puppet/fileserver.conf` (or whatever is set in the `fileserverconfig` setting).

`fileserver.conf` consists of a collection of mount-point stanzas, and looks like a hybrid of `puppet.conf` and `auth.conf`:

    # Files in the /path/to/files directory will be served
    # at puppet:///mount_point/.
    [mount_point]
        path /path/to/files
        allow *.example.com
        deny *.wireless.example.com

See the [file serving documentation](./file_serving.html) for more details.

Note that certname globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully-qualified domain name. (That is, if your certnames don't look like FQDNs, you can't use `autosign.conf` to full effect.

### `tagmail.conf`

Your puppet master server can send targeted emails to different admin users whenever certain resources are changed. This requires that you:

* Set `report = true` on your agent nodes
* Set `reports = tagmail` on the puppet master ([the `reports` setting][reports] accepts a list, so you can enable any number of reports)
* Set the [`reportfrom`][reportfrom] email address and either the [`smtpserver`][smtpserver] or [`sendmail`][sendmail] setting on the puppet master
* Create a `tagmail.conf` file at the location specified in the `tagmap` setting

More details are available at the [tagmail report reference](http://docs.puppetlabs.com/references/stable/report.html#tagmail).

[reportfrom]: /references/latest/configuration.html#reportfrom
[smtpserver]: /references/latest/configuration.html#smtpserver
[sendmail]: /references/latest/configuration.html#sendmail

The `tagmail.conf` file (located at `/etc/puppet/tagmail.conf` by default, and configurable with the `tagmap` setting) is list of lines, each of which consists of:

* A comma-separated list of tags and !negated tags; valid tags include:
    * Explicit tags
    * Class names
    * "`all`"
    * Any valid Puppet log level (`debug`, `info`, `notice`, `warning`, `err`, `alert`, `emerg`, `crit`, or `verbose`)
* A colon
* A comma-separated list of email addresses

The list of tags on a line builds the set of resources whose messages will be included in the mailing; each additional tag adds to the set, and each !negated tag subtracts from the set.

So, for example:

    all: log-archive@example.com
    webserver, !mailserver: httpadmins@example.com
    emerg, crit: james@example.com, zach@example.com, ben@example.com

This `tagmail.conf` file will mail any resource events tagged with `webserver` but _not_ with `mailserver` to the httpadmins group; any emergency or critical events to to James, Zach, and Ben, and all events to the log-archive group.

