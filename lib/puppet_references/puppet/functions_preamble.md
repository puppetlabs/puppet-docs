This page is a list of Puppet's built-in functions, with descriptions of what they do and how to use them.

Functions are plugins you can call during catalog compilation. A call to any function is an expression that resolves to a value. For more information on how to call functions, see [the language reference page about function calls.](./lang_functions.html) 

Many of these function descriptions include auto-detected _signatures,_ which are short reminders of the function's allowed arguments. Since these signatures are not exactly the same as the syntax you would use to call the function, they take a little extra practice to read, but they closely resemble a parameter list from a Puppet [class](./lang_classes.html), [defined resource type](./lang_defined_types.html), [function](./lang_write_functions_in_puppet.html), or [lambda](./lang_lambdas.html). The syntax of a signature is:

```
<FUNCTION NAME>(<DATA TYPE> <ARGUMENT NAME>, ...)
```

The `<DATA TYPE>` is a [Puppet data type value](./lang_data_type.html), like `String` or `Optional[Array[String]]`. The `<ARGUMENT NAME>` is a descriptive name chosen by the function's author to indicate what the argument is used for. Any arguments with an `Optional` data type can be omitted from the function call.
