---
layout: default
title: " PE 3.8 » Razor » Razor Objects for Provisioning
subtitle: "Razor Objects Overview"
canonical: "/pe/latest/razor_objects.html"
---

In order to provision with Razor, you must create a handful of objects that establish, in very basic terms, what should be provisioned where. These objects are described in detail here. You can try them out on these two pages: XXX and XXX

The Razor objects are presented in the order in which they should be created:

+ **Repo**: The container for the objects you use Razor to install on machines, such as operating systems.
+ **Broker**: The connector between a node and a configuration management system, such as Puppet Enterprise.
+ **Tasks**: The installation and configuration instructions.
+ **Policy**: The instructions that tell Razor which repos, brokers, and tasks to use for provisioning.
+ **Hooks**: Hooks are optional but very useful. They provide a way to run arbitrary scripts when certain events occur during the operation of the Razor server.

## Repos

A repo is where you store all of the actual bits used by Razor to install a node. Or, in some cases, the external location of bits that you link to. A repo is identified by a unique name, such as 'centos-6.4'. Instructions for the installation, such as what should be installed, where to get it, and how to configure it, are contained in *tasks*, which are described below.

To load a repo onto the server, use the command, `razor create-repo --name=<repo name> --iso_url <URL> --task <task name>`.

For example: `razor create-repo --name=centos-6.4 --iso_url http://mirrors.usc.edu/pub/linux/distributions/centos/6.4/isos/x86_64/CentOS-6.4-x86_64-minimal.iso --task centos`.

There are three types of repositories that you might want to use:

+ Repos where Razor unpacks ISOs for you and serves their contents.
+ Repos that are external, such as a mirror that you maintain.
+ Repos where a stub directory is created and the contents can be entered manually.

The `task` parameter is mandatory for creating all three of these types of repositories. You can override a `task` parameter at the policy level. If you're not using a task, reference the stock task `noop`.

#### Example 1: Unpack an ISO and Serve Its Contents

This repo is created with the `iso_url` property. The server downloads and unpacks the ISO image onto its file system:

    {
        "name": "fedora19",
        "iso_url": "file:///tmp/Fedora-19-x86_64-DVD.iso"
        "task": "puppet"
    }

#### Example 2: Point to an Existing Resource

To make a repo that points to an existing resource without loading anything onto the Razor server, provide a `url` property when you create the repository:

    {
      "name": "fedora19",
      "url": "http://mirrors.n-ix.net/fedora/linux/releases/19/Fedora/x86_64/os/"
      "task": "noop"
    }


#### Example 3: Create a Stub Directory

You can create a stub directory at `/var/lib/razor/repo-store` and load it manually. To do so, create your repo with the `no_content` property. This is useful for ISOs that you can't extract normally, for example, due to forward references:

    {
      "name": "fedora19",
      "no_content": true
      "task": "noop"
    }

For more information on repos, see the [Razor Command Reference](./razor_reference.html#repo-commands).

## Brokers

Brokers are the next object you create as you prepare to provision with Razor. Brokers are responsible for handing a node off to a config management system like Puppet Enterprise. They consist of two parts: a *broker type* and information that is specific for the broker type.

The broker type is closely tied to the configuration management system that the node is being handed off to. For example, the `puppet-pe` broker runs the curl command to install a PE agent on the designated node.

Generally, the broker consists of a shell script template and a description of additional information that must be specified to create a broker from the broker type.

For the Puppet Enterprise broker type, this information consists of the node's server, and the version of PE that a node should use. The PE version defaults to "latest" unless you stipulate a different version.

You create brokers with the `create-broker` command. The following example sets up a simple no-op broker that does nothing:

`razor create-broker --name=noop --broker_type=noop`.

And this command sets up the PE broker, which requires the server parameter.

	razor create-broker --name foo --broker_type puppet-pe --configuration '{ "server": "puppet.example.com" }'

Razor ships with some stock broker types for your use:  puppet-pe, noop, and puppet.

## Tasks

Tasks describe a process or collection of actions that should be performed while Razor provisions machines. Tasks can be used to designate an operating system or other software that should be installed, where to get it, and the configuration details for the installation.

Tasks are structurally simple. They consist of a YAML metadata file and any number of ERB templates. You include the tasks you want to run in your policies (policies are described in the next section).

Razor provides a handful of [existing tasks](https://github.com/puppetlabs/razor-server/tree/master/tasks), or you can create your own. The existing tasks are primarily for installing supported OSs.

Tasks are stored in the file system. The configuration setting `task_path` determines where in the file system Razor looks for tasks and can be a colon-separated list of paths. Relative paths in that list are taken to be relative to the top-level Razor directory. For example, setting `task_path` to `/opt/puppet/share/razor-server/tasks:/home/me/task:tasks` will make Razor search these three directories in that order for tasks.

### Task Metadata

Tasks can include the following metadata in the task's YAML file. This file is called  `metadata.yaml` and exists in `tasks/NAME.task` where `NAME` is the task name.

    ---
    description: HUMAN READABLE DESCRIPTION
    os: OS NAME
    os_version: OS_VERSION_NUMBER
    base: TASK_NAME
    boot_sequence:
      1: boot_templ1
      2: boot_templ2
      default: boot_local

Only `os_version` and `boot_sequence` are required. The `base` key allows you to derive one task from another by reusing some of the `base` metadata and templates. If the derived task has metadata that's different from the metadata in `base`, the derived metadata overrides the base task's metadata.

The `boot_sequence` hash indicates which templates to use when a node using this task boots. In the example above, a node will first boot using `boot_templ1`, then using `boot_templ2`. For every subsequent boot, the node will use `boot_local`.

## Writing Templates

Task templates are ERB templates and are searched in all the directories given in the `task_path` configuration setting. Templates are searched in the subdirectories in this order:

1. `name.task`
2. `base.task` # If the task has a base task.
3. `common`

####Template Helpers
Templates can use the following helpers to generate URLs that point back to the server; all of the URLs respond to a `GET` request, even the ones that make changes on the server:

* `file_url(TEMPLATE)`: the URL that will retrieve `TEMPLATE.erb` (after evaluation) from the current node's task.
* `repo_url(PATH)`: the URL to the file at `PATH` in the current repo.
* `log_url(MESSAGE, SEVERITY)`: the URL that will log `MESSAGE` in the current node's log.
* `node_url`: the URL for the current node.
* `store_url(VARS)`: the URL that will store the values in the hash `VARS` in the node. Currently only changing the node's IP address is supported. Use `store_url("ip" => "192.168.0.1")` for that.
* `stage_done_url`: the URL that tells the server that this stage of the boot sequence is finished, and that the next boot sequence should begin upon reboot.
* `broker_install_url`: a URL from which the install script for the node's broker can be retrieved. You can see an example in the script, [os_complete.erb](https://github.com/puppetlabs/razor-server/blob/master/tasks/common/os_complete.erb), which is used by most tasks.

Each boot (except for the default boot) must culminate in something akin to `curl <%= stage_done_url %>` before the node reboots. Omitting this will cause the node to reboot with the same boot template over and over again.

The task must indicate to the Razor server that it has successfully completed by doing a `GET` request against `stage_done_url("finished")`, for example using `curl` or `wget`. This will mark the node `installed` in the Razor database.

You use these helpers by causing your script to perform an
`HTTP GET` against the generated URL. This might mean that you pass an
argument like `ks=<%= file_url("kickstart")%>` when booting a kernel, or
that you put `curl <%= log_url("Things work great") %>` in a shell script.
