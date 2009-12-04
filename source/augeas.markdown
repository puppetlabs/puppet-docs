augeas
======

Apply the changes (single or array of changes) to the filesystem via the [augeas](http://augeas.net) tool.

* Safely manipulate configuration files
* Supports [augeas](http://www.augeas.net)' domain-specific language to describe file formats

* * *

Requirements
------------

* [augeas](http://www.augeas.net)
* The [ruby-augeas](http://augeas.net/download.html#ruby-bindings) binding

Platforms
---------

Same as [augeas](http://www.augeas.net).

Version Compatibility
---------------------

`TODO`

Examples
--------

Sample usage with a string:

    augeas{"test1":
           context => "/files/etc/sysconfig/firstboot",
           changes => "set RUN_FIRSTBOOT YES",
           onlyif  => "match other_value size > 0",
     }
{:puppet}

Sample usage with an array and custom lenses:

    augeas{"jboss_conf":
        context => "/files",
        changes => [
            "set /etc/jbossas/jbossas.conf/JBOSS_IP $ipaddress",
            "set /etc/jbossas/jbossas.conf/JAVA_HOME /usr"
        ],
        load_path => "$/usr/share/jbossas/lenses",
    }
{:puppet}


Parameters
----------

### `changes`

The changes which should be applied to the filesystem. This can be
either a string which contains a command or an array of commands.

Commands supported are:

#### `set`

`set [PATH] [VALUE]`
: Sets the value `VALUE` at loction `PATH`

#### `rm`

`rm [PATH]`
: Removes the node at location `PATH`

NOTE: You can also use the synonym `remove`.

#### `clear`

`clear [PATH]`
: Keeps the node at PATH, but removes the value

#### `ins`

`ins [LABEL] [WHERE] [PATH]`
: Inserts an empty node LABEL either `WHERE={before|after} PATH`

NOTE: You can also use the synonym `insert`.

### `context`

Optional context path. This value is pre-pended to the paths of all
changes if the path is relative. So a path specified as `/files/foo`
will not be prepended with the context while `files/foo` will be
prepended

### `force`

Optional command to force the augeas type to execute even if it
thinks changes will not be made. This does not overide the only
setting. If onlyif is set, then the foce setting will not override
that result

### `load_path`

Optional colon separated list of directories; these directories are
searched for schema definitions

### `name`

The name of this task. Used for uniqueness.

INFO: This is the `namevar` for this resource type.

### `onlyif`

Optional augeas command and comparisons to control the execution of
this type.

Supported `onlyif` syntax:

* `get [AUGEAS_PATH] [COMPARATOR] [STRING]`
* `match [MATCH_PATH] size [COMPARATOR] [INT]`
* `match [MATCH_PATH] include [STRING]`
* `match [MATCH_PATH] == [AN_ARRAY]`
* `match [MATCH_PATH] != [AN_ARRAY]`

where:

* `AUGEAS_PATH`: is a valid path scoped by the context
* `MATCH_PATH`: is a valid match synatx scoped by the context
* `COMPARATOR`: is in the set `[> >= != == <= <]`
* `STRING`: is a string
* `INT`: is a number
* `AN_ARRAY`: is in the form `['a string', 'another']`

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate provider
for your platform. Available providers are:

<table class='providers'>
  <tr>
    <th>Provider</th>
    <th>execute_changes</th>
    <th>need_to_run?</th>
    <th>parse_commands</th>
  </tr>
  <tr>
    <th>augeas</th>
    <td>X</td>
    <td>X</td>
    <td>X</td>
  </tr>
</table>

#### Features

`execute_changes`
: Actually make the changes

`need_to_run?`
: If the command should run

`parse_commands`
: Parse the command string

### `returns`

The expected return code from the augeas command.

WARNING: This is used internally by Puppet and should not be set.

### `root`

A file system path; all files loaded by Augeas are loaded
underneath `ROOT`

### `type_check`

Set to true if augeas should perform typechecking.

NOTE: Optional, defaults to `false`. Valid values are `true` and `false`.
