---
layout: default
title: "Setting Up r10k"
canonical: "/pe/latest/r10k_setup.html"
description: "Setup of r10k with Puppet Enterprise for code management."
---

[environ_dir]: /puppet/4.0/reference/environments_configuring.html
[r10kmod]: https://forge.puppetlabs.com/zack/r10k
[r10kyaml]: ./r10k_yaml.html
[puppetfile]: ./r10k_puppetfile.html
[running]: ./r10k_run.html
[reference]: ./r10k_reference.html
[r10kindex]: ./r10k.md


R10k comes packaged with Puppet Enterprise (PE) 3.8, so you don't need to separately download or install it.

To get started, you'll need to decide how r10k should communicate with Git, set up a repository for your code, and prepare r10k for configuration.

##Setting up Git

For r10k to work, it needs to be able to communicate with Git. You have two options for setting this up:

* Use Git installed on your system. This is the default for r10k.
* Use a Git library built into r10k. You don't have to install Git on your system for this method, but you do have to provide a private key.

###Use Git on Your System

1. If you do not have Git installed, [install it for your system](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 
2. After you've installed Git, [set up at least one repository](http://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) to act as a control repository for your code.

###Use Git Library in r10k

The Git library is already built into r10k, so you don't have to install Git on your system. You do need to [set up at least one repository](http://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) to act as a control repository for your code.

You don't have to do anything else with Git right now, but when you edit your [r10k.yaml](r10k_yaml) file, you'll need to specify 'rugged' in the [`git` parameter](./r10k_yaml#git) and provide your private_key file.

##Preparing r10k

You can now prepare r10k for configuration, but how you do that depends on your current situation:

* [I've never used r10k and just installed PE 3.8.](#i-am-brand-new-to-r10k-and-have-a-new-installation-of-pe-38)
* [I was using r10k and just upgraded to PE 3.8 from an earlier version of PE.](#i-was-using-r10k-with-an-earlier-version-of-pe-and-just-upgraded-to-pe-38)
* [I was using the zack-r10k module and just upgraded to PE 3.8 from an earlier version of PE.](#i-was-using-the-zack-r10k-module-and-just-upgraded-to-pe-38-from-an-earlier-version-of-pe)
* [I was using r10k with open source Puppet and just upgraded to PE 3.8.](#i-was-using-r10k-with-open-source-puppet-and-just-upgraded-to-pe-38)

###I Am Brand New to r10k and Have a New Installation of PE 3.8

If you’ve never installed or used r10k before and have just installed PE 3.8, r10k is already installed for you. You can move on to your next step: [create your own config file](r10k_yaml) for r10k in `/etc/puppetlabs/r10k/r10k.yaml`.

###I Was Using r10k With an Earlier Version of PE and Just Upgraded to PE 3.8

Puppet Enterprise automatically installs the current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to its new default location to prevent future upgrade issues. To do so:

1. Locate your current r10k.yaml file. It is likely in the `/etc/` directory.
2. Move your r10k.yaml file to the `/etc/puppetlabs/r10k/ directory.
3. Delete or rename the r10k.yaml file in `/etc/` if it is still present. Otherwise, you will see the following warning:

```
Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
/etc/puppetlabs/r10k/r10k.yaml will be used.
```

###I Was Using the zack-r10k Module With an Earlier Version of PE and Just Upgraded to PE 3.8

You have two choices: you can continue using the module or you can switch to r10k as it ships with Puppet Enterprise.

####Continue Using the Module

If you want to continue using the zack-r10k module with r10k, you can do so. The default location of r10k.yaml has changed, but in PE 3.8, r10k still reads `/etc/r10k.yaml`. To continue using the module, you should **not** move r10k.yaml to its new default location.

####Use the PE 3.8 Default r10k Configuration

If you want to use r10k as it ships with PE **without** the zack-r10k module, you should move r10k.yaml to its new default location to prevent future upgrade issues:

1. Locate your current r10k.yaml file. It is likely in the `/etc/` directory.
2. Move your r10k.yaml file to the `/etc/puppetlabs/r10k` directory.
3. Delete or rename the r10k.yaml file in `/etc/` if it is still present. Otherwise, you will see the following warning:

~~~
Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.
/etc/puppetlabs/r10k/r10k.yaml will be used.
~~~

###I Was Using r10k With Open Source Puppet and Just Upgraded to PE 3.8

Puppet Enterprise automatically installs the current PE version of r10k. However, the default location for r10k.yaml has changed, so we recommend moving it to its new default location to prevent future upgrade issues. 

Note that you should have uninstalled your open source r10k gem before you upgraded to PE. If you did not specifically do so before, you can uninstall the open source r10k gem from the system gem location now.

To get r10k ready to go with your Puppet Enterprise upgrade:

1. Move your r10k.yaml file from the `/etc/` directory to the `/etc/puppetlabs/r10k` directory.
2. Check that your specified [directory environments](environ_dir) in r10k.yaml are listed in puppet.conf.
3. Delete or rename the r10k.yaml file in `/etc/` if it is still present. Otherwise, you will see the following error:

~~~
Both /etc/puppetlabs/r10k/r10k.yaml and /etc/r10k.yaml configuration files exist.,
/etc/puppetlabs/r10k/r10k.yaml will be used.
~~~

## Next Steps

After you've prepared r10k, you're ready to configure [r10k.yaml][r10kyaml] and Puppet to use directory environments.