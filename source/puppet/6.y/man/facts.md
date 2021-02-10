---
layout: default
built_from_commit: 6988b84f7eb7f5bb89766a9ca36b0b431685b03b
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
  diff      Compare Facter 3 output with Facter 4 output
  find      Retrieve a node's facts.
  info      Print the default terminus class for this face.
  save      API only: create or overwrite an object.
  upload    Upload local facts to the puppet master.</p>

<p>TERMINI: facter, json, memory, network_device, rest, store_configs, yaml</p>

<p>See 'puppet help facts' or 'man puppet-facts' for full help.</p>

</div>
