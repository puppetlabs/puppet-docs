---
layout: default
title: "Future Parser: Reserved Words and Acceptable Names"
canonical: "/puppet/latest/reference/lang_reserved.html"
---

[settings]: ./config_about_settings.html
[tags]: ./future_lang_tags.html
[built_in]: ./future_lang_variables.html#facts-and-built-in-variables
[facts]: {{facter}}/core_facts.html
[capture]: ./future_lang_data_regexp.html#regex-capture-variables
[conditional]: ./future_lang_conditional.html
[topscope]: ./future_lang_scope.html#top-scope
[namespace]: ./future_lang_namespaces.html
[scopes]: ./future_lang_scope.html
[contains]: ./future_lang_containment.html
[resources]: ./future_lang_resources.html
[class]: ./future_lang_classes.html
[type_ref]: ./type.html
[func_ref]: ./function.html
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
* `application` --- reserved for future use; logs warning instead of error
* `attr` --- reserved for future use
* `case` --- language keyword
* `class` --- language keyword
* `consumes` --- reserved for future use; logs warning instead of error
* `default` --- language keyword
* `define` --- language keyword
* `else` --- language keyword
* `elsif` --- language keyword
* `false` --- boolean value
* `function` --- reserved for future use
* `if` --- language keyword
* `import` --- former language keyword (now removed)
* `in` --- expression operator
* `inherits` --- language keyword
* `node` --- language keyword
* `or` --- expression operator
* `private` --- reserved for future use
* `produces` --- reserved for future use; logs warning instead of error
* `true` --- boolean value
* `type` --- reserved for future use
* `undef` --- special value
* `unless` --- language keyword

Additionally:

* You cannot use the name of any existing [resource type][type_ref] or [function][func_ref] as the name of a function.
* You cannot use the name of any existing [resource type][type_ref] as the name of a defined type.
* You _shouldn't_ use the name of any existing data type (e.g. integer) as the name of a defined type, as this will make it inconvenient to interact with. (You can't directly reference a resource of that defined type with only its uppercased name --- instead of writing a resource reference like `Integer[title]`, you would have to use `Resource[integer, title]`.)

Reserved Class Names
-----

The following are built-in namespaces used by Puppet and so must not be used as class names:

* `main` --- Puppet automatically creates a `main` [class][], which [contains][] any [resources][] not contained by any other class.
* `settings` --- The automatically created `settings` namespace contains variables with the [settings][] available to the compiler (that is, the Puppet master's settings).

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

* Every variable name consisting only of digits, starting with `$0` --- These [regex capture variables][capture] are automatically set by regular expressions used in [conditional statements][conditional], and their values do not persist outside their associated code block or selector value. Puppet will raise an error if you try to assign to these variables.
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

{% partial ./_naming_variables.md %}

### Classes and Defined Types

The names of classes and defined types can consist of one or more [namespace segments][namespace]. Each namespace segment **must begin with a lowercase letter** and can include:

* Lowercase letters
* Digits
* Underscores

Namespace segments should match the following regular expression:

    \A[a-z][a-z0-9_]*\Z

The one exception is the top namespace, whose name is the empty string.

Multiple namespace segments can be joined together in a class or defined type name with the `::` (double colon) [namespace][] separator.

Class names with multiple namespaces should match the following regular expression:

    \A([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*\Z

Note that [some class names are reserved](#reserved-class-names), and [reserved words](#reserved-words) cannot be used as class or defined type names.

Additionally, you cannot use the name `<MODULE NAME>::init` for a class or defined type. This is because `init.pp` is a reserved filename, which should contain a class named after the module.

### Modules

Module names obey the same rules as individual namespace segments (like in a class or defined type name). That is, they **must begin with a lowercase letter** and can include:

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

Resource **titles** can contain any characters whatsoever. They are case-sensitive.

Resource names (or namevars) might be limited by the underlying system being managed. (E.g., most systems have limits on the characters allowed in the name of a user account.) The user is generally responsible for knowing the name limits on the platforms they manage.

### Nodes

**The set of characters allowed in node names is undefined** in this version of Puppet. For best future compatibility, you should limit node names to letters, digits, periods, underscores, and dashes. (That is, node names should match `/\A[a-z0-9._-]+\Z/`.)

### Environments

[Environment][] names can contain lowercase letters, numbers, and underscores. That is, they must match the following regular expression:

    \A[a-z0-9_]+\Z
