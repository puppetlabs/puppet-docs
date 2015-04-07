---
layout: default
title: "Getting To Know r10k"
---

[direnv]: /puppet/4.0/reference/environments.html
[gettingstarted]: ./gettingstarted_r10k.html
[configuring]: ./configuring_r10k.html

R10k does two simple but valuable things. First, it installs Puppet modules using an  authoritative, standalone list ([Puppetfile](#puppetfile)) that you create for it. Second, r10k creates and manages [directory environments][direnv] based on the branches in your Git repository.

* Continue reading to learn a little more about the basics of r10k, Puppetfile, and Git-based directory environments.
* [See "Getting Started with r10k"][gettingstarted] to get r10k up and running.
* [See "Configuring r10k"][configuring] to learn how to set up directory environments with r10k.
* [See "Mananaging Modules"][LINK] to learn how to set up your r10k Puppetfile.
* [See "Managing Environments"]

##r10k Basics

The primary purpose and benefit of r10k is that it provides a localized place in Puppet for you to manage the configuration of various environments (such as production, development, or testing), including what specific versions of modules are in each of your environments, based on code in branches of one or more Git repositories. R10k accomplishes this by seamlessly connecting the code in your Git repository's branches with the Puppet environments it has created based on those branches. So the work you do in Git is reflected in your Puppet configuration!

In PE 3.8, r10k comes built-in, meaning you can find everything you need in the etc/puppetlabs/r10k/ directory. You'll interact with r10k in three primary ways: through the [r10k.yaml](#r10kyaml) (for [configuring][configuring] your directory environments), through the command line (for [running][PAGE] r10k), and through the [Puppetfile](#) (for [managing][PAGE] your modules).

###r10k.yaml
The yaml file is where you tell r10k where to find the Git repository you'd like to use to create your directory environments. You will find your r10k.yaml file in etc/puppetlabs/r10k/. You will also find r10kexample.yaml**TODO: True name?**, which will show you how a basic r10k.yaml file should look.

###Puppetfile
Puppetfiles are text files, written in a Ruby-based DSL, that specify a list of modules to install, what version to install, and where to fetch them from. R10k can use a Puppetfile to install a set of Puppet modules for local development, or you can use Puppetfiles with r10k environment deployments to install additional modules into a given environment.