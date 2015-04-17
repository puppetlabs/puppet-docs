---
layout: default
title: "Setting Up r10k"
canonical: "/pe/latest/r10k_setup.html"
description: "Installation and setup of r10k, a Puppet code management tool."
---

[environ_dir]: /puppet/4.0/reference/environments_configuring.html
[r10kmod]: https://forge.puppetlabs.com/zack/r10k
[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md


#Setting Up r10k

R10k comes packaged with Puppet Enterprise (PE) 3.8, so you don't need to separately download or install it. 

Before you can activate r10k, you'll need to make sure you have Git, a Git repository, and a supported version of Ruby.

* Continue reading to learn how to install requirements and activate r10k.
* [See "Getting To Know r10k"][index] for basic information about r10k.
* [See "Configuring r10k.yaml"][r10kyaml] to learn how to set up directory environments with r10k.
* [See "Configuring the Puppetfile"][puppetfile] to learn how to set up your r10k Puppetfile.
* [See "Running r10k"][running] to learn how to deploy r10k.
* [See "r10k Reference"][reference] for a list of r10k subcommands.

##Installing Requirements

#####1. Install/Upgrade Ruby
R10k supports the following Ruby versions:

    * 1.8.7 (POSIX minimum version)
    * 1.9.3 (Windows minimum version)
    * 2.0.0
    * 2.1.5

If you already have Ruby installed, make sure you are running one of the above versions. You can check what version you have by running `ruby --version`.

PE comes packaged with a compatible version of Ruby, if you need it.
 
#####2. Install Git and create a repository

In order to use r10k, you must be using Git. If you do not have Git installed, [find out the best way to install it for your setup](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 

Once you've installed Git, [set up at least one repository](http://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) to act as a control repository for your code.

##Activating r10k

Once the requirements are met, you can activate r10k, but how you activate it will depend on your current situation:

1. [I've never used r10k and just installed PE 3.8.]()
2. [I was using r10k and just upgraded to PE 3.8 from an earlier version of PE.]()
3. [I was using the zack-r10k module and just upgraded to PE 3.8 from an earlier version of PE.]()
4. [I was using r10k with open source Puppet and just upgraded to PE 3.8.]()

###I am brand new to r10k and have a new installation of PE 3.8

If you've never installed or used r10k before and have just installed PE 3.8, you will find r10k all ready to go in the etc/puppetlabs/r10k directory. You can move on to [].

###I was using r10k with an earlier version of PE and just upgraded to PE 3.8

Puppet Enterprise will automatically install the current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to prevent future upgrade issues. To do so:

1. Locate your current r10k.yaml file. It will likely be in the /etc/ directory.
2. Move your r10k.yaml file to the etc/puppetlabs/r10k directory.
3. Delete or rename the r10k.yaml file in /etc/ if it is still present. Otherwise, you will see the following warning:

  ~~~
  Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
  /etc/puppetlabs/r10k/r10k.yaml will be used.
  ~~~

###I was using the zack-r10k module with an earlier version of PE and just upgraded to PE 3.8

If you want to continue using the module with r10k, you can do so. Puppet Enterprise will automatically install the current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to prevent future upgrade issues. To do so:

1. Locate your current r10k.yaml file. It will likely be in the /etc/ directory.
2. Move your r10k.yaml file to the etc/puppetlabs/r10k directory.
3. Delete or rename the r10k.yaml file in /etc/ if it is still present. Otherwise, you will see the following warning:

  ~~~
  Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
  /etc/puppetlabs/r10k/r10k.yaml will be used.
  ~~~

###I was using r10k with open source Puppet and just upgraded to PE 3.8

Puppet Enterprise will automatically install the most current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to prevent future upgrade issues. To do so:

1. Move your r10k.yaml file from the /etc/ directory to the etc/puppetlabs/r10k directory.
2. Check that your specified [directory environments](environ_dir) in r10k.yaml are listed in puppet.conf.
3. Delete or rename the r10k.yaml file in /etc if it is still present. Otherwise, you will see the following error:

  ~~~
  Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
  /etc/puppetlabs/r10k/r10k.yaml will be used.
  ~~~
  

After you've activated r10k, you're ready to configure it by editing your [r10k.yaml][r10kyaml] and your [Puppetfile][puppetfile].