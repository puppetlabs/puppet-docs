---
layout: default
title: Style and Usage Guide
---

Style and Usage Guide
=====================

The documentation project's conventions for writing about Puppet.

* * *

Version Issues
--------------

Occasionally, like with 2.6, a major version changes the terminology or the names of various tools and services. After one of these changes, all documentation not addressing backwards compatibility should use the new names and terminology exclusively. 

Eventually, we may need a prominent "decoder" document; in the meantime, the [Tools](./tools.html) reference will do.

Synecdoche
----------

We've been trying to stick with "agent node" and "puppet master server" to talk about physical or virtual machines acting out agent and master roles, but sometimes it makes more sense to call them "puppet masters" or "puppet agents," which is fine.

"Puppet"
--------

The word "puppet" is somewhat overloaded. Here's how to use it and the various terms it's attached to:

1. When referring to the entire suite/solution, Puppet is a normal proper noun. 
2. When referring to an executable tool by name (e.g. "puppet agent"), it is downcased; the principle here is that when an utterance is both a proper name and part of an executable statement, we should treat it more like code than like a name.
    * However, tool names obey sentence case (e.g. "Puppet doc is your new friend."), since the readability implications of capitalization become more important at the sentence level.
    * Tool names _do not_ obey title case when used in headers. This is inconsistent with the above re: sentence case, but a: headers don't work the same way body text does, and b: this is one of those cases where it was going to look slightly wrong no matter what we chose. 
3. When the name of a tool is used as an adjectival noun or is referring to a piece of hardware by synecdoche (e.g. "your puppet master server" or "your puppet master" or "managing ten puppet agents"), the same rules outlined in 2 apply. 
4. When the name of a tool is functioning as a _complete_ shell command, style it as code (e.g. "...and then run `puppet agent`"). Code spans in Markdown are \`delimited by backticks\`. (In theory, this usage is more strict and would also violate sentence case if positioned at the beginning of a sentence... but avoid doing that.) If you are instructing the reader to run the tool but have not provided a _complete_ command (e.g. "...after the task completes, run puppet agent again with the same command line flags."), the same rules outlined in 2 apply.
5. The main exception to _all_ of the above is Puppet Dashboard, which is always treated as a normal proper noun in both expanded and shortened ("Dashboard") forms. This is because Dashboard never gets executed by a user at the command line, and thus is only a product name and not an executable statement. 


In-Brain Variable Substitution
------------------------------

Occasionally you want a variable substitution to happen in the reader's brain instead of in the computer; in these cases, surround the placeholder text with curly braces and try to word it such that the reader won't try to enter it verbatim. e.g.: "Puppet file server URIs are formatted as `puppet://{server hostname (optional)}/{mount point}/{remainder of path}`."

The Puppet DSL includes curly braces in its syntax, so take care; we may reconsider this and try angle brackets in the future, but those are problematic when embedded in HTML, so.


Quoting Commands and Responses
------------------------------

If you're quoting a shell command inline, context should keep it from being confusing. If quoting a group of commands and responses as a code block, prefix the commands with $ or #, depending on whether they're to be run with user or root privileges. For clarity, you can choose to prefix shorter responses with \>, but longer responses are usually visually distinctive enough to be obvious. 

Define/Declare/Evaluate
-----------------------

These are the verbs we've decided on for talking about the various things that are done to Puppet constructs: 

You **define** a class or resource type when you write its implementation. For defined resource types, this is done with the `define` keyword; for classes, it's done with `class some::class { ... }`. You could consider the definition of native resource types to happen in their Ruby type/provider code. 

To **declare** a resource or class is to create an instance of the thing that was previously defined. That is, you define a type, but you declare a resource. Declaring classes is done with the `class { "some::class": attribute => value, }` syntax or with the `include` statement. Variables are also declared, though it doesn't make sense to talk about "defining" a variable. 

Then, the RAL **evaluates** resources from the compiled catalog and generates events on the managed system. 
<!-- I don't think that's right. I think the RAL **syncs** resources from the compiled catalog, and previous to that the compiler **evaluates** the manifest syntax to compile a catalog. -->

Attributes, Values, and Parameters
----------------------------------

Resource (and parameterized class) declarations consist of a type, a title, and a series of **attribute** `=>` **value** pairs. 

When defining a resource type or a parameterized class, you specify a list of **parameters** it accepts (e.g. `define gitrepo($giturl, $path = $title, $branches = [master]) { ... }`). 

Thus, parameters are relevant to the implementation, and attributes are relevant to the interface.



Coming soon
-----------

* Jeff's define/declare/evaluate rules
* Parameters, values, attributes, bears
