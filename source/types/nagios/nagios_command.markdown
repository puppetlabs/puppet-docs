nagios_command
==============

The Nagios type command.

* * *

Background
----------

{NAGIOSBG}

{GENERIC}

Parameters
----------

### `command_line`

Nagios configuration file parameter.

### `command_name`

The name parameter for Nagios type command

INFO: This is the `namevar` for this resource type.

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `naginator`

Uses [Naginator](http://projects.reductivelabs.com/projects/naginator)

### `target`

The target

### `use`

Nagios configuration file parameter.
