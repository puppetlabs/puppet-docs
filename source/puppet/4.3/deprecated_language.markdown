---
layout: default
title: "Deprecated Language Features"
---

The following features of the Puppet language are deprecated, and will be removed in Puppet 5.0.

## Non-Strict Variables

#### Now

By default, you can access the value of a variable that was never assigned. The value of an unassigned variable is `undef`.

If you set the `strict_variables` setting to true, Puppet will instead raise an error if you try to access an unassigned variable.

#### Detecting and Updating

Enable `strict_variables` on your Puppet master, run as normal for a while, and look for compilation errors.

## Automatic Symbolic Links for `ensure` Values in `file` Resources

#### Now

Puppet doesn't validate the value of the [`ensure` attribute in `file` resources](/puppet/latest/type.html#file-attribute-ensure). If the value is not `present`, `absent`, `file`, `directory`, or `link`, Puppet treats the value as an arbitrary path and creates a symbolic link to that path.

For example, these resource declarations are equivalent:

~~~ puppet
file { "/etc/inetd.conf":
  ensure => link,
  target => "/etc/inet/inetd.conf",
}

file { "/etc/inetd.conf":
  ensure => "/etc/inet/inetd.conf",
}
~~~

However, syntax errors in the `ensure` attribute's value can lead to unexpected behaviors. For instance, mistyping a value can lead Puppet to create a symbolic link that treats the typo as the link's target:

~~~ puppet
file { "/etc/inetd.conf":
  ensure => filer,
}
~~~

The above example results in Puppet creating a symbolic link at `/etc/inetd.conf` that points to `filer`---it doesn't throw an error or produce a warning.

~~~ bash
$ sudo /opt/puppetlabs/bin/puppet apply -e 'file { "/etc/inetd.conf": ensure => filer}'
Notice: Compiled catalog for master.example.com in environment production in 1.18 seconds
Notice: /Stage[main]/Main/File[/etc/filer]/ensure: created
Notice: Applied catalog in 0.49 seconds

$ sudo ls -la /etc/inetd.conf
lrwxrwxrwx 1 root root 10 Nov  9 20:53 /etc/inetd.conf -> filer
~~~

#### In Puppet 5.0

This behavior will be removed. If the value of `ensure` isn't one of its allowed values, the Puppet run will fail with an error instead of attempting to create a symlink.

#### Detecting and Updating

Confirm that the `ensure` attribute of your `file` resources has one of its allowed values. If you rely on this implicit symlinking behavior, change the value of `ensure` to `link` and add a `target` attribute that contains the target path as its value.