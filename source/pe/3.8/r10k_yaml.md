---
layout: default
title: "Setting Up Directory Environments in r10k.yaml"
canonical: "/pe/latest/r10k_yaml.html"
description: "A guide to configuring environments in the r10k.yaml file, for r10k code management with Puppet."
---

[direnv]: /puppet/4.0/reference/environments.html
[direnv_setup]: /puppet/4.0/reference/environments_creating.html
[setup]: ./r10k_setup.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md

To configure environments in r10k, you'll need to edit the r10k.yaml file with information about your Git repository and directory environments location. This section goes through everything you need to configure r10k to your setup.

##Before You Begin

Before you begin configuring r10k, you want to ensure that you have a control repository in Git, with one branch for each environment that you want to establish.

>**Warning!**
>
>If you are currently using [directory environments][direnv], skip immediately to ["Previous Directory Environment Configurations"](#previous-directory-environment-configurations).

##r10k and Git

R10k uses your existing Git repository (repo) branches to create [directory environments][direnv]. Environments allow you to designate a node or node group as a specific environment; for example, you could designate one node group as the development environment and another as the production environment. As you update the code in your control repo, r10k tracks the state of that repo to keep each environment updated.

Each branch of a connected repository is copied into a directory named after the branch. For instance, if your control repo is called "myenvironments", with branches named "production", "test", and "development", r10k copies the production branch into a production directory, the test branch into a test directory, and the development branch into a development directory.

>**Warning:** When you connect a Git repo to r10k, r10k creates the directories in the directory environments location you specified in r10k.yaml, and **erases** anything that was there before. If you already have directory environments set up, you must read ["Previous Directory Environment Configurations"](#previous-directory-environment-configurations) before you proceed.


##Editing r10k.yaml

To connect r10k and Git, you'll edit the r10k.yaml file in `/etc/puppetlabs/r10k/`. In order to run successfully, r10k needs to be able to authenticate with each repo. (Most Git systems support authentication with SSH.)

At a minimum, you must specify `cachedir` (the location for storing cached Git repos) and `sources` (the list of Git repos to use). You can use these keys to specify the path where you expect to find either the cache of your Git repo(s) or the directories of the environments being created from your repo's branches.

###`cachedir`

Accepts a string containing a path to the directory where you want the cache of your Git repo(s) to be stored; for example, `/var/cache/r10k` is typical.

###`sources`

Accepts a hash where each key contained in the hash is the short name of a specific repo (for instance, "qa" or "web" or "ops") and the corresponding value is a hash of properties for that repo. [Additional options](#additional-options-for-sources) for `sources` are listed below.

>Note: R10k does not check to make sure that different sources don't collide in a single base directory; if you are using multiple sources you are responsible for making sure that they do not overwrite each other. See the [`prefix`](#prefix) option for assistance with this.

~~~
cachedir: '/var/cache/r10k'

sources:
  my-org:
    remote: 'git@github.com:username1/myenvironments'
    basedir: '/etc/puppetlabs/puppet/environments'
  mysource:
    remote: 'git@github.com:username2/myenvironments'
    basedir: '/etc/puppetlabs/puppet/environments'
~~~

Note that for your new directory environments to be accessible to Puppet, you **must** make sure that `environmentpath` in your puppet.conf file matches the [`basedir`](#basedir) setting in r10k.yaml.

###`postrun`

An optional setting that causes r10k to run a command after deploying all of your environments. The command must be an array of strings that is used as a command line program and its arguments. You can't specify `postrun` more than one time in r10k.yaml.

~~~
postrun: ['/usr/bin/curl', '-F', 'deploy=done', 'http://my-app.site/endpoint']
# The postrun setting can only be set once.
~~~

###`git`

An optional hash containing Git specific settings. You can specify what Git provider you want to use with the `provider` option. This option accepts two values: 'rugged' and 'shellgit'. The default provider for r10k is shellgit, which maintains compatibility with existing r10k installations.

~~~
git:
  provider: shellgit
~~~

If you specify the rugged provider, you must provide a private key. You can also provide an optional 'username' when the Git remote URL does not provide a username. The rugged provider also requires Ruby 1.9 or greater.

~~~
git:
  provider: rugged
  private_key: '/root/.ssh/id_rsa'
  username: 'git'
~~~


###Additional options for `sources`

The `sources` key allows the options listed below. You can also implement additional Git-specific options, which you can learn more about through Git's documentation.

####`remote`

Specifies where the source repository should be fetched from. It can be any valid URL that r10k can check out or clone for this source. The remote must be able to be fetched without any interactive input; e.g., you cannot be prompted for usernames or passwords in order to fetch the remote.

~~~
sources:
  mysource:
    remote: 'git://git-server.site/my-org/main-modules'
~~~

####`basedir`

Specifies the path where environments will be created for this source. This directory is entirely managed by r10k, and any contents that r10k did not put there will be removed. Make sure that `environmentpath` in your puppet.conf file matches the `basedir` setting in r10k.yaml, or Puppet won't be able to access your new directory environments.

~~~
sources:
  mysource:
    remote: 'git://git-server.site/my-org/main-modules'
    basedir: '/etc/puppet/environments'
~~~

####`prefix`

Allows environment names to be prefixed with a short string specified by this source. If `prefix` is set to 'true', the source's name will be used. If `prefix` is a string, then this string is prefixed to the names of the environments. This prevents collisions when multiple sources are deployed into the same directory.

~~~
sources:
  myorg:
    remote: 'git://git-server.site/myorg/main-modules'
    basedir: '/etc/puppetlabs/puppet/environments'
    prefix: true # All environments will be prefixed with "myorg_"
  mysource:
    remote: 'git://git-server.site/mysource/main-modules'
    basedir: '/etc/puppetlabs/puppet/environments'
    prefix: 'testing' # All environments will be prefixed with "testing_"
~~~

####`invalid_branches`

Specifies how branch names that cannot be cleanly mapped to Puppet environments are handled. This option accepts three values:

* 'correct_and_warn' is the default value and replaces non-word characters with underscores and issues a warning.
* 'correct' replaces non-word characters with underscores without warning.
* 'error' ignores branches with non-word characters and issues an error.

~~~
sources:
  mysource:
    basedir: '/etc/puppetlabs/puppet/environments'
    invalid_branches: 'error'
    remote: 'git://git-server.site/mysource/main-modules'
~~~

###Previous Directory Environment Configurations

If you were using directory environments without r10k, you must make sure that any necessary files or code are either committed to the appropriate Git repo or backed up somewhere. The directory environments location is entirely managed by r10k, and any contents that r10k did not put there will be **removed**.

Remember that r10k names each new directory after the branch in your Git repo. **If your directory environment has the same name as the one r10k is creating, r10k will erase EVERYTHING in your previous directory.**


###zack-r10k module

The [zack-r10k](https://forge.puppetlabs.com/zack/r10k) module provides some help with configuring r10k. If you choose to use the zack-r10k module, be aware that use of this module is beyond the scope of PE 3.8.

Note that the zack-r10k module does not support SLES.

## Next Steps

Once you've listed each repo you want to manage with r10k in r10k.yaml, you're ready to specify your modules in your Puppetfile. If you've already done that, then you're ready to [run r10k][running] to sync your environments.

