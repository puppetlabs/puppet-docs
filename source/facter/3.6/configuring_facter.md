---
layout: default
toc_levels: 1
title: "Configuring Facter with facter.conf"
---

The `facter.conf` file is a configuration file that allows you to cache and block fact groups, and manage how Facter interacts with your system. There are three sections: `facts`, `global` and `cli`. All sections are optional and can be listed in any order within the file.

When you run Facter from the Ruby API, only the `facts` section and limited `global` settings are loaded.

Example facter.conf file:

~~~
facts : {
    blocklist : [ "file system", "EC2" ],
    ttls : [
        { "timezone" : 30 days },
    ]
}
global : {
    external-dir     : [ "path1", "path2" ],
    custom-dir       : [ "custom/path" ],
    no-exernal-facts : false,
    no-custom-facts  : false,
    no-ruby          : false
}

cli : {
    debug     : false,
    trace     : true,
    verbose   : false,
    log-level : "warn"
}
~~~

### Location

Facter does not create the `facter.conf` file automatically, so you must create it manually, or use a module to manage it. Facter loads the file by default from `/etc/puppetlabs/facter/facter.conf` on *nix systems and `C:\ProgramData\PuppetLabs\facter\etc\facter.conf` on Windows. Or, you can specify a different default with the `--config` command line option:

`facter --config path/to/my/config/file/facter.conf`

### `facts`

This section of `facter.conf` contains settings that affect fact groups. A fact group is a set of individual facts that are resolved together because they all rely on the same underlying system information. When you add a group name to the config file as a part of either of these `facts` settings, all facts in that group will be affected. Currently only built-in facts can be cached or blocked.

Settings:

* `blocklist` --- Prevents all facts within the listed groups from being resolved when Facter runs.
  Use the `--list-block-group` command line option to list valid groups.

* `ttls` --- Caches the key-value pairs of groups and their duration to be cached.
  Use the `--list-cache-group` command line option to list valid groups.

  * Cached facts are stored as JSON in `/opt/puppetlabs/facter/cache/cached_facts` on *nix and `C:\ProgramData\PuppetLabs\facter\cache\cached_facts` on Windows.

#### Example

To see a list of valid group names, from the command line, run `facter --list-block-groups` or `facter --list-cache-groups`. The output shows the fact group at the top level, with all facts in that group nested below.

~~~
$ facter --list-block-groups
EC2
  - ec2_metadata
  - ec2_userdata
file system
  - mountpoints
  - filesystems
  - partitions
~~~

If you want to block any of these groups, add the group name to the `facts` section of `facter.conf`, with the `blocklist` setting. 


~~~
facts : {
    blocklist : [ "file system" ],
}
~~~

Here, the "file system" group has been added, so the `mountpoints`, `filesystems`, and `partitions` facts will all be prevented from loading.


### `global`

The `global` section of `facter.conf` contains settings to control how Facter interacts with its external elements on your system. 

Setting        | Effect                                                        | Default
---------------|---------------------------------------------------------------|--------
`external-dir` | A list of directories to search for external facts.           |  
`custom-dir`   | A list of directories to search for custom facts.             |    
`no-external`* | If true, prevents Facter from searching for external facts.   | `false`
`no-custom`*   | If true, prevents Facter from searching for custom facts.     | `false`
`no-ruby`*     | If true, prevents Facter from loading its Ruby functionality. | `false`

\*Not available when you run Facter from the Ruby API.

### `cli` 

The `cli` section of `facter.conf` contains settings that affect Facter’s command line output. All of these settings are ignored when you run Facter from the Ruby API.


Setting         | Effect                                           | Default
----------------|--------------------------------------------------|-------
`debug`         | If true, Facter outputs debug messages.                                      | `false`
`trace`         | If true, Facter prints stacktraces from errors arising in your custom facts. | `false`
`verbose`       | If true, Facter outputs its most detailed messages.                          | `false`
`log-level`     | Sets the minimum level of message severity that gets logged. Valid options: “none”, “fatal”, “error”, “warn”, “info”, “debug”, “trace”. | “warn”


