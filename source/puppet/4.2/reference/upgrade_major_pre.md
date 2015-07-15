---
layout: default
title: "Puppet 3.x to 4.x: Get Upgrade-Ready"
canonical: "/puppet/latest/reference/upgrade_major_pre.html"
---

(
intro paragraph about how
- this is a major version jump
- the safest and most predictable way to do that is to split it into smaller tasks, where you can confirm everything's fine at the end of each one.
    - you can do something else if you want, but this is the way we recommend.
- this page has the steps to do before actually upgrading to Puppet 4.
)



## Upgrade/Migrate to Latest Puppet 3.8.x, Server 1.1.x, and PuppetDB 2.3.x

(
- Upgrade Puppet Server to the latest 1.1.x release.
- Upgrade Puppet across your deployment to the latest 3.8.x release.
- If you're still using a Rack-based Puppet master (like Apache with Passenger), migrate to Puppet Server now. (insert link to Puppet Server install guide)
    - Reminder that your goal here is to take these big changes one by one, and moving from Rack to Server is a biggish change.
    - You might have to adjust the memory Puppet Server uses. (link to that in the Puppet Server install page)
    - If you run multiple puppet masters with a single CA, you'll need to edit bootstrap.cfg to turn off the CA service, and make sure you're routing traffic to the appropriate node with a load balancer or with the agents' `ca_server` setting.
- Upgrade PuppetDB to the latest 2.3.x release, and the puppetdb terminus on your Puppet Server node to the same release.
    - This is actually all about the terminus package -- the 2.3.x package installs the termini in two places, so the server will still be able to find it after you upgrade. Puppet Server will be fine regardless, but you should always run the same versions of DB and the terminus.
)


## Check for Deprecated Features

Read the entire [list of deprecated features in Puppet 3.8](/puppet/3.8/reference/deprecated_summary.html), and determine whether you're using any of them.

All of these features are gone in 4.x. If you're using any of them, follow the advice for migrating away from them.

## Stop Stringifying Facts; Check for Breakage

Puppet 4.x always uses proper data types for facts, but Puppet 3.x's default behavior is to convert all facts to strings. If any of your modules or manifests rely on this behavior, you'll need to fix them now.

If you have already set `stringify_facts = false` in puppet.conf on every node in your deployment, skip to the next step. Otherwise:

* Check your Puppet code for any comparisons that _treat boolean facts like strings._ (For example, `if $::is_virtual == "true" {...}`.) Fix them so they'll work with true boolean values.
    * If you need to support 4.x and 3.x with the same code, you can use something like `if str2bool("$::is_virtual") {...}`.
* Next, set `stringify_facts = false` in puppet.conf on every node in your deployment. (If you want to use Puppet to change this setting, you can use an [`inifile` resource](https://forge.puppetlabs.com/puppetlabs/inifile).)
* Keep an eye on the next set of runs to make sure you didn't miss any problems in your code.


## Enable Directory Environments; Move Code Around if Necessary

(link to ./environments.html)

(Note that you might have already done this.)

(explain that directory environments are the only way to organize code in Puppet 4+.)

(if you don't use environments, move everything into the default `production` environment.)

## Enable the Future Parser; Fix Code if Necessary

(capsule description:
    - to change it per environment, set parser = future in environment.conf in a test environment. Run nodes in the test environment and make sure they still get good catalogs.
    - once you think it's cool, set parser = future in puppet.conf on all puppet master nodes to make the change global.
link to docs on enabling future parser (in 3.8) and list of gotchas, should all be on that experiments_future page?
    - some of the big ones include quoting file modes, etc.
link to future language docs as of 3.8

run for a while with future parser turned on, to make sure you've got all the kinks worked out.
)

## Read the Puppet 4.0 Release Notes

(Puppet 4.0 included several breaking changes, some of which didn't go through a formal deprecation period --- for example, the tagmail report processor was moved out of core and into an optional module. Read the release notes (link) for breaking changes, and make sure you're aware of what's coming.)

## You're Ready!

(next, go to the server upgrade page.)
