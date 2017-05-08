---
layout: default
toc_levels: 1
title: "Configuring Facter with facter.conf"
---

The `facter.conf` file is a configuration file that allows you to cache and block fact groups, and manage how Facter interacts with your system. There are three sections: `facts`, `global` and `cli`. All sections are optional and can be listed in any order within the file.

When you run Facter from the Ruby API, only the `facts` section and limited `global` settings are loaded.

Example facter.conf file:

~~~
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


