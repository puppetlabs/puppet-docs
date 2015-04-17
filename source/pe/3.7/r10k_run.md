---
layout: default
title: "Running r10k"
canonical: "/pe/latest/r10k_run.html"
description: "Deploying environments and modules with r10k, a Puppet code management tool."
---

[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md

You've [configured][r10kyaml] your r10k.yaml and set up your [Puppetfile][puppetfile]. Now it's time to run r10k!

* Continue reading to learn how to deploy your environments and modules with r10k.
* [See "Getting To Know r10k"][index] for basic information about r10k.
* [See "Setting Up r10k"][setup] to get r10k up and running.
* [See "Configuring r10k.yaml"][r10kyaml] to learn how to set up directory environments with r10k.
* [See "Configuring the Puppetfile"][puppetfile] to learn how to set up your r10k Puppetfile.
* [See "r10k Reference"][reference] for a list of r10k subcommands.

-> This is a mess. Use this page to help you: https://github.com/puppetlabs/r10k/blob/master/doc/dynamic-environments/usage.mkd and this: https://github.com/puppetlabs/r10k/blob/master/doc/dynamic-environments/configuration.mkd

##Initial r10k run

The first time you run r10k, you'll update all environments and modules with the following command: 

~~~
r10k deploy environment (for this to work  --puppetfile(don't need this the first time)
~~~

This command updates all sources, create new environments, delete old environments, and recursively updates all environment modules specified in environment Puppetfiles.

> Note that when running commands to deploy code on a master, r10k needs to have write access to your Puppet environment path. If you're using Puppet Enterprise this account is pe-puppet. To do this, run r10k as the Puppet user itself or as root. Running the user as root requires access control to the root user.

This is the simplest method for running r10k, but it's also the slowest method because r10k does the maximum possible work. Because of this, you'll want to use less resource-intensive commands for most future updates of your environments and modules.

##Updating environments

###Update all environments while avoiding unnecessary recursion:

~~~
r10k deploy environment
~~~

This command updates existing environments and recursively creates new environments.
When an environment is deployed for the first time, it automatically updates all modules as well. For subsequent updates, only the environment itself will be updated.

###Update a single environment

~~~
r10k deploy environment my_working_environment
~~~

When you're actively developing on a given environment, this is the best way to
deploy your changes. When an environment is deployed for the first
time, it automatically updates all modules as well. For subsequent updates,
only the environment itself will be updated.

###Update a single environment and its modules

~~~
r10k deploy environment my_working_environment --puppetfile
~~~

This updates the given environment and all contained modules. This is
useful if you want to make sure that a given environment is fully up to date.


##Deploying modules

###Update a single module across all environments

~~~
r10k deploy module apache
~~~

This is useful for when you're working on a module specified in a Puppetfile and want to update it across all environments.

###Update multiple modules across all environments

~~~
r10k deploy module apache jenkins java
~~~

###Update one or more modules in a single environment

~~~
r10k deploy module -e production apache jenkins java
~~~

##Viewing environments

###Display all environments being managed by r10k

~~~
r10k deploy display
~~~

###Display environments and modules 

To display all r10k-managed environments and Puppetfile modules

~~~
r10k deploy display -p
~~~

You can get detailed information about the expected and actual module versions by adding the `--detail` flag to this command: 

~~~
r10k deploy display -p --detail
~~~

###Display specific environments and modules

For an explicit list of environments being managed by r10k, and the modules specified in their Puppetfiles along with their expected and actual versions, limit your query with the environment names. For example: 

~~~
r10k deploy display -p --detail production vmwr webrefactor
~~~

The above example will display details on the modules for your production, vmwr, and webrefactor environments.

##Subcommands in r10k

###First-level subcommands
The following subcommands are available with `r10k`:

* [`deploy`](#deploy): Runs r10k.
* `help`: Generates help man page for `r10k`.
* [`puppetfile`](#puppetfile): Perform operations on a Puppetfile.
* `version` Prints the version of r10k you are using.


####First-level subcommand options

Each subcommand allows the following options:

* **-h --help**     
: Show help for this command.

* **-t --trace**
: Display stack traces on application crash.

* **-v --verbose**
: Set log verbosity. Valid values: fatal, error, warn, notice, info, debug, debug1, debug2
    
    
###`deploy`

When you run `r10k deploy`, r10k will check the Git repository you've specified in r10k.yaml to see what branches are present. Then r10k will map those branches to the Puppet directory environments it will create in the directory path you specified in r10k.yaml. It will then clone your Git repo and either create (if this is your first run) or update (if it is a subsequent run) your directory environments with the contents of your repo.

####Second-level subcommands for `r10k deploy`

The `r10k deploy` subcommand has the following additional commands available:

* `display`
: Display a list of environments in your deployment

~~~
r10k deploy display
~~~

For a list of modules in the Puppetfile, add a `-p` to the command.

* `environment`
: Deploy environments and their dependent modules.

~~~
r10k deploy environment production
~~~

* `module`
: Deploy a module in all environments.


#####Second-level options for `r10k deploy`

Each additional command allows the following option:

* **-c --config**
: Specify a configuration file

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