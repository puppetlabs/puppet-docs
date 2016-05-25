---
layout: default
title: "Deprecated Command Line Features"
---

[puppet.conf]: ./config_file_main.html
[auth.conf]: ./config_file_auth.html
[mcollective]: /mcollective/
[pe_mco_puppet]: /pe/latest/orchestration_puppet.html
[pssh]: https://code.google.com/p/parallel-ssh/
[puppetdb]: /puppetdb/latest
[inventory service]: https://github.com/puppetlabs/puppet-docs/blob/0db89cbafa112be256aab67c42b913501200cdca/source/guides/inventory_service.markdown
[puppetdb_curl]: /puppetdb/latest/api/query/curl.html
[puppetdb_facts_wire]: /puppetdb/latest/api/wire_format/facts_format_v3.html
[puppetdb_facts_replace]: /puppetdb/latest/api/commands.html#replace-facts-version-3

The following features of Puppet's command line interface are deprecated, and will be removed in Puppet 4.0.

## `puppet kick`

### Now

If you run `puppet agent` as a daemon, set `listen = true` in your agent nodes' [puppet.conf][] files, give all of them an [auth.conf][] that opens the `run` endpoint, and open their firewalls to port 8139, you can use the `puppet kick` command to start Puppet runs.

### In Puppet 4.0

The `puppet kick` command is gone, and the agent daemon will no longer listen for incoming HTTPS connections.

### Detecting and Updating

If you or your scripts use `puppet kick`, you'll need to either install [MCollective][] for a more robust and parallel task running system or use a parallel SSH tool to kick off Puppet runs. If you use Puppet Enterprise, you can already [use its orchestration features to trigger Puppet runs.][pe_mco_puppet]

You'll probably want to close port 8139, while you're at it.

### Context

Opening a port and listening for connections on every agent node is kind of horrible, so we decided to stop supporting it. If all you need to do is trigger Puppet runs, plain old [pssh][] is a better tool for the job. If you have other needs, or want to do fancy things with Puppet runs, [MCollective][] is much more capable.

## `puppet queue`

### Now

If you're using the old, slow, and deprecated ActiveRecord-based storeconfigs implementation (instead of the superior-in-every-way [PuppetDB][]), you can use the `puppet queue` command to partially work around its slowness and oldness.

### In Puppet 4.0

Switch to [PuppetDB][].

### Detecting and Updating

No matter what you're doing, switch to [PuppetDB][].

### Context

[PuppetDB][].

## `puppet facts find --terminus rest`

### Now

You can query the deprecated [inventory service][] with the `puppet facts` command.

### In Puppet 4.0

The inventory service is gone and this command no longer works.

### Detecting and Updating

If you or your scripts use `puppet facts find --terminus rest`, you should change your workflow and speak directly to [PuppetDB][]. Write a small script that hits [PuppetDB's `facts` API][puppetdb_facts] and does something with the resulting JSON, or just [use `curl` to get raw JSON.][puppetdb_curl]

[puppetdb_facts]: /puppetdb/latest/api/query/v4/facts.html

### Context

The inventory service was kind of an awkward API, and PuppetDB's API is much better.

* [PUP-1874: Deprecate the inventory service on master](https://tickets.puppetlabs.com/browse/PUP-1874)


## `puppet facts upload`

### Now

Agent nodes can upload facts to the Puppet master's deprecated [inventory service][] with the `puppet facts` command, and they'll eventually end up in PuppetDB.

### In Puppet 4.0

The inventory service is gone and this command no longer works.

### Detecting and Updating

If you or your scripts use `puppet facts upload`, you should change your workflow and speak directly to [PuppetDB][]. Write a small script that reads facts from Facter, formats them into [PuppetDB's facts wire format][puppetdb_facts_wire], then uploads them to [PuppetDB's `replace_facts` API][puppetdb_facts_replace].

### Context

The inventory service was kind of an awkward API, and PuppetDB's API is much better.

* [PUP-1874: Deprecate the inventory service on master](https://tickets.puppetlabs.com/browse/PUP-1874)
