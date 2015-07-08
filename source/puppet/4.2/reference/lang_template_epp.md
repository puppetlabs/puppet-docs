---
layout: default
title: "Language: Embedded Puppet (EPP) Template Syntax"
canonical: "/puppet/latest/reference/lang_template_epp.html"
---




Embedded Puppet (EPP) is a templating language based on the Puppet language. You can use EPP in Puppet 4 and higher, as well as Puppet 3.5 through 3.8 with the future parser enabled.

Puppet can evaluate EPP templates with the `epp` and `inline_epp` functions.

This page is about how to write EPP templates. See [Templates](./lang_template.html) for info about what templates are and how to evaluate them.


## EPP Structure and Syntax

~~~ erb
<%- | Boolean $keys_enable,
      String  $keys_file,
      Array   $keys_trusted,
      String  $keys_requestkey,
      String  $keys_controlkey
| -%>
<%# Parameters tag ↑ -%>

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



BASIC DESCRIPTION GOES HERE.

## Tags

Mostly the same as ERB, except:

SPACE TRIMMING

The right-trim tag trims:
- any amount of trailing space characters, plus
- up to one following line break, if the tag ends a line (after any spaces were trimmed)

this is a difference from erb, which won't trim space characters with it!


EXPRESSION PRINTING TAGS:

- Make sure you link to ./lang_expressions.html.
- You can print any expression, including plain variables, function calls (link to lang_functions), arithmetic expressions, etc.
- If the value isn't a string, it is converted to a string based on the rules for value interpolation in double-quoted strings. see ./lang_data_string.html#conversion-of-interpolated-values
- An expression printing tag only accepts a single expression.

NON-PRINTING TAGS:

Same rules about not putting text where a new statement wouldn't be allowed.

PARAMETERS

we add a new parameters tag, which:

- Is optional.
- has to go first in the file -- a comment can go before it if you trim whitespace, but there can't be any literal text (including line breaks) or other tags before it. (You can indent it if you use the <%-, but that can't trim preceding line breaks.)
- declares parameters, which become local variables in the template. you can pass values for them in a hash when you call the template, see the lang_template file for examples of that I think?
- There's one up above in the example.
- Always right-trim it, so it doesn't cause a blank line.
- Each parameter goes like this:
    <DATA TYPE> <VARIABLE NAME> = <DEFAULT VALUE>
    Everything but the name is optional.
- If a parameter has a default value, it's an optional parameter when you evaluate the template. Parameters without defaults are mandatory, and you HAVE to pass a value to them in order to evaluate the template.

## Accessing Variables

Access variables with the standard Puppet syntax of `$variable` or `$class::variable`.

An EPP template has its own [local scope][]. The parent scope is set to node scope, or top scope if there's no node definition. This means you can access global variables (like `$os` or `$trusted`) by their short names, but you can't use short names variables from the class that evaluated the template.

When a manifest calls the `epp` or `inline_epp` functions, it can use parameters to set local variables in the template's scope.

### Special Rule for `inline_epp`

If you evaluate a template with the `inline_epp` function, the template declares no parameters, and you don't pass any parameters, then the template can actually access variables in the surrounding class by their short names. This is only allowed if all of those conditions are true.

I don't know why this exception exists. :)

### Parameters

- Point to the info about the parameters tag above.
- re-state the stuff about how to pass in parameters from lang_template, so people don't have to jump between pages so much.
- If you declare parameters in a template, then those are the ONLY parameters you can pass when evaluating the template. If you DON'T declare pre-defined parameter names, you can pass any arbitrary parameters to the template when you evaluate it.

- In short, to use data from a class in a template, you have two options:
    - Pass it in as parameters, then use it as local variables in the template.
        - This is nice and clean, and you can see exactly what data a template is relying on without having to read the whole template. But it can get wordy.
    - Access it directly with the variables' long names ($ntp::tinker and the like, as seen below in the long example).
        - This is easier if you have a whole pile of variables you have to use. The benefit vs. ERB's approach (where the parent scope is set to the calling class) is that you can tell where the variables are supposed to come from when reading the template, without having to trace the code all over the place.




MOSTLY SKIP THE STUFF ABOUT BASIC RUBY. We don't need an equivalent b/c we already document the Puppet language. You might point to the lang_iteration page and the lang_conditional page, though, as things that are useful in templates.


## Example Template

This example is an EPP translation the ntp.conf.erb template from [the puppetlabs/ntp][ntp] module.


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
