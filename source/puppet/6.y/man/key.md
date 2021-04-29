---
layout: default
built_from_commit: 40229a5d238c1fae86d2a4acfe88860091f3728a
title: 'Man Page: puppet key'
canonical: "/puppet/latest/man/key.html"
---

<div class='mp'>
<p>Warning: 'puppet key' is deprecated and will be removed in a future release.</p>

<p>USAGE: puppet key <var>action</var> [--terminus _TERMINUS] [--extra HASH]</p>

<p>This subcommand manages certificate private keys. Keys are created
automatically by puppet agent and when certificate requests are generated
with 'puppet ssl submit_request'; it should not be necessary to use this
subcommand directly.</p>

<p>OPTIONS:
  --render-as FORMAT             - The rendering format to use.
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  --extra HASH                   - Extra arguments to pass to the indirection
                                   request
  --terminus _TERMINUS           - The indirector terminus to use.</p>

<p>ACTIONS:
  destroy    Delete an object.
  find       Retrieve an object by name.
  info       Print the default terminus class for this face.
  save       API only: create or overwrite an object.
  search     Search for an object or retrieve multiple objects.</p>

<p>TERMINI: file, memory</p>

<p>See 'puppet help key' or 'man puppet-key' for full help.</p>

</div>
