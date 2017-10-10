---
layout: default
title: "Config Files: device.conf"
canonical: "/puppet/latest/config_file_device.html"
---

[deviceconfig]: ./configuration.html#deviceconfig

The Puppet device subcommand configures network hardware using a catalog downloaded from the Puppet master; in order to function, it requires that the relevant devices be configured.

## Location

The `device.conf` file is located at `$confdir/device.conf` by default. Its location is configurable with the [`deviceconfig` setting][deviceconfig].

The location of the `confdir` depends on your OS. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Format

`device.conf` is organized in INI-like sections, with one section per device:

    [router6.example.com]
        type cisco
        url ssh://admin:password@ef03c87a.local

The name of each section should be the name that will be used with Puppet device to access the device.

The body of the section should contain a `type` directive (the only current valid value is `cisco`) and a `url` directive (which should be an SSH URL to the device's management interface).

