---
layout: default
title: "Configuration: How Puppet is configured"
---

[short list]: ./config_important_settings.html
[conf_ref]: ./configuration.html
[puppet.conf]: ./config_file_main.html
[auth.conf]: ./config_file_auth.html
[puppetdb.conf]: ./config_file_puppetdb.html
[puppetserver_config]: {{puppetserver}}/configuration.html

Puppet's commands and services can be extensively configured, and its settings can be specified in a variety of places.

See also:

* [Short list of important settings][short list]
* [The configuration reference][conf_ref]

Settings can be set in the main config file. Puppet's main config file is called `puppet.conf`.

{:.concept}
## Main settings and extra config files

When we mention "settings" in the context of Puppet, we usually mean the main settings. These are the settings that are listed in the configuration reference. They are valid in `puppet.conf` and available for use on the command line. These settings configure nearly all of Puppet's core features.

However, there are also about nine extra configuration files --- things like `auth.conf` and `puppetdb.conf`. These files exist for several reasons:

* The main settings only support a few types of values. Some things just can't be configured without complex data structures, so they needed separate files. (Authorization rules and custom CSR attributes are in this category.)
* Puppet currently doesn't allow extensions to add new settings to `puppet.conf`. This means some settings that _should_ be main settings (like the PuppetDB server) can't be.

{:.section}
### Puppet Server configuration

Puppet Server honors almost all settings in `puppet.conf` and should pick them up automatically. However, for some tasks, such as configuring the webserver or an external Certificate Authority, there are Puppet Server-specific configuration files and settings.

See [Puppet Server: Configuration][puppetserver_config]


{:.concept}
## Settings are loaded on startup

When any Puppet command or service starts up, it gets values for all of its settings. Any of these settings could change the way that command or service behaves.

A command or service _only_ reads its settings _once;_ if something needs to be reconfigured, it needs to be restarted or run again.

{:.reference}
## Settings on the command line

Settings from the command line have top priority, and **always override settings from the config file.** When a Puppet command or service is started, you can specify any setting as a command line option.

Settings require two hyphens and the name of the setting on the command line:

`$ sudo puppet agent --test --noop --certname temporary-name.example.com`

{:.reference}
## Basic settings

For most settings, you specify the option and follow it with a value. An equals sign between the two (`=`) is optional, and you can optionally put values in quotes.

All three of these are equivalent to setting `certname = temporary-name.example.com` in `puppet.conf`:

`--certname=temporary-name.example.com`

`--certname temporary-name.example.com`

`--certname "temporary-name.example.com"`

{:.reference}
## Boolean settings

Settings whose only valid values are `true` and `false`, use a shorter format. Specifying the option alone sets the setting to `true`, or prefixing the option with `no-` sets it to false.

This means:

`--noop` is equivalent to setting `noop = true` in `puppet.conf`.

`--no-noop` is equivalent to setting `noop = false` in `puppet.conf`.

{:.reference}
## Default values

If a setting isn't specified on the command line or in `puppet.conf`, it falls back to a default value. Default values for all settings are listed in the configuration reference.

Some default values are based on other settings --- when this is the case, the default is shown using the other setting as a variable (similar to `$ssldir/certs`).

