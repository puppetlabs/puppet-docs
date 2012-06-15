---
layout: default
title: "Language: Reserved Words and Acceptable Names"
---

<!-- TODO -->
[runstage]: 
[settings]: 
[namespace]: 

Reserved Words
-----

Several words are **reserved** in the Puppet language. This means they: 

* Cannot be used as bare word strings --- you must quote these words if you wish to use them as strings.
* Cannot be used as names for custom functions.
* Cannot be used as names for classes.
* Cannot be used as names for custom resource types or defined resource types.

The following words are reserved: 

* `true` --- special value
* `false` --- special value
* `undef` --- special value
* `class` --- language keyword
* `node` --- language keyword
* `define` --- language keyword
* `inherits` --- language keyword
* `if` --- language keyword
* `else` --- language keyword
* `elsif` --- language keyword
* `case` --- language keyword
* `default` --- language keyword

### Reserved Class Names

The following are built-in namespaces used by Puppet, which must not be used as class names:

* `main` --- Puppet automatically creates a `main` [run stage][runstage], which contains any resources not given an explicit run stage.
* `settings` --- The automatically created `settings` namespace contains variables with the [settings][] available to the compiler (that is, the puppet master's settings). 

Acceptable Characters in Names
-----

Puppet limits the characters you can use when naming language constructs.

> Note: In some cases, names containing unsupported characters can still work. These cases should be considered bugs, and may cease to work at any time. Removal of these bug cases will not be limited to major releases.

### Variables

Variable names can include:

* Uppercase and lowercase letters
* Numbers
* Underscores

There is no additional restriction on the first character of a variable name. Variable names are case-sensitive.

Fully qualified variables may use `::` (double colon) as a [namespace][] separator.

### Classes and Types

The names of classes, defined types, and custom types **must begin with a lowercase letter.** They can include:

* Lowercase letters
* Numbers
* Underscores
* `::` (double colon), used as a [namespace][] separator

### Modules

Module names obey the same rules as class names, with the added restriction that they cannot include the `::` namespace separator.

### Parameters

Class and defined type parameters **must begin with a lowercase letter.** They can include:

* Lowercase letters
* Numbers
* Underscores

### Resources

Resource titles may contain any characters whatsoever. They are case-sensitive.

