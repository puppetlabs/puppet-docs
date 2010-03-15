Introduction to Puppet
======================

* * *

Why Puppet
----------

As system administrators acquire more and more systems to manage, automation
of mundane tasks is increasingly important.  Rather than develop in-house
scripts, it is desirable to share a system that everyone can use, and invest
in tools that can be used regardless of one's employer.

Puppet has been developed to help the sysadmin community move to
building and sharing mature tools that avoid the duplication of
everyone solving the same problem. It does so in two ways:

-   It provides a powerful framework to simplify the majority of
    the technical tasks that sysadmins need to perform
-   The sysadmin work is written as code in Puppet's custom
    language which is shareable just like any other code.

This means that your work as a sysadmin can get done much faster,
because you can have Puppet handle most or all of the details, and
you can download code from other sysadmins to help you get done
even faster. The majority of Puppet implementations use at least
one or two modules developed by someone else, and there are already
hundreds of modules developed and shared by the community.

System Components
-----------------

Puppet is typically used in a client/server formation, with all
of your clients talking to one or more central servers. Each client
contacts the server periodically (every half hour, by default),
downloads the latest configuration, and makes sure it is in sync with
that configuration.  Once done, the client can send a report back to the
server indicating if anything needed to change. This diagram shows
the data flow in a regular Puppet implementation:

![image](http://reductivelabs.com/images/Puppet_Star.png)

Puppet's functionality is built as a stack of separate layers, each
responsible for a fixed aspect of the system, with tight controls
on how information passes between layers:

![image](http://reductivelabs.com/images/Puppet_Layers.png)

See also [Configuring Puppet](/guides/configuring.html)

### puppetmasterd

puppetmasterd is the central server in a client/server puppet setup.
Managed machines check in with the server, sending the server their
'facts' (inventory information and other variables) and then are
sent down a configuration to apply.  Managed machines can then
optionally send back reports to the central server.

### puppetd

puppetd is a daemon that optionally runs on each managed machine
and checks in periodically.  It can also be run on an on-demand
basis, in non-daemon mode.   It can additionally be run in a "no-op"
mode where it will only report if systems drift out of compliance
with established policy, allowing admins to initiate changes
manually.

### puppet

The 'puppet' executable can be used similarly to puppetd, except
in local context.  For instance if you wanted to deploy manifest
content directly to your server via rsync, and not use puppet,
you would use the 'puppet' executable to execute the code.  This tool
is also great for testing modules and manifests locally before
deploying them to the central server.

### puppetca

When a managed node checks in for the first time, it will send
a certificate signing request (CSR) to the central server.  If
autosigning is not configured, puppetca is used to sign the CSR
and make the node manageable.  'puppetca' can also be used
to list signed certificates, as well as to revoke them.

### facter

Puppet uses a library called 'facter' to source variables
from the managed system.   These variables can be used in conditionals
as well as configuration file templates.  Facter, like Puppet,
is user extensible, so it's possible to add your own facts.

### additional tools/scripts

Numerous contributed tools like 'puppetrun' (used
to remotely trigger execution of puppet code at a specific point in time)
are part of the Puppet Ecosystem but not installed by default in the main
distribution.  From a source checkout, look in the 'ext' directory
for these useful tools and scripts.

Features of the System
----------------------

### Idempotency

One big difference between Puppet and most hand-rolled tools is
that Puppet configurations are idempotent, meaning they can safely
be run multiple times. Once you develop your configuration, your
machines will apply the configuration often -- by default, every 30
minutes -- and Puppet will only make any changes to the system if
the system state does not match the configured state.

This behaviour is provided by Puppet's Transactional layer. Puppet
does not yet have full transactional support -- transactions are
not recorded, and thus cannot be rolled back -- but the basics are
there, and they are what manage how changes happen to the system.
If you tell the transactional system to operate in no-op, or
dry-run, mode, using the `--noop` argument to one of the Puppet
tools, then the transaction will guarantee that no work happens on
your system. Similarly, if any changes do happen, the transaction
will guarantee that those specific changes are logged.

This way you can use Puppet to manage a machine throughout its
lifecycle -- from initial installation, to ongoing upgrades, and
finally to end-of-life, where you move services elsewhere. Unlike
system install tools like Sun's Jumpstart or Red Hat's Kickstart,
Puppet configurations can keep machines up to date for years,
rather than just building them correctly and never touching them
again. Because of this, Puppet users usually do just enough with
their host install tools to get Puppet running, then they use
Puppet to do everything else.

### Cross Platform

Puppet's Resource Abstraction Layer (RAL) allows you to focus on the parts of the system
you care about, ignoring implementation details like command
names, arguments, and file formats -- your tools should treat all
users the same, whether the user is stored in NetInfo or
`/etc/passwd`.  We call these system entities
`resources`.

### Model & Graph Based

#### Resource Types

The concept of each resource is modelled as a type.   This is to
decouple the definition (for instance, a user) from how
that implementation is fulfilled on a particular operating system,
for instance, a Linux user versus an OS X user.

See [Type Guides](/guides/types/) for a list of managed types
and information about how to use them.

#### Providers

Providers are the fulfillment of a resource.  For instance, for
the package type, both 'yum' and 'apt' are valid ways to manage
packages.  Sometimes more than one provider will be available
on a particular platform, though each platform always has
a default provider.  There are currently 17 providers
for the package type.

#### Modifying the System

Puppet resources are what are responsible for directly managing the
bits on disk. You do not directly modify a system from the language
-- you use the language to specify a resource, which then
modifies the system.   Rather than tacking a couple of lines onto
the end of your `fstab`, you use the `mount` type to create a new
resource that knows how to modify the `fstab`, or NetInfo, or
wherever mount information is kept.

Resources have attributes called 'properties' which change
the way a resource is managed.  For instance, users have an
attribute that specicies whether the home directory should
be created.

'Metaparams' are another special kind of attribute, those exist on 
all resources.  This include things like
the log level for the resource, whether the resource should be in
`noop` mode so it never modifies the system, and the relationships
between resources.

#### Resource Relationships

Puppet has a system of modelling relationships between resources
-- what resources should be evaluated before or after one another.
They also are used to determine whether a resource needs to respond to changes in
another resource (such as if a service needs to restart if the configuration
file for the service has changed).  This ordering reduces unneccessary commands, 
such as avoiding restarting a service
if the configuration has *not* changed.  

Because the system is graph based, it's actually possible to generate a diagram
(from Puppet) of the relationships between all of your resources.  

Learning The Language
---------------------

Seeing a few examples in action will greatly help in learning the system.

For information about the Puppet language, see the excellent
[Language Tutorial](/guides/language_tutorial.html)


