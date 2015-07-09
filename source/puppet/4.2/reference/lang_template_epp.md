---
layout: default
title: "Language: Embedded Puppet (EPP) Template Syntax"
canonical: "/puppet/latest/reference/lang_template_epp.html"
---

[erb]: ./lang_template_erb.html
[epp]: /references/latest/function.html#epp
[ntp]: https://forge.puppetlabs.com/puppetlabs/ntp
[inline_epp]: /references/latest/function.html#inlineepp
[functions]: ./lang_functions.html
[hash]: ./lang_data_hash.html
[local scope]: ./lang_scope.html
[node definition]: ./lang_node_definitions.html
[variables]: ./lang_variables.html

Embedded Puppet (EPP) is a templating language based on the [Puppet language](./lang_summary.html). You can use EPP in Puppet 4 and higher, as well as Puppet 3.5 through 3.8 with the [future parser](/3.8/reference/experiments_future.html) enabled.

Puppet can evaluate EPP templates with the [`epp`][epp] and [`inline_epp`][inline_epp] functions.

This page covers how to write EPP templates. See [Templates](./lang_template.html) for information about what templates are and how to evaluate them.

## EPP Structure and Syntax

~~~ erp
    <%- | Boolean $keys_enable,
          String  $keys_file,
          Array   $keys_trusted,
          String  $keys_requestkey,
          String  $keys_controlkey
    | -%>
    <%# Parameter tag ↑ -%>

    <%# Non-printing tag ↓ -%>
    <% if $keys_enable { -%>
    <%# Expression-printing tag ↓ -%>
    keys <%= $keys_file %>
    <% unless $keys_trusted =~ Array[Data,0,0] { -%>
    trustedkey <%= $keys_trusted.join(' ') %>
    <% } -%>
    <% if $keys_requestkey =~ String[1] { -%>
    requestkey <%= $keys_requestkey %>
    <% } -%>
    <% if $keys_controlkey =~ String[1] { -%>
    controlkey <%= $keys_controlkey %>
    <% } -%>
~~~

An EPP template looks like a plain-text document interspersed with tags containing Puppet expressions. When evaluated, these tagged expressions can modify text in the template. You can use Puppet [variables][] in an EPP template to customize its output.

## Tags

EPP has two tags for Puppet code, optional tags for parameters and comments, and a way to escape tag delimiters.

* `<%= EXPRESSION %>` --- Inserts the value of a single expression.
    * With `-%>` --- Trims any trailing spaces and up to one following line break.
* `<% EXPRESSION %>` --- Executes any expressions, but does not insert a value.
    * With `<%-` --- Trims the preceding indentation.
    * With `-%>` --- Trims any trailing spaces and up to one following line break.
* `<% | PARAMETERS | %>` --- Declares the template's parameters.
    * With `<%-` --- Trims the preceding indentation.
    * With `-%>` --- Trims any trailing spaces and up to one following line break.
* `<%# COMMENT %>` --- Removed from the final output.
    * With `-%>` --- Trims any trailing spaces and up to one following line break.
* `<%%` or `%%>` --- A literal `<%` or `%>`, respectively.

Text outside a tag becomes literal text, but it is subject to any tagged Puppet code surrounding it. For example, text surrounded by a tagged `if` statement only appears in the output if the condition is true.

### Expression-Printing Tags

`<%= $fqdn %>`

An expression-printing tag inserts the value of a single [Puppet expression](./lang_expressions.html) into the output. It starts with an opening tag delimiter and equals sign (`<%=`) and ends with a closing tag delimiter (`%>`). It must contain any single Puppet expression that resolves to a value, including plain variables, [function calls](./lang_functions.html), and arithmetic expressions. If the value isn't a string, Puppet automatically converts it to a string based on the [rules for value interpolation in double-quoted strings](./lang_data_string.html#conversion-of-interpolated-values).

For example, to insert the value of the `$fqdn` and `$hostname` facts in an EPP template for an Apache config file, you could do something like:

~~~ epp
    ServerName <%= $fqdn %>
    ServerAlias <%= $hostname %>
~~~

#### Space Trimming

You can trim trailing whitespace and line breaks after expression-printing tags by adding a hyphen to the closing tag delimiter.

* `-%>` --- If the tag ends a line, trim all trailing whitespace and the following line break.

### Non-Printing Tags

`<% if $broadcastclient == true %> ...text... <% end %>`

A non-printing tag executes the code it contains, but doesn't insert a value into the output. It starts with an opening tag delimiter (`<%`) and ends with a closing tag delimiter (`%>`).

Non-printing tags that contain [conditional][./lang_iteration.html] and [iterative][./lang_conditional.html] expressions can affect untagged text between the tagged expressions, making this type of tag useful for employing conditional or looping logic, or for manipulating data before outputting it.

For example, to insert text only if a certain variable was set, you could do something like:

~~~ erp
    <% if $broadcastclient == true -%>
    broadcastclient
    <% end -%>
~~~

Expressions in non-printing tags don't have to resolve to a value or be a complete statement, but the tag must close at a place where it would be legal to write another expression. For example, you couldn't write:

~~~ erp
    <%# Syntax error: %>
    <% $servers.each -%>
    # some server
    <% do |server| %> server <%= server %>
    <% end -%>
~~~

You must keep `do |server|` inside the first tag, because you can't insert an arbitrary statement between a method call and its required block.

[//]: # (^ CHECK THIS)

#### Space Trimming

You can trim whitespace surrounding a non-printing tag by adding hyphens (`-`) to the tag delimiters.

* `<%-` --- If the tag is indented, trim the indentation.
* `-%>` --- If the tag ends a line, trim any trailing whitespace and the following line break.

### Parameter Tags

`<%- | Boolean $keys_enable | -%>`

A parameter tag declares parameters that become local [variables][] within the template. A parameter can be [typed](./lang_data_type.html) and have a default value.

The parameter tag is optional; if used, it **must** be the first content in a template. The parameter tag should always close with a right-trimmed delimiter (`-%>`) to avoid outputting a blank line. Literal text, line breaks, and non-comment tags cannot precede the template's parameter tag. (Comment tags that precede a parameter tag must use the right-trimming tag to trim trailing whitespace.)

Each parameter in the tag follows this format:

`<DATA TYPE> <VARIABLE NAME> = <DEFAULT VALUE>`

Only the variable name is required.

By calling the EPP template with a [hash][] as the last argument of the `[epp][]` or `[inline_epp][]` functions, you can pass parameter values to the template:

~~~ puppet
    # Outputs 'Hello given argument world!'
    $x = 'local variable world'
    inline_epp(@(END:epp), { x => 'given argument' })
    <%- | $x | -%>
    Hello <%= $x %> world!
    END
~~~

[//]: # (^ CHECK THIS, as I changed `inline_epptemplate` to `inline_epp`. I only see `inline_epptemplate` in autogenerated reference pages, and it's contradicted in usage and the `puppet-epp` manpage.)

You **must** pass values for all parameters that lack default values for Puppet to evaluate the template; to declare an optional parameter, assign it a default value in the template's parameter tag. You can only pass undeclared parameters to an EPP template in this fashion if it does not contain a parameter tag.

#### Space Trimming

You can trim whitespace surrounding a parameter tag by adding hyphens (`-`) to the tag delimiters.

* `<%- |` --- If the tag is indented, trim the indentation.
* `| -%>` --- If the tag ends a line, trim the trailing whitespace and the following line break.

### Comment Tags

`<%# This is a comment. %>`

A comment tag's contents do not appear in the template's output. It starts with an opening tag delimiter and a hash sign (`<%#`) and ends with a closing tag delimiter (`%>`).

#### Space Trimming

You can trim line breaks after comment tags by adding a hyphen to the closing tag delimiter.

* `-%>` --- If the tag ends a line, trim the trailing whitespace and the following line break.

### Literal Tag Delimiters

If you need the template's final output to contain a literal `<%` or `%>`, you can escape them as `<%%` or `%%>`.

## Accessing Variables

Templates can access [variables][] with the standard Puppet syntax of `$variable` or `$class::variable`.

For instance, to access `$ntp::tinker` in a template, you can either pass it when calling the template:

`epp('example/example.epp', { 'tinker' => $ntp::tinker })`

... and use the `$tinker` parameter from within the template:

`The tinker value is <%= $tinker -%>.`

This approach results in clean, clear expressions, and you can see exactly what data a template relies on without having to read the whole template.

You can also access `$ntp::tinker` directly from the template:

`The tinker value is <%= $ntp::tinker -%>.`

This approach is easier if you need to use many variables.

Either way, when compared to [ERB][] (where the parent scope is set to the class calling the template), EPP helps you see where variables are supposed to come from simply by reading the template---you don't have to examine lots of code outside of the template to trace variables' sources.

An EPP template also has its own [local scope][]. The parent scope is set to node scope, or top scope if there's no [node definition][], which means you can access global variables like `$os` or `$trusted` by their short names. However, with one exception you can't use variables from the class that evaluated the template by their short names unless you pass them as parameters when calling the template with the `[epp][]` or `[inline_epp][]` functions.

### Special Rule for `inline_epp`

If you evaluate a template with the `[inline_epp][]` function, the template declares no parameters, and you don't pass any parameters, you can access variables from the surrounding class in the template by using the variables' short names. This exceptional behavior is only allowed if **all** of those conditions are true.

### Parameters

Parameters you pass as an argument of the `[epp][]` or `[inline_epp][]` functions that call the template, or that you declare in a [parameter tag](#parameter-tag) within the template, are locally scoped to the EPP template.

There are two ways you can pass specific parameters to an EPP template when calling it:

* Declare them in the template's parameter tag and pass only those parameters as an argument.
* Pass any parameters as an argument to a template that does not contain a parameter tag.

In other words, if you **do** declare parameters in a template, you can **only** pass those declared parameters when calling the template. If you **don't** declare parameters in a template, you can pass **any** parameters when calling the template.

[//]: # (TO DO:)
[//]: # (  - Test whether you can pass parameters into a template if the parameter tag is present but empty.)

## Example Template

The following example is an EPP translation of the `ntp.conf.epp` template from the [`puppetlabs-ntp`][ntp] module.

~~~ epp
    # ntp.conf: Managed by puppet.
    #
    <% if $ntp::tinker == true and ($ntp::panic or $ntp::stepout) { -%>
    # Enable next tinker options:
    # panic - keep ntpd from panicking in the event of a large clock skew
    # when a VM guest is suspended and resumed;
    # stepout - allow ntpd change offset faster
    tinker<% if $ntp::panic { %> panic <%= $ntp::panic %><% } %><% if $ntp::stepout { -%> stepout <%= $ntp::stepout %><% } %>
    <% } -%>

    <% if $ntp::disable_monitor == true { -%>
    disable monitor
    <% } -%>
    <% if $ntp::disable_auth == true { -%>
    disable auth
    <% } -%>

    <% if $ntp::restrict =~ Array[Data,1] { -%>
    # Permit time synchronization with our time source, but do not
    # permit the source to query or modify the service on this system.
    <% $ntp::restrict.flatten.each |$restrict| { -%>
    restrict <%= $restrict %>
    <% } -%>
    <% } -%>

    <% if $ntp::interfaces =~ Array[Data,1] { -%>
    # Ignore wildcard interface and only listen on the following specified
    # interfaces
    interface ignore wildcard
    <% $ntp::interfaces.flatten.each |$interface| { -%>
    interface listen <%= $interface %>
    <% } -%>
    <% } -%>

    <% if $ntp::broadcastclient == true { -%>
    broadcastclient
    <% } -%>

    # Set up servers for ntpd with next options:
    # server - IP address or DNS name of upstream NTP server
    # iburst - allow send sync packages faster if upstream unavailable
    # prefer - select preferrable server
    # minpoll - set minimal update frequency
    # maxpoll - set maximal update frequency
    <% [$ntp::servers].flatten.each |$server| { -%>
    server <%= $server %><% if $ntp::iburst_enable == true { %> iburst<% } %><% if $server in $ntp::preferred_servers { %> prefer<% } %><% if $ntp::minpoll { %> minpoll <%= $ntp::minpoll %><% } %><% if $ntp::maxpoll { %> maxpoll <%= $ntp::maxpoll %><% } %>
    <% } -%>

    <% if $ntp::udlc { -%>
    # Undisciplined Local Clock. This is a fake driver intended for backup
    # and when no outside source of synchronized time is available.
    server   127.127.1.0
    fudge    127.127.1.0 stratum <%= $ntp::udlc_stratum %>
    restrict 127.127.1.0
    <% } -%>

    # Driftfile.
    driftfile <%= $ntp::driftfile %>

    <% unless $ntp::logfile =~ Undef { -%>
    # Logfile
    logfile <%= $ntp::logfile %>
    <% } -%>

    <% unless $ntp::peers =~ Array[Data,0,0] { -%>
    # Peers
    <% [$ntp::peers].flatten.each |$peer| { -%>
    peer <%= $peer %>
    <% } -%>
    <% } -%>

    <% if $ntp::keys_enable { -%>
    keys <%= $ntp::keys_file %>
    <% unless $ntp::keys_trusted =~ Array[Data,0,0] { -%>
    trustedkey <%= $ntp::keys_trusted.join(' ') %>
    <% } -%>
    <% if $ntp::keys_requestkey =~ String[1] { -%>
    requestkey <%= $ntp::keys_requestkey %>
    <% } -%>
    <% if $ntp::keys_controlkey =~ String[1] { -%>
    controlkey <%= $ntp::keys_controlkey %>
    <% } -%>

    <% } -%>
    <% [$ntp::fudge].flatten.each |$entry| { -%>
    fudge <%= $entry %>
    <% } -%>

    <% unless $ntp::leapfile =~ Undef { -%>
    # Leapfile
    leapfile <%= $ntp::leapfile %>
    <% } -%>
~~~

To call this template from a manifest (presuming that the template file is located in the `templates` directory of the `puppetlabs-ntp` module), add the following code to the manifest:

~~~ puppet
# epp(<FILE REFERENCE>, [<PARAMETER HASH>])
file { '/etc/ntp.conf':
  ensure  => file,
  content => epp('ntp/ntp.conf.epp', {'service_name' => 'xntpd', 'iburst_enable' => true}),
  # Loads /etc/puppetlabs/code/environments/production/modules/ntp/templates/ntp.conf.epp
}
~~~