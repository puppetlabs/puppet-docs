---
layout: default
title: "Deprecated language features"
---

The following features of the Puppet language are deprecated, and will be removed in Puppet 5.0.

## Non-strict variables

By default, you can access the value of a variable that was never assigned. The value of an unassigned variable is `undef`.

If you set the `strict_variables` setting to true, Puppet will instead raise an error if you try to access an unassigned variable.

#### Detecting and updating

Enable `strict_variables` on your Puppet master, run as normal for a while, and look for compilation errors.

## Automatic symbolic links for `ensure` values in `file` resources

#### Now

Puppet doesn't validate the value of the [`ensure` attribute in `file` resources](/puppet/latest/type.html#file-attribute-ensure). If the value is not `present`, `absent`, `file`, `directory`, or `link`, Puppet treats the value as an arbitrary path and creates a symbolic link to that path.

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

To update, confirm that the `ensure` attribute of your `file` resources has one of its allowed values. If you rely on this implicit symlinking behavior, change the value of `ensure` to `link` and add a `target` attribute that contains the target path as its value.

Likewise, using the `source` parameter with `ensure => link` can result in unexpected behavior, depending on the content of the `source` parameter's value. The result of this example is a regular file --- not a symlink --- being created at `/etc/inetd.conf` with the copied contents of `/tmp/inetd.conf`:

``` puppet
file { "/etc/inetd.conf":
  ensure => link,
  links  => manage,
  source => "file:///tmp/inetd.conf",
}
```

Alternatively, this example creates a broken symlink --- not a file --- to whatever path `inetd_file` points to on the Puppet master, but only if a file doesn't exist at the same path on the agent:

``` puppet
file { "/etc/inetd.conf":
  ensure => link,
  links  => manage,
  source => 'puppet:///modules/inetd/inetd_file',
}
```

These behaviors should not be allowed; `ensure => link` and `source` should be mutually exclusive.

For details and examples of more deprecated symlink behavior, see JIRA ticket [PUP-5830](https://tickets.puppetlabs.com/browse/PUP-5830).