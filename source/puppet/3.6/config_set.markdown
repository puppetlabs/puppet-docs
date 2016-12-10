---
layout: default
title: "Configuration: Editing Settings on the Command Line"
canonical: "/puppet/latest/reference/config_set.html"
---

[config_sections]: ./config_file_main.html#config-sections
[puppet.conf]: ./config_file_main.html
[environments]: ./environments.html
[confdir_sys]: ./dirs_confdir.html#system-and-user-confdirs

Puppet loads most of its settings from [the puppet.conf config file.][puppet.conf] You can edit this file directly, or you can change individual settings with the `puppet config set` command.

> When to Use This
> -----
>
> We recommend using `puppet config set` for:
>
> * Fast one-off config changes
> * Scriptable config changes in provisioning tools
>
> If you find yourself changing many settings at once, you might prefer to edit the puppet.conf file or manage it with a template.

Usage
-----

To assign a new value to a setting, run:

    $ sudo puppet config set <SETTING NAME> <VALUE> --section <CONFIG SECTION>

This will declaratively set the value of `<SETTING NAME>` to `<VALUE>` (in the specified config section). It will work the same way regardless of whether the setting already had a value.

### Config Sections

The `--section` option specifies which [section of puppet.conf][config_sections] to modify. It is optional, and defaults to `main`. Valid sections are:

* `main` **(default)** --- used by all commands and services
* `master` --- used by the puppet master service and the `puppet cert` command
* `agent` --- used by the puppet agent service
* `user` --- used by the puppet apply command and most other commands
* Any valid [environment][environments] name --- used by all commands and services when requesting or compiling catalogs in that environment

If modifying the [system config file][confdir_sys], be sure to use `sudo` or run the command as `root` or `Administrator`.

Example
-----

**Before:**

    # /etc/puppetlabs/puppet/puppet.conf
    [main]
    certname = agent01.example.com
    server = master.example.com
    vardir = /var/opt/lib/pe-puppet

    [agent]
    report = true
    graph = true
    pluginsync = true

    [master]
    dns_alt_names = master,master.example.com,puppet,puppet.example.com

**Commands:**

    $ sudo puppet config set trusted_node_data true --section master
    $ sudo puppet config set ordering manifest

**After:**

    # /etc/puppetlabs/puppet/puppet.conf
    [main]
    certname = agent01.example.com
    server = master.example.com
    vardir = /var/opt/lib/pe-puppet
    ordering = manifest

    [agent]
    report = true
    graph = true
    pluginsync = true

    [master]
    dns_alt_names = master,master.example.com,puppet,puppet.example.com
    trusted_node_data = true


Compatibility Note
-----

The `puppet config set` command first appeared in Puppet 3.5 and Puppet Enterprise 3.2. It can't be used with earlier versions of Puppet.
