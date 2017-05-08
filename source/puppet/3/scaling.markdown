---
layout: default
title: Scaling Puppet
---

Scaling Puppet
==============

Tune Puppet for maximum performance in large environments.

* * *

Delayed check in
----------------

Puppet's default configuration asks that each node check-in every 30 minutes.  An option called 'splay' can add a random configurable lag to this check-in time, to further balance out check-in frequency.  Alternatively, do not run puppetd as a daemon.  Add a cronjob for `puppet agent` with `--onetime`, thus allowing for setting different intervals on different nodes.

Triggered selective updates
---------------------------

Similar to the delayed check-in and cron strategies, it's possible to trigger node updates on demand.  Managed nodes can be configured to not check-in automatically, but rather to check-in only when requested.  `puppetrun` (in the 'ext' directory of the Puppet checkout) may be used to selectively update hosts.  Alternatively, do not run the daemon, instead use a tool like [mcollective](http://www.puppetlabs.com/mcollective/introduction/) to launch `puppet agent` with the `--onetime` option.

No central host
---------------

Using a central server offers numerous advantages, particularly in the area of security and enhanced control.  In environments that do not need these features, it is possible to use rsync, git, or some other means to transfer Puppet manifests and data to each individual node, and then run `puppet apply` locally (usually via cron).   This approach scales essentially infinitely, and full usage of Puppet and facter is still possible.

Minimize recursive file serving
-------------------------------

Puppet's recursive file serving works well for small directories, but it isn't as efficient as rsync or NFS, and using it for larger directories can take a performance toll on both the client and server.

