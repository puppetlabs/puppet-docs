---
layout: default
title: "Puppet 4.0 Preview: Where'd Everything Go?"
---

We moved everything around.

Reasons:

- Unify Puppet Enterprise and open source Puppet
- Make everything more predictable --- puppet, puppetserver, puppetdb all configured under /etc/puppetlabs/
- Move to omnibus packaging for Puppet, to end Ruby incompatibilities and make it easier than ever to use

There's a spec listing ALL of these changes, it's here: https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md

Highlights:

## New `codedir` directory

\*nix: `/etc/puppetlabs/code`
Windows: `C:\ProgramData\PuppetLabs\code`
Configurable with `codedir` setting

Contains all the content you use to actually configure your systems: modules, manifests, hiera data.

## Everything is in environments now

directory environments are always enabled, and the default environment is at /etc/puppetlabs/code/environment/production. Put your modules and manifests here if you're not using multiple environments.

There's still an /etc/puppetlabs/code/modules directory, but you should only use it for modules you want in **all** environments. Always default to putting it in production instead.

hiera.yaml is at /etc/puppetlabs/code/hiera.yaml, still configurable with `hiera_config` setting

hiera data is at /etc/puppetlabs/code/hieradata, still configurable in hiera.yaml.

## `confdir` has moved (on \*nix)

\*nix: `/etc/puppetlabs/puppet`
Windows: `C:\ProgramData\PuppetLabs\puppet\etc`
Configurable with `--confdir` on command line

Contains all config files for puppet, many of which are also used by puppetserver.

## Agent `vardir` has moved (on \*nix)

\*nix: `/opt/puppetlabs/puppet/cache`
Windows: `C:\ProgramData\PuppetLabs\puppet\cache`
Configurable with `--vardir` on command line

And it's separate from puppetserver's server vardir. This helps stability and predictability.

## `rundir` has moved

/var/run/puppetlabs for puppet

/var/run/puppetlabs/puppetserver for Puppet Server

## Puppet Server config dir has moved

/etc/puppetlabs/puppetserver
    /conf.d/
    /<other files>

