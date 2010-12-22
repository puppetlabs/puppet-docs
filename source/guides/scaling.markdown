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

WEBrick, the default web server used to enable Puppet's web services connectivity, is essentially a reference
implementation, and becomes unreliable beyond about ten managed nodes. In any sort of production environment, you should switch to a more efficient web server implementation such as [Passenger](./passenger.html) or [Mongrel](./mongrel.html), which will allow for serving many more nodes concurrently. If your system can work with Passenger, that is currently the recommended route.  On older systems, use Mongrel.

Delayed check in
----------------

Puppet's default configuration asks that each node check in every 30 minutes.  An option called 'splay' can add a random configurable lag to this check in time, to further balance out check in frequency.  Alternatively, do not run puppetd as a daemon, and add `puppet agent` with `--onetime` to your crontab, allowing for setting different crontab intervals on different servers.

Triggered selective updates
---------------------------

Similar to the delayed checkin and cron strategies, it's possible to trigger node updates on an as-needed basis.  Managed nodes can be configured to not check in automatically every 30 minutes, but rather to check in only when requested.  `puppetrun` (in the 'ext' directory of the Puppet checkout) may be used to selectively update hosts.  Alternatively, do not run the daemon, and a tool like [Func](http://fedorahosted.org/func) could be used to launch `puppet agent` with the `--onetime` option.

No central host
---------------

Using a central server offers numerous advantages, particularly in the area of security and enhanced control.  In environments that do not need these features, it is possible to use rsync, git, or some other means to transfer Puppet manifests and data to each individual node, and then run `puppet apply` locally (usually via cron).   This approach scales essentially infinitely, and full usage of Puppet and facter is still possible.

Minimize recursive file serving
-------------------------------

Puppet's recursive file serving works well for small directories, but it isn't as efficient as rsync or NFS, and using it for larger directories can take a performance toll on both the client and server. 

