---
layout: default
title: Scaling Puppet
---

Scaling Puppet
==============

Tune Puppet for maximum performance in large environments.

* * *

Are you using the default webserver?
------------------------------------

The default web server used to enable Puppet's web services connectivity is "WEBrick", which is essentially a reference
implementation, and is not very fast.  Switching to a more efficient web server implementation such as [Passenger](./passenger.html) or [Mongrel](./mongrel.html) will allow for serving many more nodes concurrently from the same server.   This performance tweak will offer the most immediate benefits.  If your system can work with Passenger, that is currently the recommended route.  On older systems, use Mongrel.

Delayed check in
----------------

Puppet's default configuration asks that each node check in every 30 minutes.  An option called 'splay' can add a random configurable lag to this check in time, to further balance out check in frequency.  Alternatively, do not run puppetd as a daemon, and add `puppetd` with `--onetime` to your crontab, allowing for setting different crontab intervals on different servers.

Triggered selective updates
---------------------------

Similar to the delayed checkin and cron strategies, it's possible to trigger node updates on an 'as needed' basis.  Managed nodes can be configured to not check in automatically every 30 minutes, but rather to check in only when requested.  'puppetrun' (in the 'ext' directory of the Puppet checkout) may be used to selectively update hosts.  Alternatively, do not run the daemon, and a tool like [mcollective](http://www.puppetlabs.com/mcollective/introduction/) could be used to launch `puppetd` with the `--onetime` option.

No central host
---------------

Using a central server offers numerous advantages, particularly in the area of security and enhanced control.  In environments that do need these features, it is possible to rsync (or otherwise transfer) puppet manifests and data to each individual node, and then run puppet locally, for instance, from cron.   This approach scales essentially infinitely, and full usage of Puppet and facter is still possible.

Minimize recursive file serving
-------------------------------

Puppet's recursive file serving is not going to be as efficient as rsync or NFS, so it should not be used to serve
up large directories.  For small directories, however, there is no problem in using it.   This will result in performance
improvements on both the client and server.


