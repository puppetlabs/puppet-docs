---
layout: default
title: "Managing Modules"
---

[direnv]: /puppet/4.0/reference/environments.html
[direnv_setup]: /puppet/4.0/reference/environments_creating.html
[gettingstarted]: ./gettingstarted_r10k.html
[gettingtoknow]: ./index.html
[configuring]: ./configuring_r10k.html


# Managing Modules

You'll manage your modules through the Puppetfile, which specifies which modules you want to install, what version of those modules you want, and where you want r10k to fetch the modules from.

* Continue reading to learn how to configure your Puppetfile.
* [See "Configuring r10k"][configuring] to learn how to set up your r10k Puppetfile.
* [See "Getting To Know r10k"][gettingtoknow] for basic information about r10k.
* [See "Getting Started with r10k"][gettingstarted] to get r10k up and running.
* [See "Configuring r10k"][configuring] to learn how to set up your r10k Puppetfile.
* [See "Managing Environments"]


## About the Puppetfile

The Puppetfile is a text file written in a Ruby-based DSL. It specifies what modules r10k should install, including which version of the module and where to fetch the modules from. The Puppetfile does two jobs in r10k:

1. Install a specific set of Puppet modules for local development, or 
2. Install additional modules into a given environment in an r10k environment deployment.

>**Note:**
>
>Puppetfiles do NOT include dependency resolution. You must make sure that you have every module needed for all of your modules to run listed.

You interact with Puppetfiles both directly and through the `r10k puppetfile` subcommand. Technically, because the Puppetfile format uses a Ruby DSL, any valid Ruby expression can be used. We strongly suggest that you keep things simple and use the subcommand, as all our examples demonstrate. 

##Configuring your Puppetfile

The Puppetfile has the following global settings, which control how the Puppetfile installs and handles modules. Always put the global settings in the Puppetfile above any modules you are specifying.

###`forge`

Don't use this setting. It specifies which server to fetch Forge-based modules, but it isn't operational yet. This setting should always come **before** any modules are declared in the Puppetfile.

###`moduledir`

Specifies the directory where modules will be installed. If you don't specify this setting, the default behavior installs modules in the current directory of the Puppetfile. 
You can specify either an absolute or a relative path in this setting. If you use this setting, it should always come **before** any modules are declared in the Puppetfile.

To install modules to an absolute path:

~~~
moduledir '/etc/puppet/modules'

mod 'puppetlabs/apache' # 
#installs the apache module into '/etc/puppet/modules/apache'
~~~

To install modules to a relative path:

~~~
moduledir 'thirdparty'

mod 'puppetlabs/apache' 
# installs the apache module into 'dirname/path/to/Puppetfile'/thirdparty/apache'
~~~

## Specifying modules in your Puppetfile


### `mod`

Specifies the module(s) that r10k should install.

~~~
mod 'puppetlabs/apache'
mod 'adrienthebo/thebestmoduleever'
~~~



##`puppetfile` subcommands

The `r10k puppetfile` subcommand interacts with the Puppetfile in the current working directory. The subcommand must be run as the user with write access to the Puppet environment path. The `r10k puppetfile` subcommand has several *actions*. Before running the subcommand with any of the below actions, make sure you are in the current working directory of the Puppetfile you want to interact with.

### `install`

Install or update all modules in a given Puppetfile into ./modules.

~~~
r10k puppetfile install
~~~

### `check`

Verify the Puppetfile syntax.

~~~
r10k puppetfile check
~~~

### `purge`

Remove any modules in the ./modules directory that are not specified in the Puppetfile.

~~~
r10k puppetfile purge
~~~

##Using a Git Repo as a Module

A Git repo that contains a Puppet module can be cloned and used as a module. You can specify the module "version" by using `ref`, `tag`, `commit`, and `branch` options.

* `ref`: Determines the type of Git object to check out. Can be used with a Git commit, branch reference, or a tag.
* `tag`: Directs r10k to clone the repo at a certain tag number.
* `commit`: Directs r10k to clone the repo at a certain commit.
* `branch`: Specifies a certain branch of the repo to clone.


**Install puppetlabs/apache and keep it up to date with 'master':**

~~~
mod 'apache',
  :git => 'https://github.com/puppetlabs/puppetlabs-apache'
~~~

**Install puppetlabs/apache and track the 'docs_experiment' branch:**

~~~
mod 'apache',
  :git => 'https://github.com/puppetlabs/puppetlabs-apache',
  :ref => 'docs_experiment'
~~~

**Install puppetlabs/apache and pin to the '0.9.0' tag:**

~~~
mod 'apache',
  :git => 'https://github.com/puppetlabs/puppetlabs-apache',
  :tag => '0.9.0'
~~~

**Install puppetlabs/apache and pin to the '83401079' commit:**

~~~
mod 'apache',
  :git    => 'https://github.com/puppetlabs/puppetlabs-apache',
  :commit => '83401079053dca11d61945bd9beef9ecf7576cbf'
~~~

**Install puppetlabs/apache and track the 'docs_experiment' branch:**

~~~
mod 'apache',
  :git    => 'https://github.com/puppetlabs/puppetlabs-apache',
  :branch => 'docs_experiment'
~~~

##Using the Puppet module tool

To use the Puppet module tool (PMT) to install modules with r10k, specify the [long name](/puppet/latest/reference/modules_publishing.html#a-note-on-module-names) of the module in the `mod` setting of the Puppetfile. Specify the module name in a string, and if you would like a specific module, you can also specify the version in another string. If you don't specify a version, the latest version of the module available at the time is installed and then kept at that version.

**Install the latest version of puppetlabs/apache and do not update it:**

~~~
mod 'puppetlabs/apache'
~~~

**Install a particular version of puppetlabs/apache:**

~~~
mod 'puppetlabs/apache', '0.10.0'
~~~

**Install the latest version of puppetlabs/apache and always update it to the latest version available:**

~~~
mod 'puppetlabs/apache', latest
~~~