---
layout: default
title: "Getting Started with r10k"
---

[environ_dir]: /puppet/4.0/reference/environments_configuring.html

#Getting Started with r10k

You do not need to download or install r10k, as it now comes packaged with Puppet Enterprise (PE) 3.8. 

Before you can get started with r10k, you'll need to make sure you've met the requirements.

##Requirements

#####1. Install/Upgrade Ruby
R10k supports the following Ruby versions:

    * 1.8.7 (POSIX minimum version)
    * 1.9.3 (Windows minimum version)
    * 2.0.0
    * 2.1.5

If you already have Ruby installed, please make sure you are running one of the above versions. You can check what version you have by running `$ ruby --version`.

PE comes packaged with a compatible version of Ruby, if you need it.
 
#####2. Install Git and create a repository

In order to use r10k, you must be using Git. If you do not have Git installed, [find out the best way to install it for your setup](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 

Once you've installed Git, you will need to [set up at least one repository](http://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) (repo).


##Activating r10k

Once the requirements are met, all you have left to do is activate r10k, but how you activate it will depend on your current situation:

1. [I've never used r10k and I just installed PE 3.8.]()
2. [I was using r10k and just upgraded to PE 3.8 from an earlier version of PE.]()
3. [I was using the acidprime-r10k module and just upgraded to PE 3.8 from an earlier version of PE.]()
4. [I was using r10k with Open Source Puppet and just upgraded to PE 3.8.]()

###I am brand new to r10k and have a new installation of PE 3.8

If you have never installed or used r10k before and have just installed PE 3.8, you will find r10k all ready to go in the etc/puppetlabs/r10k directory. You can move on to [].

###I was using r10k with an earlier version of PE and just upgraded to PE 3.8

You have two options: keep using Open Source r10k as it is already set up or switch the the version of r10k packaged with PE 3.8.

To get r10k ready to run with PE 3.8, you will need to:

1. Move your r10k.yaml file from the /etc/ directory to the etc/puppetlabs/r10k directory.
2. Remove the r10k gem from opt/puppet. (This step is recommended but not required.)
3. Double check that your specified [directory environments](environ_dir) in r10k.yaml are listed in puppet.conf.
4. Delete or rename the r10k.yaml file in /etc if it is still present. Otherwise, you will see the following error:

~~~
Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
/etc/puppetlabs/r10k/r10k.yaml will be used.
~~~

###I was using the acidprime-r10k module with an earlier version of` PE and just upgraded to PE 3.8

You have two options: keep using the module or switch the the version of r10k packaged with PE 3.8. If you want to switch, you need to: 

1. Locate your current r10k.yaml file. It will likely be in the /etc/ directory.
2. Move your r10k.yaml file to the etc/puppetlabs/r10k directory.
3. Remove the r10k gem from opt/puppet. (This step is recommended but not required.)
4. Delete or rename the r10k.yaml file in /etc/ if it is still present. Otherwise, you will see the following error:

~~~
Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
/etc/puppetlabs/r10k/r10k.yaml will be used.
~~~

If you would like to keep using the module, you will need to check the module's documentation for how to ensure it's compatibile with PE 3.8.

###I was using r10k with Open Source Puppet and just upgraded to PE 3.8

You have two options: keep using Open Source r10k as it is already set up or switch the the version of r10k packaged with PE 3.8.

To get r10k ready to run with PE 3.8, you will need to:

1. Move your r10k.yaml file from the /etc/ directory to the etc/puppetlabs/r10k directory.
2. Remove the r10k gem from opt/puppet. (This step is recommended but not required.)
3. Double check that your specified [directory environments](environ_dir) in r10k.yaml are listed in puppet.conf.
4. Delete or rename the r10k.yaml file in /etc if it is still present. Otherwise, you will see the following error:

~~~
Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
/etc/puppetlabs/r10k/r10k.yaml will be used.
~~~
