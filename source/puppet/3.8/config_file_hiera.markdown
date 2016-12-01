---
layout: default
title: "Config Files: hiera.yaml"
canonical: "/puppet/latest/reference/config_file_hiera.html"
---

[hiera]: {{hiera}}/
[hiera_config]: ./configuration.html#hieraconfig

The `hiera.yaml` file is used to configure [Hiera][], which Puppet can use to look up data.

## Location

The `hiera.yaml` file is located at `$confdir/hiera.yaml` by default. Its location is configurable with the [`hiera_config` setting][hiera_config].

When Puppet loads Hiera, it will use its own Hiera config file instead of the global one (which is usually located at `/etc/hiera.yaml`). If needed, you can point the `hiera_config` setting at the global Hiera config.

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html


## Example

    ---
    :backends:
      - yaml
      - json
    :yaml:
      :datadir: /etc/puppet/hieradata
    :json:
      :datadir: /etc/puppet/hieradata
    :hierarchy:
      - "%{clientcert}"
      - "%{datacenter}"
      - "%{osfamily}"
      - common

## Format

**[See the Hiera documentation for full details about the `hiera.yaml` file]({{hiera}}/configuring.html).**
