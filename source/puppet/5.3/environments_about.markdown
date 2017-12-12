---
layout: default
title: "About environments"
---

[environmentpath]: ./configuration.html#environmentpath
[codedir]: ./dirs_codedir.html
[puppet.conf]: ./config_file_main.html
[modulepath]: ./dirs_modulepath.html
[basemodulepath]: ./configuration.html#basemodulepath
[environment.conf]: ./config_file_environment.html
[environment_timeout]: ./configuration.html#environmenttimeout
[create_environment]: ./environments_creating.html
[about]: ./environments.html
[assign]: ./environments_assigning.html
[default_manifest]: ./configuration.html#defaultmanifest
[disable_per_environment_manifest]: ./configuration.html#disableperenvironmentmanifest
[main manifest]: ./dirs_manifest.html

{:.concept}
## Environments

Environments are isolated groups of Puppet agent nodes.

A Puppet master serves each environment with its own main manifest and module path. This lets you use different versions of the same modules for different groups of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines.

Related topics: [main manifests][main manifest] and [module paths][modulepath].


{:.task}
## Access environment name in Puppet manifests

If you want to share code across environments, you can use the `$environment` variable in your Puppet manifests.

To get the name of the current environment:

1. Use the `$environment` variable, which is set by the Puppet master.


{:.concept}
## Environments scenarios

The main uses for environments fall into three categories: permanent test environments, temporary test environments, and divided infrastructure.

### Permanent test environments

In a permanent test environment, there is a stable group of test nodes where all changes must succeed before they can be merged into the production code. The test nodes are a smaller version of the whole production infrastructure. They are either short-lived cloud instances or longer-lived virtual machines (VMs) in a private cloud. These nodes stay in the test environment for their whole lifespan.

### Temporary test environments

In a temporary test environment, you can test a single change or group of changes by checking the changes out of version control into the `$codedir/environments` directory, where it will be detected as a new environment. A temporary test environment can either have a descriptive name or use the commit ID from the version that it is based on. Temporary environments are good for testing individual changes, especially if you need to iterate quickly while developing them. Once you’re done with a temporary environment, you can delete it. The nodes in a temporary environment are short-lived cloud instances or VMs, which are destroyed when the environment ends.

### Divided infrastructure

If parts of your infrastructure are managed by different teams that don’t need to coordinate their code, you can split them into environments.


{:.concept}
## Environments limitations

Environments have limitations, including leakage and conflicts with exported resources.

### Plugins can leak between environments

Environment leakage occurs when different versions of Ruby files, such as resource types, exist in multiple environments. When these files are loaded on the master, the first version loaded is treated as global. Subsequent requests in other environments get that first loaded version. Environment leakage does not affect the agent, as agents are only in one environment at any given time. For more information, see below for troubleshooting environment leakage.

### Exported resources can conflict or cross over

Nodes in one environment can collect resources that were exported from another environment, which causes problems — either a compilation error due to identically titled resources, or creation and management of unintended resources. The solution is to run separate Puppet masters for each environment if you use exported resources.


{:.task}
## Troubleshooting environment leaks

Environment leaks is one of the limitations of environments.

1. Use one of the following methods to avoid environmental leaks:

* For resource types, you can avoid environment leaks with the the `puppet generate types` command as described in environment isolation documentation. This command generates resource type metadata files to ensure that each environment uses the right version of each type.

* This issue occurs only with the `Puppet::Parser::Functions` API. To fix this, rewrite functions with the modern functions API, which is not affected by environment leakage. You can include helper code in the function definition, but if helper code is more complex, it should be packaged as a gem and installed for all environments.

* Report processors and indirector termini are still affected by this problem, so put them in your global Ruby directories rather than in your environments. If they are in your environments, you must ensure they all have the same content.





