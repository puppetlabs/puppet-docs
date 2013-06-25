---
layout: default
title: "PE 3.0 » Puppet Core » Configuring"
subtitle: "Configuring Puppet Core"
---

## Configuration Files

All of puppet's configuration files can be found in `/etc/puppetlabs/puppet/` on *nix systems. On Windows, you can find them in [Puppet's data directory](http://docs.puppetlabs.com/windows/installing.html#data-directory).

## References

- For an exhaustive description of puppet's configuration settings and auxiliary configuration files, refer to the [Configuring Puppet Guide](http://docs.puppetlabs.com/guides/configuring.html).
- For details, syntax and options for the available configuration settings, visit the [configuration reference](http://docs.puppetlabs.com/references/3.2.latest/configuration.html).
- For details on how to configure access to Puppet's pseudo-RESTful HTTP API, refer to the [Access Control Guide](http://docs.puppetlabs.com/guides/rest_auth_conf.html).

    > **Note:** If you haven't modified the `auth.conf` file, it may occasionally be modified when upgrading between Puppet Enterprise versions. However, if you HAVE modified it, the upgrader will not automatically overwrite your changes, and you may need to manually update `auth.conf` to accomodate new Puppet Enterprise features. Be sure to read the upgrade notes when upgrading your puppet master to new versions of PE.

## Configuring Hiera

Puppet in PE includes full Hiera support, including automatic class parameter lookup.

* The `hiera.yaml` file is located at `/etc/puppetlabs/puppet/hiera.yaml` on the puppet master server.
* [See the Hiera documentation for details about the `hiera.yaml` config file format](/hiera/1/configuring.html).
* To use Hiera with Puppet Enterprise, you must, at minimum, edit `hiera.yaml` to set a `:datadir` for the `:yaml` backend, ensure that the [hierarchy](/hiera/1/hierarchy.html) is a good fit for your deployment, and [create data source files](/hiera/1/data_sources.html) in the data directory.

To learn more about using Hiera, see [the Hiera documentation](/hiera/1).

* * *

- [Next: Orchestration Overview](./orchestration_overview.html)



