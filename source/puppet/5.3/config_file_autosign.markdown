---
layout: default
title: "Config files: autosign.conf"
---

[autosigning]: ./ssl_autosign.html
[autosign setting]: ./configuration.html#autosign
[confdir]: ./dirs_confdir.html

The `autosign.conf` file can allow certain certificate requests to be automatically signed. It is only valid on the CA Puppet master server; a Puppet master not serving as a CA does not use `autosign.conf`.

## More about autosigning

> **Warning:** Because any host can provide any certname when requesting a certificate, basic autosigning is essentially **insecure**. Use it only when you fully trust any computer capable of connecting to the Puppet master.

Puppet also provides a policy-based autosigning interface using custom policy executables, which can be more flexible and secure than the `autosign.conf` whitelist but more complex to configure.

For more information, see [the documentation about certificate autosigning][autosigning].

## Location

Puppet looks for `autosign.conf` at `$confdir/autosign.conf` by default. To change this path, configure the [`autosign` setting][autosign setting] in the `[master]` section of `puppet.conf`.

The default `confdir` path depends on your operating system. [See the confdir documentation for more information.][confdir]

> **Note:** The `autosign.conf` file must not be executable by the Puppet master's user account. If the `autosign` setting points to an executable file, Puppet instead treats it like a custom policy executable even if it contains a valid `autosign.conf` whitelist.

## Format

The `autosign.conf` file is a line-separated list of certnames or domain name globs. Each line represents a node name or group of node names for which the CA Puppet master will automatically sign certificate requests.

```
rebuilt.example.com
*.scratch.example.com
*.local
```

Domain name globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully qualified domain name (FQDN). If your certnames don't look like FQDNs, the `autosign.conf` whitelist might not be effective.

> **Note:** The `autosign.conf` file can safely be an empty file or not-existent, even if the `autosign` setting is enabled. An empty or non-existent `autosign.conf` file is an empty whitelist, meaning that Puppet does not autosign any requests. If you create `autosign.conf` as a non-executable file and add certnames to it, Puppet then automatically uses the file to whitelist incoming requests without needing to modify `puppet.conf`.
>
> To _explicitly_ disable autosigning, set `autosign = false` in the `[master]` section of the CA Puppet master's `puppet.conf`, which disables CA autosigning even if `autosign.conf` or a custom policy executable exists.
