---
layout: default
title: "Future Parser: Reserved Words and Acceptable Names"
canonical: "/puppet/latest/reference/future_lang_reserved.html"
---

[settings]: ./config_about_settings.html
[tags]: ./future_lang_tags.html
[built_in]: ./future_lang_variables.html#facts-and-built-in-variables
[facts]: /facter/latest/core_facts.html
[capture]: ./future_lang_datatypes.html#regex-capture-variables
[conditional]: ./future_lang_conditional.html
[topscope]: ./future_lang_scope.html#top-scope
[namespace]: ./future_lang_namespaces.html
[scopes]: ./future_lang_scope.html
[contains]: ./future_lang_containment.html
[resources]: ./future_lang_resources.html
[class]: ./future_lang_classes.html
[qualified_var]: ./future_lang_variables.html#accessing-out-of-scope-variables
[type_ref]: /references/latest/type.html
[func_ref]: /references/latest/function.html
[environment]: ./environments.html

Reserved Words
-----

Several words in the Puppet language are **reserved**. This means they:

* Cannot be used as bare word strings --- you must quote these words if you wish to use them as strings.
* Cannot be used as names for custom functions.
* Cannot be used as names for classes.
* Cannot be used as names for custom resource types or defined resource types.

The following words are reserved:

* `and` --- expression operator
* `attr` --- reserved for future use
* `case` --- language keyword
* `class` --- language keyword
* `default` --- language keyword
* `define` --- language keyword
* `else` --- language keyword
* `elsif` --- language keyword
* `false` --- boolean value
* `function` --- reserved for future use
* `if` --- language keyword
* `import` --- language keyword
* `in` --- expression operator
* `inherits` --- language keyword
* `node` --- language keyword
* `or` --- expression operator
* `private` --- reserved for future use
* `true` --- boolean value
* `type` --- reserved for future use
* `undef` --- special value
* `unless` --- language keyword

Additionally, you cannot use the name of any existing [resource type][type_ref] or [function][func_ref] as the name of a function, and you cannot use the name of any existing [resource type][type_ref] as the name of a defined type. You should not use the name of any existing data type (e.g. integer) as the name of a user defined type as they cannot be directly referenced with only their upper cased name (e.g. `Resource[integer, title]` must then be used to reference such resources instead of just `Integer[title]`).

Reserved Class Names
-----

The following are built-in namespaces used by Puppet and so must not be used as class names:

* `main` --- Puppet automatically creates a `main` [class][], which [contains][] any [resources][] not contained by any other class.
* `settings` --- The automatically created `settings` namespace contains variables with the [settings][] available to the compiler (that is, the puppet master's settings).

Additionally, the names of data types can't be used as class names:

* `any`, `Any`
* `array`, `Array`
* `boolean`, `Boolean`
* `catalogentry`, `catalogEntry, CatalogEntry`
* `class`, `Class`
* `collection`, `Collection`
* `callable`, `Callable`
* `data`, `Data`
* `default`, `Default`
* `enum`, `Enum`
* `float`, `Float`
* `hash`, `Hash`
* `integer`, `Integer`
* `numeric`, `Numeric`
* `optional`, `Optional`
* `pattern`, `Pattern`
* `resource`, `Resource`
* `runtime`, `Runtime`
* `scalar`, `Scalar`
* `string`, `String`
* `struct`, `Struct`
* `tuple`, `Tuple`
* `type`, `Type`
* `undef`, `Undef`
* `variant`, `Variant`


Reserved Variable Names
-----

The following variable names are reserved, and you **must not** assign values to them:

* Every variable name consisting only of numbers, starting with `$0` --- These [regex capture variables][capture] are automatically set by regular expressions used in [conditional statements][conditional], and their values do not persist outside their associated code block or selector value. An error is raised if an attempt is made to assign to these variables.
* Puppet's [built-in variables][built_in] and [facts][facts] are reserved at [top scope][topscope], but can be safely re-used at node or local scope.
* If [enabled][trusted_on], the `$trusted` and `$facts` variables are reserved for facts and cannot be reassigned at local scopes.

[trusted_on]: ./config_important_settings.html#getting-new-features-early

Reserved Parameter Names
------

The following are special variable names that may not be used as parameters in classes or defined types:

* `$title` -- the title of a class or defined type
* `$name` -- a synonym for `$title`

Acceptable Characters in Names
-----

Puppet limits the characters you can use when naming language constructs.

> Note: In some cases, names containing unsupported characters will still work. These cases should be considered bugs, and may cease to work at any time. Removal of these bug cases will not be limited to major releases.

### Variables

Variable names begin with a `$` (dollar sign) and can include:

* Uppercase and lowercase letters
* Numbers
* Underscores

The first character after the $ must not be an uppercase letter, and generally may not be an underscore (local variables are the exception). Variable names are case-sensitive. Note that [some variable names are reserved.](#reserved-variable-names)

Variable names should match the following regular expression:

    \A\$[a-z0-9][a-zA-Z0-9_]+\Z

Variable names can be [fully qualified][qualified_var] to refer to variables from foreign [scopes][]. Qualified variable names look like `$class::name::variable_name`. They begin with `$`, the name of the class that contains the variable, and the `::` (double colon) [namespace][] separator, and end with the variable's local name.

Qualified variable names should match the following regular expression:

    \A\$([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*::[a-z][a-zA-Z0-9_]+\Z

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

### Modules

Module names obey the same rules as individual class/type namespace segments. That is, they **must begin with a lowercase letter** and can include:

* Lowercase letters
* Digits
* Underscores

Module names should match the following regular expression:

    \A[a-z][a-z0-9_]*\Z

Note that [reserved words](#reserved-words) and [reserved class names](#reserved-class-names) cannot be used as module names.

### Parameters

Class and defined type parameters begin with a `$` (dollar sign), and their first non-`$` character **must be a lowercase letter.** They can include:

* Lowercase letters
* Digits
* Underscores

Parameter names should match the following regular expression:

    \A\$[a-z][a-z0-9_]*\Z

### Tags

[Tags][] must begin with a lowercase letter, number, or underscore, and can include:

* Lowercase letters
* Digits
* Underscores
* Colons
* Periods
* Hyphens

Tag names should match the following regular expression:

    \A[a-z0-9_][a-z0-9_:\.\-]*\Z

### Resources

Resource **titles** may contain any characters whatsoever. They are case-sensitive.

Resource names (or namevars) may be limited by the underlying system being managed. (E.g., most systems have limits on the characters allowed in the name of a user account.) The user is generally responsible for knowing the name limits on the platforms they manage.

### Nodes

**The set of characters allowed in node names is undefined** in this version of Puppet. For best future compatibility, you should limit node names to letters, numbers, periods, underscores, and dashes. (That is, node names should match `/\A[a-z0-9._-]+\Z/`.)

### Environments

[Environment][] names may contain only numbers and lowercase letters. That is, they must match the following regular expression:

    \A[a-z0-9]+\Z
