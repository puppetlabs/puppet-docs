---
title: "Resource tips and examples: Augeas"
---



[Augeas](http://augeas.net/index.html) is a lovely tool that treats
config files (well, anything really, but it's mostly about config
files) as trees of values. You then modify the tree as you like,
and write the file back.

For example, the "PermitRootLogin" setting in `sshd_config` can be referenced like this:

    $ augtool print /files/etc/ssh/sshd_config/PermitRootLogin
    /files/etc/ssh/sshd_config/PermitRootLogin = "yes"

And it can be modified:

    $ augtool
    augtool> set /files/etc/ssh/sshd_config/PermitRootLogin no
    augtool> save
    Saved 1 file(s)
    $ grep PermitRootLogin /etc/ssh/sshd_config
    PermitRootLogin no

This is basically the solution to the problem of dealing with
upstream configuration changes combined with local modifications:
you can allow the upstream changes through and then apply changes
with Augeas to the new version.

Assuming you want to work with Augeas, this is a description of how
to perform Augeas changes using Puppet. Augeas itself is included in the puppet-agent package, so you don't need to install any extra packages to use it. The command-line utility `augtool` will be used to demonstrate things here, but it is not required to use Augeas within Puppet. On most Linux distributions, `augtool` can be found in a separate package.

The basic usage for the Augeas resource type is in the [resource type reference](./types/augeas.html).

The somewhat more important, and unfortunately complicated, part is
figuring out what the tree for a file looks like so you can
manipulate it properly. The definition that Augeas uses to turn a
file into a tree is called a lens, and understanding the trees is
more difficult than it should be, because many lenses are not
documented sufficiently, or at all. The documentation for those
that are
[has its own surprisingly hard to find page](http://augeas.net/docs/lenses.html)
on the Augeas site. You can see what lenses are available by
looking in `/usr/share/augeas/lenses/` (or
`/usr/local/share/augeas/lenses/`, or possibly somewhere else,
depending on your setup).

You can see which files Augeas has successfully parsed by
running `augtool ls /files/` and drilling down from there. If a
file hasn't been properly parsed by Augeas, it simply won't
show up. This could mean that the file has a syntax error, the
file doesn't exist, you don't have permission to read the file,
or it could imply a failure in the lens itself.  To find the
reasons, run `augtool print /augeas//error`:

    $ augtool print /augeas//error
    /augeas/files/etc/ssh/sshd_config/error = "read_failed"
    /augeas/files/etc/ssh/sshd_config/error/message = "Permission denied"
    /augeas/files/etc/hosts.allow/error = "parse_failed"
    /augeas/files/etc/hosts.allow/error/pos = "371"
    /augeas/files/etc/hosts.allow/error/line = "12"
    /augeas/files/etc/hosts.allow/error/char = "0"
    /augeas/files/etc/hosts.allow/error/lens = "/usr/share/augeas/lenses/dist/hosts_access.aug:93.10-.46:"
    /augeas/files/etc/hosts.allow/error/message = "Iterated lens matched less than it should"

The first is a permissions error, the second is a parse error.  See the Augeas wiki page on [tracking down errors](https://github.com/hercules-team/augeas/wiki/Tracking-down-errors) for more information.

The easiest way to understand how Augeas handles a particular file is to examine it using `augtool ls` and/or `augtool print`. In fact, you might want to make your changes by hand in a text editor, then use `augtool print` to give you an idea what the final result should look like.

Here's an example of how to determine the tree structure of a file, in this case `/etc/exports`. This is based on examples from from the bottom of `man 5 exports`:

    $ augtool
    augtool> ls /files/etc/exports/
    comment[1] = /etc/exports: the access control list for filesystems which may be exported
    comment[2] = to NFS clients.  See exports(5).
    comment[3] = sample /etc/exports file
    dir[1]/ = /
    dir[2]/ = /projects
    dir[3]/ = /usr
    dir[4]/ = /home/joe

From here you can investigate the structure, like so:

    augtool> ls /files/etc/exports/dir[1]
    client[1]/ = master
    client[2]/ = trusty

The corresponding line in the file is:

    /   master(rw) trusty(rw,no_root_squash)

Digging further:

    augtool> ls /files/etc/exports/dir[1]/client[1]
    option = rw

So, to add a new entry, you'd do something like this:

    augtool> set /files/etc/exports/dir[last()+1] /foo
    augtool> set /files/etc/exports/dir[last()]/client weeble
    augtool> set /files/etc/exports/dir[last()]/client/option[1] ro
    augtool> set /files/etc/exports/dir[last()]/client/option[2] all_squash
    augtool> save
    Saved 1 file(s)

Which creates the line:

    /foo weeble(ro,all_squash)

Now that we've seen some examples in `augtool`, let's make the same changes using Puppet.

Here's the `sshd_config` example:

``` puppet
augeas { "sshd_config":
  changes => [
    "set /files/etc/ssh/sshd_config/PermitRootLogin no",
  ],
}
```

The Augeas resource in Puppet has a useful attribute called "context" which allows you to specify a root for all of your changes. This is especially nice when making many changes to the same file. The above could also be written like this:

``` puppet
augeas { "sshd_config":
  context => "/files/etc/ssh/sshd_config",
  changes => [
    "set PermitRootLogin no",
  ],
}
```

Note that values containing whitespace need to be quoted. In this example, we use single-quotes since the `set` statement itself is already enclosed in double-quotes. You could also do the opposite.

    "set kernel.sem '500 512000 64 1024'",

Here's the `/etc/exports` example:

``` puppet
augeas{ "export foo" :
  context => "/files/etc/exports",
  changes => [
    "set dir[last()+1] /foo",
    "set dir[last()]/client weeble",
    "set dir[last()]/client/option[1] ro",
    "set dir[last()]/client/option[2] all_squash",
  ],
}
```

This adds the line as described above. In fact, it works too well. **It will add the line every time Puppet runs.** This is one of the biggest gotchas to using Augeas in Puppet. It's very easy to create resources that repeat changes on every run. (Technically, it will stop when you run out of space on that filesystem.) In almost every case, if you use a path containing `last()`, you will also need to use the Augeas resource's "onlyif" attribute to keep it under control.

In the above example, you could add something like this:

``` puppet
onlyif => "match dir[. = '/foo'] size == 0",
```

Which essentially says "only add it if it's not already there". The problem with this approach is that it only considers one thing (the name of the export in this case). If you were to change something else like "client" later, it would never get applied because an entry named "/foo" is found. You can combine multiple tests into the "onlyif" attribute to look for changes in all the various components, but then you are practically defining the entire resource twice. There's a better way.

### A Better Way

In many cases, if you set a value for a non-existent path, Augeas will create the path for you. By using a more dynamic path to refer to things, you can make sure changes to any part of the tree will get applied, and you can do it without a messy "onlyif".

Since the share name is unique in `/etc/exports` you can use that to refer to a particular entry. In the example above, it would be `/files/etc/exports/dir[. = '/foo']`.

Here's an improved version of the example above:

``` puppet
augeas { "export foo":
  context => "/files/etc/exports",
  changes => [
    "set dir[. = '/foo'] /foo",
    "set dir[. = '/foo']/client weeble",
    "set dir[. = '/foo']/client/option[1] ro",
    "set dir[. = '/foo']/client/option[2] all_squash",
  ],
}
```

This has several advantages.

  * If the entry doesn't exist at all, it will get created.
  * If the entry already exists and you change any value, it will get updated.
  * The line won't be added to `/etc/exports` on every single Puppet run.
  * You don’t need to figure out an “onlyif” attribute to control Augeas because there is no “onlyif” attribute.

The next section examines this technique in detail.

### Paths for Numbered Items

Note: This is based on experience and trial & error, not some deep understanding of Augeas or studying of documentation, so terminology might not be 100% correct and there could be a better/simpler way, so always experiment on your own. You may want to look [this][pe] over, then come back here for some practical examples.

Changing things like `sshd_config` or Postfix's `main.cf` (where you have a series of simple key=value pairs) is pretty straightforward. Unfortunately, not every configuration item in a file has a unique "left hand side" to use in the path. In situations like this, Augeas will assign numbers to each item.

There are three ways things might get numbered. We'll show a working example for each (and some limitations).

1. The items themselves are numbers

        # augtool ls /files/etc/hosts
        1/ = (none)
        2/ = (none)

2. A simple array of items with the same name

        # augtool ls /files/etc/sudoers
        spec[1]/ = (none)
        spec[2]/ = (none)

3. An array of items with a value assigned

        # augtool ls /files/etc/exports
        dir[1]/ = /foo
        dir[2]/ = /bar

Starting with `/etc/hosts`, say you want to make sure the "localhost" entry also contains the system's current hostname and FQDN.

    augtool> ls /files/etc/hosts
    #comment[1] = Do not remove the following line, or various programs
    #comment[2] = that require network functionality will fail.
    1/ = (none)
    2/ = (none)
    3/ = (none)
    4/ = (none)

Which one of these is the line we want? It's most likely `/files/etc/hosts/1`, but you can't be sure. Fortunately, Augeas lets us identify a unique path using components of the item at that path. Here's the complete entry we want to change, referenced by number:

    augtool> print /files/etc/hosts/1
    /files/etc/hosts/1
    /files/etc/hosts/1/ipaddr = "127.0.0.1"
    /files/etc/hosts/1/canonical = "localhost"
    /files/etc/hosts/1/alias[1] = "webserver1"
    /files/etc/hosts/1/alias[2] = "webserver1.domain.com"

Here's the same entry, picked out by matching the "ipaddr" component:

    augtool> print /files/etc/hosts/*[ipaddr = '127.0.0.1']
    /files/etc/hosts/1
    /files/etc/hosts/1/ipaddr = "127.0.0.1"
    /files/etc/hosts/1/canonical = "localhost"
    /files/etc/hosts/1/alias[1] = "webserver1"
    /files/etc/hosts/1/alias[2] = "webserver1.domain.com"

This not only works for listing and printing, but for changing values as well.

    augtool> set /files/etc/hosts/*[ipaddr = '127.0.0.1']/alias[1] webserver2

So our Puppet manifest could maintain our desired "localhost" entry without knowing the order of the lines in the file:

``` puppet
augeas { "localhost":
  context => "/files/etc/hosts",
  changes => [
    "set *[ipaddr = '127.0.0.1']/canonical localhost",
    "set *[ipaddr = '127.0.0.1']/alias[1] $hostname",
    "set *[ipaddr = '127.0.0.1']/alias[2] $hostname.domain.com",
  ],
}
```

Note that the above example assumes a line for "127.0.0.1" is already defined.

With `sudoers`, you could add a simple entry by matching on the value for "user".

``` puppet
augeas { "sudojoe":
  context => "/files/etc/sudoers",
  changes => [
    "set spec[user = 'joe']/user joe",
    "set spec[user = 'joe']/host_group/host ALL",
    "set spec[user = 'joe']/host_group/command ALL",
    "set spec[user = 'joe']/host_group/command/runas_user ALL",
  ],
}
```

It might seem strange to set the value for "user" by matching "user", but it works. You just have to be sure "user" is defined first in this example so the rest of the values can be assigned. (This is a simplified example. Since the user alone doesn't necessarily uniquely identify an entry in `sudoers`, you should be careful matching on that alone.)

We've already seen how to handle an array of items with values, like `/etc/exports`, but just to be clear, when the item itself has a value, you can match it using ".".

    augtool> print /files/etc/exports/dir[. = '/foo']

Wherever possible, try to find a unique path that can be used to define entries and avoid "onlyif". If you get stuck, refer to the [Path Expressions][pe] section of the Augeas Wiki.

#### Limitations

In some cases, (`/etc/sudoers`, `/etc/services`) there may not be a single item that makes an entry unique, but you can combine them to ensure you're targeting the right one. For most things in `/etc/services`, there are two lines (for TCP and UDP) with the same name and port.

    augtool> print /files/etc/services/service-name[. = 'ssh']
    /files/etc/services/service-name[23] = "ssh"
    /files/etc/services/service-name[23]/port = "22"
    /files/etc/services/service-name[23]/protocol = "tcp"
    /files/etc/services/service-name[23]/#comment = "SSH Remote Login Protocol"
    /files/etc/services/service-name[24] = "ssh"
    /files/etc/services/service-name[24]/port = "22"
    /files/etc/services/service-name[24]/protocol = "udp"
    /files/etc/services/service-name[24]/#comment = "SSH Remote Login Protocol"

    augtool> print /files/etc/services/service-name[port = '22']
    (same output as above)

But we can target just one line by using multiple components:

    augtool> print /files/etc/services/service-name[port = '22'][protocol = 'tcp']
    /files/etc/services/service-name[23] = "ssh"
    /files/etc/services/service-name[23]/port = "22"
    /files/etc/services/service-name[23]/protocol = "tcp"
    /files/etc/services/service-name[23]/#comment = "SSH Remote Login Protocol"

You can use complicated paths like this to modify existing values, but unfortunately, they can't be used to create new entries. Remember, with `sudoers` we had to set "user" first in order to match on it in subsequent lines. To match on two values they both need to be set, and you can't set them at the same time, which is why this only works for things that already exist.

In cases like this, you will need to revert back to using a combination of `last()` and "onlyif" if using versions of Puppet older than 2.7.0 without `mv` support (see #6494).  At that point you can create the whole tree and them move it into place.

[pe]: https://github.com/hercules-team/augeas/wiki/Path-expressions

## Loading generic lenses for non-standard files

Augeas lenses have a list of files that are "autoloaded" when Augeas is initialised.  To edit a file stored in a non-default location, or a file that isn't yet listed in the autoload list, then the `lens` and `incl` parameters of the Puppet `augeas` type can be used.

To load a sudoers file stored instead at `/foo/sudoers`, the `incl` parameter is set to the file path and `lens` is set to the name of the lens itself.  This is usually in the form `Sudoers.lns`, where Sudoers is the "module name" (inside sudoers.aug, it says `module Sudoers`) and by convention, `lns` is the lens that parses the entire file (see the `transform` line in sudoers.aug).

``` puppet
augeas { "sudoers":
  lens    => "Sudoers.lns",
  incl    => "/foo/sudoers",
  changes => "...",
}
```

The context is set by default to `/files/foo/sudoers` when the `incl` parameter is given.

There are some very useful generic lenses shipped with Augeas that can be used with this technique:

* **Json.lns:** parses JSON, available in Augeas 0.7.0
* **Phpvars.lns:** parses simple PHP source files used as configs containing "$key = 'value';", available in Augeas 0.3.5 (improved in 0.10.0)
* **Properties.lns:** parses Java properties files, available in Augeas 0.9.0
* **Puppet.lns:** a generic INI file lens used for puppet.conf, available in Augeas 0.3.1 (see Dput.lns, MySQL.lns for variations)
* **Shellvars.lns:** parses shell-compatible "KEY=value" files such as /etc/sysconfig/*, available since forever though syntax support is regularly improved
* **Shellvars_list.lns:** same as Shellvars, but splits up values based on whitespace (KEY='value1 value2 value3'), available in Augeas 0.7.2
* **Simplevars.lns:** parses "key = value" files such as wgetrc, available in Augeas 1.0.0
* **Simplelines.lns:** parses "key1\nkey2\nkey3" files such as cron.allow/deny, available in Augeas 1.0.0
* **Spacevars.simple_lns:** parses simple "key value" (space separated) files such as ldap.conf, available in Augeas 0.3.2
* **Xml.lns:** parses XML, available in Augeas 0.8.0

Also look at the lenses available in your installed copy of Augeas, or the list in the generated [lens documentation](http://augeas.net/docs/references/lenses/) to see if any of the lenses can be re-used for your needs.

## Working Examples

You can test a manifest containing an Augeas resource like this:

    sudo puppet apply --verbose --debug --trace --summarize test.pp

### /etc/sysctl.conf

``` puppet
# /etc/puppetlabs/code/environments/production/modules/sysctl/manifests/conf.pp
define sysctl::conf ( $value ) {

  include sysctl

  # $title contains the title of each instance of this defined type

  # guid of this entry
  $key = $title

  $context = "/files/etc/sysctl.conf"

  augeas { "sysctl_conf/$key":
    context => "$context",
    onlyif  => "get $key != '$value'",
    changes => "set $key '$value'",
    notify  => Exec["sysctl"],
  }

}

# /etc/puppetlabs/code/environments/production/modules/sysctl/manifests/init.pp
class sysctl {
  file { "sysctl_conf":
    name => $operatingsystem ? {
      default => "/etc/sysctl.conf",
    },
  }

  exec { "sysctl -p":
    alias       => "sysctl",
    refreshonly => true,
    subscribe   => File["sysctl_conf"],
  }
}
```

use case:

``` puppet
include sysctl

sysctl::conf {

  # prevent java heap swap
  "vm.swappiness": value =>  0;

  # increase max read/write buffer size that can be applied via setsockopt()
  "net.core.rmem_max": value =>  16777216;
  "net.core.wmem_max": value =>  16777216;

}
```

### /etc/security/limits.conf

``` puppet
# /etc/puppetlabs/code/environments/production/modules/limits/manifests/conf.pp
define limits::conf (
  $domain = "root",
  $type = "soft",
  $item = "nofile",
  $value = "10000",
) {
    # guid of this entry
    $key = "$domain/$type/$item"

    # augtool> match /files/etc/security/limits.conf/domain[.="root"][./type="hard" and ./item="nofile" and ./value="10000"]

    $context = "/files/etc/security/limits.conf"

    $path_list  = "domain[.=\"$domain\"][./type=\"$type\" and ./item=\"$item\"]"
    $path_exact = "domain[.=\"$domain\"][./type=\"$type\" and ./item=\"$item\" and ./value=\"$value\"]"

    augeas { "limits_conf/$key":
      context => "$context",
      onlyif  => "match $path_exact size != 1",
      changes => [
        # remove all matching to the $domain, $type, $item, for any $value
        "rm $path_list",
        # insert new node at the end of tree
        "set domain[last()+1] $domain",
        # assign values to the new node
        "set domain[last()]/type $type",
        "set domain[last()]/item $item",
        "set domain[last()]/value $value",
      ],
    }

}
```

use case:

``` puppet
limits::conf {
  # maximum number of open files/sockets for root
  "root-soft":
    domain => root,
    type   => soft,
    item   => nofile,
    value  =>  9999;
  "root-hard":
    domain => root,
    type   => hard,
    item   => nofile,
    value  =>  9999;

}
```

### sshd_config

Configure `sshd`:

``` puppet
augeas { "sshd_config":
  context => "/files/etc/ssh/sshd_config",
  changes => [
    # track which key was used to logged in
    "set LogLevel VERBOSE",
    # permit root logins only using publickey
    "set PermitRootLogin without-password",
  ],
  notify => Service["sshd"],
}

service { "sshd":
  name => $operatingsystem ? {
    Debian  => "ssh",
    default => "sshd",
  },
  require => Augeas["sshd_config"],
  enable  => true,
  ensure  => running,
}
```

### Default Runlevel

Set the default runlevel to 3:

``` puppet
augeas { "runlevel":
  context => "/files/etc/inittab",
  changes => [
    "set id/runlevels 3",
  ],
}
```

### GRUB menu.lst: Kernel Boot Options

Suppose a vendor (like VMWare) has some recommended kernel parameters that you want to apply. Assuming you have a class that only applied to VMWare guests, you could do the following.

``` puppet
# improve time keeping for VMs
case $hardwareisa {
  "i386": {
    # not going to worry about these
  }
  default: {
    augeas { "vmtime":
      context => "/files/etc/grub.conf",
      changes => [
        "set title[1]/kernel/divider 10",
        # clear sets the left hand side but assigns no value
        "clear title[1]/kernel/notsc",
      ],
    }
  }
}
```

### GRUB menu.lst: MD5 password

The following snippet will add a `password --md5 $1$...` entry into menu.lst to password protect the GRUB menu from changes.  It's split into two parts to both create and change existing passwords if already set.

``` puppet
$grub_password = '$1$....'
augeas { "grub-create-password":
  context => "/files/boot/grub/menu.lst",
  changes => [
    "ins password after default",
    "set password/md5 ''",
    "set password $grub_password",
  ],
  onlyif => "match password size == 0",
}

augeas { "grub-set-password":
  context => "/files/boot/grub/menu.lst",
  changes => "set password $grub_password",
  require => Augeas["grub-create-password"],
}
```

### Adding a service that uses both TCP and UDP to /etc/services

Augeas needs a unique identifier when using set. So the trick to adding a service that uses both TCP and UDP is to use child nodes of the service.  For example, to add zabbix-agent you can use this (note the `[2]` for the second zabbix-agent):

``` puppet
augeas { "zabbix-agent":
   context =>  "/files/etc/services",
   changes => [
      "ins service-name after service-name[last()]",
      "set service-name[last()] zabbix-agent",
      "set service-name[. = 'zabbix-agent']/port 10050",
      "set service-name[. = 'zabbix-agent']/protocol tcp",
      "ins service-name after /files/etc/services/service-name[last()]",
      "set service-name[last()] zabbix-agent",
      "set service-name[. = 'zabbix-agent'][2]/port 10050",
      "set service-name[. = 'zabbix-agent'][2]/protocol udp",
   ],
   onlyif => "match service-name[port = '10050'] size == 0",
}
```

### ifcfg BONDING_OPTS

Setting BONDING_OPTS in an /etc/sysconfig/network-scripts/ifcfg-bond* file requires an extra set of quotes due to the spaces in the values.  Augeas can't automatically add the required quotes in.

``` puppet
augeas { "bond0":
  context => "/files/etc/sysconfig/network-scripts/ifcfg-bond0",
  changes => "set BONDING_OPTS '\"mode=active-backup miimon=100\"'",
}
```

## Templating complex changes/commands

The list of commands in the changes parameter can get complex quickly, particularly when you want to run some commands on conditions, or if you want to loop around an array.  To solve this, you can use ERB templates to generate the list of commands for the provider.

### /etc/resolv.conf

Here's an example to set up /etc/resolv.conf with nameservers and domains.  First the define and an instance of the resource:

``` puppet
# /etc/puppetlabs/code/environments/production/modules/resolv/manifests/conf.pp
define resolv::conf($nameserver, $search = [], $domain = "") {
  augeas { "resolvconf":
    context => "/files/etc/resolv.conf",
    changes => template("resolv/resolvconf.erb"),
  }
}

# Elsewhere...
resolv::conf { "resolvconf":
  nameserver => [ "8.8.8.8", "8.8.4.4" ],
  search     => [ "example.com", "example.net" ],
  domain     => "example.com",
}
```

This template is stored at `modules/resolv/templates/resolvconf.erb` following the standard [module layout](./modules_fundamentals.html):

``` erb
<% if domain and not domain.empty? -%>
  set domain <%= domain %>
<% end -%>

rm search
<% search.each do |sdom| -%>
  set search/domain[last()+1] <%= sdom %>
<% end -%>

rm nameserver
<% nameserver.each do |ns| -%>
  set nameserver[last()+1] <%= ns %>
<% end -%>
```

It's just using normal [Puppet ERB templating](./lang_template.html) techniques, except that the output is a set of commands for Augeas to parse instead of the config file itself (the provider then splits on newlines).  This example shows both simple conditionals and loops, testing the variables available passed into the define.

Because this template is evaluated during catalog compilation, you unfortunately can't use "get" Augeas functions to retrieve values from the config file itself. If you need to do this, you can write [custom facts]({{facter}}/custom_facts.html) that use Augeas to read values.

### Dynamically adding numbered children -- libvirtd.conf: sasl_allowed_usernames_list

Here is another example that uses [Puppet ERB templating](./lang_template.html) to populate an Augeas node's numbered children. Quoting from [https://github.com/hercules-team/augeas/wiki/Adding-nodes-to-the-tree](https://github.com/hercules-team/augeas/wiki/Adding-nodes-to-the-tree):

> For nodes whose children are numbered sequentially (like the children of `/files/etc/hosts`), you need to invent a new label for the new child. You can either try to find out how many children `/files/etc/hosts` actually has, and then use the next number in the sequence. A much simpler way to generate a new unique numbered label is to use numbers that start with 0; since Augeas treats labels as strings, 01 and 1 are different, and since it will never use such a label, it's guaranteed to be unique:

Consider the *sasl_allowed_username_list* node in `libvirt.conf` which holds a whitelist of SASL usernames that are allowed to connect via `qemu+tcp` to the Libvirt daemon:

    augtool> print /files/etc/libvirt/libvirtd.conf/sasl_allowed_username_list
    /files/etc/libvirt/libvirtd.conf/sasl_allowed_username_list/1 = "foo"
    /files/etc/libvirt/libvirtd.conf/sasl_allowed_username_list/2 = "bar"
    /files/etc/libvirt/libvirtd.conf/sasl_allowed_username_list/3 = "baz"

In `libvirtd.conf` this looks like this:

    sasl_allowed_username_list = ["foo", "bar", "baz"]

The *sasl_allowed_username_list* children are numbered, so adding a new child is usually as simple as doing `set /files/etc/libvirt/libvirtd.conf/sasl_allowed_username_list/4 quux`. However, if we don't know in advance the exact number of children (i.e. allowed usernames) the whitelist should contain things are not as simple.

How would we dynamically set this whitelist based on a supplied array of usernames? The quote above suggests finding out how many children the node has a use the next number in the sequence, but this is not supported in Augeas directly (we can't use `last()` or `position()` for numbered children). In this case we need to dynamically create the children labels by counting up and using the above quote's second suggestion, creating labels as strings like *001*, *002* and so on. We use a clever Puppet template to achieve the desired results.

Consider the following snippets of a parameterized Libvirt Puppet module:

In `nodes.pp`:

``` puppet
node 'kvmhost01.example.com' {
  class { 'libvirt::daemon':
    ...
    sasl_allowed_usernames => [ 'userX', 'userY', 'userZ', 'userA', ],
    ...
  }
}
```

The parameterized class `libvirt::daemon`:

```
class libvirt::daemon (
  ...
  $sasl_allowed_usernames = [],
  ...
) {
  ...
  augeas { 'libvirtd.conf_sasl_allowed_username_list':
    context => '/files/etc/libvirt/libvirtd.conf',
    changes => template('libvirt/daemon/sasl_allowed_username_list.erb'),
  }
  ...
}
```

And the template in `/etc/puppetlabs/code/environments/production/modules/libvirt/daemon/sasl_allowed_username_list.erb`:

``` erb
rm sasl_allowed_username_list
<% if sasl_allowed_usernames and not sasl_allowed_usernames.empty? -%>
  <% i = 0 -%>
  <% sasl_allowed_usernames.each do |username| -%>
    <% i += 1 -%>
    set sasl_allowed_username_list/<%= sprintf("%03d", i) -%> <%= username %>
  <% end -%>
<% end -%>
```

By default the `$sasl_allowed_usernames` array is empty. When the class is applied we can supply an array of usernames that should make up the whitelist in *sasl_allowed_username_list* in libvirtd.conf. The changes Augeas should apply are generated by the template specified in `sasl_allowed_username_list.erb`. What the template does is the following:

1. Remove (unset) the *sasl_allowed_username_list* configuration directive
1. Check if the parameter `sasl_allowed_usernames` exists and is non-empty
1. Start a counter `i = 0`
1. For each username in the array increase the counter and
1. Create an Augeas `set` directive like `set sasl_allowed_username_list/001 userX`, `set sasl_allowed_username_list/002 userY` and so on.

The full set of changes Augeas should apply eventually looks like this:

```
set sasl_allowed_username_list/001 userX
set sasl_allowed_username_list/002 userY
set sasl_allowed_username_list/003 userZ
set sasl_allowed_username_list/004 userA
```

The limitation here, as in the above example with `/etc/resolv.conf` is that we can not extend an existing list in *sasl_allowed_username_list*. Instead the list is fixed (but variably long).

