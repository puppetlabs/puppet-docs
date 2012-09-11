---
layout: legacy
title: Using Puppet Templates
---

Using Puppet Templates
======================

Learn how to template out configuration files with Puppet, filling in variables
with the managed node's facts.

[lptemplates]: /learning/templates.html
[modules]: /puppet/2.7/reference/modules_fundamentals.html

* * *

Puppet supports templates written in the
[ERB](http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/) templating language, which is
part of the Ruby standard library.

Templates can be used to specify the contents of files. 

**For a full introduction to using templates with Puppet, see [the templates chapter of Learning Puppet][lptemplates].**

## Evaluating templates

Templates are evaluated via a simple function:

    $value = template("my_module/mytemplate.erb")

**Template files should be stored in the `templates` directory of a [Puppet module][modules],** which allows the `template` function to locate them with the simplified path format shown above. For example, the file referenced by `template("my_module/mytemplate.erb")` would be found on disk at `/etc/puppet/modules/my_module/templates/mytemplate.erb` (assuming the common [`modulepath`](/references/latest/configuration.html#modulepath) of `/etc/puppet/modules`).

(The `template` function can also locate files stored in Puppet's [`templatedir`](/references/latest/configuration.html#templatedir), but this is no longer recommended.) 

Templates are always evaluated by the parser, not by the client.
This means that if you are using a puppet master server, then the templates
only need to be on the server, and you never need to download them
to the client. There's no difference that the client sees between using a
template and specifying all of the text of the file as a string. 

## Using templates

Here is an example for generating the Apache configuration for
[Trac](http://trac.edgewall.org/) sites:

    # /etc/puppet/modules/trac/manifests/tracsite.pp
    define trac::tracsite($cgidir, $tracdir) {
      file { "trac-$name":
        path    => "/etc/apache2/trac/$name.conf",
        owner   => root,
        group   => root,
        mode    => 644,
        require => File[apacheconf],
        content => template("trac/tracsite.erb"),
        notify  => Service[apache2]
      }

      file { "tracsym-$name":
        ensure => symlink,
        path   => "$cgidir/$name.cgi",
        target => "/usr/share/trac/cgi-bin/trac.cgi"
      }
    }

And then here's the template:

    # /etc/puppet/modules/trac/templates/tracsite.erb
    <Location "/cgi-bin/ <%= @name %>.cgi">
        SetEnv TRAC_ENV "/export/svn/trac/<%= @name %>"
    </Location>

    # You need something like this to authenticate users
    <Location "/cgi-bin/<%= @name %>.cgi/login">
        AuthType Basic
        AuthName "Trac"
        AuthUserFile /etc/apache2/auth/svn
        Require valid-user
    </Location>

This puts each Trac configuration into a separate
file, and then we just tell Apache to load all of these files:

    # /etc/httpd/httpd.conf
    Include /etc/apache2/trac/[^.#]*


Note that the `template` function simply returns a string, which can be used as a value anywhere --- the most common use is to fill file contents, but templates can also provide values for variables:

    $myvariable = template('my_module/myvariable.erb')

## Referencing Variables

Puppet variables (both local and global, including facts) can be referred to in templates as Ruby instance variables --- that is, `@fqdn, @memoryfree, @operatingsystem`, etc. This notation is the best way to access variables visible from the current scope, and follows Puppet's normal variable lookup rules. ([Note that these rules changed for Puppet 3.0.](/guides/scope_and_puppet.html))

Puppet variables are also available as Ruby local variables --- that is, `fqdn, memoryfree, operatingsystem`, etc., without the prepended `@` sign. This notation is usually safe to use, but can potentially cause problems when variable names collide with Ruby function names. 


### Out-of-Scope Variables

You can access variables in other scopes with the `scope.lookupvar` function:

    <%= scope.lookupvar('apache::user') %>

### Testing for Undefined variables

Instance variables are not created for variables whose values are undefined, so you can easily test for undefined variables with `if @variable`:

    <% if @myvar %>
    myvar has <%= @myvar %> value
    <% end %>

Older templates often used the `has_variable?("myvar")` helper function, but this could yield odd results when variables were explicitly set to `undef`, and should usually be avoided.

If you need to test for a variable outside the current scope, you should copy it to a local variable in the manifest before evaluating the template: 

    # manifest:
    $in_var = $outside_scope::outside_var
    
    # template:
    <% if @in_var %>
    outside_var has <%= @in_var %> value
    <% end %>

## Combining templates

The template function can concatentate several templates together as follows:

     template('my_module/template1.erb','my_module/template2.erb')

This would be rendered as a single string with the content of both templates, in order.

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

This snippet will print all the defined classes in the catalog:

    <% classes.each do |klass| -%>
    The class <%= klass %> is defined
    <% end -%>

## Access to variables and Puppet functions with the scope object

Inside templates you have access to a scope object. All of the functions that you can access in the puppet manifests can be accessed via that scope object, although not via the same name.

Variables defined in the current scope are available as entries in the hash returned by the scope object's `to_hash` method. This snippet will print all of the variable names defined in the current scope:

    <% scope.to_hash.keys.each do |k| -%>
    <%= k %>
    <% end -%>

Puppet functions can be called by prepending "`function_`" to the beginning of the function name. For example, including one template inside another:

    <%= scope.function_template(["my_module/template2.erb"]) %>

## Syntax Checking

ERB files are easy to syntax check. For a file mytemplate.erb, run

    erb -P -x -T '-' mytemplate.erb | ruby -c

