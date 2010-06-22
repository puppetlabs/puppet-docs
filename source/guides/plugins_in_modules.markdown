Plugins in Modules
==================

Learn how to distribute custom facts and types from the server
to managed clients automatically.

* * *

Details
-------

This page describes the deployment of custom facts and types for
use by the client via modules. It is supported in 0.24.x onwards
and modifies the pluginsync model supported in releases prior to
0.24.x. It is NOT supported in earlier releases of Puppet but may
be present as a patch in some older Debian Puppet packages.

This technique can also be used to bundle functions for use by the
server when the manifest is being compiled. Doing so is a two step
process which is described further on in this document.

# Usage for Client Custom Facts and Types

Custom types and facts are stored in modules. These custom types and facts are
then gathered together and distributed via a file mount on your
Puppet master called plugins.

To enable module distribution you need to make changes on both the
Puppet master and the clients.

If you have existing plugins you were syncing from an earlier version of Puppet
, we'll need to perform a few steps to get
things converted to using the new system.  On the Puppet master, 
if you have an existing plugins section in
your fileserver.conf, get rid of the path parameter (if you leave
the path parameter in place, then the mount will behave like any
other fileserver mount). Move your existing plugins from the
directory specified in that path into the modules for which they
are relevant. If you do not have any modules defined or the types
and facts are not relevant to any particular module you can create
a generic module to hold all custom facts and types. It is
recommended that you name this module `custom`.

While ordinarily in Puppet, you do not need to know Ruby, plugins are
in fact Ruby modules.  Ruby libraries in your plugins directories behave like Ruby
libraries in any other (system) Ruby lib directory, and their paths need to
match whatever Ruby would normally look for.

## Module structure for 0.24.x (outdated)

For example, Ruby expects Puppet resource types to be in
$libdir/puppet/type/$type.rb, so for modules you would put them
here:

    <MODULEPATH>/<module>/plugins/puppet/type

For providers you place them in:

    <MODULEPATH>/<module>/plugins/puppet/provider

Similarly, Facter facts belong in the facter subdirectory of the
library directory:

    <MODULEPATH>/<module>/plugins/facter

If we are using our custom module and our modulepath is
/etc/puppet/modules then types and facts would be stored in the
following directories:

    /etc/puppet/modules/custom/plugins/puppet/type
    /etc/puppet/modules/custom/plugins/puppet/provider
    /etc/puppet/modules/custom/plugins/facter

## Module structure for 0.25.x

In 0.25.0 and later releases, Puppet changes uses 'lib' for the
name of the plugins directory.

This change was introducued in 0.25.0 and modules with an outdated
`plugins` directory name will generate a deprecation warning. The plugins
directory will be formally deprecated in the Rowlf release of
Puppet. This deprecation changes your module paths to:

    <MODULEPATH>/<module>/lib/puppet/type

For providers, place them in:

    <MODULEPATH>/<module>/lib/puppet/provider

Similarly, Facter facts belong in the facter subdirectory of the
library directory:

    <MODULEPATH>/<module>/lib/facter

So, if we are using our custom module and our modulepath is
/etc/puppet/modules then types and facts would be stored in the
following directories:

    /etc/puppet/modules/custom/lib/puppet/type
    /etc/puppet/modules/custom/lib/puppet/provider
    /etc/puppet/modules/custom/lib/facter

## Enabling Pluginsync

After setting up the directory structure, we then need to turn on pluginsync in our puppet.conf configuration file. If we're delivering Facter facts we also need to specify the
factpath option, so that the facts dropped by pluginsync are loaded
by Puppet:

    [main]
    pluginsync = true
    factpath = $vardir/lib/facter

## Additional options required for versions prior to 0.24.4

For versions earlier than 0.24.4 you may need to set the
pluginsource and plugindest values. In 0.24.4 onwards you should
remove these values as the defaults are now preferable. If you do
need to set these values then try something like:

    [main]
    pluginsync=true
    factsync=true
    pluginsource = puppet://$server/plugins
    plugindest = $vardir/lib
    factpath = $vardir/lib/facter

# Usage for Server Custom Functions

Functions are executed on the server while compiling the manifest.
A module defined in the manifest can include functions in the
plugins directory. The custom function will need to be placed in
the proper location within the manifest first:

    <MODULEPATH>/<module>/plugins/puppet/parser/functions

Note that this location is not within the puppetmaster's $libdir
path. Placing the custom function within the module plugins
directory will not result in the puppetmasterd loading the new
custom function. The puppet client can be used to help deploy the
custom function by copying it from 
MODULEPATH/module/plugins/puppet/parser/functions to the
proper $libdir location. To do so run the puppet client on the
server. When the client runs it will download the custom function
from the module's plugins directory and deposit it within the
correct location in $libdir. The next invocation of puppetmasterd
by a client will autoload the custom function.

As always custom functions are loaded once by puppetmasterd. Simply
replacing a custom function with a new version will not cause
puppetmasterd to automatically reload the function. You must
restart puppetmasterd.

