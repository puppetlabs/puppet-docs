---
layout: default
title: "Language: Reserved Words and Acceptable Names"
canonical: "/puppet/latest/reference/lang_reserved.html"
---

[settings]: ./config_about_settings.html
[tags]: ./lang_tags.html
[built_in]: ./lang_variables.html#facts-and-built-in-variables
[facts]: /facter/latest/core_facts.html
[capture]: ./lang_datatypes.html#regex-capture-variables
[conditional]: ./lang_conditional.html
[topscope]: ./lang_scope.html#top-scope
[namespace]: ./lang_namespaces.html
[scopes]: ./lang_scope.html
[contains]: ./lang_containment.html
[resources]: ./lang_resources.html
[class]: ./lang_classes.html
[qualified_var]: ./lang_variables.html#accessing-out-of-scope-variables
[type_ref]: /puppet/latest/reference/type.html
[func_ref]: /puppet/latest/reference/function.html
[environment]: ./environments.html

Reserved Words
-----

Several words in the Puppet language are **reserved**. This means they:

* Cannot be used as bare word strings --- you must quote these words if you wish to use them as strings.
* Cannot be used as names for custom functions.
* Cannot be used as names for classes.
* Cannot be used as names for custom resource types or defined resource types.

> **Note:** As of Puppet 3, reserved words MAY be used as names for attributes in custom resource types. This is a change from the behavior of 2.7 and earlier.

The following words are reserved:

* `and` --- expression operator
* `case` --- language keyword
* `class` --- language keyword
* `default` --- language keyword
* `define` --- language keyword
* `else` --- language keyword
* `elsif` --- language keyword
* `false` --- boolean value
* `if` --- language keyword
* `in` --- expression operator
* `import` --- language keyword
* `inherits` --- language keyword
* `node` --- language keyword
* `or` --- expression operator
* `true` --- boolean value
* `undef` --- special value
* `unless` --- language keyword

Additionally, you cannot use the name of any existing [resource type][type_ref] or [function][func_ref] as the name of a function, and you cannot use the name of any existing [resource type][type_ref] as the name of a defined type.

Reserved Class Names
-----

The following are built-in namespaces used by Puppet and so must not be used as class names:

* `main` --- Puppet automatically creates a `main` [class][], which [contains][] any [resources][] not contained by any other class.
* `settings` --- The automatically created `settings` namespace contains variables with the [settings][] available to the compiler (that is, the puppet master's settings).

Reserved Variable Names
-----

The following variable names are reserved, and you **must not** assign values to them:

* `$string` --- If a variable with this name is present, all templates and inline templates in the current scope will return the value of `$string` instead of whatever they were meant to return. This is a bug rather than a deliberate design, and can be tracked at [issue #14093](http://projects.puppetlabs.com/issues/14093).
* Every variable name consisting only of numbers, starting with `$0` --- These [regex capture variables][capture] are automatically set by regular expressions used in [conditional statements][conditional], and their values do not persist outside their associated code block or selector value. Puppet's behavior when these variables are directly assigned a value is undefined.
* Puppet's [built-in variables][built_in] and [facts][facts] are reserved at [top scope][topscope], but can be safely re-used at node or local scope.
* If [enabled][trusted_on], the `$trusted` and `$facts` variables are reserved for facts and cannot be reassigned at local scopes.

[trusted_on]: ./config_important_settings.html#getting-new-features-early


Acceptable Characters in Names
-----

Puppet limits the characters you can use when naming language constructs.

> Note: In some cases, names containing unsupported characters will still work. These cases should be considered bugs, and may cease to work at any time. Removal of these bug cases will not be limited to major releases.

### Variables

Variable names begin with a `$` (dollar sign) and can include:

* Uppercase and lowercase letters
* Numbers
* Underscores

There is no additional restriction on the first non-$ character of a variable name. Variable names are case-sensitive. Note that [some variable names are reserved.](#reserved-variable-names)

Variable names should match the following regular expression:

    \A\$[a-zA-Z0-9_]+\Z

Variable names can be [fully qualified][qualified_var] to refer to variables from foreign [scopes][]. Qualified variable names look like `$class::name::variable_name`. They begin with `$`, the name of the class that contains the variable, and the `::` (double colon) [namespace][] separator, and end with the variable's local name.

Qualified variable names should match the following regular expression:

    \A\$([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*::[a-zA-Z0-9_]+\Z

### Classes and Types

The names of classes, defined types, and custom types can consist of one or more [namespace segments][namespace]. Each namespace segment **must begin with a lowercase letter** and can include:

* Lowercase letters
* Numbers
* Underscores

Namespace segments should match the following regular expression:

    \A[a-z][a-z0-9_]*\Z

The one exception is the top namespace, whose name is the empty string.

Multiple namespace segments can be joined together in a class or type name with the `::` (double colon) [namespace][] separator.

Class names with multiple namespaces should match the following regular expression:

    \A([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*\Z

Note that [some class names are reserved](#reserved-class-names), and [reserved words](#reserved-words) cannot be used as class or type names.

Additionally, you cannot use the name `<MODULE NAME>::init` for a class or defined type. This is because `init.pp` is a reserved filename, which should contain a class named after the module.

### Modules

Module names obey the same rules as individual class/type namespace segments. That is, they **must begin with a lowercase letter** and can include:

* Lowercase letters
* Numbers
* Underscores

Module names should match the following regular expression:

    \A[a-z][a-z0-9_]*\Z

Note that [reserved words](#reserved-words) and [reserved class names](#reserved-class-names) cannot be used as module names.

### Parameters

Class and defined type parameters begin with a `$` (dollar sign), and their first non-`$` character **must be a lowercase letter.** They can include:

* Lowercase letters
* Numbers
* Underscores

Parameter names should match the following regular expression:

    \A\$[a-z][a-z0-9_]*\Z

### Tags

[Tags][] must begin with a lowercase letter, number, or underscore, and can include:

* Lowercase letters
* Numbers
* Underscores
* Colons
* Periods
* Hyphens

Tag names should match the following regular expression:

    \A[a-z0-9_][a-z0-9_:\.\-]*\Z

### Resources

Resource **titles** can contain any characters whatsoever. They are case-sensitive.

Resource names (or namevars) might be limited by the underlying system being managed. (E.g., most systems have limits on the characters allowed in the name of a user account.) The user is generally responsible for knowing the name limits on the platforms they manage.

### Nodes

**The set of characters allowed in node names is undefined** in this version of Puppet. For best future compatibility, you should limit node names to letters, numbers, periods, underscores, and dashes. (That is, node names should match `/\A[a-z0-9._-]+\Z/`.)

### Environments

[Environment][] names can contain lowercase letters, numbers, and underscores. That is, they must match the following regular expression:

    \A[a-z0-9_]+\Z
