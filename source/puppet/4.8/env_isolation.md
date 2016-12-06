---
layout: default
title: "Isolating resources in multiple environments"
canonical: "/puppet/latest/environment_isolation.html"
description: "Generating metadata to isolate resources in environments in Puppet"
---

[code_mgr_env]: {{pe}}/code_mgr.html#environment-isolation-metadata


If you have multiple environments, environment isolation prevents resource types from leaking between your various environments. To use environment isolation, you'll generate metadata files that Puppet can use in place of the normal Ruby resource type implementations.

In open source Puppet, enable environment isolation with the `generate types` command. In Puppet Enterprise, environment isolation is automatically provided by [Code Manager][code_mgr_env]. Environment isolation is not supported for r10k with Puppet Enterprise.

## Preventing resource types leaks in multiple environments

If you use multiple environments with Puppet, you might encounter issues with multiple versions of the same resource type leaking between your various environments. 

This problem occurs because Ruby resource type bindings are global in the Ruby runtime. Thus, the first loaded version of a Ruby resource type takes priority, and then subsequent requests to compile in other environments get that first loaded version.

Environment isolation solves this issue by generating and using metadata that describes the resource type implementation, instead of using the Ruby resource type implementation when compiling catalogs. 

> **Note**: Other environment isolation cases, such as external helper logic issues or varying versions of required gems, are not solved with the `generate type` command.

### Agent logic is unchanged

Catalog compilation results are exactly the same whether you use the metadata-based version of the resource type or the Ruby implementation. The agent acting on the catalog continues to use the Ruby-based implementation. Because the agent uses one, and only one, version of the logic, isolation is not a problem for the agent.

## Enable environment isolation in Puppet

With open source Puppet, enable environment isolation by running the `generate types` command:

1. On the command line, run `generate types --environment <envname>` for each of your environments.

For example, to generate metadata for your production environment, run:

`generate types --environment production`

Whenever you deploy a new version of Puppet, overwrite previously generated metadata with `generate types --environment <envname> --force`.

### Results of `generate types`

When you run the `generate types` command, it scans the entire environment for resource type implementations, excluding the resource types shipped in core Puppet. For each resource type implementation it finds, the command generates a corresponding metadata file named after the resource type in the directory `<env-root>/.resource_types`.

It also syncs the files in the `.resource_types` directory so that:

* Types that have been removed in modules are removed from `resource_types`.
* Types that have been added are added to `resource_types`.
* Types that have not changed (based on timestamp) are kept as is.
* Types that have changed (based on timestamp) are overwritten with freshly generated metadata.

The generated metadata files, which have a `.pp` extension, appear in the code directory. (If you are using Puppet Enterprise with Code Manager and file sync, these files appear in both the staging and live code directories.) These generated files are **read-only**: do not delete them, modify them, nor use expressions from them in regular manifests.

### Environment isolation with r10k

To use environment isolation with open source Puppet and r10k, generate types for each environment every time r10k deploys new code.

To generate types with r10k, either:

* Modify your existing r10k hook to run the `generate types` command after code deployment.
* Create and use a script that first runs r10k for an environment, and then runs `generate types` as a postrun command.

If you have enabled environment level purging in r10k, whitelist the `resource_types` folder so that r10k doesn't purge it.

## Reference: `generate types`

The `generate types` command accepts the following options:

* `--environment <env_name>`: The environment in which to generate metadata. If not specified on the command line, the metadata is configured for the default environment (typically `production`).
* `--force`: The `generate types` command overwrites all generated data for the environment.
