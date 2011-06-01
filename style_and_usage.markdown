Style and Usage Guide
=====================

The documentation project's conventions for writing about Puppet.

* * *

Version Issues
--------------

Occasionally, like with 2.6, a major version changes the terminology or the
names of various tools and services. After one of these changes, all
documentation not addressing backwards compatibility should use the new names
and terminology exclusively.

Eventually, we may need a more prominent "decoder" document; in the meantime,
the [Tools](./tools.html) reference will do.

Agent and Master Systems
------------------------

Systems running puppet master should be usually called "puppet master servers"
or "puppet masters." Systems running puppet agent should usually be called
"agent nodes." We're avoiding "server" and "client" because agent nodes are
almost always servers themselves.

"Puppet"
--------

Here's how to style the word "puppet," depending on how it's being used:

1. When referring to the entire suite/solution, Puppet is a normal proper noun. 
2. When referring to an executable tool by name (e.g. "puppet agent"), it is
downcased; the principle here is that when an utterance is both a proper name
and part of an executable statement, we should treat it more like code than like
a name.
    * However, tool names obey sentence case (e.g. "Puppet doc is your new
    friend.") and title case.
3. When the name of a tool is used as an adjectival noun or is referring to a
piece of hardware by synecdoche (e.g. "your puppet master server" or "your
puppet master" or "managing ten puppet agents"), follow rule 2.
4. When the name of a tool is functioning as a _complete_ shell command, style
it as code (e.g. "...and then run `puppet agent`"). Code spans in Markdown are
\`delimited by backticks\`. If you are instructing the reader to run the tool
but have not provided a _complete_ command (e.g. "...after the task completes,
run puppet agent again with the same command line flags."), follow rule 2.
5. Puppet Dashboard is always treated as a normal proper noun in both expanded
and shortened ("Dashboard") forms. This is because Dashboard never gets executed
by a user at the command line, and thus is only a product name and not an
executable statement.

Placeholder Text
----------------

Surround placeholder text with either curly braces or angle brackets, depending
on the context. When possible, try to word placeholder text such that the reader
won't try to enter it verbatim. e.g.:
"Puppet file server URIs are formatted as
`puppet://{server hostname (optional)}/{mount point}/{remainder of path}`."

Quoting Commands and Responses
------------------------------

If you're quoting a shell command inline, context should keep it from being
confusing. If quoting a group of commands and responses as a code block, prefix
the commands with $ or #, depending on whether they're to be run with user or
root privileges. For clarity, you can choose to prefix shorter responses with >,
but longer responses are usually visually distinctive enough to be obvious.

Define/Declare
--------------

Use standard verbs to describe the things that can be done to Puppet constructs:

You **define** a class or resource type when you write its implementation. For
defined resource types, this is done with the `define` keyword; for classes,
it's done with `class some::class { ... }`. You could consider the definition of
native resource types to happen in their Ruby type/provider code.

To **declare** a resource or class is to create an instance of the thing that
was previously defined. That is, you define a type, but you declare a resource.
Declaring classes is done with the `class { "some::class": attribute => value,}`
syntax or with the `include` statement.

Attributes, Values, and Parameters
----------------------------------

Resource (and parameterized class) declarations consist of a type, a title, and
a series of **attribute** `=>` **value** pairs.

When defining a resource type or a parameterized class, you specify a list of
**parameters** it accepts (e.g.
`define gitrepo($giturl, $path = $title, $branches = [master]) { ... }`).

Thus, parameters are relevant to the implementation, and attributes are relevant
to the interface.
