---
layout: default
title: Configuring Puppet
---

Configuring Puppet
==================

Puppet's settings are stored in a primary configuration file, and can be overridden individually on the command-line. In addition, several subsystems of Puppet have their own special-purpose configuration files. 

This document describes the syntax and special behavior of each of these configuration files.


* * * 

[environments]: ./environment.html
[configref]: /references/stable/configuration.html

`puppet.conf`
-------------

Puppet's main settings are all stored in `puppet.conf`, a file located in Puppet's `confdir`. (On most systems, when running as root or the Puppet user, the confdir is `/etc/puppet`; `confdir` itself is a changeable setting. The default confdir when running as a normal user is `~/.puppet`.) 

Any setting that isn't explicitly set has a default value. 

### File Format

* `puppet.conf` uses an INI-like format, with `[blocks]` containing indented groups of `setting = value` lines.
* Comment lines `# start with an octothorpe`; partial-line comments are not allowed. 
* You can interpolate the value of a setting by using its name as a `$variable`.
    * Note that `$environment` has special behavior: most applications will use their own environment, but puppet master will use the environment of the agent node it is serving.
* If a setting has multiple values, they should be a comma-separated list. 
* "Path"-type settings made up of multiple directories should use the system path separator (colon, on most Unices). 
* Finally, for settings that accept only a single file or directory, you can set the owner, group, and/or mode by putting their desired states in curly braces after the value.

Putting that all together:

    # a block:
    [main]
        # setting = value pairs:
        server = master.puppetlabs.lan
        certname = 005056c00008.localcloud.puppetlabs.lan
        
        # variable interpolation:
        rundir = $vardir/run
        modulepath = /etc/puppet/modules/$environment:/usr/share/puppet/modules
    [master]
        # a list:
        reports = store, http
        
        # a multi-directory modulepath:
        modulepath = /etc/puppet/modules:/usr/share/puppet/modules
        
        # setting owner and mode for a directory:
        vardir = /Volumes/zfs/vardir {owner = root, mode = 644}

### Blocks

Config blocks dictate when the settings they contain will take effect. Settings in a more specific block can override those in a less specific block. 

#### `[main]`

The `[main]` config block is the least specific. Settings here are always effective, unless overridden by a more specific block. 

#### `[agent]`, `[master]`, and `[user]`

These three blocks correspond to Puppet's run modes. Settings in `[agent]` will only be used by puppet agent, settings in `[master]` will be used by puppet master and puppet cert, and settings in `[user]` will be used by puppet apply. The Faces applications introduced in Puppet 2.7 default to the `user` run mode, but their mode can be changed at run time with the `--mode` option. Note that not every setting makes sense for every run mode, but specifying a setting in a block where it is irrelevant has no observable effect.

Prior to Puppet 2.6, these blocks were called `[puppetd]`, `[puppetmasterd]`, and `[puppet]`, respectively. Although these names still work, their use is deprecated. 

#### Per-environment Blocks

Blocks named for [environments][] are the most specific, and can override settings in the run mode blocks. 

Like with the `$environment` variable, puppet master treats environments differently from the other run modes: instead of using the block corresponding to its own `environment` setting, it will use the block corresponding to each agent node's environment. The puppet master's own environment setting is effectively inert. 

### Inspecting Settings

Puppet agent, apply, and master all accept the `--configprint <setting>` option, which makes them print their local value of the requested setting and exit.

    $ puppet master --configprint modulepath
    /etc/puppet/modules:/usr/share/puppet/modules

In Puppet 2.7, you can also use `puppet config print <setting>`; view values in different run modes with the `--mode` flag. Either way, you can view all settings by passing `all` instead of a specific setting. 

Agent, apply, and master also accept a `--genconfig` option, which behaves similarly to `--configprint all` but outputs a complete `puppet.conf` file, with descriptive comments for each setting, default values explicitly declared, and settings irrelevant to the requested run mode commented out. 

### Command-Line Options

You can override **any** setting at runtime by specifying it as a command-line option. Boolean settings translate to bare options; to set them to false, add a prefix of `no-`:

    # Equivalent to listen = true:
    $ puppet agent --listen
    # Equivalent to listen = false:
    $ puppet agent --no-listen

For non-boolean settings, just follow the option with the desired value: 

    $ puppet agent --certname magpie.puppetlabs.lan
    # An equals sign is optional:
    $ puppet agent --certname=magpie.puppetlabs.lan

Since `environment` is also just a setting, you can combine it with `--configprint` to inspect settings for specific environments:

    $ puppet agent --environment testing --configprint modulepath
    /etc/puppet/testing/modules:/usr/share/puppet/modules

(As implied above, this doesn't work in the master run mode.)

`auth.conf`
-----------

Access to Puppet's REST API is configured in `auth.conf`, the location of which is determined by the `rest_authconfig` setting. (Default: `/etc/puppet/auth.conf`.) It consists of a series of ACL stanzas, and behaves quite differently from `puppet.conf`; for full details, see the [REST access control documentation](./rest_auth_conf.html). 

    # Example auth.conf:
    
    path /
    auth any
    environment override
    allow magpie.lan
    
    path /certificate_status
    auth any
    environment production
    allow magpie.lan
    
    path /facts
    method save
    auth any
    allow magpie.lan
    
    path /facts
    auth yes
    method find, search
    allow magpie.lan, dashboard, redmaster.magpie.lan

`fileserver.conf`
---------------

By default, `fileserver.conf` isn't necessary, provided that you only need to serve files from modules. If you want to create additional fileserver mount points, you can do so in `/etc/puppet/fileserver.conf` (or whatever is set in the `fileserverconfig` setting).

`fileserver.conf` consists of a collection of mount-point stanzas, and looks like a hybrid of `puppet.conf` and `auth.conf`:

    # Files in the /path/to/files directory will be served
    # at puppet:///mount_point/.
    [mount_point]
        path /path/to/files
        allow *.domain.com
        deny *.wireless.domain.com

See the [file serving documentation](./file_serving.html) for more details. 

Note that certname globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully-qualified domain name. (That is, if your certnames don't look like FQDNs, you can't use `autosign.conf` to full effect.

`tagmail.conf`
------------

Your puppet master server can send targeted emails to different admin users whenever certain resources are changed. This requires that you:

* Set `report = true` on your agent nodes
* Set `reports = tagmail` on the puppet master (`reports` accepts a list, so you can enable any number of reports)
* Set the `reportfrom` email address and either the `smtpserver` or `sendmail` setting on the puppet master
* Create a `tagmail.conf` file at the location specified in the `tagmap` setting

More details are available at the [tagmail report reference](http://docs.puppetlabs.com/references/stable/report.html#tagmail). 

The `tagmail.conf` file is list of lines, each of which consists of a tag, a colon, and an email address. The tag portion of a line can also be a !negated tag, a list of tags, or the word "all," which does exactly what it sounds like.

    all: zach@puppetlabs.com
    webserver, !mailserver: httpadmins@domain.com

`autosign.conf`
---------------

The `autosign.conf` file (located at `/etc/puppet/autosign.conf` by default, and configurable with the `autosign` setting) is a list of certnames or certname globs (one per line) whose certificate requests will automatically be signed. 

    rebuilt.puppetlabs.lan
    *.magpie.puppetlabs.lan
    *.local

Note that certname globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully-qualified domain name. (That is, if your certnames don't look like FQDNs, you can't use `autosign.conf` to full effect.

As any host can provide any certname, autosigning should only be used with great care, and only in situations where you essentially trust any computer able to connect to the puppet master.

`device.conf`
-----------

Puppet device, added in Puppet 2.7, configures network hardware using a catalog downloaded from the puppet master; in order to function, it requires that the relevant devices be configured in `/etc/puppet/device.conf` (configurable with the `deviceconfig` setting). 

`device.conf` is organized in INI-like blocks, with one block per device:

    [device certname]
        type <type>
        url <url>
    [router6.puppetlabs.lan]
        type cisco
        url ssh://admin:password@ef03c87a.local
