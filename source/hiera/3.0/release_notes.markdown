---
layout: default
title: "Hiera 3: Release Notes"
---


## Hiera 3.0.3 and 3.0.2

Hiera 3.0.3 has no functional differences from 3.0.1, but we needed to increase the version number for testing and packaging purposes.

Hiera 3.0.2 was never released.

## Hiera 3.0.1

Released June 24, 2015.

Shipped in puppet-agent version: 1.2.0.

Hiera 3.0 changes the default values for the `:hierarchy` and `:datadir` settings. It contains no new features and no other changes, but because there was a small chance of changed behavior for existing installations, it received a new semver major version.

### BREAK: New Default `:hierarchy`

Previously, if you didn't specify a value for the `:hierarchy` setting in hiera.yaml, your hierarchy would only contain one static data source (`"common"`). Now, the first level of the hierarchy will be linked to each Puppet node's verified certname. Hiera will still fall back to `"common"` if there isn't a data source for a given node.

The new default hierarchy is:

~~~ yaml
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - "common"
~~~

This should make Hiera more useful out of the box.

* [HI-374](https://tickets.puppetlabs.com/browse/HI-374)
* [HI-397](https://tickets.puppetlabs.com/browse/HI-397)

### BREAK: New Default `:datadir`

The YAML and JSON backends both have a `:datadir` setting which controls where the data files are stored.

Previously, if you didn't specify a `:datadir` value for either of these backends, Hiera would use `$codedir/hieradata` ([more on Puppet's codedir](/puppet/latest/reference/dirs_codedir.html)), with a single data directory for all environments. Now, if `:datadir` is unspecified, Hiera will use a different data directory for each environment, using Puppet's default environments directory. You can find each environment's Hiera data at `$codedir/environments/<ENVIRONMENT>/hieradata`.

The new default data directory is:

~~~ yaml
:yaml:
  # on *nix:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
  # on Windows:
  :datadir: "C:\ProgramData\PuppetLabs\code\environments\%{environment}\hieradata"
~~~

* [HI-374](https://tickets.puppetlabs.com/browse/HI-374)

## Hiera 3.0.0

Hiera 3.0.0 was never released; we discovered a release-blocking oversight after the release had been tagged but before packages had been built.
