---
layout: default
title: "Deprecated settings"
---
[fileserver.conf]: ./config_file_fileserver.html
[legacy_auth]: ./config_file_auth.html
[new_auth]: {{puppetserver}}/config_file_auth.html
[backend]: ./hiera_custom_backends.html

These Puppet settings are deprecated and will be removed in Puppet 5.0.

* Legacy `auth.conf` file
  Puppet Server 2.2 and newer use a [new, HOCON-based `auth.conf` file][new_auth], which is a full replacement for the [old `auth.conf` format][legacy_auth]. Support for the old file will be removed in Puppet 5.0 (and the Puppet Server version that supports it). Puppet Server's old `client-whitelist` settings for the `/puppet-ca/v1/certificate_status` and `/puppet-admin-api` endpoints will be removed at the same time.

* The [new `auth.conf` file][new_auth] is located in `/etc/puppetlabs/puppetserver/conf.d/auth.conf`.
* The [old `auth.conf` file][legacy_auth] is located in `$confdir/auth.conf`.

* Authorization rules in `fileserver.conf`
  Before `auth.conf` existed, [`fileserver.conf`][fileserver.conf] let you specify authorization rules for the file server on a per-mountpoint basis. After authorization was centralized, this was redundant; all authorization rules should go in `auth.conf` (new style).

  In Puppet 5.0 and the Puppet Server version that supports it, "allow" and "deny" rules in `fileserver.conf` will not be allowed.

* `cfacter`
  The `cfacter` setting was used to enable pre-releases of native Facter (distributed as the "cfacter" package) prior to the release of Facter 3.0. Now that native Facter is the default in `puppet-agent` packages, this setting has no purpose.

* `configtimeout`

  The `configtimeout` setting combined the connect and read timeouts, which could cause erroneous timeouts if everything was working fine but Puppet was transferring a very large file. The old `configtimeout` setting now logs a deprecation warning if it's set, and will be removed in Puppet 5.0.

  It has been replaced by two new settings:

  * [`http_connect_timeout`](./configuration.html#httpconnecttimeout) --- controls how long Puppet should attempt to make a connection. A short timeout for this is sensible, since an over-long connect time usually means something's wrong.
  * [`http_read_timeout`](./configuration.html#httpreadtimeout) --- controls how long Puppet should allow transfers to continue. It's normal to let this last a long time or be infinite, since some things just take a while to compile or download.

* `data_binding_terminus`

  When [automatic class parameter lookup](./hiera_automatic.html) was still young, we included the option to replace Hiera with an alternate data backend, using the `data_binding_terminus` setting.

  But data binding termini were a really hairy extension point, and Hiera 5's [improved custom backend system][backend] makes them unnecessary. Setting `data_binding_terminus` to anything but `hiera` is now deprecated, and the setting will be removed in Puppet 6.

  * If you're using a custom `data_binding_terminus`, rewrite it as a [custom Hiera 5 backend][backend]. You're already an advanced Puppet hacker if you managed to build one of these in the first place, so you can probably write an equivalent Hiera 5 backend in an afternoon or two. We hope you enjoy this improved interface!
  * If you were disabling automatic class parameter lookup (`data_binding_terminus = none`), you can't do that anymore. Module authors are relying on it for default data these days.

* `ignorecache`

  The `ignorecache` setting has no effect, and has been dead code since Puppet 0.24.5.

  This setting does not log a deprecation warning. Once it is removed in Puppet 5.0, Puppet fails to start if you pass `--ignorecache` as a command line argument.

* `pluginsync`
  For all practical purposes, `pluginsync = true` (the default value) is mandatory for all Puppet users. If pluginsync is disabled, it becomes difficult or impossible to use custom facts, custom resource types, and custom providers, all of which are crucial parts of the Puppet ecosystem.

  Since disabling it is catastrophic and has no particular benefit, we plan to remove the option to do so in Puppet 5.0.
