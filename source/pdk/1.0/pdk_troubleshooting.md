---
layout: default
title: "Troubleshooting Puppet Development Kit"
canonical: "/pdk/1.0/pdk_troubleshooting.html"
description: "Troubleshooting Puppet Development Kit, the shortest path to developing better Puppet code."
---

{:.concept}
## PDK not in shell PATH
 
PDK is not automatically added to the PATH in some shells. To fix this, add the PATH to the affected shells:
 
* For zsh on OS X, add the PATH by adding the line `eval '/usr/libexec/path_helper -s'` to to the zsh resource file (`~/.zshrc`).
 
* For Debian, add a symlink to `/usr/local/bin` by running `sudo ln -sv /opt/puppetlabs/bin/pdk /usr/local/bin/` 


{:.concept}
## Windows: Execution policy restrictions

In some Windows installations, trying to run the `pdk` command causes errors related to execution policy restrictions.

To fix this issue, set your script execution policy to at least [RemoteSigned](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.security/set-executionpolicy) by running `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`

Alternatively, you can change the `Scope` parameter of the `ExecutionPolicy` to the current session only by running `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

For more information about PowerShell execution policies or how to change them, see Microsoft documentation [about_Execution_Policies](http://go.microsoft.com/fwlink/?LinkID=135170).
