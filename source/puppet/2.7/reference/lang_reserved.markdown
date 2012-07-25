---
layout: default
title: "Language: Reserved Words and Acceptable Names"
---

<!-- TODO -->
[contains]: ./lang_containment.html
[resources]: ./lang_resources.html
[class]: 
[settings]: 
[namespace]: 
[qualified_var]: 

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

Reserved Class Names
-----

The following are built-in namespaces used by Puppet, and so must not be used as class names:

* `main` --- Puppet automatically creates a `main` [class][], which [contains][] any [resources][] not contained by any other class.
* `settings` --- The automatically created `settings` namespace contains variables with the [settings][] available to the compiler (that is, the puppet master's settings). 

Acceptable Characters in Names
-----

Puppet limits the characters you can use when naming language constructs.

> Note: In some cases, names containing unsupported characters will still work. These cases should be considered bugs, and may cease to work at any time. Removal of these bug cases will not be limited to major releases.

### Variables

Variable names begin with a `$` (dollar sign) and can include:

* Uppercase and lowercase letters
* Numbers
* Underscores

There is no additional restriction on the first non-$ character of a variable name. Variable names are case-sensitive.

That is, variable names should match the following regular expression:

    ^\$[a-zA-Z0-9_]+

[Fully qualified variables][qualified_var] consist of `$`, the class name, the `::` (double colon) [namespace][] separator, and the variable's local name. That is, they should match the following regular expression:

    ^\$^[a-z][a-z0-9_]*(::[a-z][a-z0-9_]*)*::[a-zA-Z0-9_]+

### Classes and Types

The names of classes, defined types, and custom types **must begin with a lowercase letter.** They can include:

* Lowercase letters
* Numbers
* Underscores

That is, they should match the following regular expression:

    ^[a-z][a-z0-9_]*

Namespaced class and type names can be constructed by joining several valid class names with the `::` (double colon) [namespace][] separator. That is, they should match the following regular expression:

    ^[a-z][a-z0-9_]*(::[a-z][a-z0-9_]*)*

### Modules

Module names obey the same rules as class names, with the added restriction that they cannot include the `::` namespace separator.

That is, they should match the following regular expression:

    ^[a-z][a-z0-9_]*

### Parameters

Class and defined type parameters begin with a `$` (dollar sign), and their first non-`$` character **must be a lowercase letter.** They can include:

* Lowercase letters
* Numbers
* Underscores

That is, they should match the following regular expression:

    ^\$[a-z][a-z0-9_]*

### Resources

Resource **titles** may contain any characters whatsoever. They are case-sensitive. 

Resource names (or namevars) may be limited by the underlying system being managed. (E.g., most systems have limits on the characters allowed in the name of a user account.) The user is generally responsible for knowing these limits.

### Nodes

**The set of characters allowed in node names is undefined** in this version of Puppet. For best future compatibility, you should limit node names to letters, numbers, periods, underscores, and dashes. (That is, node names should match `/[a-z0-9._-]+/`.)
