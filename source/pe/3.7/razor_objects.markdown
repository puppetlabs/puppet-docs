---
layout: default
title: " PE 3.8 » Razor » Razor Objects for Provisioning"
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

You create brokers with the `create-broker` command. The following example sets up a simple noop broker that does nothing:

`razor create-broker --name=noop --broker_type=noop`.

And this command sets up the PE broker, which requires the server parameter.

	razor create-broker --name foo --broker_type puppet-pe --configuration '{ "server": "puppet.example.com" }'

Razor ships with some stock broker types for your use:  puppet-pe, noop, and puppet. In addition, you can create your own. See [Writing Broker Types](./razor_brokertypes.html) for more information.

## Tasks

Tasks describe a process or collection of actions that should be performed while Razor provisions machines. Tasks can be used to designate an operating system or other software that should be installed, where to get it, and the configuration details for the installation.

Tasks are structurally simple. They consist of a YAML metadata file and any number of ERB templates. You include the tasks you want to run in your policies (policies are described in the next section).

Razor provides a handful of [existing tasks](https://github.com/puppetlabs/razor-server/tree/master/tasks), or you can create your own. The existing tasks are primarily for installing supported OSs.

Tasks are stored in the file system. The configuration setting `task_path` determines where in the file system Razor looks for tasks and can be a colon-separated list of paths. Relative paths in that list are taken to be relative to the top-level Razor directory. For example, setting `task_path` to `/opt/puppet/share/razor-server/tasks:/home/me/task:tasks` will make Razor search these three directories in that order for tasks.

### Task Metadata

Tasks can include the following metadata in the task's YAML file. This file is called  `metadata.yaml` and exists in `tasks/<NAME>.task` where `NAME` is the task name. Therefore, the task name looks like this: `tasks/<NAME>.task/metadata.yaml

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

## Writing Task Templates

Task templates are ERB templates and are searched in all the directories given in the `task_path` configuration setting. Templates are searched in the subdirectories in this order:

1. `name.task`
2. `base.task` # If the task has a base task.
3. `common`

####Template Helpers
Templates can use the following helpers to generate URLs that point back to the server; all of the URLs respond to a `GET` request, even the ones that make changes on the server:

* `file_url(TEMPLATE)`: The URL that will retrieve `TEMPLATE.erb` (after evaluation) from the current node's task.
* `repo_url(PATH)`: The URL to the file at `PATH` in the current repo.
* `log_url(MESSAGE, SEVERITY)`: The URL that will log `MESSAGE` in the current node's log.
* `node_url`: The URL for the current node.
* `store_url(VARS)`: The URL that will store the values in the hash `VARS` in the node. Currently only changing the node's IP address is supported. Use `store_url("ip" => "192.168.0.1")` for that.
* `stage_done_url`: The URL that tells the server that this stage of the boot sequence is finished, and that the next boot sequence should begin upon reboot.
* `broker_install_url`: A URL from which the install script for the node's broker can be retrieved. You can see an example in the script, [os_complete.erb](https://github.com/puppetlabs/razor-server/blob/master/tasks/common/os_complete.erb), which is used by most tasks.

Each boot (except for the default boot) must culminate in something akin to `curl <%= stage_done_url %>` before the node reboots. Omitting this will cause the node to reboot with the same boot template over and over again.

The task must indicate to the Razor server that it has successfully completed by doing a `GET` request against `stage_done_url("finished")`, for example using `curl` or `wget`. This will mark the node `installed` in the Razor database.

You use these helpers by causing your script to perform an
`HTTP GET` against the generated URL. This might mean that you pass an
argument like `ks=<%= file_url("kickstart")%>` when booting a kernel, or
that you put `curl <%= log_url("Things work great") %>` in a shell script.

## Policies

Policies orchestrate repos, brokers, and tasks to tell Razor what bits to install, where to get the bits, how they should be configured, and how to communicate between a node and PE.

Policies contain tags, which are named rule-sets that identify which nodes should be bound to a given policy. It's also possible, however, for a node to bind to a policy without matching tags.

A node boots into the microkernel and sends facts to the Razor server. At that point, Razor walks through the policy list in order looking for an eligible policy. If it finds one, it binds to it. If it doesn't find one, the node continues to send facts to the microkernel until it does bind. Binding to a policy essentially means that the node will be provisioned according to the policy's directions.

>**Security Note:** It's important to understand the potential repercussions of policy binding. If you don't manage policies closely, you can inadvertently enable Razor to match with and provision machines that you don't want to provision. In the case of existing servers, this could lead to catastrophic data loss. See [Provisioning Around Existing Machines](./razor_brownfield.html) for strategies to avoid overwriting existing machines.

Policies are stored in order in Razor. Each policy has several reasons why it might be ineligible for a node to bind to it:

* The policy could be disabled.
* The policy might already have the maximum number of nodes bound to it.
* The policy might require tags that the node doesn't have.

Because policies contain a good deal of information, it's handy to save them in a JSON file that you run when you create the policy. Here's an example of a policy called "centos-for-small." This policy stipulates that it should be applied to the first 20 nodes that have no more than two processors that boot.

	{
		"name": "centos-for-small",
		"repo": "centos-6.4",
		"task": "centos",
		"broker": "noop",
		"enabled": true,
		"hostname": "host${id}.example.com",
		"root_password": "secret",
		"max_count": 20,
		"tags": ["small"]
	}

**Policy Tables**
You might create multiple policies, and then retrieve the policies collection. The policies are listed in order in a policy table. You can influence the order of policies as follows:

+ When you create a policy, you can include a `before` or `after` parameter in the request to indicate where the new policy should appear in the policy table.
+ Using the `move-policy` command with `before` and `after` parameters, you can put an existing policy before or after another one.

### Tags

A tag consists of a unique `name` and a `rule`. The tag matches a node if evaluating it against the tag's facts results in `true`. Note that tag matching is case sensitive.

For example, here is a tag rule:

    ["or",
     ["=", ["fact", "macaddress"], "de:ea:db:ee:f0:00"]
     ["=", ["fact", "macaddress"], "de:ea:db:ee:f0:01"]]

The tag could also be written like this:

    ["in", ["fact", "macaddress"], "de:ea:db:ee:f0:00", "de:ea:db:ee:f0:01"]

The syntax for rule expressions is defined in `lib/razor/matcher.rb`. Expressions are of the form `[op arg1 arg2 ... argn]` where `op` is one of the operators below, and `arg1` through `argn` are the arguments for the operator. If they are expressions themselves, they will be evaluated before `op` is evaluated.

The expression language currently supports the following operators:


Operator                       |Returns                                          |Aliases
-------------------------------|-------------------------------------------------|-------
`["=", arg1, arg2]`            |true if `arg1` and `arg2` are equal |`"eq"`
`["!=", arg1, arg2]`            |true if `arg1` and `arg2` are not equal |`"neq"`
`["and", arg1, ..., argn]`     |true if all arguments are true|
`["or", arg1, ..., argn]`      |true if any argument is true|
`["not", arg]`                 |logical negation of `arg`, where any value other than `false` and `nil` is considered true|
`["fact", arg1 (, arg2)]`      |the fact named `arg1` for the current node* |
`["metadata", arg1 (, arg2)]`  |the metadata entry `arg1` for the current node* |
`["tag", arg]`                 |the result (a boolean) of evaluating the tag with name `arg` against the current node|
`["in", arg1, arg2, ..., argn]`|true if `arg1` equals one of `arg2` ... `argn`  |
`["num", arg1]`                |`arg1` as a numeric value, or raises an error  |
`[">", arg1, arg2]`            |true if `arg1` is strictly greater than `arg2` |`"gt"`
`["<", arg1, arg2]`            |true if `arg1` is strictly less than `arg2`    |`"lt"`
`[">=", arg1, arg2]`           |true if `arg1` is greater than or equal to `arg2`|`"gte"`
`["<=", arg1, arg2]`           |true if `arg1` is less than or equal to `arg2`   |`"lte"`



>**Note:**  The `fact` and `metadata` operators take an optional second argument. If `arg2` is passed, it is returned if the fact/metadata entry  `arg1` is not found. If the fact/metadata entry `arg1` is not found and no second argument is given, a `RuleEvaluationError` is raised.

## Hooks

