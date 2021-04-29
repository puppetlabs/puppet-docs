---
layout: default
built_from_commit: 40229a5d238c1fae86d2a4acfe88860091f3728a
title: 'Man Page: puppet config'
canonical: "/puppet/latest/man/config.html"
---

<div class='mp'>
<p>USAGE: puppet config <var>action</var> [--section SECTION_NAME]</p>

<p>This subcommand can inspect and modify settings from Puppet's
'puppet.conf' configuration file. For documentation about individual settings,
see https://puppet.com/docs/puppet/latest/configuration.html.</p>

<p>OPTIONS:
  --render-as FORMAT             - The rendering format to use.
  --verbose                      - Whether to log verbosely.
  --debug                        - Whether to log debug information.
  --section SECTION_NAME         - The section of the configuration file to
                                   interact with.</p>

<p>ACTIONS:
  delete    Delete a Puppet setting.
  print     Examine Puppet's current settings.
  set       Set Puppet's settings.</p>

<p>See 'puppet help config' or 'man puppet-config' for full help.</p>

</div>
