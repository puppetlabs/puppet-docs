---
layout: default
title: Using Puppet Templates
---

Using Puppet Templates
======================

Learn how to template out configuration files with Puppet, filling in variables
from the client system from facter.

* * *

Puppet supports templates and templating via
[ERB](http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/), which is
part of the Ruby standard library and is used for many other
projects including Ruby on Rails.  While it is a Ruby templating
system, you do not need to understand much Ruby to use ERB.

Templates allow you to manage the content of template files, for example configuration files that
cannot yet be managed directly by a built-in Puppet type.   This might include
an Apache configuration file, Samba configuration file, etc.

## Evaluating templates

Templates are evaluated via a simple function:

    $value = template("mytemplate.erb")

You can specify the full path to your template, or you can put all
your templates in Puppet's templatedir, which usually defaults to
`/var/puppet/templates` (you can find out what it is on your system
by running `puppet --configprint templatedir`).  Best practices indicates
including the template in the `templates` directory inside your [module](./modules.html).

Templates are always evaluated by the parser, not by the client.
This means that if you are using puppetmasterd, then the templates
only need to be on the server, and you never need to download them
to the client. There's no difference that the client sees between using a
template and specifying all of the text of the file as a string. This also
means that any client-specific variables (facts) are learned first
by puppetmasterd during the client start-up phase, then those
variables are available for substitution within templates.

## Using templates

Here is an example for generating the Apache configuration for
[Trac](http://trac.edgewall.org/) sites:

    define tracsite($cgidir, $tracdir) {
        file { "trac-$name":
            path => "/etc/apache2/trac/$name.conf",
            owner => root,
            group => root,
            mode => 644,
            require => File[apacheconf],
            content => template("tracsite.erb"),
            notify => Service[apache2]
        }

        symlink { "tracsym-$name":
            path => "$cgidir/$name.cgi",
            ensure => "/usr/share/trac/cgi-bin/trac.cgi"
        }
    }

And then here's the template:

    <Location "/cgi-bin/ <%= name %>.cgi">
        SetEnv TRAC_ENV "/export/svn/trac/<%= name %>"
    </Location>

    # You need something like this to authenticate users
    <Location "/cgi-bin/<%= name %>.cgi/login">
        AuthType Basic
        AuthName "Trac"
        AuthUserFile /etc/apache2/auth/svn
        Require valid-user
    </Location>

This puts each Trac configuration into a separate
file, and then we just tell Apache to load all of these files:

    Include /etc/apache2/trac/[^.#]*

## Combining templates

You can also concatentate several templates together as follows:

     template('/path/to/template1','/path/to/template2')

## Iteration

Puppet's templates also support array iteration. If the variable you are
accessing is an array, you can iterate over it in a loop. Given Puppet manifest
code like this:

    $values = [val1, val2, otherval]

You could have a template like this:

    <% values.each do |val| -%>
    Some stuff with <%= val %>
    <% end -%>

This would produce:

    Some stuff with val1
    Some stuff with val2
    Some stuff with otherval

Note that normally, ERB template lines that just have code on them
would get translated into blank lines.  This is because ERB generates
newlines by default.  To prevent this, we use the closing tag -%> instead of %>.

As we mentioned, erb is a Ruby system, but you don't need to know Ruby
well to use ERB.   Internally, Puppet's values get translated to real Ruby values,
including true and false, so you can be pretty confident that
variables will behave as you might expect.

## Conditionals

The ERB templating supports conditionals.  The following construct is
a quick and easy way to conditionally put content into a file:

    <% if broadcast != "NONE" %>        broadcast <%= broadcast %> <% end %>

## Templates and variables

You can also use templates to fill in variables in addition to filling
out file contents.

    myvariable = template('/var/puppet/template/myvar')

## Undefined variables

If you need to test to see if a variable is defined before using it, the following works:

    <% if has_variable?("myvar") then %>
    myvar has <%= myvar %> value
    <% end %>

## Out of scope variables

You can access out of scope variables explicitly with the lookupvar
function:

    <%= scope.lookupvar('apache::user') %>

## Access to defined tags and classes

In Puppet version 0.24.6 and later, it is possible from a template
to get the list of defined classes, the list of tags in the current
scope, and the list of all tags as ruby arrays. For example:

This snippet will print all the tags defined in the current scope:

    <% tags.each do |tag| -%>
    The tag <%= tag %> is part of the current scope
    <% end -%>

This snippet will print all the defined tags in the catalog:

    <% all_tags.each do |tag| -%>
    The tag <%= tag %> is defined
    <% end -%>

And this snippet will print all the defined class in the catalog:

    <% classes.each do |klass| -%>
    The class <%= klass %> is defined
    <% end -%>

## Syntax Checking

ERB files are easy to syntax check. For a file mytemplate.erb, run

    erb -x -T '-' mytemplate.erb | ruby -c

