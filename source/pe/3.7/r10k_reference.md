---
layout: default
title: "r10k Reference"
canonical: "/pe/latest/r10k_reference.html"
description: "Subcommand reference for r10k, a Puppet code management tool."
---
[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[r10kindex]: ./r10k.md

* [See "Getting To Know r10k"][index] for basic information about r10k.
* [See "Setting Up r10k"][setup] to get r10k up and running.
* [See "Configuring Directory Environments in r10k"][r10kyaml] to learn how to set up directory environments in r10k.yaml.
* [See "Managing Modules with the Puppetfile"][puppetfile] to learn how to set up your r10k Puppetfile.
* [See "Running r10k"][running] to learn how to deploy your environments.


The following subcommands are available with `r10k`:

* [`deploy`](#deploy): Runs r10k.
* `help`: Generates help man page for `r10k`.
* [`puppetfile`](#puppetfile): Perform operations on a Puppetfile.
* `version` Prints the version of r10k you are using.

##First-level subcommand options

Each subcommand allows the following options:

* **--color**: Enable colored log messages.
* **-h --help**: Show help for this command.
* **-t --trace**: Display stack traces on application crash.
* **-v --verbose**: Set log verbosity. Valid values: fatal, error, warn, notice, info, debug, debug1, debug2.
 
    
###`deploy`

The `r10k deploy` command accepts the following subcommands:

* `display`: Display a list of environments in your deployment.
  * To display a list of modules in the Puppetfile, add a `-p` to the command.
  * To display detailed information, add `--detail` to the command.
* `environment`: Deploy environments and their dependent modules.
* `module`: Deploy a module in all environments.
  * To update the modules in the given environment, add `-e` to the command.

###`puppetfile`

The `r10k puppetfile` command accepts the following subcommands:

* `check`: Verify the Puppetfile syntax is correct.
* `install`: Install all modules from a Puppetfile.
* `purge`: Purge unmanaged modules from a Puppetfile managed directory.