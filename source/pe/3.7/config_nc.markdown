---
layout: default
title: "PE 3.8 » Configuration"
subtitle: "Configuring & Tuning Node Classifier"
canonical: "/pe/latest/config_nc.html"
---

### Pruning the Node Classifier Database

The size of the node classifier database increases over time as PE runs and agents continue to check in. PE periodically prunes the node classifier database to prevent it from becoming too large. The pruning process runs every 24 hours (and every time you start PE), and it deletes node check-in history that is older than the default of seven days. 

To change the default number of days, in the `classifier.conf` file on your Puppet master, enter the value for `prune-days-threshold`. The default path for the `classifier.conf` file is `/etc/puppetlabs/console-services/conf.d`.