---
layout: default
title: "Environment Isolation"
canonical: "/puppet/latest/environment_isolation.html"
description: "Generating metadata to isolate resources in environments in Puppet"
---

[code_mgr_env]: {{pe}}/code_mgr.html#environment-isolation-metadata

{:.concept}
## Environment isolation

Environment isolation prevents resource types from leaking between your various environments.
 
If you use multiple environments with Puppet, you might encounter issues with multiple versions of the same resource type leaking between your various environments on the master. This doesn’t happen with Puppet’s built-in resource types, but it can happen with any other resource types. 
 
This problem occurs because Ruby resource type bindings are global in the Ruby runtime. The first loaded version of a Ruby resource type takes priority, and then subsequent requests to compile in other environments get that first-loaded version. Environment isolation solves this issue by generating and using metadata that describes the resource type implementation, instead of using the Ruby resource type implementation, when compiling catalogs.
 
>Note: Other environment isolation problems, such as external helper logic issues or varying versions of required gems, are not solved by the generated metadata approach. This fixes only resource type leaking. Resource type leaking is a problem that affects only masters, not agents.


{:.Task} 
## Enable environment isolation with Puppet

To use environment isolation, generate metadata files that Puppet can use instead of the default Ruby resource type implementations.
  
1. On the command line, run `puppet generate types --environment <ENV_NAME>` for each of your environments. For example, to generate metadata for your production environment, run: `puppet generate types --environment production`
2. Whenever you deploy a new version of Puppet, overwrite previously generated metadata by running `puppet generate types --environment <ENV_NAME> --force`
 
 
{:.Task} 
## Enable environment isolation with r10k
 
To use environment isolation with r10k, generate types for each environment every time r10k deploys new code. (Environment isolation is not supported with r10k in Puppet Enterprise.)
 

1. To generate types with r10k, use one of the following methods:
 
   * Modify your existing r10k hook to run the `generate types` command after code deployment.
   * Create and use a script that first runs r10k for an environment, and then runs `generate types` as a post run command.
 
2. If you have enabled environment-level purging in r10k, whitelist the `resource_types` folder so that r10k doesn’t purge it.
 
> Note: In Puppet Enterprise, environment isolation is provided by Code Manager. Environment isolation is not supported for r10k with Puppet Enterprise.
 
 
{:.Task} 
## Troubleshooting environment isolation

If the `generate types` command cannot generate certain types, if the type generated has missing or inaccurate information, or if the generation itself has errors or fails, you will get a catalog compilation error of “type not found” or “attribute not found.” 
 
To fix these errors:
 
1. Ensure that your Puppet resource types are correctly implemented. Refactor any problem resource types.
 
2. Regenerate the metadata by removing the environment’s `.resource_types` directory and running the `generate types` command again.
 
3. If you continue to get catalog compilation errors, disable environment isolation to help you isolate the error.
 
To disable environment isolation in open source Puppet:
 
1. Remove the `generate types` command from any r10k hooks.
2. Remove the `.resource_types` directory.
 
To disable environment isolation in Puppet Enterprise:
 
1. In `/etc/puppetlabs/puppetserver/conf.d/pe-puppet-server.conf`, remove the `pre-commit-hook-commands` setting.
2. In Hiera, set `puppet_enterprise::master::puppetserver::pre_commit_hook_commands: []`
3. On the command line, run `service pe-puppetserver reload`
4. Delete the `.resource_types` directories from your staging code directory, `/etc/puppetlabs/code-staging`.
5. Deploy the environments.


{:.Reference} 
## generate types
 
When you run the `generate types` command, it scans the entire environment for resource type implementations, excluding core Puppet resource types.
 
The `generate types` command accepts the following options:
 
*  `--environment <ENV_NAME>`: The environment for which to generate metadata. If you don’t specify this argument, the metadata is generated for the default environment (`production`).
*  `--force`: Use this flag to overwrite all previously generated metadata.
 
For each resource type implementation it finds, the command generates a corresponding metadata file, named after the resource type, in the `<env-root>/.resource_types` directory.
It also syncs the files in the `.resource_types` directory so that:
 
* Types that have been removed in modules are removed from `resource_types`.
* Types that have been added are added to `resource_types`.
* Types that have not changed (based on timestamp) are kept as is.
* Types that have changed (based on timestamp) are overwritten with freshly generated metadata.
 
The generated metadata files, which have a .pp extension, exist in the code directory. If you are using Puppet Enterprise with Code Manager and file sync, these files appear in both the staging and live code directories. The generated files are read-only. Do not delete them, modify them, or use expressions from them in manifests.
