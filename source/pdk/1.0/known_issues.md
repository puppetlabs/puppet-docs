---
layout: default
title: "Puppet Development Kit known issues"
canonical: "/pdk/1.0/known_issues.html"
description: "Puppet Development Kit known issues"
---

## Known issues

### Running Windows unit tests on non-Windows platforms breaks unit tests

Specifying "Windows 2008 R2" as a supported OS in `metadata.json` breaks running all unit tests. As a workaround, remove the Windows 2008 R2 support specification from your `metadata.json`. [PDK-583](https://tickets.puppetlabs.com/browse/PDK-583)

### `pdk test unit --list` output lacks information

Output from `pdk test unit --list` lacks detailed information and tests appear duplicated. To get the full text descriptions, execute the tests in JUnit format by running `pdk test unit --format=junit`. [PDK-374](https://tickets.puppetlabs.com/browse/PDK-374).

### `pdk test unit --tests` runs all tests instead of only listed tests

Passing a list with `pdk test unit --tests` is not working properly. Attempting to pass a list of tests with the `--tests=` flag still runs all tests found in the `spec/` directory. [PDK-429](https://tickets.puppetlabs.com/browse/PDK-429).

### PowerShell errors if `Remove-Item` on the module directory

If you `Remove-Item` on a module folder, PowerShell errors because of a spec fixture symlink. To remove the module directory, use `-Force`: `Remove-Item -Recurse -Force <module_dir>` <!--SDK-316-->

### PDK not in ZShell PATH on OS X
 
With ZShell on OS X, PDK is not automatically added to the PATH. To fix this, add the PATH by adding the line `eval '/usr/libexec/path_helper -s'` to the zsh resource file (`~/.zshrc`).
