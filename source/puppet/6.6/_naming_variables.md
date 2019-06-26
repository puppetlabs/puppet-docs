[qualified_var]: ./lang_variables.html#accessing-out-of-scope-variables

Variable names begin with a `$` (dollar sign) and are case-sensitive.

Most variable names **must start** with a lowercase letter or an underscore. The exception is regex capture variables, which are named with only numbers.

Variable names can include:

* Uppercase and lowercase letters
* Numbers
* Underscores (`_`)

If the first character is an underscore, that variable should only be accessed from its own local scope; using qualified variable names where any namespace segment begins with `_` is deprecated.

Note that [some variable names are reserved.](./lang_reserved.html#reserved-variable-names)

#### Qualified Variable Names

[Qualified variable][qualified_var] names are prefixed with the name of their scope and the `::` (double colon) namespace separator. (For example, the `$vhostdir` variable from the `apache::params` class would be `$apache::params::vhostdir`.)

Optionally, the name of the very first namespace can be empty, representing the top namespace. In previous versions of the Puppet language, this was often used to work around bugs, but it's not necessary in this version. The main use is to indicate to readers that you're accessing a top-scope variable, e.g. `$::is_virtual`.

#### Regular Expressions For Variable Names

Short variable names should match the following regular expression:

    \A\$[a-z0-9_][a-zA-Z0-9_]*\Z

Qualified variable names should match the following regular expression:

    \A\$([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*::[a-z0-9_][a-zA-Z0-9_]*\Z

