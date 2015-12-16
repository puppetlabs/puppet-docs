## About Resource Types

### Built-in Types and Custom Types

This is the documentation for the _built-in_ resource types and providers, keyed
to a specific Puppet version. (See sidebar.) Additional resource types can be
distributed in Puppet modules; you can find and install modules by browsing the
[Puppet Forge](http://forge.puppetlabs.com). See each module's documentation for
information on how to use its custom resource types.

### Declaring Resources

To manage resources on a target system, you should declare them in Puppet
manifests. For more details, see
[the resources page of the Puppet language reference.](/puppet/latest/reference/lang_resources.html)

You can also browse and manage resources interactively using the
`puppet resource` subcommand; run `puppet resource --help` for more information.

### Namevars and Titles

All types have a special attribute called the *namevar.* This is the attribute
used to uniquely identify a resource _on the target system._ If you don't
specifically assign a value for the namevar, its value will default to the
_title_ of the resource.

Example:

    file { '/etc/passwd':
      owner => root,
      group => root,
      mode  => 644
    }

In this code, `/etc/passwd` is the _title_ of the file resource; other Puppet
code can refer to the resource as `File['/etc/passwd']` to declare
relationships. Because `path` is the namevar for the file type and we did not
provide a value for it, the value of `path` will default to `/etc/passwd`.

### Attributes, Parameters, Properties

The *attributes* (sometimes called *parameters*) of a resource determine its
desired state.  They either directly modify the system (internally, these are
called "properties") or they affect how the resource behaves (e.g., adding a
search path for `exec` resources or controlling directory recursion on `file`
resources).

### Providers

*Providers* implement the same resource type on different kinds of systems.
They usually do this by calling out to external commands.

Although Puppet will automatically select an appropriate default provider, you
can override the default with the `provider` attribute. (For example, `package`
resources on Red Hat systems default to the `yum` provider, but you can specify
`provider => gem` to install Ruby libraries with the `gem` command.)

Providers often specify binaries that they require. Fully qualified binary
paths indicate that the binary must exist at that specific path, and
unqualified paths indicate that Puppet will search for the binary using the
shell path.

### Features

*Features* are abilities that some providers may not support. Generally, a
feature will correspond to some allowed values for a resource attribute; for
example, if a `package` provider supports the `purgeable` feature, you can
specify `ensure => purged` to delete config files installed by the package.

Resource types define the set of features they can use, and providers can
declare which features they provide.

----------------

