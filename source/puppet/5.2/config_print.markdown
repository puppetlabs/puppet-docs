---
layout: default
title: "Configuration: Checking values of settings"
---


[config_sections]: ./config_file_main.html#config-sections
[setting_sources]: ./config_about_settings.html
[confdir_sys]: ./dirs_confdir.html#location
[environment]: ./environments.html
[confdir]: ./dirs_confdir.html
[vardir]: ./dirs_vardir.html
[modulepath]: ./dirs_modulepath.html

Puppet settings are highly dynamic, and their values can come from [several different places][setting_sources].

To see the actual settings values that a Puppet service will use, it's often best to ask Puppet itself. The `puppet config print` command lets you do this.

General Usage
-----

The `puppet config print` command loads and evaluates settings, and can imitate any of Puppet's other commands and services when doing so. The `--section` and `--environment` options let you control how settings are loaded; for details, see the sections below on imitating different services.

> **Note:** To ensure that you're seeing the values Puppet will use when running as a service, be sure to use `sudo` or run the command as `root` or `Administrator`. If you run `puppet config print` as some other user, Puppet might not use the [system config file.][confdir_sys]

#### To see the value of one setting:

    $ sudo puppet config print <SETTING NAME> [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]

This will show _just the value_ of `<SETTING NAME>`.

---

#### To see the value of multiple settings:

    $ sudo puppet config print <SETTING 1> <SETTING 2> [...] [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]

This will show `name = value` pairs for all requested settings.

---

#### To see the value of all settings:

    $ sudo puppet config print [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]

This will show `name = value` pairs for all settings.


### Config Sections

The `--section` option specifies which [section of puppet.conf][config_sections] to use when finding settings. It is optional, and defaults to `main`. Valid sections are:

* `main` **(default)** --- used by all commands and services
* `master` --- used by the Puppet master service and the `puppet cert` command
* `agent` --- used by the Puppet agent service
* `user` --- used by the Puppet apply command and most other commands

As usual, the other sections will override the `main` section if they contain a setting; if they don't, the value from `main` will be used, or a default value if the setting isn't present there.

### Environments

The `--environment` option specifies which [environment][] to use when finding settings. It is optional and defaults to the value of the `environment` setting in the `user` section (usually `production`, since it's rare to specify an environment in `user`).

Note that you can only specify environments that already exist.

This option is generally only useful when looking up settings used by the Puppet master service, since it's rare to use environment config sections for Puppet apply and Puppet agent.


Imitating Puppet Master and Puppet Cert
-----

To see the settings the Puppet master service and the Puppet cert command would use:

* Specify `--section master`.
* Use the `--environment` option to specify the environment you want settings for, or let it default to `production`.
* Remember to use `sudo`.
* If your Puppet master is managed as a rack application (e.g. with Passenger), check the `config.ru` file to make sure it's using the [confdir][] and [vardir][] that you expect. If it's using non-standard ones, you will need to specify them on the command line with the `--confdir` and `--vardir` options; otherwise you might not see the correct values for settings.

### Examples

To see the effective [modulepath][] used in the `dev` environment:

    $ sudo puppet config print modulepath --section master --environment dev
    /etc/puppetlabs/code/environments/dev/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules

To see whether PuppetDB is configured for exported resources:

    $ sudo puppet config print storeconfigs storeconfigs_backend --section master
    storeconfigs = true
    storeconfigs_backend = puppetdb

Imitating Puppet Agent
-----

To see the settings the Puppet agent service would use:

* Specify `--section agent`.
* Remember to use `sudo`.
* If you are seeing something unexpected, check your Puppet agent init script or cron job to make sure it is using the standard [confdir][] and [vardir][], is running as root, and isn't overriding other settings with command line options. If it's doing anything unusual, you might have to set more options for the config print command.

### Example

To see whether the agent is configured to use manifest ordering when applying the catalog:

    $ sudo puppet config print ordering --section agent
    manifest

Imitating Puppet Apply
-----

To see the settings the Puppet apply command would use:

* Specify `--section user`.
* Remember to use `sudo`.
* If you are seeing something unexpected, check the cron job or script that is responsible for configuring the machine with Puppet apply. Make sure it is using the standard [confdir][] and [vardir][], is running as root, and isn't overriding other settings with command line options. If it's doing anything unusual, you might have to set more options for the config print command.

### Example

To see whether Puppet apply is configured to use reports:

    $ sudo puppet config print report reports --section user
    report = true
    reports = store,http
