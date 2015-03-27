---
layout: default
title: "Configuring r10k"
---

[direnv]: /puppet/4.0/reference/environments.html
[direnv_setup]: /puppet/4.0/reference/environments_creating.html

[gettingstarted]: ./gettingstarted_r10k.html
[gettingtoknow]: ./index.html

#Configuring r10k

Configuring r10k is as easy as updating a .yaml file with the location of your Git repository (repo) information. This section will go through everything you need to configure r10k to your setup. 

* Continue reading to learn how to configure r10k.
* [See "Getting To Know r10k"][gettingtoknow] for basic information about r10k.
* [See "Getting Started with r10k"][gettingstarted] to get r10k up and running.
* [See "Mananaging Modules"][LINK] to learn how to set up your r10k Puppetfile.
* [See "Managing Environments"]


##Before You Begin

Before you begin configuring r10k, you will want to ensure that you have a Git repository (repo) with one branch per environment you would like to establish. 

>**Warning!** 
>
>If you are currently using [directory environments](direnv), skip immediately to ["Previous Directory Environment Configurations"](#previous-directory-environment-configurations). 


##Connect r10k and Git

R10k uses your existing Git repo's branches to create [directory environments]((direnv)). (Directory environments allow you to designate one node or node group as the development environment and another node or node group as the production environment.) As you continue submitting and pulling code to the Git repo, r10k tracks the state of the repo to keep each environment updated. 

Each branch of a connected repository is cloned into a directory named after the branch. For instance, if you have a repo named project1 with branches named: production, test, and, development, r10k will clone the production branch into a production directory, the test branch into a test directory, and the development branch into a development directory.

>**Warning:** When you connect a Git repo to r10k, it will create the directory and **erase** anything that was there before. If you already have directory environments set up, you must read ["Previous Directory Environment Configurations"](#previous-directory-environment-configurations) before you proceed.

In order to run successfully, r10k will need to be able to authenticate with each repo. (Most Git systems support authentication with SSH.)

###Edit r10k.yaml

You can entirely configure r10k through the r10k.yaml in etc/puppetlabs/r10k/. 

At a minimum, you must specify `cachedir` (the location for storing cached Git repos) and `sources` (the list of Git repos to use). You can use these keys to specify the path where you expect to find either the cache of your Git repo(s) or the directories of the environments being created from your repo's branches.

`cachedir` accepts a string containing a path to the directory where you want the cache of your Git repo(s) to be stored. `sources` accepts a hash where each key contained in the hash is the short name of a specific repo (for instance, "qa" or "web" or "ops") and the corresponding value is a hash of properties for that repo.

>Note:
>
>R10k will not check to make sure that different sources don't collide in a single base directory; if you are using multiple sources you are responsible for making sure that they do not overwrite each other. See the `prefix` option for assistance with this.

~~~
cachedir: '/var/cache/r10k'

sources:
  my-org:
    remote: 'git@github.com:$<GITHUB ORGANIZATION or GITSERVER>/$<GITHUB/GIT REPO NAME>'
    basedir: '/etc/puppetlabs/puppet/environments'
  mysource:
    remote: 'git@github.com:$<GITHUB ORGANIZATION or GITSERVER>/$<GITHUB/GIT REPO NAME>'
    basedir: '/etc/puppetlabs/puppet/environments'
~~~

You must make sure that `environmentpath` in your puppet.conf file should match the `basedir` setting in r10k.yaml.

You can also specify `postrun`, which will cause r10k to run a command after deploying all your environments. The command must be an array of strings that will be used as an argument vector, and you can't specify `postrun` more than one time in r10k.yaml.

~~~
postrun: ['/usr/bin/curl', '-F', 'deploy=done', 'http://my-app.site/endpoint']
The postrun setting can only be set once.
~~~

####Additional Options for `sources`

The `sources` key allows the options listed below. You can also implement additional Git-specific options, which you can learn more about through Git's documentation.

* `remote` - Specifies where the source repository should be fetched from. It may be any valid URL that the source may check out or clone. The remote must be able to be fetched without any interactive input, e.g. you cannot be prompted for usernames or passwords in order to fetch the remote.

~~~
sources:
  mysource:
    remote: 'git://git-server.site/my-org/main-modules'
~~~

* `basedir` - Specifies the path where environments will be created for this source. This directory will be entirely managed by r10k and any contents that r10k did not put there will be removed. 

~~~
sources:
  mysource:
    remote: 'git://git-server.site/my-org/main-modules'
    basedir: '/etc/puppet/environments'
~~~

* `prefix` - Allows environment names to be prefixed with the short name of the specified source. This prevents collisions when multiple sources are deployed into the same directory.

~~~
sources:
  mysource:
    basedir: '/etc/puppet/environments'
    prefix: true # All environments will be prefixed with "mysource_"
~~~

* `invalid_branches` - Specifies how branch names that cannot be cleanly mapped to Puppet environments **TODO: More clarity on how this works** are handled. This option accepts three values: 'correct_and_warn' is the default value and replaces non-word characters with underscores and issues a warning; 'correct' which replaces non-word characters with underscores without warning; and 'error' which ignores branches with non-word characters and issues an error.

~~~
sources:
  mysource:
    basedir: '/etc/puppetlabs/puppet/environments'
    invalid_branches: 'error'
~~~

Once you have listed each repo you would like to manage with r10k in r10k.yaml,  you are done configuring!

Subsequent changes to the branches will be kept in sync on the filesystem by future r10k runs. You can read more about that in [running r10k][LINKW/REALNAME].

###Previous Directory Environment Configurations

If you were using directory environments without r10k, you must make sure that any necessary files/code are either committed to the appropriate Git repo or backed up somewhere. Remember that r10k will name each new directory after the branch in your Git repo. **If your directory environment has the same name as the one r10k is creating, r10k will erase EVERYTHING in your previous directory.**
