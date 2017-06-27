---
layout: default
title: "Deprecated language features"
---

These features of the Puppet language are deprecated in Puppet 5.0.

## Hiera 3.x features

[hiera_functions]: ./hiera_use_hiera_functions.html
[v3]: ./hiera_config_yaml_3.html
[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html
[custom_backend]: ./hiera_custom_backends.html
[merging]: ./hiera_merging.html
[module layer]: ./hiera_layers.html#the-module-layer
[lookup_function]: ./hiera_migrate_functions.html
[lookup_command]: ./man/lookup.html
[backend_3]: {{hiera}}/custom_backends.html

These Hiera features are deprecated, because we replaced them with improved equivalents in [Hiera 5](./hiera_intro.html).

Old feature | Replacement
------------|------------
The [classic `hiera_*` functions][hiera_functions].         | [The `lookup` function][lookup_function].
The `hiera` command line tool.                              | [The `puppet lookup` command][lookup_command].
[Version 3][v3] and [version 4][v4] of the hiera.yaml file. | [Version 5][v5].
[Hiera 3 custom backends][backend_3].                       | [Hiera 5 custom backends][custom_backend].
Setting a global hash merge behavior in hiera.yaml.         | [Per-key and per-lookup merge behavior][merging].
The `calling_module`, `calling_class`, and `calling_class_path` pseudo-variables. | [The module data layer][module layer].

## Non-strict variables

By default, you can access the value of a variable that was never assigned. The value of an unassigned variable is `undef`.

If you set the `strict_variables` setting to `true`, Puppet raises an error if you try to access an unassigned variable.

**To update:** Enable `strict_variables` on your Puppet master, run as normal, and look for compilation errors.

## Automatic symbolic links for `ensure` values in `file` resources

Puppet doesn't validate the value of the [`ensure` attribute in `file` resources](/puppet/latest/reference/type.html#file-attribute-ensure). If the value is not `present`, `absent`, `file`, `directory`, or `link`, Puppet treats the value as an arbitrary path and creates a symbolic link to that path.

For example, these resource declarations are equivalent:

``` puppet
file { "/etc/inetd.conf":
  ensure => link,
  target => "/etc/inet/inetd.conf",
}

file { "/etc/inetd.conf":
  ensure => "/etc/inet/inetd.conf",
}
```

However, syntax errors in the `ensure` attribute's value can lead to unexpected behaviors. For instance, mistyping a value can lead Puppet to create a symbolic link that treats the typo as the link's target:

``` puppet
file { "/etc/inetd.conf":
  ensure => filer,
}
```

The above example results in Puppet creating a symbolic link at `/etc/inetd.conf` that points to `filer`---it doesn't throw an error or produce a warning.

``` bash
$ sudo /opt/puppetlabs/bin/puppet apply -e 'file { "/etc/inetd.conf": ensure => filer}'
Notice: Compiled catalog for master.example.com in environment production in 1.18 seconds
Notice: /Stage[main]/Main/File[/etc/filer]/ensure: created
Notice: Applied catalog in 0.49 seconds

$ sudo ls -la /etc/inetd.conf
lrwxrwxrwx 1 root root 10 Nov  9 20:53 /etc/inetd.conf -> filer
```

**To update:** Confirm that the `ensure` attribute of your `file` resources has one of its allowed values. If you rely on this implicit symlinking behavior, change the value of `ensure` to `link` and add a `target` attribute that contains the target path as its value.
