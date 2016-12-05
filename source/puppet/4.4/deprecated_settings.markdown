---
layout: default
title: "Deprecated Settings"
---


The following Puppet settings are deprecated and will be removed in Puppet 5.0.

## The legacy `auth.conf` file

[legacy_auth]: ./config_file_auth.html
[new_auth]: {{puppetserver}}/config_file_auth.html

Puppet Server 2.2 and higher use a [new, HOCON-based `auth.conf` file][new_auth], which is a full replacement for the [old `auth.conf` format][legacy_auth]. The old file will be removed in Puppet 5.0 (and the Puppet Server version that supports it). Puppet Server's old `client-whitelist` settings for the `/puppet-ca/v1/certificate_status` and `/puppet-admin-api` endpoints will be removed at the same time.

* The [new `auth.conf` file][new_auth] is located at `/etc/puppetlabs/puppetserver/conf.d/auth.conf`.
* The [old `auth.conf` file][legacy_auth] is located at `$confdir/auth.conf`.

## Authorization rules in `fileserver.conf`

[fileserver.conf]: ./config_file_fileserver.html

Before `auth.conf` existed, [`fileserver.conf`][fileserver.conf] let you specify authorization rules for the file server on a per-mountpoint basis. After authorization was centralized, this was redundant; all authorization rules should go in `auth.conf` (new style).

In Puppet 5.0 (and the Puppet Server version that supports it), "allow" and "deny" rules in `fileserver.conf` will not be allowed.

## `cfacter`

The `cfacter` setting was used to enable pre-releases of native Facter (distributed as the "cfacter" package) prior to the release of Facter 3.0. Now that native Facter is the default in puppet-agent packages, this setting has no purpose.

## `configtimeout`

The `configtimeout` setting mashed the connect and read timeouts together, and could cause erroneous timeouts if everything was working fine but Puppet was transferring a very large file.

It's been replaced by two new settings:

* [`http_connect_timeout`](./configuration.html#httpconnecttimeout) --- controls how long Puppet should attempt to make a connection. A short timeout for this is sensible, since an over-long connect time usually means something's wrong.
* [`http_read_timeout`](./configuration.html#httpreadtimeout) --- controls how long Puppet should allow transfers to continue. It's normal to let this last a long time or be infinite, since some things just take a while to compile or download.

The old `configtimeout` setting now logs a deprecation warning if it's set, and will be removed in Puppet 5.0.

## `ignorecache`

The `ignorecache` setting has no effect, and has been dead code since Puppet 0.24.5.

This setting does not log a deprecation warning. Once it is removed in Puppet 5.0, Puppet will fail to start if you pass `--ignorecache` as a command line argument.
