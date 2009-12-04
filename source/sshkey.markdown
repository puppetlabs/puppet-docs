sshkey

Installs and manages ssh host keys. At this point, this type only
knows how to install keys into /etc/ssh/ssh\_known\_hosts, and it
cannot manage user authorized keys yet.

### Parameters

#### alias

Any alias the host might have. Multiple values must be specified as
an array. Note that this parameter has the same name as one of the
metaparams; using this parameter to set aliases will make those
aliases available in your Puppet scripts.

#### ensure

The basic property that the resource should be in. Valid values are
`present`, `absent`.

#### key

The key itself; generally a long string of hex digits.

#### name

-   **namevar**

The host name that the key is associated with.

#### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **parsed**: Parse and generate host-wide known hosts files for
    SSH.

#### target

The file in which to store the ssh key. Only used by the `parsed`
provider.

#### type

The encryption type used. Probably ssh-dss or ssh-rsa. Valid values
are `ssh-dss` (also called `dsa`), `ssh-rsa` (also called `rsa`).


* * * * *

