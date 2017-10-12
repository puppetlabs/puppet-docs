---
layout: default
title: "Static Catalogs"
canonical: "/puppet/latest/static_catalogs.html"
---

[catalogs]: ./subsystem_catalog_compilation.html
[catalog endpoint]: ./http_api/http_catalog.html
[file metadata]: ./http_api/http_file_metadata.html
[`file_content`]: ./http_api/http_file_content.html
[`static_file_content`]: {{puppetserver}}/puppet-api/v3/static_file_content.html
[resource_declaration]: ./lang_resources.html
[file resources]: ./types/file.html
[puppet catalog]: ./man/catalog.html
[environment]: ./environments.html
[facts]: ./lang_facts_and_builtin_vars.html
[exported resources]: ./lang_exported.html
[main manifest]: ./dirs_manifest.html
[modules]: ./modules_fundamentals.html
[resources]: ./lang_resources.html
[variables]: ./lang_variables.html
[classes]: ./lang_classes.html
[modulepath]: ./dirs_modulepath.html
[`puppet.conf`]: ./config_file_main.html
[`environment.conf`]: ./config_file_environment.html

[Puppet Server]: {{puppetserver}}/
[`puppetserver.conf`]: {{puppetserver}}/config_file_puppetserver.html
[Application Orchestration]: {{pe}}/app_orchestration_overview.html
[file sync]: {{pe}}/cmgmt_filesync.html
[Code Manager]: {{pe}}/code_mgr.html
[`code_content`]: {{puppetserver}}/

Puppet 4.4.0 and Puppet Server 2.3.0 introduced a new feature for [catalog compilation][catalogs]: **static catalogs**.

> #### What's a catalog?
>
> A catalog is a document that describes the [desired state for each resource][resource_declaration] that Puppet manages on a node. A Puppet master typically compiles a catalog from manifests of Puppet code. For more information about catalogs and compilation, see [our step-by-step overview of the catalog compilation process][catalogs]. For details about retrieving and reviewing catalogs, see [the `puppet catalog` man page][puppet catalog] and [the `catalog` API endpoint documentation][catalog endpoint].

### What's a static catalog?

A *static* catalog includes additional metadata that identifies the desired state of a node's [file resources][] that have `source` attributes pointing to `puppet:///` locations. This metadata can refer to a specific version of the file, rather than the latest version, and can confirm that the agent is applying the appropriate version of the file resource for the catalog. Also, because much of the metadata is provided in the catalog, Puppet agents make fewer requests to the master.

### Why use static catalogs?

When a Puppet master compiles a non-static catalog, the catalog doesn't specify a particular version of its file resources. When the agent applies the catalog, it always retrieves the latest version of that file resource, or uses a previously retrieved version if it matches the latest version's contents. Note that this potential problem affects file resources that use the *source* attribute. File resources that use the *content* attribute are not affected, and their behavior will not change in static catalogs.

When a Puppet manifest depends on a file whose contents change more frequently than the Puppet agent receives new catalogs --- for instance, if the agent is caching catalogs or can't reach a Puppet master over the network --- a node might apply a version of the referenced file that doesn't match the instructions in the catalog.

Consequently, the agent's Puppet runs might produce different results each time the agent applies the same catalog. This often causes problems, because Puppet generally expects a catalog to produce the same results each time it's applied, regardless of any code or file content updates on the master.

Additionally, each time a Puppet agent applies a non-static cached catalog that contains file resources sourced from `puppet:///` locations, the agent requests [file metadata][] from the master, even though nothing's changed in the cached catalog. This causes the master to perform unnecessary resource-intensive checksum calculations for each such file resource.

Static catalogs avoid these problems by including metadata that refers to a specific version of the resource's file. This prevents the a newer version from being incorrectly applied, and avoids having the agent request the metadata on each Puppet run.

We call this type of catalog "static" because it contains all of the information that an agent needs to determine whether the node's configuration matches the instructions and **static** state of file resources **at the point in time when the catalog was compiled.**

### Static catalog features

A static catalog includes file metadata in its own section and associates it with the catalog's file resources. For example, consider the following file resource:

``` puppet
file { '/etc/application/config.conf':
  ensure => file,
  source => 'puppet:///modules/module_name/config.conf'
}
```

In a non-static catalog, the Puppet agent requests metadata and content for the file from the Server. The server generates a checksum for the file and provides that file as it currently exists on the master.

With static catalogs enabled, the Puppet master generates metadata for each file resource sourced from a `puppet:///` location and adds it to the static catalog, and adds a `code_id` to the catalog that associates such file resources with the version of their files as they exist *at compilation time*.

Inlined metadata is part of a `FileMetadata` object in the static catalog that's divided into two new sections: `metadata` for metadata associated with individual files, and `recursive_metadata` for metadata associated with many files. To use the appropriate version of the file content for the catalog, [Puppet Server][] also adds a `code_id` parameter to the catalog. The value of `code_id` is a unique string that Puppet Server uses to retrieve the version of file resources in an environment at the time when the catalog was compiled.

When applying a file resource from a static catalog, an agent first checks the catalog for that file's metadata. If it finds some, Puppet uses the metadata to call the [`static_file_content`][] API endpoint on the Puppet Server and retrieve the file's contents, also called the `code_content`. If the catalog doesn't contain metadata for the resource, Puppet requests the file resource's metadata from the master, compares it to the local file if it exists, and requests the resource's file from the master in its current state if the local file doesn't exist or differs from the master's version.

### Configuring `code_id` and the `static_file_content` endpoint

When requesting the file's content via the static catalog's metadata, the Puppet agent passes the file's path, the catalog's `code_id`, and the requested environment to Puppet Server's [`static_file_content`][] API endpoint. The endpoint returns the appropriate version of the file's contents as the `code_content`.

If static catalogs are enabled but Puppet Server static catalog settings aren't configured, the `code_id` parameter defaults to a null value and the agent uses the [`file_content`][] API endpoint, which always returns the latest content. To populate the `code_id` with a more useful identifier and have the agent use the  `static_file_content` endpoint to retrieve a specific version of the file's content, you must specify scripts or commands that provide Puppet with the appropriate results.

Puppet Server locates these commands by using the `code-id-command` and `code-content-command` settings in Puppet Server's [`puppetserver.conf`][] file. Puppet Server runs the `code-id-command` each time it compiles a static catalog, and it runs the `code-content-command` each time an agent requests file contents from the `static_file_content` endpoint.

> **Note:** The Puppet Server process must be able to execute these scripts. Puppet Server also validates their output and checks their exit codes. Environment names can contain only alphanumeric characters and underscores (`_`). The `code_id` can  contain only alphanumeric characters, dashes (`-`), underscores (`_`), semicolons (`;`), and colons (`:`). If either command returns a non-zero exit code, Puppet Server logs an error and returns the error message and a 500 response code to the API request.

Puppet Server validates the standard output of each of these scripts, and if the output's acceptable, it adds the results to the catalog as their respective parameters' values. This lets you use any versioning or synchronization tools you want, as long as you write scripts that produce a valid string for the `code_id` and code content using the catalog's `code_id` and file's environment.

The `code-id-command` and `code-content-command` scripts can be as simple or complex as necessary.

> **Note:** The following examples demonstrate how Puppet Server passes arguments to the `code-id-command` and `code-content-command` scripts and how Puppet Server uses the results to return a specific version of a file resource. The example scripts themselves are not recommended for production use.

For example, for files in an environment managed by Git, use something like the following `code-id-command` script, with the environment name passed in as the first command-line argument:

``` bash
#!/bin/bash
set -e
if [[ -z "$1" ]]; then
  echo Expected an environment >&2
  exit 1
fi
cd /etc/puppetlabs/code/environments/"$1" && git rev-parse HEAD
```

As long as the script's exit code is zero, Puppet Server uses the script's standard output as the catalog's `code_id`.

A `code-content-command` script can also be simple. Puppet Server passes the environment name as the first command-line argument, the `code_id` as the second argument, and the path to the file resource from its `content_uri` as the third argument:

``` bash
#!/bin/bash
set -e
if [[ $# < 3 ]]; then
  echo Expected environment, code-id, file-path >&2
  exit 1
fi
cd /etc/puppetlabs/code/environments/"$1" && git show "$2":"$3"
```

The script's standard output becomes the file's `code_content`, provided the script returns a non-zero exit code.

### Enabling or disabling static catalogs

Starting in Puppet 4.4.0 and Puppet Server 2.3.0, the global `static_catalogs` setting is enabled by default, whether you upgrade Puppet or perform a clean installation. However, the default configuration doesn't include the `code-id-command` and `code-content-command` scripts or settings needed to produce static catalogs, and even when configured to produce static catalogs Puppet Server doesn't inline metadata for all types of file resources.

Static catalogs are produced only by Puppet Server. The Ruby Puppet master never produces static catalogs, even when served by WEBrick or Passenger.

Puppet Server also won't produce static catalogs for an agent under the following circumstances:

-   If the `static_catalogs` setting is false in:
    -   The Puppet Server's [`puppet.conf`][] file.
    -   The [`environment.conf`][] file for the environment under which the agent is requesting a catalog.
    -   The agent's `puppet.conf` file.
-   If the Server's `code-id-command` and `code-content-command` settings and scripts are not configured, or if the `code-id-command` returns an empty string.
-   If the agent's version is older than 4.4.0.

Additionally, Puppet Server only inlines metadata for [file resources][] if **all** of the following conditions are true:

* It contains a `source` parameter with a Puppet URI, such as `source => 'puppet:///path/to/file'`.
* It contains a `source` parameter that uses the built-in `modules` mount point.
* The file it sources is within the following glob relative to the environment's root directory: `*/*/files/**`. For example, Puppet Server will inline metadata into static catalogs for file resources sourcing module files located by default in `/etc/puppetlabs/code/environments/<ENVIRONMENT>/modules/<MODULE NAME>/files/**`.
