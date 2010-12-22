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

The word "puppet" is somewhat overloaded. Here's how to use it:

* When referring to the entire suite/solution, Puppet is capitalized. 
* When referring to an executable tool (e.g. puppet agent) by name, it's downcased.
    * However, tool names obey sentence case (e.g. "Puppet doc is your new friend."). 
    * Tool names _do not_ obey title case when used in headers. (This is one of those cases where it's going to look slightly wrong no matter what, so be sparing about using tool names in headers.)
* When the name of a tool is used as an adjectival noun or is referring to a piece of hardware by synecdoche (e.g. "your puppet master server" or "your puppet master" or "managing ten puppet agents"), the same rules apply: downcase it unless it starts a sentence.
* When the name of a tool is functioning as a _complete_ shell command (e.g. "...and then run `puppet agent`"), wrap it in \`backticks\`. (In theory, it would probably be downcased even at the beginning of a sentence, but don't ever do that.) If you are instructing the reader to run the tool but have not provided a _complete_ command (e.g. "...after the task completes, run puppet agent again with the same command line flags."), treat it as simply the name of the tool.


Coming soon
-----------

* Jeff's define/declare/evaluate rules
* Parameters, values, attributes, bears
