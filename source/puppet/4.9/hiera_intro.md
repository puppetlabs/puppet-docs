---
title: "Hiera: What is Hiera?"
---


[auto_lookup]: todo
[facts]: todo
[roles_and_profiles]: todo

Hiera is Puppet's built-in data lookup system. By default, it uses simple YAML or JSON files, although you can extend it to work with almost any data source. Almost every successful Puppet user relies on it heavily, and you should too.


## Hiera is the config file for your Puppet code

Puppet's primary strength is in reusable code. But code that serves many needs has to be configurable --- site-specific information should usually be in configuration data, rather than in the code itself.

Hiera is the most flexible way to get configuration data into Puppet. Puppet [automatically searches Hiera for class parameters][auto_lookup], so you can use Hiera to configure any module.

## Hiera helps you avoid repetition

Hiera's hierarchical lookups are built for a "defaults, with overrides" pattern. This lets you specify common data once, then override it in situations where the default won't work. And since Hiera uses Puppet's [facts][] to specify data sources, you can structure your overrides in whatever way makes sense for your infrastructure.

## You should use Hiera with the roles and profiles method

Hiera is immensely powerful, and with great power comes great responsibility. Specifically, you're responsible for making your infrastructure _maintainable_ and _legible,_ both for your co-workers and for your future self.

The best way to do this is to adopt sensible, rigorous rules about _where_ and _how_ Hiera data should enter your system. This makes your code and data easier to reason about and safer to edit.

For most Puppet users, [the roles and profiles method][roles_and_profiles] is a good starting point. It sets simple rules about what should and shouldn't be configured with Hiera, and strikes a good balance between flexibility and maintainability.


