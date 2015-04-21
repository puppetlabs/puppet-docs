---
layout: default
title: "Setting Up r10k"
canonical: "/pe/latest/r10k_setup.html"
description: "Setup of r10k with Puppet Enterprise for code management."
---

[environ_dir]: /puppet/4.0/reference/environments_configuring.html
[r10kmod]: https://forge.puppetlabs.com/zack/r10k
[setup]: ./r10k_setup.html
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md


R10k comes packaged with Puppet Enterprise (PE) 3.8, so you don't need to separately download or install it. 

Before you can get r10k set up, you'll need to make sure you have Git, a Git repository, and a supported version of Ruby.

##Installing Requirements

###1. Install/Upgrade Ruby

R10k supports the following Ruby versions:

    * 1.8.7 (POSIX minimum version)
    * 1.9.3 (Windows minimum version)
    * 2.0.0
    * 2.1.5

If you already have Ruby installed, make sure you are running one of the above versions. You can check what version you have by running `ruby --version`.

PE comes packaged with a compatible version of Ruby, if you need it.
 
###2. Install Git and create a repository

In order to use r10k, you must be using Git. If you do not have Git installed, [find out the best way to install it for your setup](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 

Once you've installed Git, [set up at least one repository](http://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) to act as a control repository for your code.

##Activating r10k

Once the requirements are met, you can activate r10k, but how you activate it will depend on your current situation:

1. [I've never used r10k and just installed PE 3.8.]()
2. [I was using r10k and just upgraded to PE 3.8 from an earlier version of PE.]()
3. [I was using the zack-r10k module and just upgraded to PE 3.8 from an earlier version of PE.]()
4. [I was using r10k with open source Puppet and just upgraded to PE 3.8.]()

###I am brand new to r10k and have a new installation of PE 3.8

If you've never installed or used r10k before and have just installed PE 3.8, you will find r10k all ready to go in the etc/puppetlabs/r10k directory. You're ready to configure directory environments in [r10k.yaml][r10kyaml] and modules in your [Puppetfile][puppetfile].

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

If you want to continue using the module with r10k, you can do so. Puppet Enterprise automatically installs the current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to prevent future upgrade issues. To do so:

1. Locate your current r10k.yaml file. It will likely be in the /etc/ directory.
2. Move your r10k.yaml file to the etc/puppetlabs/r10k directory.
3. Delete or rename the r10k.yaml file in /etc/ if it is still present. Otherwise, you will see the following warning:

  ~~~
  Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
  /etc/puppetlabs/r10k/r10k.yaml will be used.
  ~~~

###I was using r10k with open source Puppet and just upgraded to PE 3.8

Puppet Enterprise automatically installs the current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to prevent future upgrade issues. To get r10k ready to go with your Puppet Enterprise upgrade:

1. Move your r10k.yaml file from the /etc/ directory to the etc/puppetlabs/r10k directory.
2. Check that your specified [directory environments](environ_dir) in r10k.yaml are listed in puppet.conf.
3. Remove the r10k gem from opt/puppet, if it is still present there.
4. Delete or rename the r10k.yaml file in /etc if it is still present. Otherwise, you will see the following error:

  ~~~
  Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
  /etc/puppetlabs/r10k/r10k.yaml will be used.
  ~~~
  

After you've activated r10k, you're ready to configure directory environments in [r10k.yaml][r10kyaml] and modules in your [Puppetfile][puppetfile].