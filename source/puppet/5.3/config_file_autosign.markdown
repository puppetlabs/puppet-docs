---
layout: default
title: "Config files: autosign.conf"
---

[autosigning]: ./ssl_autosign.html
[autosign setting]: ./configuration.html#autosign
[confdir]: ./dirs_confdir.html

The `autosign.conf` file can allow certain certificate requests to be automatically signed. It is only valid on the CA Puppet master server; a Puppet master not serving as a CA does not use `autosign.conf`.

## More about autosigning

> **Warning:** Since any host can request any certname, autosigning with `autosign.conf` is essentially **insecure**.

Puppet also provides a policy-based autosigning interface using custom policy executables, which can be more flexible and secure than the `autosign.conf` whitelist but more complex to configure.

For more information, see [the documentation about certificate autosigning][autosigning].

## Location

The `autosign.conf` file is located at `$confdir/autosign.conf` by default. To change this path, configure the [`autosign` setting][autosign setting] in `puppet.conf` or as a command-line flag.

The default `confdir` path depends on your operating system. [See the confdir documentation for more information.][confdir]

## Format

The `autosign.conf` file is a line-separated list of certnames or domain name globs. Each line represents a node name or group of node names whose certificate requests that the CA Puppet master should automatically sign upon receipt.

    rebuilt.example.com
    *.scratch.example.com
    *.local

Domain name globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully qualified domain name (FQDN). If your certnames don't look like FQDNs, the `autosign.conf` whitelist might not be effective.
