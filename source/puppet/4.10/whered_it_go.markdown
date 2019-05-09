---
layout: default
title: "Where did everything go in Puppet 4.x?"
---


[confdir]: /puppet/latest/dirs_confdir.html
[directory environments]: /puppet/latest/environments.html
[spec]: https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md
[main manifest]: /puppet/latest/dirs_manifest.html

In Puppet 4, we changed the locations of a lot of important config files and directories. We also changed Puppet's packaging to install different things in different places.

This page is a summary, to quickly orient users arriving from Puppet 3.

> If you want full details, [we've written a specification of the directories used by all of Puppet's tools.][spec]

## New all-in-one `puppet-agent` package

On managed \*nix systems, you'll now install `puppet-agent` instead of `puppet`. (This package also provides `puppet apply`, suitable for standalone Puppet systems.)

This is a new name for a new thing. Instead of using package dependencies to bring in tools like Facter, Hiera, and Ruby, it includes private versions of all of them.

It also includes MCollective.

On Windows, you'll use the same package as before, but the open source package now includes MCollective.

## \*nix executables are in `/opt/puppetlabs/bin/`


On \*nix platforms, the main executables moved to `/opt/puppetlabs/bin`. This means **Puppet and related tools aren't included in your PATH by default.** You'll need to either:

* Add `/opt/puppetlabs/bin` to your PATH
* Symlink Puppet's tools to somewhere else in your PATH
* Use the full path (like `/opt/puppetlabs/bin/puppet apply` when running Puppet commands

On Windows, executables stayed in the same location, and the MSI package still adds Puppet's tools to the PATH.

### Private `bin` directories

The executables in `/opt/puppetlabs/bin` are just the "public" applications that make up Puppet. Private supporting commands like `ruby` and `gem` are in `/opt/puppetlabs/puppet/bin`, to keep them from accidentally overriding system tools if you add the public bin dir to your PATH.

\*nix `confdir` is now `/etc/puppetlabs/puppet`
-----

Puppet's system [`confdir`][confdir] (used by `root` and the `puppet` user) is now `/etc/puppetlabs/puppet`, instead of `/etc/puppet`. Open source Puppet now uses the same `confdir` as Puppet Enterprise.

The [`confdir`][confdir] is the directory that holds config files like `puppet.conf` and `auth.conf`.

On Windows, this stayed the same. It's still in the `COMMON_APPDATA` folder, defaulting to `C:\ProgramData\PuppetLabs\puppet\etc` on modern Windows versions.

### `ssldir` is inside `confdir`

On some Linux distros, our default config used to set Puppet's `ssldir` as `$vardir/ssl` rather than `$confdir/ssl`. Now we're not doing that; the default location is in the `confdir` on all platforms.

### Other stuff in `/etc/puppetlabs`

We're also moving other related configs into the `/etc/puppetlabs` directory. Puppet Server now uses `/etc/puppetlabs/puppetserver`, and MCollective uses `/etc/puppetlabs/mcollective`.


## New `codedir` holds all modules/manifests/data


All of the content used to configure nodes has moved into a new directory, named `codedir`. (This stuff used to be in the `confdir`.)

The default `codedir` location is:

* `/etc/puppetlabs/code` on \*nix
* `C:\ProgramData\PuppetLabs\code` on Windows
* `<USER DIRECTORY>/.puppetlabs/etc/code` if you're running as a non-root user

The main contents of the `codedir` are:

* The `environments` directory
* The global `modules` directory
    * Note: This is only for module versions you specifically want in _all_ environments.

### Directory environments are always on

[Directory environments][] are always enabled now.

The default `environmentpath` is `$codedir/environments`. On install, we create a directory for the default `production` environment.

This means that if you're starting from scratch, you should:

* Put modules in `$codedir/environments/production/modules`.
* Put your [main manifest][] in `$codedir/environments/production/manifests`.

You can still put global modules in `$codedir/modules`, and can configure a global [main manifest][] with the `default_manifest` setting.

### Hiera data goes in environments by default

Hiera's default settings now use an environment-specific datadir for the YAML and JSON backends. So the `production` environment's default Hiera data directory would be `/etc/puppetlabs/code/environments/production/hieradata`.

## Some other directories have moved


* The system `vardir` for `puppet agent` has moved, and is now separate from Puppet Server's `vardir`.
    * On \*nix: `/opt/puppetlabs/puppet/cache`
    * On Windows: `C:\ProgramData\PuppetLabs\puppet\cache`
* The `rundir`, where the service PID files go, has moved:
    * On \*nix: `/var/run/puppetlabs`. (Puppet Server has a `puppetserver` directory in this directory.)
    * On Windows: `C:\ProgramData\PuppetLabs\puppet\var\run` --- this is the same as before, but it's now outside the main `vardir`.

