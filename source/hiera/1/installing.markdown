---
layout: default
title: "Hiera 1: Installing"
---

[repos]: /guides/puppetlabs_package_repositories.html
[config]: ./configuring.html

{% partial /hiera/_hiera_update.md %}

> **Note:** If you are using Puppet 3 or later, you probably **already have Hiera installed.** You can skip these steps, and go directly to [configuring Hiera][config].

Prerequisites
-----

* Hiera works on \*nix and Windows systems.
* It requires Ruby 1.8.5 or later.
* To work with Puppet, it requires Puppet 2.7.x or later.
* If used with Puppet 2.7.x, it also requires the additional `hiera-puppet` package; see below.



Installing Hiera
-----

If you are using Hiera with Puppet, you should install it **on your puppet master server(s);** it is optional and unnecessary on agent nodes. (If you are using a standalone puppet apply site, every node should have Hiera.)

### Step 1: Install the `hiera` Package or Gem

Install the `hiera` package, using Puppet or your system's standard package tools.

> **Note:** You may need to [enable the Puppet Labs package repos][repos] first.

    $ sudo puppet resource package hiera ensure=installed

If your system does not have native Hiera packages available, you may need to install it as a Rubygem.

    $ sudo gem install hiera

### Step 2: Install the Puppet Functions

If you are using Hiera with Puppet 2.7.x, you must also install the `hiera-puppet` package on every puppet master.

    $ sudo puppet resource package hiera-puppet ensure=installed

Or, on systems without native packages:

    $ sudo gem install hiera-puppet

> **Note:** Puppet 3 does not need the `hiera-puppet` package, and may refuse to install if it is present. You can safely remove `hiera-puppet` in the process of upgrading to Puppet 3.


Next
----

That's it: Hiera is installed. Next, [configure Hiera with its `hiera.yaml` config file][config].
