---
layout: default
title: "PE Deployment Guide"
subtitle: "First Steps: Setting Up Your Environment"
---


First Steps: Setting Up Your Environment
-----
Once you've completed installation and verified that all the parts are talking to each other, there are a few things you'll want to do to set up your working environment.
 
Puppet's manifests, as well as any modules, ENC's, etc. you are writing or modifying, should be treated like any other code under development, which is to say they should be version controlled, tested prior to release, and backed up frequently. Below we'll give you some suggestions for getting that done.

###Version Control
 
Typically, one central manifest is used to define the entire site, although that manifest (typically, `site.pp`) can refer to other manifests used by modules.

Editing your manifests "live", directly on the puppet master is a dangerous idea. You can lose functioning code or, worse, your half-written manifest could get published to your clients prematurely. To avoid this, we strongly recommend you use a version control system such as Git or Subversion to control development of your manifests. Generally speaking, we recommend Git and GitHub, but really any version control system will work. 

####Git Resources

A course in using Git is well beyond the scope of this guide, but there are many online tutorials, guides and other resources. Some of our favorites are: 
[Pro Git](http://kmkeen.com/mirror/progit.pdf), [Git+Immersion](http://gitimmersion.com) and the [tutorials on GitHub](http://learn.github.com/p/intro.html). If you prefer video, the author of *Pro Git*, Scott Chacon, has an excellent [presentation](http://www.youtube.com/watch?v=ZDR433b0HJY). There are also some applications that wrap Git in a GUI (e.g., GitX) if you feel more comfortable working that way. The [Git site](http://git-scm.com) has links to GUI tools for various platforms as well as tons of information on how to set up and use the tool.

####Git Workflows and Your Infrastructure

While there are many ways to map Git workflows to infrastructure, one of the most popular patterns is to set up Git branches to map to puppet [environments](http://docs.puppetlabs.com/guides/environment.html). In this scenario, a Git branch maps to a given environment. For example, you can set up Git branches to correspond to the development, testing and production environments favored by many company's workflows. You can even set things up to create environments dynamically as workflows change. For a detailed discussion and examples of this, refer to this [blog post on git workflows and puppet environments](http://puppetlabs.com/blog/git-workflow-and-puppet-environments/).

If you are already familiar with Git and have some workflows and branch structures in place already, you can probably just add in manifest control. There's no need to reinvent the wheel. If you're setting up version control for the first time, and the above example using environments is too involved, you can start with a basic set up as follows:



### Testing
There are several resources you can turn to in order to test your manifests and modules. At this stage of the game, we don't mean testing in the formal sense of unit tests, CI tests, etc. We simply mean making reality checks to make sure things are working in the way you want. So, first you'll want to pick out the nodes you're going to automate initially. Generally speaking, when you start to deploy PE, you'll want to begin with low-risk nodes that are not mission critical. There are few approaches you can take in selecting nodes.

 * One approach is to select a sub-set of nodes in, say, your development pool (as opposed to production servers). Identify configurations and services those nodes have in common and automate those things one by one. 
    
* Another approach is to spin up a new machine that is a generic version of some group of servers in your infrastructure (again, choose things at first that aren't mission critical). Gradually automate more and more of its configuration, checking as you go that it is working correctly. Gradually automate the configuration of services and applications, migrating data from existing servers as needed. Once you're satisfied everything is working correctly, you can cut over to the newly automated machine and go live with it. You can use some (or all) of the classes, manifests and modules you used for this machine as the groundwork for automating other categories of nodes.
    
* A third approach can actually let you get two things done. If you're like most sysadmins, you have a backlog of things people have asked you for that are not for essential purposes. For example, a team has asked you for a server to test some new tool on, or to try out some new database/application/file server. Build up this server using PE.

[This guide](http://docs.puppetlabs.com/guides/tests_smoke.html) will give you some basic ideas for simple smoke testing of manifests and modules. Below we'll briefly list a few tools and resources which can help you further test your PE implementation. For a more in-depth discussion, take a look at this [blog post on syntax checking and automated testing](http://puppetlabs.com/blog/verifying-puppet-checking-syntax-and-writing-automated-tests/).

However, all of that said, when you are first deploying puppet, your best bet is to rely heavily on modules you can get from [the Puppet Forge](http://forge.puppetlabs.com). Forge modules, especially those from frequent contributors or "Modules of the Week", are proven solutions for the most common things sysadmins need automate and they can save you a ton of time.

#### Noop
Don't overlook the power of the `noop` flag. Noop lets you do a dry run of puppet without actually doing anything. Instead, noop will sniff out catalog compilation errors and give you log output that shows what puppet would have done to what, when. To run in noop mode, add the `--noop` flag when running `puppet agent` or `puppet apply`. You will see the results of your run in the Console and in stdout.  

#### Puppet Parser
Puppet parser is another simple tool that lets you check the syntax of puppet code. You can run it manually to check a given file, for example, `puppet parser validate site.pp`. This will check the manifest file for correct syntax and will return errors showing which line(s), if any, contain syntax errors such as missing curly braces or other typos and mistakes. You can also integrate syntax checking into your text editor, as explained in the previously referenced [blog post](http://puppetlabs.com/blog/verifying-puppet-checking-syntax-and-writing-automated-tests/).

#### Puppet-lint
[Puppet lint](http://puppet-lint.com) is an easy to use style checker that runs through your manifests to ensure that they conform to puppet's style guide. It's available as a ruby gem. Install it by running `$ gem install puppet-lint`. You can learn more about puppet-lint from this [blog post](https://puppetlabs.com/blog/using-puppet-lint-to-save-yourself-from-style-faux-pas/).

#### Pre/Post Commit Hooks
Tools like Git or Subversion have hooks that allow you to run scripts before or after a commit. At minimum, you can use pre/post commit hooks to run puppet parser or puppet-lint automatically, but you will surely think of many more useful tests and other things to do with them. The Git site has [good information](http://git-scm.com/book/en/Customizing-Git-Git-Hooks) to help get you started.

#### `rspec-puppet`
Writing tests with rspec is probably beyond the scope of this guide and not something you'll want to tackle when you are first deploying PE. However, we mention it here so that when you move on to writing more complex manifests and/or your own modules you're aware of the tool and what it can do to help you write the best puppet code you can. If you're curious now, we recommend [this tutorial](http://rspec-puppet.com/tutorial/) to get you started.


### Backing Up
We really don't need to explain how or why you should back up your manifest and other files, but we will gently remind you to back up your SSL certificates along with everything else.
	    
### Organize Your Users
Figure out who at your institution should have access to PE and with what privileges. You can add and define users manually in the console, or you can access an existing directory via LDAP, etc. For more information, see the PE manual page on [user management](http://docs.puppetlabs.com/pe/2.7/console_auth.html).	Obviously, you should initially limit access to a select group, possibly a group of one.    

### Ad Hoc Change Tools

You'll want to have some kind of fall-back plan/tools for worst-case scenarios where something prevents you from controlling a machine with Puppet. In most cases, this simply means ensuring that you do nothing that would prevent you from SSHing into a given node and manually fixing whatever went wrong (e.g. with a DNS entry, a certificate, a root password, etc.). In addition to SSH, tools you might consider for this role include vintage things like Expect, Rsync, or even Telnet/FTP. As your skills with PE grow, you'll be able to consign these tools to the ashbin of history, but for worst case scenarios, just keep them in mind.

