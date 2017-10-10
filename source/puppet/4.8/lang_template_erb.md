---
layout: default
title: "Language: Embedded Ruby (ERB) template syntax"
canonical: "/puppet/latest/lang_template_erb.html"
---

[erb]: http://ruby-doc.org/stdlib/libdoc/erb/rdoc/ERB.html
[ntp]: https://forge.puppetlabs.com/puppetlabs/ntp
[functions]: ./lang_functions.html
[local scope]: ./lang_scope.html
[lambdas]: ./lang_lambdas.html
[strings]: ./lang_data_string.html
[numbers]: ./lang_data_number.html
[arrays]: ./lang_data_array.html
[hashes]: ./lang_data_hash.html
[undef]: ./lang_data_undef.html
[variables]: ./lang_variables.html

[ERB][] is a templating language based on Ruby. Puppet can evaluate ERB templates with the `template` and `inline_template` functions.

This page covers how to write ERB templates. See [Templates](./lang_template.html) for information about what templates are and how to evaluate them.

**Note:** If you've used ERB in other projects, it might have had different features enabled. This page only describes how ERB works in Puppet.

## ERB structure and syntax

``` erb
<%# Non-printing tag ↓ -%>
<% if @keys_enable -%>
<%# Expression-printing tag ↓ -%>
keys <%= @keys_file %>
<% unless @keys_trusted.empty? -%>
trustedkey <%= @keys_trusted.join(' ') %>
<% end -%>
<% if @keys_requestkey != '' -%>
requestkey <%= @keys_requestkey %>
<% end -%>
<% if @keys_controlkey != '' -%>
controlkey <%= @keys_controlkey %>
<% end -%>

<% end -%>
```

An ERB template looks like a plain-text document interspersed with tags containing Ruby code. When evaluated, this tagged code can modify text in the template.

Puppet passes data to templates via special objects and variables, which you can use in the tagged Ruby code to control the templates' output.

## Tags

ERB has two tags for Ruby code, a tag for comments, and a way to escape tag delimiters.

* `<%= EXPRESSION %>` --- Inserts the value of an expression.
    * With `-%>` --- Trims the following line break.
* `<% CODE %>` --- Executes code, but does not insert a value.
    * With `<%-` --- Trims the preceding indentation.
    * With `-%>` --- Trims the following line break.
* `<%# COMMENT %>` --- Removed from the final output.
    * With `-%>` --- Trims the following line break.
* `<%%` or `%%>` --- A literal `<%` or `%>`, respectively.

Text outside a tag becomes literal text, but it is subject to any tagged Ruby code surrounding it. For example, text surrounded by a tagged `if` statement only appears in the output if the condition is true.

### Expression-printing tags

`<%= @fqdn %>`

An expression-printing tag inserts values into the output. It starts with an opening tag delimiter and equals sign (`<%=`) and ends with a closing tag delimiter (`%>`). It must contain a snippet of Ruby code that resolves to a value; if the value isn't a string, it will be automatically converted to a string using its `to_s` method.

For example, to insert the value of the `$fqdn` and `$hostname` facts in an Apache config file, you could do something like:

``` erb
ServerName <%= @fqdn %>
ServerAlias <%= @hostname %>
```

#### Space trimming

You can trim line breaks after expression-printing tags by adding a hyphen to the closing tag delimiter.

* `-%>` --- If the tag ends a line, trim the following line break.

### Non-printing tags

`<% if @broadcastclient == true %> ...text... <% end %>`

A non-printing tag executes the code it contains, but doesn't insert a value into the output. It starts with an opening tag delimiter (`<%`) and ends with a closing tag delimiter (`%>`).

Non-printing tags that contain iterative or conditional expressions can affect the untagged text they surround.

For example, to insert text only if a certain variable was set, you could do something like:

``` erb
    <% if @broadcastclient == true -%>
    broadcastclient
    <% end -%>
```

Non-printing code doesn't have to resolve to a value or be a complete statement, but the tag must close at a place where it would be legal to write another statement. For example, you couldn't write:

``` erb
<%# Syntax error: %>
<% @servers.each -%>
# some server
<% do |server| %>server <%= server %>
<% end -%>
```

You must keep `do |server|` inside the first tag, because you can't insert an arbitrary statement between a method call and its required block.

#### Space trimming

You can trim whitespace surrounding a non-printing tag by adding hyphens (`-`) to the tag delimiters.

* `<%-` --- If the tag is indented, trim the indentation.
* `-%>` --- If the tag ends a line, trim the following line break.

### Comment tags

`<%# This is a comment. %>`

A comment tag's contents do not appear in the template's output. It starts with an opening tag delimiter and a hash sign (`<%#`) and ends with a closing tag delimiter (`%>`).

#### Space trimming

You can trim line breaks after comment tags by adding a hyphen to the closing tag delimiter.

* `-%>` --- If the tag ends a line, trim the following line break.

### Literal tag delimiters

If you need the template's final output to contain a literal `<%` or `%>`, you can escape them as `<%%` or `%%>`.

## Accessing Puppet variables

Templates can access Puppet's [variables][]. This is the main source of data for templates.

An ERB template has its own [local scope][], and its parent scope is set to the class or defined type that evaluates the template. This means a template can use short names for variables from that class or type, but it can't insert new variables into it.

There are two ways to access variables in an ERB template:

* `@variable`
* `scope['variable']` (and its older equivalent, `scope.lookupvar('variable')`)

### `@variable`

All variables in the current scope (including global variables) are passed to templates as Ruby instance variables, which begin with "at" signs (`@`). If you can access a variable by its short name in the surrounding manifest, you can access it in the template by replacing its `$` sign with an `@`. So `$os` becomes `@os`, `$trusted` becomes `@trusted`, etc.

This is the most legible way to access variables, but it doesn't support variables from other scopes. For that, you need to use the `scope` object.

### `scope['variable']` or `scope.lookupvar('variable')`

Puppet also passes templates an object called `scope`, which can access all variables (including out-of-scope ones) with a hash-style access expression. For example, to access `$ntp::tinker` you would use `scope['ntp::tinker']`.

There is also another way to use the `scope` object: you can call its `lookupvar` method and pass the variable's name as its argument, like `scope.lookupvar('ntp::tinker')`. This is exactly equivalent to the above, but slightly less convenient. It predates the hash-style indexing, which was added in Puppet 3.0.

### Puppet data types in Ruby

Puppet's data types are converted to Ruby classes as follows:

{% partial ./_puppet_types_to_ruby_types.md %}

### Testing for undefined variables

If a Puppet variable was never defined, its value is `undef`, which means its value in a template will be `nil`.

## Some basic Ruby for ERB templates

To manipulate and print data in ERB templates, you'll need to know a small amount of Ruby. We can't teach that on this page, but we can give a brief look at some of the things you're likely to use.

### `if` statements

Ruby's `if ... end` statement lets you write conditional text. You'll want to put the control statements in non-printing tags, and the conditional text between the tags. (Like `<% if <CONDITION> %> text goes here <% end %>`.)

``` erb
<% if @broadcast != "NONE" %>broadcast <%= @broadcast %><% end %>
```

The general format of an `if` statement is:

``` puppet
if <CONDITION>
  ... code ...
elsif <CONDITION>
  ... other code ...
end
```

### Iteration

Ruby lets you iterate over arrays and hashes with the `each` method. This method takes a block of code, and executes it once for each element in the array or hash. In a template, un-tagged text is treated as part of the code that gets repeated. (It might help to think of literal text as an _instruction,_ telling the evaluator to insert that text into the final output.)

To write a block of code in Ruby, use either `do |arguments| ... end` or `{|arguments| ... }`. Note that this is different from [Puppet's lambdas][lambdas] ---  but they work similarly.

``` erb
<% @values.each do |val| -%>
Some stuff with <%= val %>
<% end -%>
```

If `$values` was set to `['one', 'two']`, this example would produce:

```
Some stuff with one
Some stuff with two
```

This example also trims line breaks for the non-printing tags, so they won't appear as blank lines in the output.

### Manipulating data

Usually, your templates will use data from Puppet variables. These values will almost always be [strings][], [numbers][], [arrays][], and [hashes][].

These will become the equivalent Ruby objects when you access them from an ERB template. For information about the ways you can transform these objects, see the Ruby documentation for:

* [Strings](http://ruby-doc.org/core/String.html)
* [Integers](http://ruby-doc.org/core/Integer.html)
* [Arrays](http://ruby-doc.org/core/Array.html)
* [Hashes](http://ruby-doc.org/core/Hash.html)

Also, note that Puppet's [special `undef` value][undef] becomes Ruby's special `nil` value in ERB templates.

## Calling Puppet functions from templates

You can use [Puppet functions][functions] inside templates with the `scope.call_function(<NAME>, <ARGS>)` method. This method takes two arguments:

* The name of the function, as a string.
* All arguments to the function, as an array. (This must be an array even for one argument or zero arguments.)

For example, to evaluate one template inside another:

    <%= scope.call_function('template', ["my_module/template2.erb"]) %>

To log a warning using Puppet's own logging system, so that it will appear in reports:

    <%= scope.call_function('warning', ["Template was missing some data; this config file may be malformed."]) %>

> **Note:** Previous versions of Puppet handled this by creating a `function_<NAME>` method on the `scope` object for each function; these could be called with an arguments array, like `<%= scope.function_template(["my_module/template2.erb"]) %>`
>
> That still works in this version of Puppet, but the `call_function` method is better. The auto-generated methods don't support the modern function APIs, which are now used by the majority of built-in functions.
>
> `scope.call_function` was added in Puppet 4.2.

## Example template

This example template is taken from [the puppetlabs/ntp][ntp] module.

``` erb
# ntp.conf: Managed by puppet.
#
<% if @tinker == true and (@panic or @stepout) -%>
# Enable next tinker options:
# panic - keep ntpd from panicking in the event of a large clock skew
# when a VM guest is suspended and resumed;
# stepout - allow ntpd change offset faster
tinker<% if @panic -%> panic <%= @panic %><% end %><% if @stepout -%> stepout <%= @stepout %><% end %>
<% end -%>

<% if @disable_monitor == true -%>
disable monitor
<% end -%>
<% if @disable_auth == true -%>
disable auth
<% end -%>

<% if @restrict != [] -%>
# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
<% @restrict.flatten.each do |restrict| -%>
restrict <%= restrict %>
<% end -%>
<% end -%>

<% if @interfaces != [] -%>
# Ignore wildcard interface and only listen on the following specified
# interfaces
interface ignore wildcard
<% @interfaces.flatten.each do |interface| -%>
interface listen <%= interface %>
<% end -%>
<% end -%>

<% if @broadcastclient == true -%>
broadcastclient
<% end -%>

# Set up servers for ntpd with next options:
# server - IP address or DNS name of upstream NTP server
# iburst - allow send sync packages faster if upstream unavailable
# prefer - select preferrable server
# minpoll - set minimal update frequency
# maxpoll - set maximal update frequency
<% [@servers].flatten.each do |server| -%>
server <%= server %><% if @iburst_enable == true -%> iburst<% end %><% if @preferred_servers.include?(server) -%> prefer<% end %><% if @minpoll -%> minpoll <%= @minpoll %><% end %><% if @maxpoll -%> maxpoll <%= @maxpoll %><% end %>
<% end -%>

<% if @udlc -%>
# Undisciplined Local Clock. This is a fake driver intended for backup
# and when no outside source of synchronized time is available.
server   127.127.1.0
fudge    127.127.1.0 stratum <%= @udlc_stratum %>
restrict 127.127.1.0
<% end -%>

# Driftfile.
driftfile <%= @driftfile %>

<% unless @logfile.nil? -%>
# Logfile
logfile <%= @logfile %>
<% end -%>

<% unless @peers.empty? -%>
# Peers
<% [@peers].flatten.each do |peer| -%>
peer <%= peer %>
<% end -%>
<% end -%>

<% if @keys_enable -%>
keys <%= @keys_file %>
<% unless @keys_trusted.empty? -%>
trustedkey <%= @keys_trusted.join(' ') %>
<% end -%>
<% if @keys_requestkey != '' -%>
requestkey <%= @keys_requestkey %>
<% end -%>
<% if @keys_controlkey != '' -%>
controlkey <%= @keys_controlkey %>
<% end -%>

<% end -%>
<% [@fudge].flatten.each do |entry| -%>
fudge <%= entry %>
<% end -%>

<% unless @leapfile.nil? -%>
# Leapfile
leapfile <%= @leapfile %>
<% end -%>
```
