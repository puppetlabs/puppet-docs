---
layout: default
title: "Deploying Environments"
canonical: "/pe/latest/r10k_run.html"
description: "Deploying environments and modules with r10k, a Puppet code management tool."
---

[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md

You've [configured][r10kyaml] your environments in r10k.yaml and declared your modules in [Puppetfile][puppetfile]. Now it's time to run r10k!

##Initial r10k run

The first time you run r10k, you'll deploy all environments and modules with the following command: 

~~~
r10k deploy environment
~~~

This command checks the Git repository you've specified in r10k.yaml to see what branches are present. Then r10k maps those branches to the Puppet directory environments it creates in the directory path you specified in r10k.yaml. It then clones your Git repo, and either creates (if this is your first run) or updates (if it is a subsequent run) your directory environments with the contents of your repo branches.

> Note that when running commands to deploy code on a master, r10k needs to have write access to your Puppet environment path. If you're using Puppet Enterprise this account is pe-puppet. To do this, run r10k as the Puppet user itself or as root. Running the user as root requires access control to the root user.

##Updating environments

###Update all environments

~~~
r10k deploy environment
~~~

This command updates existing environments and recursively creates new environments.
When an environment is deployed for the first time (as in the initial r10k run above), this command automatically updates all modules as well. For subsequent updates, only the environment itself is updated.

###Update all environments and modules

To update all environments and modules on subsequent r10k runs, run the above command with the `--puppetfile` flag:

~~~
r10k deploy environment --puppetfile
~~~

This command updates all sources, create new environments, delete old environments, and recursively updates all environment modules specified in environment Puppetfiles.

However, you should note that this is the slowest method for using r10k, because it does the maximum possible work. You'll likely want to use less resource-intensive commands for most future updates of your environments and modules.

###Update a single environment

~~~
r10k deploy environment my_working_environment
~~~

When you're actively developing on a given environment, this is the best way to
deploy your changes. When an environment is deployed for the first
time, it automatically updates all modules as well. For subsequent updates,
only the environment itself is updated.

###Update a single environment and its modules

~~~
r10k deploy environment my_working_environment --puppetfile
~~~

This updates the given environment and all contained modules. This is
useful if you want to make sure that a given environment is fully up to date.

##Installing and updating modules

When you use the `r10k deploy` command to update modules, r10k installs/updates the modules as you've specified them in your [Puppetfile](puppetfile). For `r10k puppetfile` commands that you can use to install, verify, and purge modules, see [Running Puppetfile commands](puppetfile#running-puppetfile-commands).

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

You can display information about your environments and modules with the `display` subcommand.

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

The above example displays details on the modules for your production, vmwr, and webrefactor environments.

