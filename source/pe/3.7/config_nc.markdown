---
layout: default
title: "PE 3.8 » Configuration"
subtitle: "Configuring & Tuning Node Classifier"
canonical: "/pe/latest/config_nc.html"
---

### Pruning the Node Classifier Database

The size of the node classifier database increases over time as PE runs and agents continue to check in. PE periodically prunes node check-ins from the node classifier database to prevent it from becoming too large. The pruning process runs every 24 hours (and every time pe-console-services starts or is restarted), and it deletes node check-in history that is older than the default of seven days. 

To change the default number of days, in the `params.pp` file on your Puppet master, enter the value for `$classifier_prune_threshold`. The default path for the `params.pp` file is `/opt/puppet/share/puppet/modules/puppet_enterprise/manifests/params.pp`.

**Note:** If you set the `$classifier_prune_threshold` value to 0, the node classifier service will never prune the database.