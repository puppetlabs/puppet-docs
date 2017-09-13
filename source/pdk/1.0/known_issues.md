---
layout: default
title: "Puppet Development Kit known issues"
canonical: "/pdk/1.0/known_issues.html"
description: "Puppet Development Kit known issues"
---

## Known issues

### `pdk test unit --list` output lacks information

Output from `pdk test unit --list` lacks detailed information and tests appear duplicated. To get the full text descriptions, execute the tests in JUnit format by running `pdk test unit --format=junit`. [PDK-374](https://tickets.puppetlabs.com/browse/PDK-374).

### `pdk test unit --tests` doesn't pass through user provided list of tests

Functionality of `pdk test unit --tests` is not working properly. Attempting to pass a list of tests via the `--tests=` flag will still run all tests found in the `spec/` directory. [PDK-429](https://tickets.puppetlabs.com/browse/PDK-429).

### PowerShell errors if `Remove-Item` on the module directory

If you `Remove-Item` on a module folder, PowerShell errors because of a spec fixture symlink. To remove the module directory, use `-Force`: `Remove-Item -Recurse -Force <module_dir>` <!--SDK-316-->

