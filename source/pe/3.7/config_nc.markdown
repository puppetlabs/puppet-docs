---
layout: default
title: "PE 3.8 » Configuration"
subtitle: "Configuring & Tuning Node Classifier"
canonical: "/pe/latest/config_nc.html"
---

### Pruning the Node Classifier Database

The size of the node classifier database increases over time as PE runs and agents continue to check in. PE periodically prunes node check-ins from the node classifier database to prevent it from becoming too large. The pruning process runs every 24 hours (and each time pe-console-services starts or is restarted), and it deletes node check-in history that is older than the default of seven days. 

To change the default number of days:

1. In the PE console, navigate to the **Classification** page. 
2. Click the **PE Console** group.
3. In the **PE Console** group page, click the **Classes** tab.
4. Locate the `puppet_enterprise::profile::console` class, and from the Parameter drop-down list, select `classifier_prune_threshold`.
5. In the **Value** field, enter the number of days that you want to use as the default number.
6. To make the change take affect, run Puppet (`puppet agent -t`). Running Puppet will restart pe-console-services.

**Note:** If you set the `classifier_prune_threshold` value to 0, the node classifier service will never prune the database.