---
layout: default
title: "Deprecated command line features"
---


These features of Puppet's command line interface are deprecated in this version of Puppet:

* The system now behaves as if the setting `--trusted_server_facts` is always set to true, and the setting itself is deprecated but is still present; this to avoid errors for users having set it to true (which is now the default).