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


"Puppet"
--------

The word "puppet" is somewhat overloaded. Sorry. Here's how to use it and the various terms it's attached to:

* When referring to the entire suite/solution, Puppet is capitalized. 
* When referring to an executable tool (e.g. puppet agent) by name, it is downcased; the principle here is that when an utterance is both a proper name and an executable statement, we should treat it more like code than like a name.
    * However, tool names obey sentence case (e.g. "Puppet doc is your new friend."), since the readability implications of capitalization become more important at the sentence level.
    * Tool names _do not_ obey title case when used in headers. This is inconsistent with the above re: sentence case, but a: headers don't work the same way body text does, and b: this is one of those cases where it was going to look slightly wrong no matter what we chose. 
* All of the same rules apply when the name of a tool is used as an adjectival noun or is referring to a piece of hardware by synecdoche (e.g. "your puppet master server" or "your puppet master" or "managing ten puppet agents"). 
* When the name of a tool is functioning as a _complete_ shell command (e.g. "...and then run `puppet agent`"), wrap it in \`backticks\`. (In theory, this usage would also violate sentence case if positioned at the beginning of a sentence... but don't ever do that.) If you are instructing the reader to run the tool but have not provided a _complete_ command (e.g. "...after the task completes, run puppet agent again with the same command line flags."), treat it as simply the name of the tool.
* The main exception to _all_ of the above is Puppet Dashboard, which is always treated as a normal proper noun in both expanded and shortened ("Dashboard") forms. This is because Dashboard never gets executed by a user at the command line, and thus is only a product name and not an executable statement. 
* If you screw up in applying any of this, it's not the end of the world. 


Coming soon
-----------

* Jeff's define/declare/evaluate rules
* Parameters, values, attributes, bears
