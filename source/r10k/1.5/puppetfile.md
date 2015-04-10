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

You'll manage your modules through the Puppetfile, in which you'll specify detailed information about what modules r10k should install and where it should install them.

* Continue reading to learn how to configure your Puppetfile.
* [See "Getting To Know r10k"][gettingtoknow] for basic information about r10k.
* [See "Configuring r10k"][configuring] to learn how to set up your r10k Puppetfile.
* [See "Getting Started with r10k"][gettingstarted] to get r10k up and running.
* [See "Managing Environments"]


## About the Puppetfile

The Puppetfile is a text file written in a Ruby-based DSL. This file specifies where r10k should install modules and what modules it should install, including which version of the module and where to fetch the modules from. This allows r10k to install modules into a given environment in your deployment, or it can install a specific set of Puppet modules for local development.

>**Note:** Puppetfiles do NOT include dependency resolution. You must make sure that you have every module needed for all of your specified modules to run.

You interact with Puppetfiles both directly and through the `r10k puppetfile` subcommand. Technically, because the Puppetfile format uses a Ruby DSL, any valid Ruby expression can be used. We strongly suggest that you keep things simple and use the subcommand, as all our examples demonstrate. 

##Configuring your Puppetfile

###Setting the module installation directory

This setting points to the directory where r10k will install your modules. You can specify either an absolute or a relative path in this setting. If you don't specify this setting, r10k will install modules in the Puppetfile's current directory.

**Note:** If you use this setting, it should always come **before** any modules listed in the Puppetfile.

To install modules to an absolute path:

~~~
moduledir '/etc/puppet/modules'

mod 'puppetlabs/apache'
#installs the apache module into '/etc/puppet/modules/apache'
~~~

To install modules to a relative path:

~~~
moduledir 'thirdparty'

mod 'puppetlabs/apache' 
# installs the apache module into 'dirname/path/to/Puppetfile/thirdparty/apache'
~~~

###Declaring modules in your Puppetfile

The **`mod`** setting specifies the module(s) that r10k should install. Specify the module [long name](/puppet/latest/reference/modules_publishing.html#a-note-on-module-names) in a string. You can specify the latest version, either with or without updating that version, or you can specify a particular version of a module to be maintained at that version.

**Install the latest version of the module, and then keep the module at that version:**

~~~
mod 'puppetlabs/apache'
mod 'adrienthebo/thebestmoduleever'
~~~

**Install a specific version, and then keep the module at that version:**

~~~
mod 'puppetlabs/apache', '0.10.0'
~~~

**Install the latest available version of a module, and then update that module:""**

~~~
mod 'puppetlabs/apache', :latest
~~~

####Declaring a Git repo as a module

You can also specify a Git repo that contains a Puppet module; r10k will clone that repo and use it as a module. In this case, you can specify the module "version" by using the `ref`, `tag`, `commit`, and `branch` options.

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

##Running Puppetfile commands

After you've configured your Puppetfile, you'll be able to manage your modules via the `r10k puppetfile` subcommand. This subcommand must be run as the user with write access to the Puppet environment path. It interacts with the Puppetfile in the current working directory, so before running the subcommand, make sure you are in the directory of the Puppetfile you want to use. You can run the `r10k puppetfile` subcommand with following actions:

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

