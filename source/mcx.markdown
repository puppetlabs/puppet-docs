mcx
===

MCX object management using DirectoryService on OS X.

* * *

Background
----------

The default provider of this type merely manages the XML plist as
reported by the `dscl -mcxexport command`. This is similar to the
content property of the file type in Puppet.

The recommended method of using this type is to use Work Group
Manager to manage users and groups on the local computer, record
the resulting puppet manifest using the command `ralsh mcx` then
deploying this to other machines.

Requirements
------------

No additional requirements.

Platforms
---------

Only supported on OSX.

Version Compatibility
---------------------

`TODO`

Examples
--------

`TODO`

Parameters
----------

### `content`

The XML Plist. The value of `MCXSettings` in DirectoryService. This
is the standard output from the system command:

    dscl localhost -mcxexport /Local/Default/<ds_type>/<ds_name>
{:shell}

NOTE: `ds_type` is capitalized and plural in the `dscl` command.

### `ds_name`

The name to attach the MCX Setting to. e.g. `localhost` when
`ds_type => computer`. This setting is not required, as it may be
parsed so long as the resource name is parseable. e.g.
`/Groups/admin` where `group` is the `dstype`.

### `ds_type`

The DirectoryService type this MCX setting attaches to. Valid
values are `user`, `group`, `computer`, `computerlist`.

### `ensure`

Create or remove the MCX setting. Valid values are `present`,
`absent`.

### `name`

The name of the resource being managed. The default naming
convention follows Directory Service paths:

    /Computers/localhost
    /Groups/admin
    /Users/localadmin
{:shell}

The `ds_type` and `ds_name` type parameters are not necessary if the
default naming convention is followed.

INFO: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `mcxcontent`

MCX Settings management using DirectoryService on OS X.

Required binaries:
* `/usr/bin/dscl`.

NOTE: This provider was contributed by [Jeff
McCune](mailto:mccune.jeff@gmail.com)

