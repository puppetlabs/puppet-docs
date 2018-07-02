---
layout: default
title: "Config Files: autosign.conf"
canonical: "/puppet/latest/reference/config_file_autosign.html"
---

[autosigning]: ./ssl_autosign.html
[autosign]: ./configuration.html#autosign

The `autosign.conf` file can allow certain certificate requests to be automatically signed. It is only valid on the CA Puppet master server; a Puppet master that is not serving as a CA will not consult `autosign.conf`.

## More About Autosigning

Puppet also provides a policy-based interface for autosigning, which can be more flexible and secure. The `autosign.conf` file is the simpler and less secure method.

For more details, see [the reference page about certificate autosigning][autosigning].

## Location

The `autosign.conf` file is located at `$confdir/autosign.conf` by default. Its location is configurable with the [`autosign` setting][autosign].

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Format

The `autosign.conf` file is a list of certnames or domain name globs (one per line). Each line represents a node name or group of node names whose certificate requests should be automatically signed when the CA Puppet master receives them.

    rebuilt.example.com
    *.scratch.example.com
    *.local

Note that domain name globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully-qualified domain name. (That is, if your certnames don't look like FQDNs, you can't use `autosign.conf` to full effect.

**Note:** Since any host can request any certname, autosigning with `autosign.conf` is essentially insecure. See [the reference page about certificate autosigning][autosigning] for more context.

