---
layout: default
title: Style and Usage Guide
---

Style and Usage Guide
===========

This file documents the documentation project's conventions for writing about Puppet.

* * *

Introduction
------------

Our use of language is somewhat scattershot. This is an attempt to wrangle it, a bit. 



Version Issues
--------------

Occasionally, like with 2.6, a major version changes the terminology or the names of various tools and services. After one of these changes, all documentation not addressing backwards compatibility should use the new names and terminology exclusively. 

Eventually, we may need a prominent "decoder" document; in the meantime, the [Tools](./tools.html) reference will do.

Synecdoche
----------

It is okay to refer to a piece of physical or virtual hardware as a "puppet master" or "puppet agent," and it can potentially be less confusing than calling them "clients" or "servers" (especially since it's pretty likely that a given agent node is also a server in some capacity). Also good: "agent node" and "puppet master server." 

"Puppet"
--------

The word "puppet" is somewhat overloaded. Here's how to use it and the various terms it's attached to:

1. When referring to the entire suite/solution, Puppet is a normal proper noun. 
2. When referring to an executable tool by name (e.g. "puppet agent"), it is downcased; the principle here is that when an utterance is both a proper name and part of an executable statement, we should treat it more like code than like a name.
    * However, tool names obey sentence case (e.g. "Puppet doc is your new friend."), since the readability implications of capitalization become more important at the sentence level.
    * Tool names _do not_ obey title case when used in headers. This is inconsistent with the above re: sentence case, but a: headers don't work the same way body text does, and b: this is one of those cases where it was going to look slightly wrong no matter what we chose. 
3. When the name of a tool is used as an adjectival noun or is referring to a piece of hardware by synecdoche (e.g. "your puppet master server" or "your puppet master" or "managing ten puppet agents"), the same rules outlined in 2 apply. 
4. When the name of a tool is functioning as a _complete_ shell command, style it `as code` (e.g. "...and then run `puppet agent`"). Code spans in Markdown are delimited by \`backticks\`. (In theory, this usage is more strict and would also violate sentence case if positioned at the beginning of a sentence... but don't ever do that.) If you are instructing the reader to run the tool but have not provided a _complete_ command (e.g. "...after the task completes, run puppet agent again with the same command line flags."), the same rules outlined in 2 apply.
5. The main exception to _all_ of the above is Puppet Dashboard, which is always treated as a normal proper noun in both expanded and shortened ("Dashboard") forms. This is because Dashboard never gets executed by a user at the command line, and thus is only a product name and not an executable statement. 
6. If you screw up in applying any of this, it's not the end of the world. 


Variables To Be Substituted By the Reader
-----------------------------------------

Occasionally you want a variable substitution to happen in the reader's brain instead of in the computer; in these cases, surround the placeholder text with curly braces and try to word it such that the reader won't try to enter it verbatim. e.g.: "Puppet file server URIs are formatted as `puppet://{server hostname (optional)}/{mount point}/{remainder of path}`."

The Puppet DSL includes curly braces in its syntax, so take care. We may eventually look for another way to format placeholder text.


Coming soon
-----------

* Jeff's define/declare/evaluate rules
* Parameters, values, attributes, bears
