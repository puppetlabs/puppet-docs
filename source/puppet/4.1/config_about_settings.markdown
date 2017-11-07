---
layout: default
title: "Configuration: How Puppet is Configured"
canonical: "/puppet/latest/config_about_settings.html"
---

[short list]: ./config_important_settings.html
[conf_ref]: ./configuration.html
[puppet.conf]: ./config_file_main.html
[auth.conf]: ./config_file_auth.html
[puppetdb.conf]: ./config_file_puppetdb.html
[puppetserver_config]: ./puppetserver/2.1/configuration.html

Puppet's commands and services can be extensively configured, and its settings can be specified in a variety of places.

This page is an overview of how Puppet's configuration works.

How Puppet Loads Settings
-----

### What are These Settings?

Here they are:

* The [short list of useful settings][short list]
* The [complete list of settings][conf_ref] (AKA the configuration reference)

### Settings are Loaded on Startup

When any Puppet command or service starts up, it gets values for all of its settings. Any of these settings may change the way that command or service behaves.

A command or service will _only_ read its settings _once;_ if it needs to be reconfigured, it will need to be restarted or run again.

### Settings can be set on the Command Line

When a Puppet command or service is started, you can specify any setting as a command line option, using two hyphens and the name of the setting:

    $ sudo puppet agent --test --noop --certname temporary-name.example.com

Settings from the command line have top priority, and **will always override settings from the config file.**

(When running under Rack, the Puppet master service can have command line options set in its `config.ru` file. For the Puppet agent service, you can often edit the init script to add command line options. In both cases, this is really only useful for the `confdir` and `vardir` settings, which can't be set in puppet.conf.)

#### Basic Settings

For most settings, you specify the option and follow it with a value. An equals sign between the two (`=`) is optional, and values may optionally be surrounded by quotes.

`--certname=temporary-name.example.com`

`--certname temporary-name.example.com`

`--certname "temporary-name.example.com"`

All three of these are equivalent to setting `certname = temporary-name.example.com` in puppet.conf.

#### Boolean Settings

For settings whose only valid values are `true` and `false`, you use a shorter format instead. Specify the option alone to set the setting to `true`, or prefix the option with `no-` to set it to false. That is:

`--noop` is equivalent to setting `noop = true` in puppet.conf.

`--no-noop` is equivalent to setting `noop = false` in puppet.conf.

### Settings can be set in the Main Config File

Puppet's main config file is called `puppet.conf`. Its format and behavior are [described in full on a separate page][puppet.conf].

### Settings Have Default Values

If a setting isn't specified on the command line or in puppet.conf, it will fall back to a default value. Default values for all settings are [listed in the configuration reference.][conf_ref]

Some of these default values are based on other settings --- when this is the case, the default is shown using the other setting as a variable (e.g. `$ssldir/certs`).

Main Settings vs. Extra Config Files
-----

When we mention "settings" in the context of Puppet, we usually mean the **main settings.** These are the settings that are listed in the configuration reference ([short list][], [long list][conf_ref]). They are valid in [puppet.conf][] and available for use on the command line. These settings configure nearly all of Puppet's core features.

However, there are also about nine extra configuration files --- things like [auth.conf][] and [puppetdb.conf][]. These files exist for several reasons:

- The main settings only support a few types of values. Some things just can't be configured without complex data structures, so they needed separate files. (Authorization rules and custom CSR attributes are in this category.)
- Puppet currently doesn't allow extensions to add new settings to puppet.conf. This means some settings that _should_ be main settings (like the PuppetDB server) can't be.

### Puppet Server Configuration

Puppet Server honors almost all settings in `puppet.conf` and should pick them up automatically. However, for some tasks, such as configuring the webserver or an external Certificate Authority, there are Puppet Server-specific configuration files and settings. See [Puppet Server: Configuration][puppetserver_config] for more information.

