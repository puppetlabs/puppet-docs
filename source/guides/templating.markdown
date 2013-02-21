---
layout: legacy
title: Using Puppet Templates
---

Using Puppet Templates
======================

Learn how to template out configuration files with Puppet, filling in variables
with the managed node's facts.

[lptemplates]: /learning/templates.html
[modules]: /puppet/latest/reference/modules_fundamentals.html
[functions]: /references/stable/function.html
[erb]: http://ruby-doc.org/stdlib-1.8.7/libdoc/erb/rdoc/ERB.html

* * *

Puppet supports templates written in the [ERB][] templating language, which is part of the Ruby standard library.

Templates can be used to specify the contents of files. 

**For a full introduction to using templates with Puppet, see [the templates chapter of Learning Puppet][lptemplates].**

Evaluating Templates
-----

Templates are evaluated via a simple function:

    $value = template("my_module/mytemplate.erb")

**Template files should be stored in the `templates` directory of a [Puppet module][modules],** which allows the `template` function to locate them with the simplified path format shown above. For example, the file referenced by `template("my_module/mytemplate.erb")` would be found on disk at `/etc/puppet/modules/my_module/templates/mytemplate.erb` (assuming the common [`modulepath`](/references/latest/configuration.html#modulepath) of `/etc/puppet/modules`).

(If a file cannot be located within any module, the `template` function will fall back to searching relative to the paths in Puppet's [`templatedir`](/references/latest/configuration.html#templatedir). However, using this setting is no longer recommended.)

Templates are always evaluated by the parser, not by the client.
This means that if you are using a puppet master server, then the templates
only need to be on the server, and you never need to download them
to the client. The client sees no difference between using a
template and specifying all of the text of the file as a string. 

ERB Template Syntax
-----

ERB is part of the Ruby standard library. Full information about its syntax and evaluation is [available in the Ruby documentation][erb]. An abbreviated version is presented below.

### ERB is Plain Text With Embedded Ruby

ERB templates may contain any kind of text; in the context of Puppet, this is usually some sort of config file. (Outside the context of Puppet, it is usually HTML.)

Literal text in an ERB file becomes literal text in the processed output. Ruby instructions and expressions can be embedded in **tags;** these will be interpreted to help create the processed output. 

### Tags

The tags available in an ERB file depend on the way the ERB processor is configured. Puppet always uses the same configuration for its templates (see "trim mode" below), which makes the following tags available:

* `<%= Ruby expression %>` --- This tag will be replaced with the value of the expression it contains.
* `<% Ruby code %>` --- This tag will execute the code it contains, but will not be replaced by a value. Useful for conditional or looping logic, setting variables, and manipulating data before printing it.
* `<%# comment %>` --- Anything in this tag will be suppressed in the final output.
* `<%%` or `%%>` --- A literal <% or %>, respectively.
* `<%-` --- Same as `<%`, but suppresses any leading whitespace in the final output. Useful when indenting blocks of code for readability. 
* `-%>` --- Same as `%>`, but suppresses the subsequent line break in the final output. Useful with many lines of non-printing code in a row, which would otherwise appear as a long stretch of blank lines.

### Trim Mode

Puppet uses ERB's undocumented `"-"` (explicit line trim) mode, which allows tags to suppress leading whitespace and trailing line breaks as described above, and disallows the `& line of code` shortcut. Although it unfortunately doesn't appear in the ERB docs, you can read its effect in the Ruby source code starting in the `initialize` method of the `ERB::Compiler::TrimScanner` class.


Using Templates
-----

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

Referencing Variables
-----

Puppet passes all of the currently set variables (including facts) to templates when they are evaluated. There are several ways to access these variables:

* All of the variables visible **in the current scope** are available as Ruby instance variables --- that is, `@fqdn, @memoryfree, @operatingsystem`, etc. This style of reference works identically to using short (local) variable names in a Puppet manifest: `@fqdn` is exactly equivalent to `$fqdn`.
* All of the variables visible **in the current scope** are also available as Ruby local variables --- that is, `fqdn, memoryfree, operatingsystem`, etc., without the prepended `@` sign. This style of reference can sometimes cause problems when variable names collide with Ruby method names; it's generally better to use the `@` style.
* Puppet passes an object named `scope` to the template. This contains **all** of the currently set variables, as well as some other data ([including functions][template_functions]), and provides some methods for accessing them. You can use the scope object's `lookupvar` method to find **any** variable, in any scope. See "Out-of-Scope Variables" below for more details.

[Note that Puppet's variable lookup rules changed for Puppet 3.0.](/guides/scope_and_puppet.html)

### Out-of-Scope Variables

You can access variables in other scopes with the `scope.lookupvar` method:

    <%= scope.lookupvar('apache::user') %>

This can also be used to ensure that you are getting the top-scope value of a variable that may have been overridden in a local scope:

    <%= scope.lookupvar('::domain') %>

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

### Getting a List of All Variables

If you use the scope object's `to_hash` method, you can get a hash of every variable that is defined in the current scope. This hash uses the local name (`osfamily`) of each variable, rather than the qualified name (`::osfamily`). 

This snippet will print all of the variable names defined in the current scope:

    <% scope.to_hash.keys.each do |k| -%>
    <%= k %>
    <% end -%>


Combining Templates
-----

The template function can concatenate several templates together as follows:

     template('my_module/template1.erb','my_module/template2.erb')

This would be rendered as a single string with the content of both templates, in order.

Iteration
-----

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

Conditionals
-----

The ERB templating supports conditionals.  The following construct is
a quick and easy way to conditionally put content into a file:

    <% if broadcast != "NONE" %>        broadcast <%= broadcast %> <% end %>

Access to Tags and Declared Classes
-----

> **Note:** The lists of tags and declared classes are parse-order dependent --- they are only safe to use if you know exactly when in the compilation process the template will be evaluated. Using these variables is not recommended. 

In version 0.24.6 and later, Puppet passes the following extra variables to a template:

* `classes` --- an array of all of the classes that have been declared so far
* `tags` --- an array of all of the tags applied to the current container
* `all_tags` --- an array of all of the tags in use anywhere in the catalog

You can iterate over these variables or access their members. 

This snippet will print all the classes that have been declared so far:

    <% classes.each do |klass| -%>
    The class <%= klass %> is defined
    <% end -%>

This snippet will print all the tags applied to the current container:

    <% tags.each do |tag| -%>
    The tag <%= tag %> is part of the current scope
    <% end -%>

This snippet will print all of the tags in use so far:

    <% all_tags.each do |tag| -%>
    The tag <%= tag %> is defined
    <% end -%>

Using Functions Within Templates
-----

[template_functions]: #using-functions-within-templates

[Puppet functions][functions] can be used inside templates, but their use there is slightly different from their use in manifests:

* All functions are methods on the `scope` object.
* You must prepend "`function_`" to the beginning of the function name.
* The arguments of the function must be provided **as an array,** even if there is only one argument. (This is mandatory in Puppet 3. Prior to Puppet 3, some functions would succeed when passed a string and some would fail.)

For example, to include one template inside another:

    <%= scope.function_template(["my_module/template2.erb"]) %>

To log a warning using Puppet's own logging system, so that it will appear in reports:

    <%= scope.function_warning(["Template was missing some data; this config file may be malformed."]) %>

Syntax Checking
-----

ERB files are easy to syntax check. For a file mytemplate.erb, run

    erb -P -x -T '-' mytemplate.erb | ruby -c

