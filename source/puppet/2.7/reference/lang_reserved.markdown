---
layout: default
title: "Language: Reserved Words and Acceptable Names"
---

<!-- TODO: Bring configuration guide into reference manual -->
[settings]: /guides/configuring.html
[tags]: ./lang_tags.html
[namespace]: ./lang_namespaces.html
[scopes]: ./lang_scope.html
[contains]: ./lang_containment.html
[resources]: ./lang_resources.html
[class]: ./lang_classes.html
[qualified_var]: ./lang_variables.html#accessing-out-of-scope-variables

Reserved Words
-----

Several words in the Puppet language are **reserved**. This means they: 

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

The following are built-in namespaces used by Puppet and so must not be used as class names:

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

Variable names should match the following regular expression:

    ^\$[a-zA-Z0-9_]+$

Variable names can be [fully qualified][qualified_var] to refer to variables from foreign [scopes][]. Qualified variable names look like `$class::name::variable_name`. They begin with `$`, the name of the class that contains the variable, and the `::` (double colon) [namespace][] separator, and end with the variable's local name. 

Qualified variable names should match the following regular expression:

    ^\$([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*::[a-zA-Z0-9_]+$

### Classes and Types

The names of classes, defined types, and custom types can consist of one or more [namespace segments][namespace]. Each namespace segment **must begin with a lowercase letter** and can include:

* Lowercase letters
* Numbers
* Underscores

Namespace segments should match the following regular expression:

    ^[a-z][a-z0-9_]*$

The one exception is the top namespace, whose name is the empty string.

Multiple namespace segments can be joined together in a class or type name with the `::` (double colon) [namespace][] separator. 

Class names with multiple namespaces should match the following regular expression:

    ^([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*$

### Modules

Module names obey the same rules as individual class/type namespace segments. That is, they **must begin with a lowercase letter** and can include:

* Lowercase letters
* Numbers
* Underscores

Module names should match the following regular expression:

    ^[a-z][a-z0-9_]*$

### Parameters

Class and defined type parameters begin with a `$` (dollar sign), and their first non-`$` character **must be a lowercase letter.** They can include:

* Lowercase letters
* Numbers
* Underscores

Parameter names should match the following regular expression:

    ^\$[a-z][a-z0-9_]*$

### Tags

[Tags][] must begin with a lowercase letter, number, or underscore, and can include:

* Lowercase letters
* Numbers
* Underscores
* Colons

Tag names should match the following regular expression: 

    ^[a-z0-9_][a-z0-9_:]*$

### Resources

Resource **titles** may contain any characters whatsoever. They are case-sensitive. 

Resource names (or namevars) may be limited by the underlying system being managed. (E.g., most systems have limits on the characters allowed in the name of a user account.) The user is generally responsible for knowing the name limits on the platforms they manage.

### Nodes

**The set of characters allowed in node names is undefined** in this version of Puppet. For best future compatibility, you should limit node names to letters, numbers, periods, underscores, and dashes. (That is, node names should match `/^[a-z0-9._-]+$/`.)
