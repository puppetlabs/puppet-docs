---
layout: default
built_from_commit: d3ee2f44b7cb0cadbb6fc9495f2eb093c4d6e148
title: 'Facter: CLI'
toc: columns
canonical: "/puppet/latest/cli.html"
---

# Facter CLI

---
SYNOPSIS
--------
  facter [options] [query] [query] [...]

DESCRIPTION
-----------
Collect and display facts about the current system. The library behind Facter is easy to extend, making Facter an easy way to collect information about a system.

If no queries are given, then all facts will be returned.

Many of the command line options can also be set via the HOCON config file. This file can also be used to block or cache certain fact groups.

OPTIONS
-------

  * `--color`:

    Enable color output.


  * `--no-color`:

    Disable color output.


  * `-c`, `--config`:

    The location of the config file.


  * `--custom-dir`:

    A directory to use for custom facts.


  * `-d`, `--debug`:

    Enable debug output.


  * `--external-dir`:

    A directory to use for external facts.


  * `--hocon`:

    Output in Hocon format.


  * `-j`, `--json`:

    Output in JSON format.


  * `-l`, `--log-level`:

    Set logging level. Supported levels are: none, trace, debug, info, warn, error, and fatal.


  * `--no-block`:

    Disable fact blocking.


  * `--no-cache`:

    Disable loading and refreshing facts from the cache


  * `--no-custom-facts`:

    Disable custom facts.


  * `--no-external-facts`:

    Disable external facts.


  * `--no-ruby`:

    Disable loading Ruby, facts requiring Ruby, and custom facts.


  * `--trace`:

    Enable backtraces for custom facts.


  * `--verbose`:

    Enable verbose (info) output.


  * `--show-legacy`:

    Show legacy facts when querying all facts.


  * `-y`, `--yaml`:

    Output in YAML format.


  * `--strict`:

    Enable more aggressive error reporting.


  * `-t`, `--timing`:

    Show how much time it took to resolve each fact


  * `--sequential`:

    Resolve facts sequentially


  * `--list-block-groups`:

    List block groups


  * `--list-cache-groups`:

    List cache groups


  * `--puppet, -p`:

    Load the Puppet libraries, thus allowing Facter to load Puppet-specific facts.


  * `help`:

    Help for all arguments



FILES
-----
<em>/etc/puppetlabs/facter/facter.conf</em>

A HOCON config file that can be used to specify directories for custom and external facts, set various command line options, and specify facts to block. See example below for details, or visit the [GitHub README](https://github.com/puppetlabs/puppetlabs-hocon#overview).

EXAMPLES
--------
Display all facts:

```
$ facter
disks => {
  sda => {
    model => "Virtual disk",
    size => "8.00 GiB",
    size_bytes => 8589934592,
    vendor => "ExampleVendor"
  }
}
dmi => {
  bios => {
    release_date => "06/23/2013",
    vendor => "Example Vendor",
    version => "6.00"
  }
}
```

Display a single structured fact:

```
$ facter processors
{
  count => 2,
  isa => "x86_64",
  models => [
    "Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz",
    "Intel(R) Xeon(R) CPU E5-2680 v2 @ 2.80GHz"
  ],
  physicalcount => 2
}
```

Display a single fact nested within a structured fact:

```
$ facter processors.isa
x86_64
```

Display a single legacy fact. Note that non-structured facts existing in previous versions of Facter are still available,
but are not displayed by default due to redundancy with newer structured facts:

```
$ facter processorcount
2
```

Format facts as JSON:

```
$ facter --json os.name os.release.major processors.isa
{
  "os.name": "Ubuntu",
  "os.release.major": "14.04",
  "processors.isa": "x86_64"
}
```

An example config file.

```
# always loaded (CLI and as Ruby module)
global : {
    external-dir : "~/external/facts",
    custom-dir   :  [
       "~/custom/facts",
       "~/custom/facts/more-facts"
    ],
    no-external-facts : false,
    no-custom-facts   : false,
    no-ruby           : false
}
# loaded when running from the command line
cli : {
    debug     : false,
    trace     : true,
    verbose   : false,
    log-level : "info"
}
# always loaded, fact-specific configuration
facts : {
    # for valid blocklist entries, use --list-block-groups
    blocklist : [ "file system", "EC2" ],
    # for valid time-to-live entries, use --list-cache-groups
    ttls : [ { "timezone" : 30 days } ]
}
```

