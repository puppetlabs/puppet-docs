---
layout: default
title: "Puppet 4.0 Preview: Where Did Everything Go?"
---


[confdir]: /puppet/latest/reference/dirs_confdir.html
[directory environments]: /puppet/latest/reference/environments.html
[spec]: https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md

In Puppet 4, we moved a lot of things around. This page is a summary for existing users arriving from Puppet 3, so you can get oriented quickly without having to work very hard.

What's Up, and Why Did It Happen?
-----

We changed Puppet's packaging to install different things in different places. We also changed the default locations for a lot of important config directories.

We did this for a couple of reasons:

* To unify Puppet Enterprise and open source Puppet. Once we've released open source and enterprise versions of Puppet 4, users of both can find their software in the same locations, and use the same code and config directories. This should make everything more usable and more predictable.
* To treat Windows and \*nix more similarly. We've been shipping omnibus agent installers for Windows from the beginning, and now \*nix users can reap some of the same benefits.

Reasons:

- Unify Puppet Enterprise and open source Puppet
- Make everything more predictable --- puppet, puppetserver, puppetdb all configured under /etc/puppetlabs/
- Move to omnibus packaging for Puppet, to end Ruby incompatibilities and make it easier than ever to use

### Full Details?

[We've written a specification of the directories used by all of Puppet's tools.][spec] It goes into exhaustive detail for every platform. You should be able to get by with the summary on this page, but if there's anything deeper you need to know, it's in the spec.

As we finish updating the core documentation for Puppet 4 (and its sister tools), we'll be changing every reference to important directories to match the new paths.


New All-in-One `puppet-agent` Package
-----

On managed \*nix systems, you'll now install `puppet-agent` instead of `puppet`.

This is a new name for a new thing. Instead of using dependencies to bring in tools like Facter, Hiera, and Ruby, we ship almost everything Puppet needs in a single package.

This package applies to systems running `puppet agent` and `puppet apply`; Puppet master servers should install `puppetserver` as well.

New stuff about `puppet-agent`:

* It has private versions of Ruby and some other dependencies. We're taking up a little more disk space in exchange for fewer weird bugs and less interaction with your business applications.
* Puppet now includes cfacter and MCollective. (You can start using cfacter by setting `cfacter = true` in puppet.conf. Getting MCollective up and running is a bit more complicated, and some of its plugin packages might not be ready during the preview release.)

On Windows, you'll use the same package as before, but the open source package now includes MCollective.

On \*nix, the Executables Moved
-----

On \*nix platforms, the main executables moved to `/opt/puppetlabs/bin`. This means **Puppet and related tools aren't included in your PATH by default.** You'll need to either:

* Add `/opt/puppetlabs/bin` to your PATH
* Symlink Puppet's tools to somewhere else in your PATH
* Use the full path (like `/opt/puppetlabs/bin/puppet apply` when running Puppet commands

On Windows, this stayed the same. The MSI package still adds Puppet's tools to the PATH.

### Private `bin` Dirs

The executables in `/opt/puppetlabs/bin` are just the "public" applications that make up Puppet. Commands like `ruby` and `gem` are in `/opt/puppetlabs/puppet/bin`, to keep them from accidentally overriding system tools in your PATH.

On \*nix, Config Files and Certificates Moved
-----

Puppet's [`confdir`][confdir] for `root` (and the `puppet` user) is now `/etc/puppetlabs/puppet`. (The `confdir` is the directory that holds files like `puppet.conf` and `auth.conf`, as well as the `ssl` directory.)

This means open source Puppet now uses the same `confdir` as Puppet Enterprise.

On Windows, this stayed the same. It's still in the `COMMON_APPDATA` folder, defaulting to `C:\ProgramData\PuppetLabs\puppet\etc` on modern Windows versions.

### Other Tools

We're also moving other configs into the `/etc/puppetlabs` directory. Puppet Server now uses `/etc/puppetlabs/puppetserver`, and MCollective uses `/etc/puppetlabs/mcollective`.


Modules, Manifests, and Data Have New Homes
-----

There are two big changes here:

1. [Directory environments][] are always enabled now. If you aren't already using environments, you should default to putting modules and manifests in the `production` environment. The global `modules` directory still exists, but it's only for code you specifically want in _all_ environments.
2. Both environments and global content have moved into a new directory named `codedir`. The system `codedir`s are:
    * `/etc/puppetlabs/code` on \*nix
    * `C:\ProgramData\PuppetLabs\code` on Windows

Short version: if you're building up a new Puppet master server, start by installing modules into `/etc/puppetlabs/code/environments/production/modules`, and assigning classes to nodes in `/etc/puppetlabs/code/environments/production/manifests`.

The `codedir` is also the new home for the `hiera.yaml` file and the `hieradata` directory.

### Why the `codedir`?

The point of the `codedir` is to make it easier to deploy and sync content across multiple Puppet master servers and standalone Puppet apply nodes. The `confdir` has a lot of stuff that should _never_ be synced between servers, and it was freely mixed with stuff that should _always_ be synced. Now they're nicely separate.

Some Other Directories Have Moved
-----

* The system `vardir` for `puppet agent` has moved, and is now separate from the `vardir` Puppet Server will use.
    * On \*nix: `/opt/puppetlabs/puppet/cache`
    * On Windows: `C:\ProgramData\PuppetLabs\puppet\cache`
* The `rundir`, where the service PID files go, has moved:
    * On \*nix: `/var/run/puppetlabs`. (Puppet Server has a `puppetserver` directory inside this.)
    * On Windows: `C:\ProgramData\PuppetLabs\puppet\var\run` --- this is the same as before, but it's now outside the main `vardir`.


