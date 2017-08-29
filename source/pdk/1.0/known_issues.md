---
layout: default
title: "Puppet Development Kit known issues"
canonical: "/pdk/1.0/known_issues.html"
description: "Puppet Development Kit known issues"
---

## Known issues

### `pdk test unit --list` output lacks information

Output from `pdk test unit --list` lacks detailed information and tests appear duplicated. To get the full text descriptions, execute the tests in JUnit format by running `pdk test unit --format=junit`. [PDK-374](https://tickets.puppetlabs.com/browse/PDK-374).

### PowerShell errors if `Remove-Item` on the module directory

If you `Remove-Item` on a module folder, PowerShell errors because of a spec fixture symlink. To remove the module directory, use `-Force`: `Remove-Item -Recurse -Force <module_dir>` <!--SDK-316-->

### PDK not in shell PATH 

PDK is not automatically added to the PATH in some shells. To fix this, add the PATH to the affected shells. [PDK-446](https://tickets.puppetlabs.com/browse/PDK-446) 

* For zsh on OS X, add the PATH by adding the line <code>eval `/usr/libexec/path_helper -s`</code> to the zsh resource file (`~/.zshrc`). 

* For Debian, add a symlink to `/usr/local/bin` by running `sudo ln -sv /opt/puppetlabs/bin/pdk /usr/local/bin/`

