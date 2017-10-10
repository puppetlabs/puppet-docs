---
layout: default
title: "Config Files: hiera.yaml"
canonical: "/puppet/latest/config_file_hiera.html"
---

[hiera]: {{hiera}}/
[hiera_config]: ./configuration.html#hieraconfig

The `hiera.yaml` file is used to configure [Hiera][], which Puppet can use to look up data.

## Location

The `hiera.yaml` file is located at `$codedir/hiera.yaml` by default. Its location is configurable with the [`hiera_config` setting][hiera_config].

When Puppet loads Hiera, it will use its own Hiera config file instead of the global one (which is usually located at `/etc/hiera.yaml`). If needed, you can point the `hiera_config` setting at the global Hiera config.

The location of the `codedir` depends on your OS. [See the codedir documentation for details.][codedir]

[codedir]: ./dirs_codedir.html


## Example

    ---
    :backends:
      - yaml
      - json
    :yaml:
      :datadir: /etc/puppetlabs/code/hieradata
    :json:
      :datadir: /etc/puppetlabs/code/hieradata
    :hierarchy:
      - "%{clientcert}"
      - "%{datacenter}"
      - "%{osfamily}"
      - common

## Format

**[See the Hiera documentation for full details about the `hiera.yaml` file]({{hiera}}/configuring.html).**
