---
layout: default
title: Virtual Resource Design Patterns
---

Virtual Resource Design Patterns
=================

Referencing an entity from more than one place.

* * *

About Virtual Resources
-----------------------

By default, any resource you describe in a client's Puppet config
will get sent to the client and be managed by that client. However,
resources can be specified in a way that marks them
as virtual, meaning that they will not be sent to the client by
default. You mark a resource as virtual by prefixing @ to the
resource specification; for instance, the following code defines a
virtual user:

    @user { luke: ensure => present }

If you include this code (or something similar) in your
configuration then the user will never get sent to your clients
without some extra effort.

How This Is Useful
------------------

Puppet enforces configuration normalization, meaning that a given
resource can only be specified in one part of your configuration.
You can't configure user johnny in both the solaris and freebsd
classes.

For most cases, this is fine, because most resources are distinctly
related to a single Puppet class --- they belong in the webserver
class, mailserver class, or whatever. Some resources can not be
cleanly tied to a specific class, though; multiple
otherwise-unrelated classes might need a specific resource. For
instance, if you have a user who is both a database administrator
and a Unix sysadmin, you want the user installed on all machines
that have either database administrators or Unix administrators.

You can't specify the user in the dba class nor in the sysadmin
class, because that would not get the user installed for all cases
that matter.

In these cases, you can specify the user as a virtual resource, and
then mark the user as real in both classes. Thus, the user is still
specified in only one part of your configuration, but multiple
parts of your configuration verify that the user will be installed
on the client.

The important point here is that you can take a virtual resource
and mark it non-virtual as many times as you want in a
configuration; it's only the specification itself that must be
normalized to one specific part of your configuration.

How to Realize Resources
------------------------

There are two ways to mark a virtual resource so that it gets sent
to the agent: You can use a special syntax called a **collection,** or
you can use the **realize** function.

Collections provide a
simple syntax (sometimes referred to as the "spaceship" operator) for marking virtual objects as real, such that they
should be sent to the agent. Collections require the type of
resource you are collecting and zero or more attribute comparisons
to specifically select resources. For instance, to find our
mythical user, we would use:

    User <| title == luke |>

As promised, we've got the user type (capitalized, because we're
performing a type-level operation), and we're looking for the user
whose title is luke. "Title" is special here --- it is the value
before the colon when you specify the user. This is somewhat of an
inconsistency in Puppet, because this value is often referred to as
the name, but many types have a name parameter and they could have
both a title and a name.

If no comparisons are specified, all virtual resources of that type
will be marked real.

This attribute querying syntax is currently very simple. The only
comparisons available are equality and non-equality (using the ==
and != operators, respectively), and you can join these comparisons
using or and and. You can also parenthesize these statements, as
you might expect. So, a more complicated collection might look
like:

    User <| (groups == dba or groups == sysadmin) or title == luke |>

Realizing Resources
-------------------

Puppet provides a simple form of syntactic sugar for marking
resource non-virtual by title, the realize function:

    realize User[luke]
    realize(User[johnny], User[billy])

The function follows the same syntax as other functions in the
language, except that only resource references are valid values.

Virtual Define-Based Resources
------------------------------

Since version 0.23, define-based resources may also be made
virtual. For example:

    define msg($arg) {
      notify { "$name: $arg": }
    }
    @msg { test1: arg => arg1 }
    @msg { test2: arg => arg2 }

With the above definitions, neither of the msg resources will be
applied to a node unless it realizes them, e.g.:

    realize( Msg[test1], Msg[test2] )
    
Remember that when referencing an instance of a namespaced defined type, or when specifying such a defined type for the collection syntax, you have to capitalize all segments of the type's name (e.g. `Apache::Vhost['wordpress']` or `Apache::Vhost <| |>`).

Keep in mind that resources inside virtualized define-based
resources must have unique names. The following example will
fail, complaining that `File[foo]` is defined twice:

        define basket($arg) {
                file{'foo':
                        ensure  => present,
                        content => $arg,
                        }
                }
        @basket { 'fruit': arg => 'apple' }
        @basket { 'berry': arg => 'watermelon' }

        realize( Basket[fruit], Basket[berry] )

Here's a working example:

        define basket($arg) {
            file{$name:
                ensure  => present,
                content => $arg,
                }
            }
        @basket { 'fruit': arg => 'apple' }
        @basket { 'berry': arg => 'watermelon' }

        realize( Basket[fruit], Basket[berry] )

Note that the working example will result in two File resources, named `fruit` and `berry`.


