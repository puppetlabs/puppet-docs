---
layout: default
title: "PE 3.0 » Puppet Core » Configuring"
subtitle: "Configuring Puppet Core"
---

### Configuration Files
All of puppet's configuration files can be found in `/etc/puppetlabs/puppet/` on *nix systems. On Windows, you can find them in [Puppet's data directory](http://docs.puppetlabs.com/windows/installing.html#data-directory).

### References
- For an exhaustive description of puppet's configuration settings and auxiliary configuration files, refer to the [Configuring Puppet Guide](http://docs.puppetlabs.com/guides/configuring.html).

- For details, syntax and options for the available configuration settings, visit the [configuration reference](http://docs.puppetlabs.com/references/3.2.latest/configuration.html).

- For details on how to configure access to Puppet's pseudo-RESTful HTTP API, refer to the [Access Control Guide](http://docs.puppetlabs.com/guides/rest_auth_conf.html). Note that the `auth.conf` file is controlled by Puppet and can be over-written during installation, so if you have made any custom modifications, you will want to check them against any newly installed version of the file.


* * * 

- [Next: Orchestration Overview](./orchestration_overview.html)



