---
layout: default
title: "Deprecated command line features"
---


These features of Puppet's command line interface are deprecated, and will be removed in Puppet 5.0.

* The `inspect` command and its associated fields in the report have been removed, most notably the `kind` field, which used to distinguish between `apply` and `inspect` runs.

* The system now behaves as if the setting `--trusted_server_facts` is always set to true, and the setting itself is deprecated but is still present; this to not cause errors for users having set it to true (which is now the default). The setting will be removed in a future major version update, and before then any use of the setting `trusted_server_facts` should have been removed.