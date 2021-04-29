---
layout: default
built_from_commit: 40229a5d238c1fae86d2a4acfe88860091f3728a
title: 'Man Page: puppet catalog'
canonical: "/puppet/latest/man/catalog.html"
---

<div class='mp'>
<p>USAGE: puppet catalog <var>action</var> [--terminus _TERMINUS] [--extra HASH]</p>

<p>This subcommand deals with catalogs, which are compiled per-node artifacts
generated from a set of Puppet manifests. By default, it interacts with the
compiling subsystem and compiles a catalog using the default manifest and
<code>certname</code>; use the <code>--terminus</code> option to change the source of the catalog.</p>

<p>OPTIONS:
  --render-as FORMAT             - The rendering format to use.
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  --extra HASH                   - Extra arguments to pass to the indirection
                                   request
  --terminus _TERMINUS           - The indirector terminus to use.</p>

<p>ACTIONS:
  apply       Find and apply a catalog.
  compile     Compile a catalog.
  download    Download this node's catalog from the puppet master server.
  find        Retrieve the catalog for the node from which the command is run.
  info        Print the default terminus class for this face.
  save        API only: create or overwrite an object.
  select      Retrieve a catalog and filter it for resources of a given type.</p>

<p>TERMINI: compiler, json, msgpack, rest, store_configs, yaml</p>

<p>See 'puppet help catalog' or 'man puppet-catalog' for full help.</p>

</div>
