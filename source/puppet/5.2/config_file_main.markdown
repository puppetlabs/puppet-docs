---
layout: default
title: "Config files: The main config file (puppet.conf)"
---

[conf_ref]: ./configuration.html
[about]: ./config_about_settings.html
[short]: ./config_important_settings.html
[config]: ./configuration.html#config
[subcommands]: ./man/
[reports]: ./configuration.html#reports
[modulepath]: ./configuration.html#modulepath
[ssldir]: ./configuration.html#ssldir
[dir_environments]: ./environments.html
[environmentpath]: ./configuration.html#environmentpath
[puppetserver_diff]: {{puppetserver}}/puppet_conf_setting_diffs.html

The `puppet.conf` file is Puppet's main config file. It configures all of the Puppet commands and services, including Puppet agent, Puppet master, Puppet apply, and Puppet cert. Nearly all of the settings listed in the [configuration reference][conf_ref] can be set in puppet.conf.

It resembles a standard INI file, with a few syntax extensions. Settings can go into application-specific sections, or into a `[main]` section that affects all applications.

(Useful background info: [about settings][about], [short list of settings][short], [full list of settings][conf_ref].)


## Location

The puppet.conf file is always located at `$confdir/puppet.conf`.

Although its location is configurable with the [`config` setting][config], it can only be set on the command line (e.g. `puppet agent -t --config ./temporary_config.conf`).

The location of the `confdir` depends on your OS. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html


## Examples

### Example agent config

```
[main]
certname = agent01.example.com
server = puppet
environment = production
runinterval = 1h
```

### Example master config

```
[main]
certname = puppetmaster01.example.com
server = puppet
environment = production
runinterval = 1h
strict_variables = true

[master]
dns_alt_names = puppetmaster01,puppetmaster01.example.com,puppet,puppet.example.com
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
environment_timeout = unlimited
```

## Format

The puppet.conf file consists of one or more **config sections,** each of which can contain any number of **settings.**

The file can also include **comment lines** at any point.

### Config sections

    [main]
        certname = puppetmaster01.example.com

A config section is a group of settings. It consists of:

* Its **name**, enclosed in square brackets. The `[name]` of the config section must be on its own line, with no leading space.
* Any number of **setting lines**, which can be indented for readability.
* Any number of empty lines or comment lines.

As soon as a new config section `[name]` appears in the file, the former config section is closed and the new one begins. A given config section should only occur once in the file.

Puppet uses four **config sections**:

* `main` is the global section used by all commands and services. It can be overridden by the other sections.
* `master` is used by the Puppet master service and the Puppet cert command.
* `agent` is used by the Puppet agent service.
* `user` is used by the Puppet apply command, as well as many of the less common [Puppet subcommands][subcommands].

Puppet prefers to use settings from one of the three application-specific sections (`master`, `agent`, or `user`). If it doesn't find a setting in the application section, it will use the value from `main`. (If `main` doesn't set one, it will fall back to the default value.)

### Puppet Server ignores some config settings

If you're using Puppet Server, you should note that it honors almost all settings in `puppet.conf` and should pick them up automatically. However, [some Puppet Server settings differ from a Ruby Puppet master’s `puppet.conf` settings][puppetserver_diff].

### Comment lines

    # This is a comment.

Comment lines start with a hash sign (`#`). They can be indented with any amount of leading space.

Partial-line comments (e.g. `report = true # this enables reporting`) are not allowed, and will be treated as part of the value of the setting. To be treated as a comment, the hash sign must be the first non-space character on the line.

### Setting lines

    certname = puppetmaster01.example.com

A setting line consists of:

* Any amount of leading space (optional).
* The name of a **setting.**
* An **equals sign** (`=`), which can optionally be surrounded by any number of spaces.
* A **value** for the setting.

### Special types of values for settings

Generally, the value of a setting will be a single word. However, there are a few special types of values:

#### Lists of words

Some settings (like [`reports`][reports]) can accept multiple values, which should be specified as a comma-separated list (with optional spaces after commas). Example: `report = http,puppetdb`

#### Paths

Some settings (like [`environmentpath`][environmentpath]) take a list of directories. The directories should be separated by the system path separator character, which is colon (`:`) on \*nix platforms and semicolon (`;`) on Windows.

    # *nix version:
    environmentpath = $codedir/special_environments:$codedir/environments
    # Windows version:
    environmentpath = $codedir/environments;C:\ProgramData\PuppetLabs\code\environment

Path lists are ordered; Puppet will always check the first directory first, then move on to the others if it doesn't find what it needs.

#### Files or directories

Settings that take a single file or directory (like [`ssldir`][ssldir]) can accept an optional hash of permissions. When starting up, Puppet will enforce those permissions on the file or directory.

You generally shouldn't do this, as the defaults are good for most users. However, if you need to, you can specify permissions by putting a hash like this after the path:

    ssldir = $vardir/ssl {owner = service, mode = 0771}

The allowed keys in the hash are `owner`, `group`, and `mode`. There are only two valid values for the `owner` and `group` keys:

* `root` --- the root or Administrator user or group should own the file.
* `service` --- the user or group that the Puppet service is running as should own the file. (The service's user and group are specified by the `user` and `group` settings. On a Puppet master running open source Puppet, these default to `puppet`;  on Puppet Enterprise they default to `pe-puppet`.)

### Interpolating variables in settings

The values of settings are available as variables within puppet.conf, and you can insert them into the values of other settings. To reference a setting as a variable, prefix its name with a dollar sign (`$`):

    ssldir = $vardir/ssl

Not all settings are equally useful; there's no real point in interpolating `$ssldir` into `basemodulepath`, for example. We recommend that you use only the following variables:

* `$codedir`
* `$confdir`
* `$vardir`

[env_conf_interp]: ./config_file_environment.html#interpolation-in-values
