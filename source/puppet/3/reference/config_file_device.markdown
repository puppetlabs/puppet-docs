---
layout: default
title: "Config Files: device.conf"
---

[deviceconfig]: /references/3.stable/configuration.html#deviceconfig

The puppet device subcommand, added in Puppet 2.7, configures network hardware using a catalog downloaded from the puppet master; in order to function, it requires that the relevant devices be configured.

## Location

The `device.conf` file is located at `$confdir/device.conf` by default. Its location is configurable with the [`deviceconfig` setting][deviceconfig].

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Format

`device.conf` is organized in INI-like blocks, with one block per device:

    [router6.example.com]
        type cisco
        url ssh://admin:password@ef03c87a.local

The name of each block should be the name that will be used with puppet device to access the device.

The body of the block should contain a `type` directive (the only current valid value is `cisco`) and a `url` directive (which should be an SSH URL to the device's management interface).

