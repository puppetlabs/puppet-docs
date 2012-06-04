---
layout: legacy
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

Note: Plugins in modules is supported in 0.24.x onwards
and modifies the pluginsync model supported in releases prior to
0.24.x. It is NOT supported in earlier releases of Puppet but may
be present as a patch in some older Debian Puppet packages. The older 0.24.x
configuration for plugins in modules is documented at the end of this
page.

## Module structure for 0.25.x and later

In Puppet version 0.25.x and later, plugins are stored in the `lib` directory of a module, using an internal directory structure that mirrors that of the Puppet code:

    {modulepath}
    └── {module}
        └── lib
            ├── facter
            └── puppet
                ├── parser
                │   └── functions
                ├── provider
                    ├── exec
                    ├── package
                    └── etc... (any resource type)
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

And so on. 

Most types and facts should be stored in which ever module they are related to;
for example, a Bind fact might be distributed in your Bind module.  If you wish to centrally
deploy types and facts you could create a separate module just for this purpose, for example
one called `custom`.  This module needs to be a valid module (with the correct directory structure and
an `init.pp` file).

So, if we are using our custom module and our modulepath is
/etc/puppet/modules then types and facts would be stored in the
following directories:

    /etc/puppet/modules/custom/lib/puppet/type
    /etc/puppet/modules/custom/lib/puppet/provider
    /etc/puppet/modules/custom/lib/puppet/parser/functions
    /etc/puppet/modules/custom/lib/facter

Note: 0.25.x versions of Puppet have a known bug whereby plugins are instead loaded from the deprecated `plugins` directories of modules when applying a manifest locally with the `puppet` command, even though puppetmasterd will correctly serve the contents of `lib/` directories to agent nodes. This bug is fixed in Puppet 2.6.

## Enabling Pluginsync

After setting up the directory structure, we then need to turn on pluginsync in our puppet.conf configuration file on both the master and the clients:

    [main]
    pluginsync = true

## Note on Usage for Server Custom Functions

Functions are executed on the server while compiling the manifest.
A module defined in the manifest can include functions in the
plugins directory. The custom function will need to be placed in
the proper location within the manifest first:

    {modulepath}/{module}/lib/puppet/parser/functions

Note that this location is not within the puppetmaster's $libdir
path. Placing the custom function within the module plugins
directory will not result in the puppetmasterd loading the new
custom function. The puppet client can be used to help deploy the
custom function by copying it from
modulepath/module/lib/puppet/parser/functions to the
proper $libdir location. To do so run the puppet client on the
server. When the client runs it will download the custom function
from the module's lib directory and deposit it within the
correct location in $libdir. The next invocation of the Puppet master
by a client will autoload the custom function.

As always custom functions are loaded once by the Puppet master. Simply
replacing a custom function with a new version will not cause
Puppet master to automatically reload the function. You must
restart the Puppet master.

## Legacy 0.24.x and Plugins in Modules

For older Puppet release the `lib` directory was called `plugins`.

So for types you would place them in:

    {modulepath}/{module}/plugins/puppet/type

For providers you place them in:

    {modulepath}/{module}/plugins/puppet/provider

Similarly, Facter facts belong in the facter subdirectory of the
library directory:

    {modulepath}/{module}/plugins/facter

If we are using our custom module and our modulepath is
/etc/puppet/modules then types and facts would be stored in the
following directories:

    /etc/puppet/modules/custom/plugins/puppet/type
    /etc/puppet/modules/custom/plugins/puppet/provider
    /etc/puppet/modules/custom/plugins/facter

## Enabling pluginsync for 0.24.x versions

For 0.24.x versions you may need to specify some additional options:

    [main]
    pluginsync=true
    factsync=true
    factpath = $vardir/lib/facter

