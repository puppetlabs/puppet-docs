---
layout: default
title: Learning — Functions and Templates
---

Learning — Functions and Templates
=========

File serving isn't the be-all/end-all of getting content into place. Before we cover parameterized classes and defined types, take a break to learn about templates, then a brief detour into some other functions.

* * *

&larr; [Modules (part one)](./modules1.html) --- [Index](./) --- [Modules (part two)](./modules2.html) &rarr;

* * * 

[templatecheat]: http://cheat.errtheblog.com/s/erb/

Templating
------

Okay: in the last chapter, you built a module that shipped and managed a configuration file, which was pretty cool. And if you expect all your enterprise Linux systems to use the exact same set of NTP servers, that's probably good enough. Except let's say you decide most of your machines should use internal NTP servers --- whose ntpd configurations are also managed by Puppet, and which should be asking for the time from an external source. The number of files you'll need to ship just multiplied, and they'll only differ by three or four lines, which seems redundant and wasteful. 

It would be much better if you could root around in the text of your configuration files with all the tricks you learned in [Variables, Conditionals, and Facts](./variables.html). Thus: templates!

Puppet can use [ERB templates][templatecheat] anywhere a string is called for. (Like a file's `content` attribute, for instance, or the value of a variable.) Templates go in the (wait for it) `templates/` directory of a module, and will mostly look like normal configuration files (or what-have-you), except for the occasional `<% tag with Ruby code %>`.

Yes, Ruby --- unfortunately you can't use the Puppet language in templates. But usually you'll only be printing a variable or doing a simple loop, which you'll get a feel for almost instantly. Anyway, let's cut to the chase: 

Some Simple ERB
-----

First, note that any **facts** and **variables defined in the current scope** are available to a template as standard Ruby local variables, which are plain words without a `$` sigil in front of them. Variables from other scopes are reachable, but to read them, you have to call the `lookupvar` method on the `scope` object. (For example, `scope.lookupvar('apache::user')`.)

### Tags

ERB tags are angle brackets with percent signs just inside. There isn't any HTML-like concept of opening or closing tags.

    <% document = "" %>

Tags can set variables, munge data, implement control flow, or... actually, pretty much anything. Normal tags won't print anything visible in the rendered output, though; for that, you need to use printing tags. 

### Printing an Expression

To print the value of an expression, use a printing tag, which looks like a normal tag with an equals sign right after the opening delimiter:

    <%= sectionheader %>
      environment = <%= gitrevision[0,5] %>

The expression can be a simple variable, or it can be an arbitrarily complicated Ruby expression.