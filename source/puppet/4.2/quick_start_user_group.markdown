---
layout: default
title: "Quick Start » Creating Users and Groups"
subtitle: "Users and Groups Quick Start Guide"
canonical: "/puppet/latest/quick_start_user_group.html"
---

## Before you begin 

> **Prerequisites**: This guide assumes you've already [installed Puppet](https://docs.puppetlabs.com/puppetserver/2.1/install_from_packages.html), and have installed at least one [*nix agent](https://docs.puppetlabs.com./install_linux.html).

> For this  walk-through, log in as root or administrator on your nodes.

## Create a User and Group

Puppet uses some defaults for unspecified user and group attributes, so all you'll need to do to create a new user and group is set the 'ensure' attribute to 'present'. This 'present' value tells Puppet to check if the resource exists on the system, and to create the specified resource if it does not.

1.  To create a user named `jargyle`, on your Puppet master, run `puppet apply -e "user { 'jargyle': ensure => present, }"`. The result should show, in part, `Notice: /Stage[main]/Main/User[jargyle]/ensure: created`.

2.  To create a group named `web`, on your Puppet master, run `puppet apply -e "group { 'web': ensure => present, }"`. The result should show, in part, `Notice: /Stage[main]/Main/Group[web]/ensure: created`.

> That's it! You've successfully created the Puppet user `jargyle` and the Puppet group `web`. 

## Add the Group to the Main Manifest

1. From the command line on your Puppet master, run `puppet resource -e group web`. This opens a file in your text editor with the following content:

			group { 'web':
  			  ensure => 'present',
  			  gid    => '502',
			}
			
	>**Note**: Your gid (the group ID) might be a different number than the example shown in this guide.
			
2. Copy the lines of code, and save and exit the file.

3. Navigate to your main manifest: `cd /etc/puppetlabs/code/environments/production/manifests`.

4. Still using the Puppet master, paste the code you got from Steps 1 and 2 into the default node `site.pp`, then save and exit.

5. From the command line on your Puppet master, run `puppet parser validate site.pp` to ensure that there are no errors. The parser will return nothing if there are no errors. 

6. From the command line on your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

> That's it! You've successfully added your group, `web`, to the main manifest.

## Add the User to the Main Manifest

1. From the command line on your Puppet master, run `puppet resource -e user jargyle`. This opens a file in your text editor with the following content:

			user { 'jargyle':
 			  ensure           => 'present',
			  gid              => '501',
			  home             => '/home/jargyle',
			  password         => '!!',
			  password_max_age => '99999',
			  password_min_age => '0',
			  shell            => '/bin/bash',
			  uid              => '501',
			}

	>**Note**: Your uid (the user ID), or gid (the group ID) might be different numbers than the examples shown in this guide.

8. Add the following Puppet code to the file:

			comment           => 'Judy Argyle',
			groups            => 'web',

9. **Delete** the following Puppet code from the file:

			  gid              => '501',
		
10. Copy all of the code, and save and exit the file.

11. Paste the code from Step 10 into your default node in `site.pp`. It should look like this:

			user { 'jargyle':
 			  ensure           => 'present',
			  home             => '/home/jargyle',
			  comment           => 'Judy Argyle',
			  groups            => 'web',
			  password         => '!!',
			  password_max_age => '99999',
			  password_min_age => '0',
			  shell            => '/bin/bash',
			  uid              => '501',
			}

12. From the command line on your Puppet master, run `puppet parser validate site.pp` to ensure that there are no errors. The parser will return nothing if there are no errors. 

13. From the command line on your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

> Success! You have created a user, `jargyle`, and added jargyle to the group with `groups => web`. 
> For more information on users and groups, check out the documentation for Puppet resource types regarding [users](https://docs.puppetlabs.com/puppet/latest/type.html#user) and [groups](https://docs.puppetlabs.com/puppet/latest/type.html#group).
> With users and groups, you can assign different permissions for managing Puppet. 

---------
Next: [Hello, World!](./quick_start_helloworld.html)
