---
layout: default
title: "Environments: Suggestions for Use"
canonical: "/puppet/latest/environments_suggestions.html"
---

[adrien_blog]: http://puppetlabs.com/blog/git-workflow-and-puppet-environments
[directory_environments]: ./environments.html

The main uses for environments tend to fall into a few categories. A single group of admins might use several of them for different purposes.

## Permanent test environments

In this pattern, you have a relatively stable group of test nodes in a permanent `test` environment, where all changes must succeed before they can be merged into your production code.

The test nodes probably closely resemble the whole production infrastructure in miniature. They might be short-lived cloud instances, or longer-lived VMs in a private cloud. They'll probably stay in the `test` environment for their whole lifespan.

## Temporary test environments

In this pattern, developers and admins can create temporary environments to test out a single change or group of changes. This usually means doing a fresh checkout from your version control into the `$codedir/environments` directory, where it will be detected as a new environment. These environments might have descriptive names, or might just use the commit IDs from the version of the code they're based on.

Temporary environments are good for testing individual changes, especially if you need to iterate quickly while developing them. Since it's easy to create many of them, you don't have to worry about coordinating with other developers and admins the way you would with a monolithic `test` environment; everyone can have a personal environment for their current development work.

Once you're done with a temporary environment, you can delete it. Usually, the nodes in a temporary environment will be short-lived cloud instances or VMs, which can be destroyed when the environment ends; otherwise, you'll need to move the nodes back into a stable environment.


## Divided infrastructure

If parts of your infrastructure are managed by different teams that don't need to coordinate their code, it may make sense to split them into environments.
