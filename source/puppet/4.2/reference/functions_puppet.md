(insert YAML frontmatter here)



You can write functions in the Puppet language.

## Syntax

(see examples like the lang_lambdas and lang_classes pages for how to format this section.)

functions look almost exactly like defined types, and then act a lot like lambdas:

~~~ ruby
function <NAME>(<PARAMETER LIST>) {
  ... body of function ...
  final statement, which will be the value of the function
}
~~~


The parameter list acts almost EXACTLY like parameter lists in lambdas do. (In lambdas, it's the part between the pipe characters, like |Integer $x, Integer $y|.) You can pretty much copy that snippet of docs from the lambdas page. Note that whereas the extra arguments parameter is mostly useless in lambdas, it's very useful in functions. (Again, it acts the same way.)

The one main difference with parameters is with the default values. If you reference a variable in a default value for a parameter, Puppet will always start looking for that variable at top scope. So if you use $fqdn, but then you CALL the function from a class that overrides the variable $fqdn, the parameter's default value will be the value from top scope, not the value from the class. You can reference qualified variable names in a function default value, but compilation will fail if that class wasn't declared by the time the function gets called.

Unlike functions written in ruby, functions written in Puppet CANNOT accept a lambda as their final argument.

As for the statements in the body of the function: you can basically do anything at all in there. AFAICT there aren't any special rules. BUT, you should avoid declaring resources, and you should be careful about causing any other side effects. Functions are supposed to be for constructing values and transforming data. If you want to create resources based on inputs, that's what defined types are for!

Also, the final expression in the function body will be the value returned by the function:

- this is almost exactly how lambdas work.
- Note that pretty much all the conditional expressions in the puppet language have values that work in a similar way, so you can use an if statement or a case statement as the final expression to give different values based on different numbers of inputs (for example).

## Naming

Same rules as class or defined type names. Copy those rules here.

If it's in a module, it should have a namespaced name, same as classes etc.


## Location

Functions should go in modules. They go in the `functions` folder, which is a top-level directory, a sibling of `manifests`, `lib`, et al.

Puppet autoloads them based on name, with the same rules as classes or defined types. (copy rules here.)

You can also put functions in the main manifest, in which case they can have any name. You mostly shouldn't do that, for the same reason you shouldn't generally do it for classes or defined types.

If you do put a function in the main manifest, it will override any function of the same name from modules. (It can't override built-in functions, though.)

## Behavior

Once a function is written and available (usually by putting it in a module where the autoloader will be able to find it), you can call that function in any puppet manifest. The arguments you pass to the function call will map to the parameters defined in the function's definition. You will have to provide arguments for the mandatory parameters, and can choose whether to provide arguments for the optional ones.

The function call acts like a normal function call, and resolves to the function's value.

link here to language docs on function calls.

