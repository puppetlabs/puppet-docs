exec
====

Executes external commands.

* * *

Introduction
------------

It is critical that all commands
executed using this mechanism can be run multiple times without
harm, i.e., they are *idempotent*. One useful way to create
idempotent commands is to use the checks like `creates` to avoid
running the command unless some condition is met.

Note also that you can restrict an `exec` to only run when it
receives events by using the `refreshonly` parameter; this is a
useful way to have your configuration respond to events with
arbitrary commands.

It is worth noting that `exec` is special, in that it is not
currently considered an error to have multiple `exec` instances
with the same name. This was done purely because it had to be this
way in order to get certain functionality, but it complicates
things. In particular, you will not be able to use `exec` instances
that share their commands with other instances as a dependency,
since Puppet has no way of knowing which instance you mean.

For example:

    # defined in the production class
    exec { "make":
        cwd => "/prod/build/dir",
        path => "/usr/bin:/usr/sbin:/bin"
    }
    
    . etc. .
    
    # defined in the test class
    exec { "make":
        cwd => "/test/build/dir",
        path => "/usr/bin:/usr/sbin:/bin"
    }
{:puppet}

Any other type would throw an error, complaining that you had the
same instance being managed in multiple places, but these are
obviously different images, so `exec` had to be treated specially.

It is recommended to avoid duplicate names whenever possible.

Note that if an `exec` receives an event from another resource, it
will get executed again (or execute the command specified in
`refresh`, if there is one).

There is a strong tendency to use `exec` to do whatever work Puppet
can't already do; while this is obviously acceptable (and
unavoidable) in the short term, it is highly recommended to migrate
work from `exec` to native Puppet types as quickly as possible. If
you find that you are doing a lot of work with `exec`, please at
least notify us at Reductive Labs what you are doing, and hopefully
we can work with you to get a native resource type for the work you
are doing.

{GENERIC}

Parameters
----------

### `command`

The actual command to execute. Must either be fully qualified or a
search path for the command must be provided. If the command
succeeds, any output produced will be logged at the instance's
normal log level (usually `notice`), but if the command fails
(meaning its return code does not match the specified code) then
any output is logged at the `err` log level.

INFO: This is the `namevar` for this resource type.

### `creates`

A file that this command creates. If this parameter is provided,
then the command will only be run if the specified file does not
exist:

    exec { "tar xf /my/tar/file.tar":
        cwd => "/var/tmp",
        creates => "/var/tmp/myfile",
        path => ["/usr/bin", "/usr/sbin"]
    }

### `cwd`

The directory from which to run the command. If this directory does
not exist, the command will fail.

### `env`

WARNING: This parameter is deprecated. Use 'environment' instead.

{TODO}

### `environment`

Any additional environment variables you want to set for a command.
Note that if you use this to set PATH, it will override the `path`
attribute. Multiple environment variables should be specified as an
array.

### `group`

The group to run the command as. This seems to work quite
haphazardly on different platforms -- it is a platform issue not a
Ruby or Puppet one, since the same variety exists when running
commnands as different users in the shell.

### `logoutput`

Whether to log output. Defaults to logging output at the loglevel
for the `exec` resource. Use *on\_failure* to only log the output
when the command reports an error. Values are **true**, *false*,
*on\_failure*, and any legal log level. Valid values are `true`,
`false`, `on_failure`.

### `onlyif`

If this parameter is set, then this `exec` will only run if the
command returns 0. For example:

    exec { "logrotate":
        path => "/usr/bin:/usr/sbin:/bin",
        onlyif => "test `du /var/log/messages | cut -f1` -gt 100000"
    }
{:puppet}

This would run `logrotate` only if that test returned true.

Note that this command follows the same rules as the main command,
which is to say that it must be fully qualified if the path is not
set.

Also note that onlyif can take an array as its value, eg:

    onlyif => ["test -f /tmp/file1", "test -f /tmp/file2"]
{:puppet}

This will only run the exec if /all/ conditions in the array return
true.

### `path`

The search path used for command execution. Commands must be fully
qualified if no path is specified. Paths can be specified as an
array or as a colon-separated list.

### `refresh`

How to refresh this command. By default, the exec is just called
again when it receives an event from another resource, but this
parameter allows you to define a different command for refreshing.

### `refreshonly`

The command should only be run as a refresh mechanism for when a
dependent object is changed. It only makes sense to use this option
when this command depends on some other object; it is useful for
triggering an action:

    # Pull down the main aliases file
    file { "/etc/aliases":
        source => "puppet://server/module/aliases"
    }
    
    # Rebuild the database, but only when the file changes
    exec { newaliases:
        path => ["/usr/bin", "/usr/sbin"],
        subscribe => File["/etc/aliases"],
        refreshonly => true
    }
{:puppet}

Note that only `subscribe` and `notify` can trigger actions, not
`require`, so it only makes sense to use `refreshonly` with
`subscribe` or `notify`. Valid values are `true`, `false`.

### `returns`

The expected return code(s). An error will be returned if the
executed command returns something else. Defaults to 0. Can be
specified as an array of acceptable return codes or a single
value.

### `timeout`

The maximum time the command should take. If the command takes
longer than the timeout, the command is considered to have failed
and will be stopped. Use any negative number to disable the
timeout. The time is specified in seconds.

### `unless`

If this parameter is set, then this `exec` will run unless the
command returns 0. For example:

    exec { "/bin/echo root >> /usr/lib/cron/cron.allow":
        path => "/usr/bin:/usr/sbin:/bin",
        unless => "grep root /usr/lib/cron/cron.allow 2>/dev/null"
    }
{:puppet}

This would add `root` to the cron.allow file (on Solaris) unless
`grep` determines it's already there.

Note that this command follows the same rules as the main command,
which is to say that it must be fully qualified if the path is not
set.

### `user`

The user to run the command as. Note that if you use this then any
error output is not currently captured. This is because of a bug
within Ruby. If you are using Puppet to create this user, the exec
will automatically require the user, as long as it is specified by
name.

  
