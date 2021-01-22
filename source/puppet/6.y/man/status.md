---
layout: default
built_from_commit: 7ee979c756ae4213067b12f9af7971ef380d60c4
title: 'Man Page: puppet status'
canonical: "/puppet/latest/man/status.html"
---

<div class='mp'>
<p>Warning: 'puppet status' is deprecated and will be removed in a future release.</p>

<p>USAGE: puppet status <var>action</var> [--terminus _TERMINUS] [--extra HASH]</p>

<p>View puppet server status.</p>

<p>OPTIONS:
  --render-as FORMAT             - The rendering format to use.
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  --extra HASH                   - Extra arguments to pass to the indirection
                                   request
  --terminus _TERMINUS           - The indirector terminus to use.</p>

<p>ACTIONS:
  find    Check status of puppet master server.
  info    Print the default terminus class for this face.</p>

<p>TERMINI: local, rest</p>

<p>See 'puppet help status' or 'man puppet-status' for full help.</p>

</div>
