---
layout: default
title: "r10k Subcommand Reference"
canonical: "/pe/latest/r10k_reference.html"
description: "Subcommand reference for r10k, a Puppet code management tool."
---

[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[r10kindex]: ./r10k.md



The following subcommands are available with `r10k`:

* [`deploy`](#deploy): Performs operations on environments.
* `help`: Generates help page for r10k.
* [`puppetfile`](#puppetfile): Performs operations on a Puppetfile.
* `version` Prints the version of r10k you are using.

##First-level subcommand options

Each subcommand allows the following options:

* `--color`: Enables colored log messages.
* `-h`, `--help`: Shows help for this command.
* `-t`, `--trace`: Displays stack traces on application crash.
* `-v`, `--verbose`: Sets log verbosity. Valid values: fatal, error, warn, notice, info, debug, debug1, debug2.


###`deploy`

The `r10k deploy` command accepts the following subcommands:

* `display`: Displays a list of environments in your deployment.
  * To display a list of modules in the Puppetfile, add the `-p` flag to the command.
  * To display detailed information, add `--detail` to the command.
* `environment`: Deploys environments and their dependent modules.
  * To update modules specified in the environment's Puppetfile, add the `-p` flag to the command.
* `module`: Deploys a module in all environments.
  * To update the modules in the environment, add the `-e` flag to the command.

###`puppetfile`

The `r10k puppetfile` command accepts the following subcommands:

* `check`: Verifies the Puppetfile syntax is correct.
* `install`: Installs all modules from a Puppetfile.
* `purge`: Purges unmanaged modules from a Puppetfile managed directory.
