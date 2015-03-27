---
layout: default
title: "Puppetfile"
---

The Puppetfile is a text file written in a Ruby-based DSL that specifies a list of modules to install, including a specific version and where to fetch them from. There are two uses for Puppetfiles within r10k:

1. Install a specific set of Puppet modules for local development, or 
2. For use within r10k environment deployments to install additional modules into a given environment.

>**Note:**
>
>Puppetfiles do NOT include dependency resolution. You must make sure that you have every module needed for all of your modules to run listed.

You interact with Puppetfiles directly and though the `r10k puppetfile` subcommand. Technically, because the Puppetfile format uses a Ruby DSL, any valid Ruby expression can be used. We strongly suggest keeping it simple and using the subcommand, as all our examples will demonstrate. 

##File Structure

The Puppetfile has the following global settings that are used to control how the Puppetfile installs and handles modules:

`forge`
: You should not edit this setting. It specifies which server Forge-based modules are fetched from, but is currently a no-op.

`moduledir`
: Specifies the directory where modules will be installed. Defaults to the current directory of the Puppetfile. You can specify an absolute path and the modules will be installed there, otherwise the `moduledir` setting treated as relative to the directory of the Puppetfile.

**Note:**The moduledir setting should be placed before any modules are declared.

To install modules to an absolute path:

~~~
moduledir '/etc/puppet/modules'

mod 'puppetlabs/apache' # will be installed into '/etc/puppet/modules/apache'
~~~

To install modules to a relative path:

~~~
moduledir 'thirdparty'

mod 'puppetlabs/apache' # will be installed into 'dirname/path/to/Puppetfile'/thirdparty/apache
~~~

`mod`
: The name(s) of the module(s) to install.

~~~
mod 'puppetlabs/apache'
mod 'adrienthebo/thebestmoduleever'
~~~


##Actions

The `r10k puppetfile` subcommand will interact with the Puppetfile in the current working directory. The subcommand needs to be run as the user with write access to the puppet environmentpathThe `r10k puppetfile` subcommand has several *actions*. Before running the subcommand with any of the below actions, make sure you are in the current working directory of the Puppetfile you would like to interact with.

`install`
: Install or update all modules in a given Puppetfile into ./modules.

~~~
r10k puppetfile install
~~~

`check`
: Verify the Puppetfile syntax.

~~~
r10k puppetfile check
~~~

`purge`
: Remove any modules in the ./modules directory that are not specified in the Puppetfile.

~~~
r10k puppetfile purge
~~~

##Using a Git Repo as a Module

A Git repo that contains a Puppet module can be cloned and used as a module. You can specify the module "version" by using `ref`, `tag`, `commit`, and `branch` options.

* `ref` - Determines the type of Git object to check out. Can be used with a Git commit, branch reference, or a tag.
* `tag` - Directs r10k to clone the repo at a certain tag number.
* `commit` - Directs r10k to clone the repo at a certain commit.
* `branch` - Specifies a certain branch of the repo to clone.


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

To use the Puppet module tool (PMT) to install modules with r10k, specify the [long name](/puppet/latest/reference/modules_publishing.html#a-note-on-module-names) of the module in the `mod` setting of the Puppetfile. Specify the module name in a string, and if you would like a specific module, you can also specify the version in another string. If you do not specify a version, the latest version of the module available at the time is installed and kept at that version.

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