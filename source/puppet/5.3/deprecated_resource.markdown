---
layout: default
title: "Deprecated resource type features"
---


These features of Puppet's built-in resource types are deprecated in this version of Puppet.

* Previously, if a class was defined more than once their bodies would be merged. The output of a warning or error was under the control of the `--strict` flag. Now, this is always an error except for the top scope class named '' (also known as 'main').