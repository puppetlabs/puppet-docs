yumrepo
=======

* * *

The client-side description of a yum repository. Repository
configurations are found by parsing /etc/yum.conf and the files
indicated by reposdir in that file (see yum.conf(5) for details)

Most parameters are identical to the ones documented in
yum.conf(5)

Continuation lines that yum supports for example for the baseurl
are not supported. No attempt is made to access files included with
the **include** directive

### Parameters

#### baseurl

The URL for this repository. Set this to 'absent' to remove it from
the file completely Valid values are `absent`. Values can match
`/.*/`.

#### descr

A human readable description of the repository. Set this to
'absent' to remove it from the file completely Valid values are
`absent`. Values can match `/.*/`.

#### enabled

Whether this repository is enabled or disabled. Possible values are
'0', and '1'. Set this to 'absent' to remove it from the file
completely Valid values are `absent`. Values can match `/(0|1)/`.

#### enablegroups

Determines whether yum will allow the use of package groups for
this repository. Possible values are '0', and '1'. Set this to
'absent' to remove it from the file completely Valid values are
`absent`. Values can match `/(0|1)/`.

#### exclude

List of shell globs. Matching packages will never be considered in
updates or installs for this repo. Set this to 'absent' to remove
it from the file completely Valid values are `absent`. Values can
match `/.*/`.

#### failovermethod

Either 'roundrobin' or 'priority'. Set this to 'absent' to remove
it from the file completely Valid values are `absent`. Values can
match `/roundrobin|priority/`.

#### gpgcheck

Whether to check the GPG signature on packages installed from this
repository. Possible values are '0', and '1'.

Set this to 'absent' to remove it from the file completely Valid
values are `absent`. Values can match `/(0|1)/`.

#### gpgkey

The URL for the GPG key with which packages from this repository
are signed. Set this to 'absent' to remove it from the file
completely Valid values are `absent`. Values can match `/.*/`.

#### include

A URL from which to include the config. Set this to 'absent' to
remove it from the file completely Valid values are `absent`.
Values can match `/.*/`.

#### includepkgs

List of shell globs. If this is set, only packages matching one of
the globs will be considered for update or install. Set this to
'absent' to remove it from the file completely Valid values are
`absent`. Values can match `/.*/`.

#### keepalive

Either '1' or '0'. This tells yum whether or not HTTP/1.1 keepalive
should be used with this repository. Set this to 'absent' to remove
it from the file completely Valid values are `absent`. Values can
match `/(0|1)/`.

#### metadata\_expire

Number of seconds after which the metadata will expire. Set this to
'absent' to remove it from the file completely Valid values are
`absent`. Values can match `/[0-9]+/`.

#### mirrorlist

The URL that holds the list of mirrors for this repository. Set
this to 'absent' to remove it from the file completely Valid values
are `absent`. Values can match `/.*/`.

#### name

-   **namevar**

The name of the repository.

#### priority

Priority of this repository from 1-99. Requires that the priorities
plugin is installed and enabled. Set this to 'absent' to remove it
from the file completely Valid values are `absent`. Values can
match `/[1-9][0-9]?/`.

#### protect

Enable or disable protection for this repository. Requires that the
protectbase plugin is installed and enabled. Set this to 'absent'
to remove it from the file completely Valid values are `absent`.
Values can match `/(0|1)/`.

#### proxy

URL to the proxy server for this repository. Set this to 'absent'
to remove it from the file completely Valid values are `absent`.
Values can match `/.*/`.

#### proxy\_password

Password for this proxy. Set this to 'absent' to remove it from the
file completely Valid values are `absent`. Values can match
`/.*/`.

#### proxy\_username

Username for this proxy. Set this to 'absent' to remove it from the
file completely Valid values are `absent`. Values can match
`/.*/`.

#### timeout

Number of seconds to wait for a connection before timing out. Set
this to 'absent' to remove it from the file completely Valid values
are `absent`. Values can match `/[0-9]+/`.


* * * * *

