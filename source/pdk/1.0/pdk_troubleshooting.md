---
layout: default
title: "Troubleshooting Puppet Development Kit"
canonical: "/pdk/1.0/pdk_troubleshooting.html"
description: "Troubleshooting Puppet Development Kit, the shortest path to developing better Puppet code."
---

{:.concept}
## PDK not in ZShell PATH on OS X
 
With ZShell on OS X, PDK is not automatically added to the PATH. To fix this, add the PATH by adding the line `eval '/usr/libexec/path_helper -s'` to the zsh resource file (`~/.zshrc`).

{:.concept}
## Windows: Execution policy restrictions


In some Windows installations, trying to run the `pdk` command is prohibited by the default execution policy restrictions.

To fix this issue, set your script execution policy to at least [RemoteSigned](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.security/set-executionpolicy) by running `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`

Alternatively, you can change the `Scope` parameter of the `ExecutionPolicy` to the current session only by running `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

For more information about PowerShell execution policies or how to change them, see Microsoft documentation [about_Execution_Policies](http://go.microsoft.com/fwlink/?LinkID=135170).
