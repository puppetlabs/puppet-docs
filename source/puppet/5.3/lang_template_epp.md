---
layout: default
title: "Language: Embedded Puppet (EPP) template syntax"
---

[erb]: ./lang_template_erb.html
[epp]: /puppet/latest/function.html#epp
[ntp]: https://forge.puppetlabs.com/puppetlabs/ntp
[inline_epp]: /puppet/latest/function.html#inlineepp
[functions]: ./lang_functions.html
[hash]: ./lang_data_hash.html
[local scope]: ./lang_scope.html
[node definition]: ./lang_node_definitions.html
[variables]: ./lang_variables.html
[defined type]: ./lang_defined_types.html
[variable_names]: ./lang_variables.html#naming
[typed]: ./lang_data_type.html

Embedded Puppet (EPP) is a templating language based on the [Puppet language](./lang_summary.html). You can use EPP in Puppet 4 and higher, as well as Puppet 3.5 through 3.8 with the [future parser](/puppet/3.8/experiments_future.html) enabled.

Puppet can evaluate EPP templates with the [`epp`][epp] and [`inline_epp`][inline_epp] functions.

This page covers how to write EPP templates. See [Templates](./lang_template.html) for information about what templates are and how to evaluate them.

## EPP structure and syntax

``` erp
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

<% } -%>
```

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

### Expression-printing tags

`<%= $fqdn %>`

An expression-printing tag inserts the value of a single [Puppet expression](./lang_expressions.html) into the output. It starts with an opening tag delimiter and equals sign (`<%=`) and ends with a closing tag delimiter (`%>`). It must contain any single Puppet expression that resolves to a value, including plain variables, [function calls](./lang_functions.html), and arithmetic expressions. If the value isn't a string, Puppet automatically converts it to a string based on the [rules for value interpolation in double-quoted strings](./lang_data_string.html#conversion-of-interpolated-values).

All facts are available in EPP templates. For example, to insert the value of the `fqdn` and `hostname` facts in an EPP template for an Apache config file, you could do something like:

``` epp
ServerName <%= $facts[fqdn] %>
ServerAlias <%= $facts[hostname] %>
```

#### Space trimming

You can trim trailing whitespace and line breaks after expression-printing tags by adding a hyphen to the closing tag delimiter.

* `-%>` --- If the tag ends a line, trim all trailing whitespace and the following line break.

### Non-printing tags

`<% if $broadcastclient == true { %> ...text... <% } %>`

A non-printing tag executes the code it contains, but doesn't insert a value into the output. It starts with an opening tag delimiter (`<%`) and ends with a closing tag delimiter (`%>`).

Non-printing tags that contain [iterative](./lang_iteration.html) and [conditional](./lang_conditional.html) expressions can affect the untagged text they surround.

For example, to insert text only if a certain variable was set, you could do something like:

``` erp
<% if $broadcastclient == true { -%>
broadcastclient
<% } -%>
```

Expressions in non-printing tags don't have to resolve to a value or be a complete statement, but the tag must close at a place where it would be legal to write another expression. For example, you couldn't write:

``` erp
<%# Syntax error: %>
<% $servers.each -%>
# some server
<% |server| { %> server <%= server %>
<% } -%>
```

You must keep `|server| {` inside the first tag, because you can't insert an arbitrary statement between a function call and its required block.

#### Space trimming

You can trim whitespace surrounding a non-printing tag by adding hyphens (`-`) to the tag delimiters.

* `<%-` --- If the tag is indented, trim the indentation.
* `-%>` --- If the tag ends a line, trim any trailing whitespace and the following line break.

### Parameter tags

[inpage_paramtag]: #parameter-tags

`<%- | Boolean $keys_enable = false, String $keys_file = '' | -%>`

A parameter tag declares which parameters the template will accept. Each parameter can be [typed][] and can have a default value.

The parameter tag is optional; if used, it **must** be the first content in a template. The parameter tag should always close with a right-trimmed delimiter (`-%>`) to avoid outputting a blank line. Literal text, line breaks, and non-comment tags cannot precede the template's parameter tag. (Comment tags that precede a parameter tag must use the right-trimming tag to trim trailing whitespace.)

The parameter tag's pair of pipe characters (`|`) should contain a comma-separated list of parameters. Each parameter follows this format:

``` puppet
Boolean $keys_enable = false
```

That is:

* An optional [data type][typed], which will restrict the allowed values for the parameter (defaults to `Any`)
* A [variable name][variable_names].
* An optional equals (`=`) sign and default value (which must match the data type, if one was specified).

Parameters with default values are optional, and can be omitted when the template is evaluated. (If you want to use a default value of `undef`, make sure to also specify a data type that allows `undef`. For example, `Optional[String]` will accept `undef` as well as any string. For more details, read up on [data types][typed].)

See [Parameters](#parameters) below for details about passing parameters.


#### Space trimming

You can trim whitespace surrounding a parameter tag by adding hyphens (`-`) to the tag delimiters.

* `<%- |` --- If the tag is indented, trim the indentation.
* `| -%>` --- If the tag ends a line, trim the trailing whitespace and the following line break.

### Comment tags

`<%# This is a comment. %>`

A comment tag's contents do not appear in the template's output. It starts with an opening tag delimiter and a hash sign (`<%#`) and ends with a closing tag delimiter (`%>`).

#### Space trimming

You can trim line breaks after comment tags by adding a hyphen to the closing tag delimiter.

* `-%>` --- If the tag ends a line, trim the trailing whitespace and the following line break.

### Literal tag delimiters

If you need the template's final output to contain a literal `<%` or `%>`, you can escape them as `<%%` or `%%>`. The first literal tag is taken, and the rest of the line is treated as a literal. This means that `<%% Test %%>` in an EPP template would turn out as `<% Test %%>` not `<% Test %>`.


## Accessing variables

EPP templates can access [variables][] with Puppet's normal `$variable` syntax (`The tinker value is <%= $ntp::tinker %>`), which is a major advantage over ERB.

A template works like a [defined type][]:

* It has its own anonymous [local scope][].
* The parent scope is set to node scope (or top scope if there's no [node definition][]).
* When you call the template (with the [`epp`][epp] or [`inline_epp`][inline_epp] functions), you can use parameters to set variables in its local scope.
* Unlike erb templates, epp templates cannot directly access variables in the calling class without namespacing. Fully qualify variables or pass them in as parameters.

This means templates can use short names to access global variables (like `$os` or `$trusted`) and their own local variables, but must use qualified names (like `$ntp::tinker`) to access variables from any class. (With one exception for `inline_epp`; [see below](#special-scope-rule-for-inlineepp).)

### Parameters

You can pass parameters when you call a template, and they will become local variables inside the template. To do this, pass a [hash][] as the last argument of the [`epp`][epp] or [`inline_epp`][inline_epp] functions:

``` puppet
epp('example/example.epp', { 'logfile' => "/var/log/ntp.log" })
```

``` epp
<%- | Optional[String] $logfile = undef | -%>
<%# (Declare the $logfile parameter as optional) -%>

<% unless $logfile =~ Undef { -%>
logfile <%= $logfile %>
<% } -%>
```

The keys of the hash should match the variable names you'll be using in the template, minus the leading `$` sign. Parameters must follow [the normal rules for local variable names.][variable_names]

If the template has a [parameter tag][inpage_paramtag], it **must** be the first content in a template and you can _only_ pass the parameters it declares. Passing any additional parameters is a syntax error. However, if a template omits the parameter tag, you can pass it any parameters.

If a template's parameter tag includes any parameters without default values, they are mandatory. You must pass values for them when calling the template.

#### Why use parameters?

Templates have two ways to use data:

* Directly access class variables like `$ntp::tinker`.
* Use parameters passed at call time.

These are both better than [ERB][]'s approach (where the parent scope is set to the class calling the template), because they're both more explicit and reliable; you can see where variables are supposed to come from simply by reading the template.

You should use class variables when a template is closely tied to the class that uses it, you don't expect it to be used anywhere else, and you need to use a _lot_ of variables.

You should use parameters when a template might be used in several different places and you want to keep it flexible. Also, declaring parameters with a tag makes a template's data requirements visible at a glance.

### Special scope rule for `inline_epp`

If:

* You evaluate a template with the [`inline_epp`][inline_epp] function.
* The template declares no parameters.
* You don't pass any parameters.

...you can access variables from the calling class in the template by using the variables' short names. This exceptional behavior is only allowed if **all** of those conditions are true.


## Example template

The following example is an EPP translation of the `ntp.conf.erb` template from the [`puppetlabs-ntp`][ntp] module.

``` epp
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
```

To call this template from a manifest (presuming that the template file is located in the `templates` directory of the `puppetlabs-ntp` module), add the following code to the manifest:

``` puppet
# epp(<FILE REFERENCE>, [<PARAMETER HASH>])
file { '/etc/ntp.conf':
  ensure  => file,
  content => epp('ntp/ntp.conf.epp'),
  # Loads /etc/puppetlabs/code/environments/production/modules/ntp/templates/ntp.conf.epp
}
```
