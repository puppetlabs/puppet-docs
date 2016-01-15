---
layout: default
title: "Config Files: The Main Config File (puppet.conf)"
canonical: "/puppet/latest/reference/config_file_main.html"
---

[conf_ref]: ./configuration.html
[about]: ./config_about_settings.html
[short]: ./config_important_settings.html
[config]: ./configuration.html#config
[subcommands]: ./man/
[conf_environments]: ./environments_classic.html
[reports]: ./configuration.html#reports
[modulepath]: ./configuration.html#modulepath
[ssldir]: ./configuration.html#ssldir
[dir_environments]: ./environments.html

The `puppet.conf` file is Puppet's main config file. It configures all of the Puppet commands and services, including Puppet agent, Puppet master, Puppet apply, and Puppet cert. Nearly all of the settings listed in the [configuration reference][conf_ref] can be set in puppet.conf.

It resembles a standard INI file, with a few syntax extensions. Settings may go into application-specific sections, or into a `[main]` section that affects all applications.

(Useful background info: [about settings][about], [short list of settings][short], [full list of settings][conf_ref].)


## Location

The puppet.conf file is always located at `$confdir/puppet.conf`.

Although its location is configurable with the [`config` setting][config], it can only be set on the command line (e.g. `puppet agent -t --config ./temporary_config.conf`).

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html


## Example

The below example is something you might see with a fresh install of Puppet Enterprise 3.7.

    # Settings in [main] are used if a more specific section doesn't set a value.
    [main]
        certname = puppetmaster01.example.com
        logdir = /var/log/pe-puppet
        rundir = /var/run/pe-puppet
        basemodulepath = /etc/puppetlabs/puppet/environments/production/modules:/opt/puppet/share/puppet/modules
        server = puppet.example.com
        user  = pe-puppet
        group = pe-puppet
        archive_files = true
        archive_file_server = puppet.example.com

    # This section is used by the Puppet master and Puppet cert applications.
    [master]
        certname = puppetmaster01.example.com
        dns_alt_names = puppetmaster01,puppetmaster01.example.com,puppet,puppet.example.com
        ca_name = 'Puppet CA generated on puppetmaster01.example.com at 2013-08-09 19:11:11 +0000'
        reports = http,puppetdb
        reporturl = https://localhost:443/reports/upload
        node_terminus = exec
        external_nodes = /etc/puppetlabs/puppet-dashboard/external_node
        ssl_client_header = SSL_CLIENT_S_DN
        ssl_client_verify_header = SSL_CLIENT_VERIFY
        storeconfigs_backend = puppetdb
        storeconfigs = true
        autosign = true

    # This section is used by the Puppet agent application.
    [agent]
        report = true
        classfile = $vardir/classes.txt
        localconfig = $vardir/localconfig
        graph = true
        pluginsync = true
        environment = production

## Format

The puppet.conf file consists of one or more **config sections,** each of which may contain any number of **settings.**

The file may also include **comment lines** at any point.

### Config Sections

    [main]
        certname = puppetmaster01.example.com

A config section is a group of settings. It consists of:

* Its **name,** enclosed in square brackets. The `[name]` of the config section must be on its own line, with no leading space.
* Any number of **setting lines,** which may be indented for readability.
* Any number of empty lines or comment lines.

As soon as a new config section `[name]` appears in the file, the former config section is closed and the new one begins. A given config section should only occur once in the file.

### The Primary Config Sections

Puppet uses four **primary config sections:**

* `main` is the global section used by all commands and services. It can be overridden by the other sections.
* `master` is used by the Puppet master service and the Puppet cert command.
* `agent` is used by the Puppet agent service.
* `user` is used by the Puppet apply command, as well as many of the less common [Puppet subcommands][subcommands].

Puppet will prefer to use settings from one of the three application-specific sections (`master`, `agent`, or `user`). If it doesn't find a setting in the application section, it will use the value from `main`. (If `main` doesn't set one, it will fall back to the default value.)

### Environment Config Sections

    [test]
      modulepath = $confdir/environments/test/modules:$condfir/modules:/usr/share/puppet/modules
      manifest = $confdir/environments/test/manifests

If you are using [config file environments][conf_environments], each environment can have its own config section. See the [page on config file environments][conf_environments] for details.

If it exists, the environment config section for the active environment always has highest priority. That is, it will override settings from the `master` section while the Puppet master is serving agents assigned to that environment.

### Comment Lines

    # This is a comment.

Comment lines start with a hash sign (`#`). They may be indented with any amount of leading space.

Partial-line comments (e.g. `report = true # this enables reporting`) are not allowed, and will be treated as part of the value of the setting. To be treated as a comment, the hash sign must be the first non-space character on the line.

### Setting Lines

    certname = puppetmaster01.example.com

A setting line consists of:

* Any amount of leading space (optional).
* The name of a **setting.**
* An **equals sign** (`=`), which may optionally be surrounded by any number of spaces.
* A **value** for the setting.

### Special Types of Values for Settings

Generally, the value of a setting will be a single word. However, there are a few special types of values:

#### Lists of words

Some settings (like [`reports`][reports]) can accept multiple values, which should be specified as a comma-separated list (with optional spaces after commas). Example: `report = http,puppetdb`

#### Paths

Some settings (like [`modulepath`][modulepath] or [`environmentpath`]) take a list of directories. The directories should be separated by the system path separator character, which is colon (`:`) on \*nix platforms and semicolon (`;`) on Windows.

    # *nix version:
    modulepath = $confdir/modules:/opt/usr/share/puppet/modules
    # Windows version:
    modulepath = $confdir/modules;C:/Users/Administrator/global_modules

Path lists are ordered; Puppet will always check the first directory first, then move on to the others if it doesn't find what it needs.

#### Files or Directories

Settings that take a single file or directory (like [`ssldir`][ssldir]) can accept an optional hash of permissions. When starting up, Puppet will enforce those permissions on the file or directory.

You generally shouldn't do this, as the defaults are good for most users. However, if you need to, you can specify permissions by putting a hash like this after the path:

    ssldir = $vardir/ssl {owner = service, mode = 0771}

The allowed keys in the hash are `owner`, `group`, and `mode`. There are only two valid values for the `owner` and `group` keys:

* `root` --- the root or Administrator user or group should own the file.
* `service` --- the user or group that the Puppet service is running as should own the file. (The service's user and group are specified by the `user` and `group` settings. On a Puppet master running open source Puppet, these default to `puppet`;  on Puppet Enterprise they default to `pe-puppet`.)

### Interpolating Variables in Settings

The values of settings are available as variables within puppet.conf, and you can insert them into the values of other settings. To reference a setting as a variable, prefix its name with a dollar sign (`$`):

    ssldir = $vardir/ssl

Not all settings are equally useful; there's no real point in interpolating `$ssldir` into `basemodulepath`, for example. We recommend that you use only the following variables:

* `$confdir`
* `$vardir`
* `$environment` --- the name of the active environment. Used in dynamic [config file environments.][conf_environments] If you are using this in puppet.conf, you should switch to [directory environments][dir_environments].

[env_conf_interp]: ./config_file_environment.html#interpolation-in-values
