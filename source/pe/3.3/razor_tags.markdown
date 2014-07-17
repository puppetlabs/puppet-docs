---
layout: default
title: " PE 3.3 » Razor » Tags"
subtitle: "Using Razor Tags"
canonical: "/pe/latest/razor_tags.html"

---

A tag consists of a unique `name` and a `rule`. The tag matches a node if evaluating it against the tag's facts results in `true`. Note that tag matching is case sensitive.

For example, here is a tag rule:

    ["or",
     ["=", ["fact", "macaddress"], "de:ea:db:ee:f0:00"]
     ["=", ["fact", "macaddress"], "de:ea:db:ee:f0:01"]]

The tag could also be written like this:

    ["in", ["fact", "macaddress"], "de:ea:db:ee:f0:00", "de:ea:db:ee:f0:01"]

The syntax for rule expressions is defined in `lib/razor/matcher.rb`. Expressions are of the form `[op arg1 arg2 ... argn]` where `op` is one of the operators below, and `arg1` through `argn` are the arguments for the operator. If they are expressions themselves, they will be evaluated before `op` is evaluated.

The expression language currently supports the following operators:


Operator                       |Returns                                          |Aliases
-------------------------------|-------------------------------------------------|-------
`["=", arg1, arg2]`            |true if `arg1` and `arg2` are equal |`"eq"`
`["!=", arg1, arg2]`            |true if `arg1` and `arg2` are not equal |`"neq"`
`["and", arg1, ..., argn]`     |true if all arguments are true|
`["or", arg1, ..., argn]`      |true if any argument is true|
`["not", arg]`                 |logical negation of `arg`, where any value other than `false` and `nil` is considered true|
`["fact", arg1 (, arg2)]`      |the fact named `arg1` for the current node* |
`["metadata", arg1 (, arg2)]`  |the metadata entry `arg1` for the current node* |
`["tag", arg]`                 |the result (a boolean) of evaluating the tag with name `arg` against the current node|
`["in", arg1, arg2, ..., argn]`|true if `arg1` equals one of `arg2` ... `argn`  |
`["num", arg1]`                |`arg1` as a numeric value, or raises an error  |
`[">", arg1, arg2]`            |true if `arg1` is strictly greater than `arg2` |`"gt"`
`["<", arg1, arg2]`            |true if `arg1` is strictly less than `arg2`    |`"lt"`
`[">=", arg1, arg2]`           |true if `arg1` is greater than or equal to `arg2`|`"gte"`
`["<=", arg1, arg2]`           |true if `arg1` is less than or equal to `arg2`   |`"lte"`



>\* **Note:**  The `fact` and `metadata` operators take an optional second argument. If `arg2` is passed, it is returned if the fact/metadata entry  `arg1` is not found. If the fact/metadata entry `arg1` is not found and no second argument is given, a `RuleEvaluationError` is raised.
