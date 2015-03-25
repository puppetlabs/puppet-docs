---
layout: default
title: "PE 3.7 » Puppet Core » Configuring"
subtitle: "Configuring Puppet Core"
canonical: "/pe/latest/puppet_config.html"
---

### Configuration Files

All of puppet's configuration files can be found in `/etc/puppetlabs/puppet/` on *nix systems. On Windows, you can find them in [Puppet's data directory](/guides/install_puppet/install_windows.html#data-directory).

### References

- For an exhaustive description of puppet's configuration settings and auxiliary configuration files, refer to the [Configuring Puppet Guide](/guides/configuring.html).
- For details, syntax and options for the available configuration settings, visit the [configuration reference](/references/3.7.latest/configuration.html).
- For details on how to configure access to Puppet's pseudo-RESTful HTTP API, refer to the [Access Control Guide](/guides/rest_auth_conf.html).

    > **Note:** If you haven't modified the `auth.conf` file, it may occasionally be modified when upgrading between Puppet Enterprise versions. However, if you HAVE modified it, the upgrader will not automatically overwrite your changes, and you may need to manually update `auth.conf` to accomodate new Puppet Enterprise features. Be sure to read the upgrade notes when upgrading your Puppet master to new versions of PE.

### Configuring Hiera

Puppet in PE includes full Hiera support, including automatic class parameter lookup.

* The `hiera.yaml` file is located at `/etc/puppetlabs/puppet/hiera.yaml` on the Puppet master server.
* [See the Hiera documentation for details about the `hiera.yaml` config file format](/hiera/1/configuring.html).
* To use Hiera with Puppet Enterprise, you must, at minimum, edit `hiera.yaml` to set a `:datadir` for the `:yaml` backend, ensure that the [hierarchy](/hiera/1/hierarchy.html) is a good fit for your deployment, and [create data source files](/hiera/1/data_sources.html) in the data directory.

To learn more about using Hiera, see [the Hiera documentation](/hiera/1).

### Disabling Update Checking

When the Puppet master's web server (`pe-puppetserver`) starts or restarts, it checks for updates. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

* the IP address of the client
* the type and version of the client's OS
* the installed version of PE

There are two methods to disable update checking (e.g. if your company policy forbids transmitting this information), one of which is specific to platforms using systemd (currently RHEL-7 and SLES-12 only).

* If your platform **DOES NOT** use systemd, you can disable update checks by adding the following line to the `/etc/puppetlabs/installer/answers.install` file:

    `q_pe_check_for_updates=n`

   **Note**: if you delete the `/etc/puppetlabs/installer/answers.install` file, update checking will resume.

* If your platform uses systemd, you can disable updates by creating the following file:

    `/etc/puppetlabs/puppetserver/opt-out`
    
  As long as this file is present, Puppet Server will not check in for updates. (Note that this method will work on all platforms, not just those using systemd.)


* * *

- [Next: Troubleshooting Puppet](./trouble_puppet.html)



