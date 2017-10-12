---
layout: default
title: "Environment Isolation"
canonical: "/puppet/latest/environment_isolation.html"
---


Beginning in Puppet 4.6.0, there is a new experimental feature aiming to solve a problem with the isolation of multiple versions of the same Ruby resource type implementation being used in different environments. This is a problem because the Ruby resource type implementations are constructed in a way that binds Ruby constructs to constants and these bindings are global in the Ruby runtime. Thus, the first loaded version of a resource type implementation will win and subsequent requests to compile in other environments will get the first loaded version.

There are other environment isolation cases that this new experimental feature does not solve (external helper logic, different versions of required gems, and similar).

## How it works

The experimental feature consists of two parts:

* A utility that generates loadable metadata describing the resource type implementation.
* The ability to load and use this metadata instead of the Ruby resource type implementation when compiling.

### The agent logic is unchanged

The result of the compilation (the catalog) will be identical irrespective of using the metadata based version of the resource type or the Ruby implementation. The agent acting on the catalog continues to use the Ruby based implementation. Isolation is not a problem there because it is using one and only one version of the logic.

(Note: It is untested what happens when an agent is changed to be in different environments and the agent runs as a daemon; if it does not spawn new processes it would be subject to isolation problems).

## Generation of Metadata

A new command-line utility `generate types` has been added to Puppet. This command will scan the entire environment for resource type implementations (it skips the resource types shipped in core Puppet). For each found resource type implementation it will write the corresponding metadata in a file named after the resource type in the directory `<env-root>/.resource_types`.

Each time `generate types` is executed it will sync the files in the `.resource_types` directory such that:
* Types that have been removed in modules are removed from `resource_types`.
* Types that are added are added.
* Types that are unchanged (based on timestamp) are kept as is.
* Types that have changed (based on timestamp) are overwritten with freshly generated metadata.

The environment to generate in is given on the command line using `--environment <env_name>`.

The environment will be the configured default environment if not given on the command line (typically `production`).

A `--force` flag can be used to make `generate` overwrite all generated data for the environment.

## The metadata is in Pcore

The generated metadata is using another experimental feature in Puppet called Pcore. Pcore is the name we have given to the Puppet type system including new extensions that make it possible to describe objects in the Puppet language and to map them to implementation types (for now Ruby classes, later other possible runtime languages).

As of Puppet 4.6.0, the generated Pcore logic is considered to be write only, and it may change in a future Puppet release. (When you're deploying a new Puppet version, a `generate types --environment <env> --force` should be executed).

The generated Pcore uses the `.pp` extension because it is regular Puppet logic that is parsed by the regular parser and evaluated by the regular evaluator. The expressions used in the generated files should however not be used in regular manifests.

At this time, the generated Pcore is undocumented and is considered a private implementation detail.

## Opting in to using this experimental feature

Opting in to using the new feature is done by running the `generate types` command. It is important to run this command in all environments in use - or at a minimum in those environments where resource types clash.

Opting out is performed by removing the `<env_root>/.resource_types` directory and its content.

## Suggested workflow

It is suggested that a run of `generate types --environment <envname>` is performed in a hook whenever new code is deployed with r10k as that ensures that the generated meta data is up to date for new code deploys.

## The future of this experimental feature

The primary purpose of this experimental feature is to solve the lack of isolation between resource type implementations of different versions in different environments. It is also the foundation for further exploration towards the goal of being able to express resource types completely in the Puppet language. The Pcore format used in the initial release of this experimental version is driven completely by the existing 3.x API and is not considered to be a temporary bridge that helps us separate the compilation and agent apply logic code paths. We may base additional features on top of this 3.x based format such as validating attribute types, making it possible to use the puppet type system to validate attributes (parameters and properties) also on the agent side, validate the names of providers and similar features.
