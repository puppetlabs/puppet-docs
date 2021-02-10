---
layout: default
built_from_commit: abe39259f7c9eb3e129c6dcda93bab904bf68910
title: 'Man Page: puppet facts'
canonical: "/puppet/latest/man/facts.html"
---

<div class='mp'>
<p>USAGE: puppet facts <var>action</var> [--terminus _TERMINUS] [--extra HASH]</p>

<p>This subcommand manages facts, which are collections of normalized system
information used by Puppet. It can read facts directly from the local system
(with the default <code>facter</code> terminus).</p>

<p>OPTIONS:
  --render-as FORMAT             - The rendering format to use.
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  --extra HASH                   - Extra arguments to pass to the indirection
                                   request
  --terminus _TERMINUS           - The indirector terminus to use.</p>

<p>ACTIONS:
  find      Retrieve a node's facts.
  info      Print the default terminus class for this face.
  save      API only: create or overwrite an object.
  show      Retrieve current node's facts.
  upload    Upload local facts to the puppet master.</p>

<p>TERMINI: facter, json, memory, network_device, rest, store_configs, yaml</p>

<p>See 'puppet help facts' or 'man puppet-facts' for full help.</p>

</div>
