---
layout: default
title: "Quick Start » Creating User and Group"
subtitle: "User/Group Quick Start Guide"
canonical: "/puppet/latest/quick_start_user_group.html"
---

Intro

## Create the User and Group

(Intro on making and controlling users and groups)

1. On your Puppet master, run `puppet apply -e "user { jargyle: ensure => 'present', }"`. The result should show, in part, `Notice: /Stage[main]/Main/User[jargyle]/ensure: created`.
2. On your Puppet master, run `puppet apply -e "group { web: ensure => 'present', }"`. The result should show, in part, `Notice: /Stage[main]/Main/Group[web]/ensure: created`.

> That's it! You've successfully created the Puppet user `jargyle` and the Puppet group `web`. 

## Add the User and Group to the Main Manifest

(Intro)

1. From the CLI of your Puppet master, run `puppet resource -e group web`. It should return the following Puppet code in the form of a file in your text editor:

			group { 'web':
  			  ensure => 'present',
  			  gid    => '502',
			}
			
2. Copy the code, then save and exit the file.
3. Navigate to your main manifest (`cd /etc/puppetlabs/code/environments/production/manifests`).
4. Paste the code you got from running `puppet resource -e group web` into your default node, then save and exit.
5. From the CLI of your Puppet master, run `puppet parser validate site.pp` to ensure that there are no errors. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file again and fix the problem before continuing.
6. From the CLI of your Puppet agent, use `puppet agent -t` to trigger a Puppet run.
7. From the CLI of your Puppet master, run `puppet resource -e user jargyle`. It should return the following Puppet code in the form of a file in your text editor:

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

8. Edit the file by adding the following Puppet code to it:

			comment           => 'Judy Argyle',
			groups            => 'web',

9. **Delete** the following Puppet code from the jargyle user:

			  gid              => '501',
		
10. Copy all of the code, then save and exit the file.
11. Paste the code you got after editing `puppet resource -e user jargyle` into your default node, then save and exit.
12. From the CLI of your Puppet master, run `puppet parser validate site.pp` to ensure that there are no errors. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file again and fix the problem before continuing.
13. From the CLI of your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

> Success! You have created a group, `web`, and a user, `jargyle`, and added jargyle to the group with `groups => web`. 

(Final notes)