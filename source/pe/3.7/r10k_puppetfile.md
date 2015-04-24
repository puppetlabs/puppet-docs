---
layout: default
title: "Managing Modules with the Puppetfile"
canonical: "/pe/latest/r10k_puppetfile.html"
description: "A guide to managing modules with the r10k Puppetfile, for code management with Puppet."
---

[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md

You'll manage your modules through the Puppetfile, in which you'll specify detailed information about what modules r10k should install and where it should install them.

## About the Puppetfile

The Puppetfile is a text file written in a Ruby-based DSL. This file specifies where r10k should install modules and what modules it should install, including which version of the module and where to fetch the modules from. This allows r10k to install modules into a given environment in your deployment, or it can install a specific set of Puppet modules for local development.

>**Note:** Puppetfiles do NOT include dependency resolution. You must make sure that you have every module needed for all of your specified modules to run.

After you edit the Puppetfile, you can perform Puppetfile operations from the command line through the [`r10k puppetfile`](#running-puppetfile-commands) subcommand. 

##Editing your Puppetfile

You'll need to create a text file called Puppetfile. In this file, you'll list the modules you want r10k to manage by using the **`mod`** setting. Optionally, you can also change the directory in which r10k installs your modules.

###Declaring modules in your Puppetfile

####`mod`

The `mod` setting specifies the module(s) that r10k should install. Specify the module [long name](/puppet/latest/reference/modules_publishing.html#a-note-on-module-names) in a string. You can specify the latest version, either with or without updating that version, or you can specify a particular version of a module to be maintained at that version.

**Install the latest version of the module, and then keep the module at that version:**

~~~
mod 'puppetlabs/apache'
mod 'adrienthebo/thebestmoduleever'
~~~

**Install a specific version, and then keep the module at that version:**

~~~
mod 'puppetlabs/apache', '0.10.0'
~~~

**Install the latest available version of a module, and then update that module:**

~~~
mod 'puppetlabs/apache', :latest
~~~

#####Declaring a Git repo as a module

You can also specify a Git repo that contains a Puppet module; r10k then copies that repo and uses it as a module. In this case, you can specify the module "version" by using the `ref`, `tag`, `commit`, and `branch` options.

* `ref`: Determines the type of Git object to check out. Can be used with a Git commit, branch reference, or a tag.
* `tag`: Directs r10k to clone the repo at a certain tag value.
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

**Install puppetlabs/apache and pin to the '8df51aa' commit:**

~~~
mod 'apache',
  :git    => 'https://github.com/puppetlabs/puppetlabs-apache',
  :commit => '8df51aa'
~~~

**Install puppetlabs/apache and track the 'proxy_match' branch:**

~~~
mod 'apache',
  :git    => 'https://github.com/puppetlabs/puppetlabs-apache',
  :branch => 'proxy_match'
~~~

###Changing the module installation directory

By default, r10k installs modules in a modules directory in the Puppetfile’s current directory. Optionally, you can point to another directory for module installation. You can specify either an absolute or a relative path in this setting.

~~~
mod 'puppetlabs/apache'
#installs the apache module into 'dirname/path/to/Puppetfile/modules/apache'
~~~

**Note:** If you use this setting, it should always come **before** any modules listed in the Puppetfile.

####To install modules to an absolute path:

~~~
moduledir '/etc/puppet/modules'

mod 'puppetlabs/apache'
#installs the apache module into '/etc/puppet/modules/apache'
~~~

####To install modules to a relative path:

~~~
moduledir 'thirdparty'

mod 'puppetlabs/apache' 
# installs the apache module into 'dirname/path/to/Puppetfile/thirdparty/apache'
~~~

After you've specified your modules in the Puppetfile, you're ready to [run r10k](running) or perform Puppetfile operations with the Puppetfile subcommands below.

##Running Puppetfile subcommands

After you've configured your Puppetfile, you'll be able to manage your modules via the `r10k puppetfile` subcommand. This subcommand must be run as the user with write access to that environment's `modules` directory (or the moduledir directory, if you specified a different modules directory in the Puppetfile). It interacts with the Puppetfile in the current working directory, so before running the subcommand, make sure you are in the directory of the Puppetfile you want to use. You can run the `r10k puppetfile` subcommand with following actions:

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

If the moduledir directory specified in the Puppetfile contains modules that are *not* specified in the Puppetfile, `purge` removes them.

~~~
r10k puppetfile purge
~~~

## Next Steps

Once you've set up your Puppetfile, you're ready to [deploy](running) your environments and modules.