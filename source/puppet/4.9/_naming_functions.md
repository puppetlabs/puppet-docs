Function names usually look something like this:

* `num2bool` (a function that could come from anywhere)
* `postgresql::acls_to_resource_hash` (a function in the `postgresql` module)
* `environment::hash_from_api_call` (a function in an environment)

Function names are almost the same as [class names][]. They consist of one or more segments; each segment must start with a lowercase letter, and can include:

* Lowercase letters.
* Numbers.
* Underscores.

If a name has multiple segments, they are separated by the double-colon (`::`) namespace separator.

Function names can be either _global_ or _namespaced._

* Global names have only one segment (like `str2bool`), and can be used in any module or environment.

    Global names are shorter, but they're not guaranteed to be unique --- two modules might use the same function name, in which case Puppet won't necessarily load the one you want.
* Namespaced names have multiple segments (like `stdlib::str2bool`), and are guaranteed to be unique. The first segment is dictated by the function's location:
    * In an environment, it must be the literal word `environment` (like `environment::str2bool`).
    * In a module, it must be the module's name (like `stdlib::str2bool`, for a function stored in the `stdlib` module).

    Functions usually only have two name segments, although it's legal to use more.

Some illegal function names:

* `6_pack` (must start with a letter)
* `_hash_from_api_call` (must start with a letter)
* `Find-Resource` (can only contain lowercase letters, numbers, and underscores)
