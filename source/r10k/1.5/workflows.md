---
layout: default
title: "Deploying Code/Workflow"
---



Subsequent changes to the branches will be kept in sync on the filesystem by future r10k runs. You can read more about that in [running r10k][LINKW/REALNAME].

Finally, if there are directories that do not match existing branches, r10k will assume that the branches for those environments were delete and will remove those environments.

----

(https://github.com/puppetlabs/r10k/blob/master/doc/dynamic-environments/quickstart.mkd#summary)

This base will allow us to do all sorts of useful things. Most interesting (to me and for the purposes of this tutorial) is the ability to now utilize Git branches to help manage infrastructure as part of your software development lifecycle. Now, when you want to test a new profile, you can do the following:

Create a new branch of the Puppet code repository
Create your Puppet code in this new branch
Push the new branch up to the repository
Deploy it as a new environment using the r10k deploy environment -p command.
From any agent node (including the master), you may run the agent against the new environment by specifying it on the command line. For example, if you create the branch test, run puppet as:

puppet agent -t --environment test
You can also modify the /etc/puppet/puppet.conf file on a node and add the environment setting to the agent section to make the change permanent:

...
[agent]
environment = test
Voila - you're testing code without impacting your production environment!

----

(https://github.com/puppetlabs/r10k/blob/master/doc/common-patterns.mkd)

Common Patterns
This guide provides common patterns seen in the r10k community. These patterns are, of course, simply a guide. Understand why you are or are not using a specific pattern before implementing it.

Repository Setup

Use a Control Repo to store your Puppetfile.

Hiera data should be in the Control repo OR as a separate source in r10k.yaml. Any hiera.yaml in the Control repo will be ignored on a per environment basis, locating it at /etc/puppet/hiera.yaml is prefered.

Each puppet module should be contained in its own independent forge module or repository.

Editing modules

All environment content is checked out into $environmentpath/modules on the node r10k is run on, either your puppet master or each masterless node. Edits made directly to these files will be lost on the next deploy. It is best practice not to edit code on the production system in the production paths.

You may clone upstream repositories in a regular user's directory, on the master or on another machine. Create a new feature branch locally, make all required edits, and push the new branch upstream when ready for testing. R10k will deploy changes from the upstream repositories, eliminating the need for manual updates of the $environmentpath contents.

-----

(https://github.com/puppetlabs/r10k/blob/master/doc/dynamic-environments/workflow-guide.mkd)

R10k's dynamic deployments work best with a workflow that understands and respects how r10k works, to prevent automation and manual processes from conflicting. Your workflow will need to be customized to meet your team's skills, tools, and needs. This guide describes a generic workflow that can be customized easily.

This guide assumes that each of your modules is in a separate repository and that the Puppetfile is in its own repo called the Control Repo. All module repos have a primary branch of master and the Control's primary branch is production. All changes are made through r10k and no user makes manual changes to the environments under /etc/puppet.

Adding New Modules

This workflow is useful when adding a forge or internally-developed module to your puppet environment.

Create new feature branch

Create a new feature branch in your module repositories. Do this for each repository, including the control repository, that will reference the new module. You do not need to do so for modules that are not being edited.

git checkout -b feature

If you are simply adding the module at this time and not referencing it in other modules or manifests, only the Control repo requires a new branch.

Add new module and branches to control repo

The new module is added to the control repository's Puppetfile like so:

# Forge modules:
mod "puppetlabs/ntp"

# Your modules:
mod "custom_facts",
  :git => "git://github.com/user/custom_facts"
For any existing modules that you branched, add a reference to the new branch name. Don't forget the comma at the end of the :git value.

mod "other_module",
  :git => "git://github.com/user/other_module",
  :ref => "feature"
Reference new module in manifests, modules, and hiera

If you are simply adding the module at this time and not referencing it in other modules or manifests, you may skip this step.

Edit your existing manifests, modules, and hiera as needed to make sure of the new module.

Deploy environments

Save all your changes in each module repo. Commit and push the changes upstream:

git commit -a -m ‘Add feature reference to module’
git push origin feature
Commit and push the change in your control repo upstream:

git commit -a -m ‘Add module puppetlabs/ntp to branch feature'
git push origin feature
Finally, deploy the environments via r10k. This step must occur on the master:

r10k deploy environment -p

Add the -v option for verbosity if you need to troubleshoot any errors. The new branch should be located at $environmentpath/feature.

Test the new module branches

If you are simply adding the module at this time and not referencing it in other modules or manifests, you may skip this step.

Run the puppet agent against the new environment from at least two nodes, one that should not be impacted by change and one that should be impacted.

puppet agent -t --environment feature

Verify that catalog compilation succeeds and that you are satisfied that the effective changes match your expected changes. Repeat the steps above until you are satisfied with the results.

Merge changes

In each of the changed modules and the control repo, checkout the main branch, merge, and push changes to the master/production branch.

# Module repos
git checkout master
git merge feature
git push origin master

# Control repo
git checkout production
git merge feature
vi Puppetfile
# Remove all :ref's pointing to 'feature'. Don't forget the trailing commas
# on the :git statements
git commit -a -m 'Remove refs to feature branch for module puppetlabs/ntp'
git push origin production
If you are simply adding the module at this time and not referencing it in other modules or manifests, you are now finished.

Cleanup feature branches

You may skip this step for long-lived branches, however most feature branches should be short-lived and can be pruned once testing and merging is complete.

Remove the old branches in each repo:

git branch -D repo
git push origin :repo
Deploy via r10k on the master and ensure there are no errors. The feature dynamic environment will no longer exist at $environmentpath/feature if you deleted the branch in your Control repo.

r10k deploy environment -p

Editing existing Modules

When editing your own existing modules, this workflow should be followed.

Create new feature branches

Create a new feature branch in your module repositories. Do this in the edited module, the control repository, and in each module that will reference the updated module. You do not need to do so for modules that are not being edited.

git checkout -b feature

Update control repo to reference new branch

For all modules that you branched, add a reference to the new branch name to the Puppetfile in your Control repo. Don't forget the comma at the end of the :git value.

mod "other_module",
  :git => "git://github.com/user/other_module",
  :ref => "feature"
Modify existing module, references to module

Make the required changes to your existing module. Edit your existing manifests, modules, and hiera as needed to make sure of the updated module.

Deploy environments

Save all your changes in each modified repo. Commit and push the changes upstream:

git commit -a -m ‘Add feature reference to module’
git push origin feature
Commit and push the change in your control repo upstream:

git commit -a -m ‘Add module puppetlabs/ntp to branch feature'
git push origin feature
Finally, deploy the environments via r10k. This step must occur on the master:

r10k deploy environment -p

Add the -v option for verbosity if you need to troubleshoot any errors. The new branch should be located at $environmentpath/feature.

Test the new module branches

Run the puppet agent against the new environment from at least two nodes, one that should not be impacted by change and one that should be impacted.

puppet agent -t --environment feature

Verify that catalog compilation succeeds and that you are satisfied that the effective changes match your expected changes. Repeat the steps above until you are satisfied with the results.

Merge changes

In each of the changed module repos, checkout the main branch and merge.

# Module repos
git checkout master
git merge feature
git push origin master
In the Control repo, check out master. Do NOT merge the feature branch as it now references the incorrect branch for each git repo, and no other changes were made (unlike a new module, where a new repo is referenced).

# Control repo
git checkout master
Cleanup feature branches

You may skip this step for long-lived branches, however most feature branches should be short-lived and can be pruned once testing and merging is complete.

Remove the old branches in each repo:

git branch -D repo
git push origin :repo
Redeploy with r10k on the master and ensure there are no errors. The feature dynamic environment should no longer exist at $environmentpath/feature.

r10k deploy environment -p

Customize Your Workflow

This guide is very generic in nature. Use it as a template and expand and modify it to fit your team, your tools, and your company culture. Above all, be consistent in your methodology.


**Additional Things to Look At, Jean:**

* https://groups.google.com/forum/#!topic/puppet-users/20FSOyWiHdE (This discussion is evolving, so it might be useful or pointless.)
* Might be interesting? (https://groups.google.com/forum/#!topic/puppet-users/918j022z8u4)
* https://tickets.puppetlabs.com/browse/RK-31 (There are mentions of this throughout the docs, but it's worth a second check.)
    * This is just more of the above: https://github.com/puppetlabs/r10k/pull/356/files
* https://tickets.puppetlabs.com/browse/CODEMGMT-105 (This should be covered by the Puppetfile doc.)
* This might be a useful thing to have in the docs (https://github.com/puppetlabs/r10k/blob/master/doc/faq.mkd)
* UGH I HADN'T CONSIDERED THIS D: (http://johan.koewacht.net/puppet/2015/01/12/R10k-and-PE-Console.html)
* This needs to be looked into... I... I lost this ticket until today :( (https://tickets.puppetlabs.com/browse/RK-58)
* This is Brandon High's r10k setup if you find that helpful (https://github.com/highb/r10k-example) and the steps he followed (https://docs.google.com/a/puppetlabs.com/document/d/16PTtYOgKcLEOmM-a-Fxk1pjqP-2oVXy3t3_uIcla7k8/edit#heading=h.ob8rj3olwamn)