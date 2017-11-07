---
layout: default
title: "Config files: device.conf"
---

[puppet-device]: ./man/device.html
[deviceconfig]: ./configuration.html#deviceconfig
[confdir]: ./dirs_confdir.html

The `puppet-device` subcommand retrieves catalogs from the Puppet master and applies them to remote devices.
Devices to be managed by the `puppet-device` subcommand are configured in `device.conf`.

[See the puppet-device documentation for details.][puppet-device]

## Location

The `device.conf` file is located at `$confdir/device.conf` by default,
and its location is configurable with the [`deviceconfig`][deviceconfig] setting.

The location of `confdir` depends on your operating system.
[See the confdir documentation for details.][confdir]

## Format

The `device.conf` file is an INI-like file, with one section per device:

    [device001.example.com]
    type cisco
    url ssh://admin:password@device001.example.com
    debug

The section name specifies the `certname` of the device.

The values for the `type` and `url` properties are specific to each type of device.

The the optional `debug` property specifies transport-level debugging, 
and is limited to telnet and ssh transports.


For Cisco devices, the `url` is in the following format:

    scheme://user:password@hostname/query

with:

* scheme: either `ssh` or `telnet`

* user: optional connection username, depending on the device configuration

* password: connection password

* query: optional `?enable=` parameter whose value is the enable password

