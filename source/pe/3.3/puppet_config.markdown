---
layout: default
title: "PE 3.3 » Puppet Core » Configuring"
subtitle: "Configuring Puppet Core"
canonical: "/pe/latest/puppet_config.html"
---

## Configuration Files

All of puppet's configuration files can be found in `/etc/puppetlabs/puppet/` on *nix systems. On Windows, you can find them in Puppet's data directory.

## References

- For an exhaustive description of puppet's configuration settings and auxiliary configuration files, refer to the [Configuring Puppet Guide](/puppet/3.6/reference/config_about_settings.html).
- For details, syntax and options for the available configuration settings, visit the [configuration reference](/puppet/3.4/reference/configuration.html).
- For details on how to configure access to Puppet's pseudo-RESTful HTTP API, refer to the [Access Control Guide](/guides/rest_auth_conf.html).

    > **Note:** If you haven't modified the `auth.conf` file, it may occasionally be modified when upgrading between Puppet Enterprise versions. However, if you HAVE modified it, the upgrader will not automatically overwrite your changes, and you may need to manually update `auth.conf` to accomodate new Puppet Enterprise features. Be sure to read the upgrade notes when upgrading your puppet master to new versions of PE.

## Configuring Hiera

Puppet in PE includes full Hiera support, including automatic class parameter lookup.

* The `hiera.yaml` file is located at `/etc/puppetlabs/puppet/hiera.yaml` on the puppet master server.
* [See the Hiera documentation for details about the `hiera.yaml` config file format](/hiera/1/configuring.html).
* To use Hiera with Puppet Enterprise, you must, at minimum, edit `hiera.yaml` to set a `:datadir` for the `:yaml` backend, ensure that the [hierarchy](/hiera/1/hierarchy.html) is a good fit for your deployment, and [create data source files](/hiera/1/data_sources.html) in the data directory.

To learn more about using Hiera, see [the Hiera documentation](/hiera/1).

## Disabling Update Checking

When the puppet master's web server (`pe-httpd`) starts or restarts, it checks for updates. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

* the IP address of the client
* the type and version of the client's OS
* the installed version of PE

If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to add the following line to the `/etc/puppetlabs/installer/answers.install` file:

    q_pe_check_for_updates=n

Keep in mind that if you delete the `/etc/puppetlabs/installer/answers.install` file, update checking will resume.


* * *

- [Next: Troubleshooting Puppet](./trouble_puppet.html)



