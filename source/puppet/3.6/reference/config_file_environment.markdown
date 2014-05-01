---
layout: default
title: "Config Files: environment.conf"
canonical: "/puppet/latest/reference/config_file_environment.html"
---

[directory environments]: ./environments.html
[environmentpath]: ./environments.html#about-environmentpath
[modulepath]: /references/3.6.latest/configuration.html#modulepath
[manifest]: /references/3.6.latest/configuration.html#manifest
[config_version]: /references/3.6.latest/configuration.html#configversion

When using [directory environments][], each environment may contain an `environment.conf` file. This file can override several settings whenever the puppet master is serving nodes assigned to that environment.

## Location

Each environment.conf file should be stored in a [directory environment][directory environments]. It should be at the top level of its home environment, next to the `manifests` and `modules` directories.

For example: if your [`environmentpath` setting][environmentpath] is set to `$confdir/environments`, the environment.conf file for the `test` environment should be located at `$confdir/environments/test/environment.conf`.

## Example

    # /etc/puppetlabs/puppet/environments/test/environment.conf
    # Exclude global directories in basemodulepath from this environment:
    modulepath = modules
    # Use our custom script to get a git commit for the current state of the code:
    config_version = get_environment_commit.sh

## Format

The environment.conf file uses the same INI-like format as puppet.conf, with one exception: it cannot contain config sections like `[main]`. All settings in environment.conf must be outside any config section.

## Allowed Settings

In this version of Puppet, the environment.conf file is only allowed to override three settings:

* [`modulepath`][modulepath]
* [`manifest`][manifest]
* [`config_version`][config_version]

Setting `modulepath` lets you remove module directories inherited from the `basemodulepath` setting, or add additional global directories for only certain environments. Setting `manifest` lets you use something other than the environment-specific `manifests` directory as the site manifest; you can even use a global manifest for all environments.

## Relative Paths in Values

All of the allowed settings accept file paths or lists of paths as their values.

If any of these paths are **relative paths** --- that is, they start _without_ a leading slash or drive letter --- they will be resolved relative to that environment's main directory.

In the example above, the `modulepath = modules` line would resolve to `modulepath = /etc/puppetlabs/puppet/environments/test/modules`. Likewise, `config_version = get_environment_commit.sh` in that environment will be interpreted as `config_version = /etc/puppetlabs/puppet/environments/test/get_environment_commit.sh`
