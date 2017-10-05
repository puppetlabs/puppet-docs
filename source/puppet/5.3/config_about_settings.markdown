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

-   [Short list of important settings][short list]
-   [The configuration reference][conf_ref]

Settings can be set in the main config file. Puppet's main config file is called `puppet.conf`.

{:.concept}
## Main settings and extra config files

When we mention "settings" in the context of Puppet, we usually mean the main settings. These are the settings that are listed in the configuration reference. They are valid in `puppet.conf` and available for use on the command line. These settings configure nearly all of Puppet's core features.

However, there are also about nine extra configuration files --- things like `auth.conf` and `puppetdb.conf`. These files exist for several reasons:

-   The main settings only support a few types of values. Some things just can't be configured without complex data structures, so they needed separate files. (Authorization rules and custom CSR attributes are in this category.)
-   Puppet currently doesn't allow extensions to add new settings to `puppet.conf`. This means some settings that _should_ be main settings (like the PuppetDB server) can't be.

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

{:.concept}
## Configuring locale settings

Puppet 5.1 added support for locale-specific strings in output, and it detects your locale from your system configuration. This provides localized strings, report messages, and log messages for the locale's language when available.

Upon startup, Puppet looks for a set of environment variables on \*nix systems, or the code page setting on Windows. When Puppet finds one that is set, it uses that locale whether it is run from the command line or as a service.

For help setting your operating system's locale or adding new locales, consult its documentation. This section covers setting the locale for Puppet services.

{:.task}
### Checking your locale settings on \*nix and macOS

To check your current locale settings, run the `locale` command. This outputs the settings used by your current shell.

```
$ locale
LANG="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL=
```

To see which locales are supported by your system, run `locale -a`, which outputs a list of available locales. Note that Puppet might not have localized strings for every available locale.

To check the current status of environment variables that might conflict with or override your locale settings, use the `set` command. For example, this command lists the set environment variables and searches for those containing `LANG` or `LC_`:

```
sudo set | egrep 'LANG|LC_'
```

{:.task}
### Checking your locale settings on Windows

To check your current locale setting, run the `Get-WinSystemLocale` command from PowerShell.

```
PS C:\> Get-WinSystemLocale
LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)
```

To check your system's current code page setting, run the `chcp` command.

{:.task}
### Setting your locale on *nix with an environment variable

You can use environment variables to set your locale for processes started on the command line. For most Linux distributions, set the `LANG` variable to your preferred locale, and the `LANGUAGE` variable to an empty string. On SLES, also set the `LC_ALL` variable to an empty string.

For example, to set the locale to Japanese for a terminal session on SLES:

```
export LANG=ja_JP.UTF-8
export LANGUAGE=''
export LC_ALL=''
```

To set the locale for the Puppet agent service, you can add these `export` statements to:

-   `/etc/sysconfig/puppet` on RHEL and its derivatives
-   `/etc/default/puppet` on Debian, Ubuntu, and their derivatives

After updating the file, restart the Puppet service to apply the change.

{:.task}
### Setting your locale for the Puppet agent service on macOS

To set the locale for the Puppet agent service on macOS, update the `LANG` setting in the `/Library/LaunchDaemons/com.puppetlabs.puppet.plist` file.

```xml
<dict>
        <key>LANG</key>
        <string>ja_JP.UTF-8</string>
</dict>
```

After updating the file, restart the Puppet service to apply the change.

{:.task}
### Setting your locale on Windows

On Windows, Puppet uses the `LANG` environment variable if it is set. If not, it uses the configured region, as set in the Administrator tab of the Region control panel.

On Windows 10, you can use PowerShell to set the system locale:

```
Set-WinSystemLocale en-US
```

{:.task}
### Disabling internationalized strings

Puppet 5.3.2 adds the optional Boolean `disable_i18n` setting, which you can configure in `puppet.conf`. If set to `true`, Puppet disables localized strings in log messages, reports, and parts of the command-line interface. This can improve performance when using Puppet modules, especially if [environment caching](./environments_creating.markdown#environment_timeout) is disabled, and even if you don't need localized strings or the modules aren't localized. This setting is `false` by default in open source Puppet.

If you're experiencing performance issues, configure this setting in the `[master]` section of the Puppet master's `puppet.conf` file. To force unlocalized messages, which are in English by default, configure this section in a node's `[main]` or `[user]` sections of `puppet.conf`.