---
layout: default
title: "r10k Reference"
---
#r10k Reference

##r10k Subcommands

###First-level subcommands

The following subcommands are available with `r10k`:

* [`deploy`](#deploy): Runs r10k.
* `help`: Generates help man page for `r10k`.
* [`puppetfile`](#puppetfile): Perform operations on a Puppetfile.
* `version` Prints the version of r10k you are using.

####First-level subcommand options

Each subcommand allows the following options:

* **-h --help**     
Show help for this command.

* **-t --trace**
Display stack traces on application crash.

* **-v --verbose**
Set log verbosity. Valid values: fatal, error, warn, notice, info, debug, debug1, debug2
    
###`deploy`

When you run `r10k deploy`, r10k checks the Git repository you've specified in r10k.yaml to see what branches are present. Then r10k maps those branches to the Puppet directory environments it creates in the directory path you specified in r10k.yaml. It then clones your Git repo, and either creates (if this is your first run) or updates (if it is a subsequent run) your directory environments with the contents of your repo.

####Second-level subcommands for `r10k deploy`

The `r10k deploy` subcommand has the following additional commands available:

* `display`

Display a list of environments in your deployment:

~~~
r10k deploy display
~~~

For a list of modules in the [TODO: Which Puppetfile?] Puppetfile, add a `-p` to the command.

* `environment`
Deploy environments and their dependent modules.

~~~
r10k deploy environment production
~~~

* `module`
Deploy a module in all environments.


#####Second-level options for `r10k deploy`

Each additional command allows the following option:

* **-c --config**
Specify a configuration file

###    
└> be r10k puppetfile --help
NAME
    puppetfile - Perform operations on a Puppetfile

USAGE
    r10k puppetfile <subcommand>

DESCRIPTION
    `r10k puppetfile` provides an implementation of the librarian-puppet
    style Puppetfile (http://bombasticmonkey.com/librarian-puppet/).

SUBCOMMANDS
    check      Try and load the Puppetfile to verify the syntax is correct.
    install    Install all modules from a Puppetfile
    purge      Purge unmanaged modules from a Puppetfile managed directory
    
    
 be r10k deploy environment --help
NAME
    environment - Deploy environments and their dependent modules

USAGE
    r10k deploy environment <options>
    <environment> <...>

DESCRIPTION
    `r10k deploy environment` creates and updates Puppet environments based
    on Git branches.

    Environments can provide a Puppetfile at the root of the directory to
    deploy independent Puppet modules. To recursively deploy an environment,
    pass the `--puppetfile` flag to the command.

    **NOTE**: If an environment has a Puppetfile when it is instantiated a
    recursive update will be forced. It is assumed that environments are
    dependent on modules specified in the Puppetfile and an update will be
    automatically scheduled. On subsequent deployments, Puppetfile deployment
    will default to off.
    
    
 be r10k deploy module --help    
NAME
    module - Deploy modules in all environments

USAGE
    r10k deploy module [module] <module ...>

DESCRIPTION
    `r10k deploy module` Deploys and updates modules inside of Puppet
    environments. It will load the Puppetfile configurations out of all
    environments, and will try to deploy the given module names in all
    environments.

OPTIONS
    -e --environment    Update the modules in the given environment
    
    
 be r10k deploy display --help
NAME
    display - Display environments and modules in the deployment
    aliases: list

USAGE
    r10k deploy display

OPTIONS
      --detail        Display detailed information
    -p --puppetfile    Display Puppetfile modules    