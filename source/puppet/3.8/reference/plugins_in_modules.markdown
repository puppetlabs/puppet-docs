---
layout: default
title: Plugins in Modules
---

Plugins in Modules
==================

Learn how to distribute custom facts and types from the server
to managed clients automatically.

* * *

Details
-------

This page describes the deployment of custom facts and types for
use by the client via modules.

Custom types and facts are stored in modules. These custom types and facts are
then gathered together and distributed via a file mount on your
Puppet master called plugins.

This technique can also be used to bundle functions for use by the
server when the manifest is being compiled. Doing so is a two step
process which is described further on in this document.

To enable module distribution you need to make changes on both the
Puppet master and the clients.

## Module structure

Plugins are stored in the `lib` directory of a module, using an internal directory structure that mirrors that of the Puppet code:

    {modulepath}
    └── {module}
        └── lib
            |── augeas
            │   └── lenses
            ├── facter
            └── puppet
                ├── parser
                │   └── functions
                ├── provider
                |   ├── exec
                |   ├── package
                |   └── etc... (any resource type)
                └── type


As the directory tree suggests, custom facts should go in `lib/facter/`, custom types should go in `lib/puppet/type/`, custom providers should go in `lib/puppet/provider/{type}/`, and custom functions should go in `lib/puppet/parser/functions/`.

For example:

A custom user provider:

    {modulepath}/{module}/lib/puppet/provider/user/custom_user.rb

A custom package provider:

    {modulepath}/{module}/lib/puppet/provider/package/custom_pkg.rb

A custom type for bare Git repositories:

    {modulepath}/{module}/lib/puppet/type/gitrepo.rb

A custom fact for the root of all home directories (that is, `/home` on Linux, `/Users` on Mac OS X, etc.):

    {modulepath}/{module}/lib/facter/homeroot.rb

A custom Augeas lens:

    {modulepath}/{module}/lib/augeas/lenses/custom.aug

> Note: Support for syncing Augeas lenses was added in Puppet 2.7.18.

And so on.

Most types and facts should be stored in which ever module they are related to;
for example, a Bind fact might be distributed in your Bind module.  If you wish to centrally
deploy types and facts you could create a separate module just for this purpose, for example
one called `custom`.

So, if we are using our custom module and our modulepath is
/etc/puppet/modules then types and facts would be stored in the
following directories:

    /etc/puppet/modules/custom/lib/puppet/type
    /etc/puppet/modules/custom/lib/puppet/provider
    /etc/puppet/modules/custom/lib/puppet/parser/functions
    /etc/puppet/modules/custom/lib/facter

## Note on Usage for Server Custom Functions

Functions are executed on the server while compiling the manifest.
A module defined in the manifest can invoke functions from the
plugins directory. The custom function will need to be placed in
the proper location within the module first:

    {modulepath}/{module}/lib/puppet/parser/functions
