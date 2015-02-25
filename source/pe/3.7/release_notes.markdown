---
layout: default
title: "PE 3.8 » Release Notes"
subtitle: "Puppet Enterprise 3.8 Release Notes"
canonical: "/pe/latest/release_notes.html"
---

This page contains information about new features and general improvements in the latest Puppet Enterprise (PE) release.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [Security and Bug Fixes](./release_notes_security.html).

## New Features in PE 3.8.0

### Support For String Interpolation in the PE Console

Values for parameters and variables can be specified in the console using strings, booleans, numbers, hashes, and arrays. The supported syntax for specifying strings has been extended beyond literal strings, and now also includes limited support for string interpolation of fact values. You can now specify values such as `"I live at $ipaddress"`, which interpolates the result of referencing the `$ipaddress` fact, as well as values such as `${$os["release"]["full"]}`, which interpolates the result of the embedded expression.

For more information on the syntax and restrictions for string interpolation in the console, see [Tips on specifying parameter and variable values](./console_classes_groups.markdown#setting-class-parameters).

