---
layout: default
title: "History of Puppet Language Features"
nav: /_includes/puppet_general.html
---

The Puppet language has changed significantly over time, with many features being added and some features being removed. This page tracks a subset of those changes, showing how the language has evolved and when various features became available.

Puppet Language Features by Release
---------------------------

Feature                                                                          | 0.23.x | 0.24.x     | 0.25.x | 2.6.x                       | 2.7.0              | 3.x | 3.2.x                 | 3.4.x
---------------------------------------------------------------------------------|--------|------------|--------|-----------------------------|--------------------|-----|-----------------------|----------------------
[Dynamic variable scope (declaring classes/resources assigns parent scope)][ds]  | X      | X          | X      | X                           | X (deprecated)     |     |                       |
[Appending to attributes in class inheritance (+>)][plusign]                     | X      | X          | X      | X                           | X                  | X   | X                     | X
[Multi-line C-style comments][ccomment]                                          |        | X (0.24.7) | X      | X                           | X                  | X   | X                     | X
[Arrays of resource references allowed in relationships][rel_array]              |        | X          | X      | X                           | X                  | X   | X                     | X
[Overrides in class inheritance][override]                                       |        | X          | X      | X                           | X                  | X   | X                     | X
[Appending to variables in child scopes (+=)][append_var]                        |        | X          | X      | X                           | X                  | X   | X                     | X
[Class names starting with 0-9][class_name]                                      |        | X          | X      | X                           |                    |     |                       |
[Regular expressions in node definitions][regex_nodes]                           |        |            | X      | X                           | X                  | X   | X                     | X
[Assigning expressions to variables][exp_anywhere]                               |        |            | X      | X                           | X                  | X   | X                     | X
[Regular expressions in conditionals/expresions][regex]                          |        |            | X      | X                           | X                  | X   | X                     | X
[`elsif` in if statements][elsif]                                                |        |            |        | X                           | X                  | X   | X                     | X
[Chaining Resources][chain]                                                      |        |            |        | X                           | X                  | X   | X                     | X
[Hashes][]                                                                       |        |            |        | X (partial until 2.6.7)\*\* | X                  | X   | X                     | X
[Class Parameters][class_params]                                                 |        |            |        | X                           | X                  | X   | X                     | X
[Run Stages][stages]                                                             |        |            |        | X                           | X                  | X   | X                     | X
[The "in" operator][in]                                                          |        |            |        | X                           | X                  | X   | X                     | X
[`$title`, `$name`, and `$module_name` available in parameter lists][titleparam] |        |            |        | X (2.6.5)                   | X                  | X   | X                     | X
[Optional trailing comma in parameter lists][param_trail]                        |        |            |        |                             | X (2.7.8)          | X   | X                     | X
[Hyphens/dashes allowed in variable names][hyphenvars] \*                        |        |            |        |                             | X (2.7.3 - 2.7.14) |     |                       |
[Automatic class parameter lookup via data bindings][auto_params]                |        |            |        |                             |                    | X   | X                     | X
["Unless" conditionals][unless]                                                  |        |            |        |                             |                    | X   | X                     | X
Iteration over arrays and hashes                                                 |        |            |        |                             |                    |     | [X (future)][32_iter] | [X (future)][32_iter]
[The modulo (`%`) operator][modulo]                                              |        |            |        |                             |                    |     | X                     | X
[`$trusted` hash][trusted]                                                       |        |            |        |                             |                    |     |                       | X

\* In Puppet 2.7.20+ and 3.0.2+, hyphens in variable names can be reenabled with [the `allow_variables_with_dashes` setting][hv_pref]. This should only be used as a temporary measure while renaming variables.

\*\* Until Puppet 2.6.7, hashes could not be nested and hash members could not be used in selectors.

[auto_params]: /hiera/1/puppet.html#automatic-parameter-lookup
[param_trail]: /puppet/latest/reference/lang_defined_types.html#defining-a-type
[ds]: /puppet/2.7/reference/lang_scope.html
[plusign]: /puppet/latest/reference/lang_classes.html#appending-to-resource-attributes
[ccomment]: /puppet/latest/reference/lang_comments.html#c-style-comments
[rel_array]: /puppet/latest/reference/lang_relationships.html#relationship-metaparameters
[override]: /puppet/latest/reference/lang_classes.html#overriding-resource-attributes
[append_var]: /puppet/latest/reference/lang_variables.html#appending-assignment
[class_name]: /puppet/latest/reference/lang_reserved.html#classes-and-types
[regex_nodes]: /puppet/latest/reference/lang_node_definitions.html#regular-expression-names
[exp_anywhere]: /puppet/latest/reference/lang_expressions.html#location
[regex]: /puppet/latest/reference/lang_datatypes.html#regular-expressions
[elsif]: /puppet/latest/reference/lang_conditional.html#if-statements
[chain]: /puppet/latest/reference/lang_relationships.html#chaining-arrows
[hashes]: /puppet/latest/reference/lang_datatypes.html#hashes
[class_params]: /puppet/latest/reference/lang_classes.html#class-parameters-and-variables
[stages]: /puppet/latest/reference/lang_run_stages.html
[in]: /puppet/latest/reference/lang_expressions.html#in
[titleparam]: /puppet/latest/reference/lang_defined_types.html#title-and-name
[hyphenvars]: /puppet/latest/reference/lang_variables.html#naming
[hv_pref]: /puppet/3/reference/configuration.html#allowvariableswithdashes
[unless]: /puppet/latest/reference/lang_conditional.html#unless-statements
[32_iter]: /puppet/3/reference/lang_experimental_3_2.html#collection-manipulation-and-iteration
[modulo]: /puppet/latest/reference/lang_expressions.html#modulo
[trusted]: /puppet/latest/reference/lang_variables.html#trusted-node-data
