---
layout: default
title: " PE 3.8 » Razor » Razor Objects for Provisioning"
subtitle: "Razor Objects Overview"
canonical: "/pe/latest/razor_objects.html"

---

In order to provision with Razor, you must create a handful of objects that
establish, in very basic terms, what should be provisioned where. These
objects are described in detail here.

The Razor objects are described in slightly different order than
they're created in the steps for [provisioning a node](./razor_using.html).

+ **Repo**: The container for the objects you use Razor to install on
machines, such as operating systems.
+ **Broker**: The connector between a node and a configuration management
system, such as Puppet Enterprise.
+ **Tasks**: The installation and configuration instructions.
+ **Policy**: The instructions that tell Razor which repos, brokers, and
tasks to use for provisioning.
+ **Hooks**: Hooks give you a way to run arbitrary scripts provided by you
to react to certain events in a node's lifecycle.

## Repos

A repo is where you store all of the actual bits used by Razor to install a
node. Or, in some cases, the external location of bits that you link to. A
repo is identified by a unique name, such as 'centos-6.6'. Instructions for
the installation, such as what should be installed, where to get it, and
how to configure it, are contained in *tasks*, which are described below.

To load a repo onto the server, use the command, `razor create-repo
--name=<repo name> --iso_url <URL> --task <task name>`.

For example: `razor create-repo --name=centos-6.6 --iso_url
http://mirrors.usc.edu/pub/linux/distributions/centos/6.6/isos/x86_64/CentOS-6.6-x86_64-minimal.iso
--task centos`.

There are three types of repositories that you might want to use, all
created with the [`create-repo`](./razor_reference.html#create-new-repo-create-repo) command:

+ Repos where Razor downloads and unpacks ISOs for you and serves their contents.
+ Repos that are external, such as a mirror that you maintain.
+ Repos where a stub directory is created and you add the contents manually.

The `task` parameter is mandatory for creating all three of these types of
repositories, and indicates the default installer to use with this
repo. You can override a `task` parameter at the policy level. If you're
not using a task, reference the stock task `noop`.

#### Example 1: Unpack an ISO and Serve Its Contents

This repo is created with the `--iso-url` property. The server downloads and
unpacks the ISO image onto its file system:

~~~
razor create-repo --name centos-6.6 --task centos
	--iso-url http://centos.sonn.com/6.6/isos/x86_64/CentOS-6.6-x86_64-bin-DVD1.iso
~~~

#### Example 2: Point to an Existing Resource

To make a repo that points to an existing resource without loading anything
onto the Razor server, provide a `url` property when you create the
repository. The `url` should be serving the unpacked contents of the
install media.

~~~
razor create-repo --name centos-6.6 --task centos
	--url http://mirror.example.org/centos/6.6/
~~~


#### Example 3: Create a Stub Directory

For some install media, especially Windows install DVD's, Razor is not able
to automatically unpack the media; this is a known limtation of the library
that Razor uses to unpack ISO images.

In those cases, it is necessary to first use `create-repo` to set up a stub
directory on the Razor server, and then manually add content to it. The
stub directory is created with the following:

~~~
razor create-repo --name win2012r2 --task windows/2012r2 \
	--no-content true
~~~

Once this command completes successfully, log into your Razor server as root and cd into your server's `repo_store_root`. Then run the following:

~~~
# mount -o loop /path/to/windows_server_2012_r2.iso /mnt
# cp -pr /mnt/* win2012r2
# umount /mnt
~~~

For more information on repos, see the
[Razor Command Reference](./razor_reference.html#repo-commands).

For more information on installing Windows, see the
[Windows Installation](./razor_windows_install.html) instructions.

## Brokers

Brokers are the next object you create as you prepare to provision with
Razor. Brokers are responsible for handing a node off to a config
management system like Puppet Enterprise. They consist of two parts: a
*broker type* and information that is specific to the broker, such as the
location of the Puppet master.

The broker type is closely tied to the configuration management system that
the node is handed off to. For example, the `puppet-pe` broker runs
the curl command to install a PE agent on the designated node.

Generally, the broker consists of a shell script template and a description
of additional information that must be specified to create a broker from
the broker type.

For the Puppet Enterprise broker type, this information consists of the
node's server, and the version of PE that a node should use. The PE version
defaults to "latest" unless you stipulate a different version.

You create brokers with the `create-broker` command. The following example
sets up a simple noop broker that does nothing:

~~~
razor create-broker --name=noop --broker_type=noop
~~~

And this command sets up the PE broker, which requires the server
parameter.

~~~
razor create-broker --name example1 --broker_type puppet-pe --configuration server=puppet.example.com
~~~

Razor ships with some broker types for your use: puppet-pe, noop, and
puppet. In addition, you can create your own. See
[Writing Broker Types](./razor_brokertypes.html) for more information.

## Tasks

Tasks describe a process or collection of actions that should be performed
while Razor provisions machines. Tasks can be used to designate an
operating system or other software that should be installed, where to get
it, and the configuration details for the installation.

Tasks are structurally simple. They consist of a YAML metadata file and any
number of ERB templates. You include the tasks you want to run in your
policies (policies are described in the next section). The templates are
used to generate things like the iPXE script that will boot a node into the
installer, and automated installation files like kickstart, preseed or
unattended files.

Razor provides a handful of
[existing tasks](https://github.com/puppetlabs/razor-server/tree/master/tasks),
or you can create your own. The existing tasks are primarily for installing
supported operating systems.

Tasks are stored in the file system. The configuration setting `task_path`
determines where in the file system Razor looks for tasks and can be a
colon-separated list of paths. Relative paths in that list are taken to be
relative to the top-level Razor directory. For example, setting `task_path`
to `/opt/puppet/share/razor-server/tasks:/home/me/task:tasks` will make
Razor search these three directories in that order for tasks.

### Task Metadata

Tasks can include the following metadata in the task's YAML file. This file
is called `metadata.yaml` and exists in `tasks/<NAME>.task` where `NAME` is
the task name. Therefore, the task name looks like this:
`tasks/<NAME>.task/metadata.yaml`.

~~~
---
description: HUMAN READABLE DESCRIPTION
os: OS NAME
os_version: OS_VERSION_NUMBER
base: TASK_NAME
boot_sequence:
  1: boot_templ1
  2: boot_templ2
  default: boot_local
~~~

Only `os_version` and `boot_sequence` are required. The `base` key allows
you to derive one task from another by reusing some of the `base` metadata
and templates. If the derived task has metadata that's different from the
metadata in `base`, the derived metadata overrides the base task's
metadata.

The `boot_sequence` hash indicates which templates to use when a node using
this task boots. In the example above, a node will first boot using
`boot_templ1`, then using `boot_templ2`. For every subsequent boot, the
node will use `boot_local`.

## Writing Task Templates

Task templates are ERB templates and are searched in all the directories
given in the `task_path` configuration setting. Templates are searched in
the subdirectories in this order:

1. `name.task`
2. `base.task` # If the task has a base task.
3. `common`

#### Template Helpers

Templates can use the following helpers to generate URLs that point back to
the server; all of the URLs respond to a `GET` request, even the ones that
make changes on the server:

* `file_url(TEMPLATE)`: The URL that will retrieve `TEMPLATE.erb` (after evaluation) from the current node's task.
* `repo_url(PATH)`: The URL to the file at `PATH` in the current repo.
* `log_url(MESSAGE, SEVERITY)`: The URL that will log `MESSAGE` in the current node's log.
* `node_url`: The URL for the current node.
* `store_url(VARS)`: The URL that will store the values in the hash `VARS` in the node. Currently only changing the node's IP address is supported. Use `store_url("ip" => "192.168.0.1")` for that.
* `stage_done_url`: The URL that tells the server that this stage of the boot sequence is finished, and that the next boot sequence should begin upon reboot.
* `broker_install_url`: A URL from which the install script for the node's broker can be retrieved. You can see an example in the script, [os_complete.erb](https://github.com/puppetlabs/razor-server/blob/master/tasks/common/os_complete.erb), which is used by most tasks.

Each boot (except for the default boot) must culminate in something akin to
`curl <%= stage_done_url %>` before the node reboots. Omitting this will
cause the node to reboot with the same boot template over and over again.

The task must indicate to the Razor server that it has successfully
completed by doing a `GET` request against `stage_done_url("finished")`,
for example using `curl` or `wget`. This will mark the node `installed` in
the Razor database.

You use these helpers by causing your script to perform an `HTTP GET`
against the generated URL. This might mean that you pass an argument like
`ks=<%= file_url("kickstart")%>` when booting a kernel, or that you put
`curl <%= log_url("Things work great") %>` in a shell script.

## Policies

Policies orchestrate repos, brokers, and tasks to tell Razor what bits to
install, where to get the bits, how they should be configured, and how to
communicate between a node and PE.

Policies contain tags, which are named rule-sets that identify which nodes
should be bound to a given policy. It's also possible, however, for a node
to bind to a policy without matching tags.

A node boots into the microkernel and sends facts to the Razor server. At
that point, Razor walks through the policy list in order looking for an
eligible policy. If it finds one, it binds to it. If it doesn't find one,
the node continues to send facts to the microkernel until it does
bind. Binding to a policy essentially means that the node will be
provisioned according to the policy's directions.

>**Security Note:** It's important to understand the potential
   repercussions of policy binding. If you don't manage policies closely,
   you can inadvertently enable Razor to match with and provision machines
   that you don't want to provision. In the case of existing servers, this
   could lead to catastrophic data loss. See
   [Provisioning Around Existing Machines](./razor_brownfield.html) for
   strategies to avoid overwriting existing machines.

Policies are stored in order in Razor. Each policy has several reasons why
it might be ineligible for a node to bind to it:

* The policy might be disabled.
* The policy might already have the maximum number of nodes bound to it.
* The policy might require tags that the node doesn't have.

Here's an example of a policy called "centos-for-small." This policy
stipulates that it should be applied to the first 20 nodes that match the
`small` tag.

~~~
razor create-policy --name centos-for-small
	--repo centos-6.6 --broker pe --tag small
	--enabled --hostname "host${id}.example.com"
	--root-password secret --max-count 20
~~~

**Policy Tables** You might create multiple policies, and then retrieve the
policies collection with `razor policies`. The policies are listed in order
in a policy table. You can influence the order of policies as follows:

+ When you create a policy, you can include a `before` or `after` parameter
in the request to indicate where the new policy should appear in the policy
table.
+ Using the `move-policy` command with `before` and `after` parameters, you
can put an existing policy before or after another one.

### Tags

A tag consists of a unique `name` and a `rule`. The tag matches a node if
evaluating it against the tag's facts results in `true`. Note that tag
matching is case sensitive.

For example, here is a tag rule:

~~~
  ["or",
   ["=", ["fact", "macaddress"], "de:ea:db:ee:f0:00"]
    ["=", ["fact", "macaddress"], "de:ea:db:ee:f0:01"]]
~~~

The tag could also be written like this:

~~~
  ["in", ["fact", "macaddress"], "de:ea:db:ee:f0:00", "de:ea:db:ee:f0:01"]
~~~

The syntax for rule expressions uses JSON arrays that roughly resemble s-expressions. Expressions are of the form
`[op arg1 arg2 ... argn]` where `op` is one of the operators below, and
`arg1` through `argn` are the arguments for the operator. If they are
expressions themselves, they will be evaluated before `op` is evaluated.

The expression language currently supports the following operators:


Operator                       |Returns                                          |Aliases
-------------------------------|-------------------------------------------------|-------
`["=", arg1, arg2]`            |true if `arg1` and `arg2` are equal |`"eq"`
`["!=", arg1, arg2]`           |true if `arg1` and `arg2` are not equal |`"neq"`
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
`["lower", arg]`               |the lowercase version of the string `arg`|
`["upper", arg]`               |the uppercase version of the string `arg`|


>**Note:** The `fact` and `metadata` operators take an optional second
   argument. If `arg2` is passed, it is returned if the fact/metadata entry
   `arg1` is not found. If the fact/metadata entry `arg1` is not found and
   no second argument is given, a `RuleEvaluationError` is raised.

## Hooks

Hooks are an optional but very useful Razor object. They provide a way to
run arbitrary scripts when certain events occur during a node's
lifecycle. The behavior and structure of a hook are defined by a *hook
type*.

The two primary components for hooks are:
+ **Configuration**: This is a JSON document for storing data on a hook. These
  have an initial value and can be updated by hook scripts.
+ **Event Scripts**: These are scripts that run when a specified event
  occurs.  Event scripts must be named according to the handled event.

### File Layout for a Hook Type

Similar to brokers and tasks, hook types are defined through a `.hook`
directory and optional event scripts within that directory:

~~~
    hooks/
      some.hook/
        configuration.yaml
        node-bind-policy
        node-unbind-policy
        ...
~~~

### Available events

These are the events for which hook scripts can be provided:

* `node-booted`: Triggered every time a node boots via iPXE.
* `node-registered`: Triggered after a node has been registered, for
  example, after its facts have been set for the first time by the
  microkernel.
* `node-deleted`: Triggered after a node has been deleted.
* `node-bound-to-policy`: Triggered after a node has been bound to a
  policy. The script input contains a `policy` property with the details of
  the policy that has been bound to the node.
* `node-unbound-from-policy`: Triggered after a node has been marked as
  uninstalled by the `reinstall-node` command and thus has been returned to
  the set of nodes available for installation.
* `node-facts-changed`: Triggered whenever a node changes its facts.
* `node-install-finished`: Triggered when a policy finishes its last step.

### Creating Hooks

The `create-hook` command is used to create a hook object from a hook type:

~~~
razor create-hook --name myhook --hook-type some_hook
    --configuration example1=7 --configuration example2=rhubarb
~~~

The hook object created by this command will be set up with its initial
configuration set to the JSON document

~~~
{
	"example1": 7,
    "example2": "rhubarb"
}
~~~

Each time an event script for a hook is run, it has an opportunity to
modify the hook's configuration. These changes to the configuration are
preserved by the Razor server. The Razor server also makes sure that hooks
do not modify their configurations concurrently to avoid the data
corruption that could result from that.

The `delete-hook` command is used to remove a hook.

>**Note:** If a hook's configuration needs to change, it must be deleted then recreated
with the updated configuration.

### Hook Configuration

Hook scripts can use the hook object's `configuration`.

The hook type specifies the configuration data that it accepts in
`configuration.yaml`. That file must define a hash:

~~~
example1:
  description: "Explain what example1 is for"
  default: 0
example2:
  description "Explain what example2 is for"
  default: "Barbara"
...
~~~

For each event that the hook type handles, it must contain a script with
the event's name. That script must be executable by the Razor server. All
hook scripts for a certain event are run (in an indeterminate order) when
that event occurs.

### Event scripts

The general protocol is that hook event scripts receive a JSON object on
their `stdin`, and might return a result by printing a JSON object to their
`stdout`. The properties of the input object vary by event, but they always
contain a `hook` property:

~~~
{
  "hook": {
    "name": hook name,
    "configuration": ... operations to perform ...
  }
}
~~~

The `configuration` object is initialized from the hash described in
the hook's `configuration.yaml` and the properties set by the current
values of the hook object's `configuration`. With the `create-hook` command
above, the input JSON would be:

~~~
{
  "hook": {
    "name": "myhook",
    "configuration": {
      "update": {
        "example1": 7,
        "example2": "rhubarb"
      }
    }
  }
}
~~~

The script might return data by producing a JSON object on its `stdout` to
indicate changes that should be made to the hook's `configuration`. The
updated `configuration` will be used on subsequent invocations of any
event for that hook. The output must indicate which properties to
update, and which ones to remove:

~~~
{
  "hook": {
    "configuration": {
      "update": {
        "example1": 8
      },
      "remove": [ "frob" ]
    }
  }
}
~~~

The Razor server makes sure that invocations of hook scripts are
serialized. For any hook, events are processed one-by-one to allow for
transactional safety around the changes any event script might make.

#### Node Events

Most events are directly related to a node. The JSON input to the event
script will have a `node` property that contains the representation of the
node in the same format the API produces for node details.

The JSON output of the event script can modify the node metadata:

~~~
{
  "node": {
    "metadata": {
      "update": {
        "example1": 8
      },
      "remove": [ "frob" ]
    }

~~~

#### Error Handling

The hook script must exit with exit code 0 if it succeeds; any other exit
code is considered a failure of the script. Whether the failure of a script
has any other effects depends on the event. A failed execution can still
make updates to the hook and node objects by printing to `stdout` in the same
way as a successful execution.

To report error details, the script should produce a JSON object with an
`error` property on its `stdout` in addition to exiting with a non-zero exit
code. If the script exits with exit code 0, the `error` property will still
be recorded, but the event's severity will not be an error. The `error`
property should itself contain an object whose `message` property is a
human-readable message; additional properties can be set. For example:

~~~
{
  "error": {
    "message": "connection refused by frobnicate.example.com",
    "port": 2345,
        ...
    ...
  }
}
~~~


#### Sample input

The input to the hook script will be in JSON, containing a structure like this:

~~~
    {
      "hook": {
        "name": "counter",
        "configuration": { "value": 0 }
      },
      "node": {
        "name": "node10",
        "hw_info": {
          "mac": [ "52-54-00-30-8e-45" ],
          ...
        },
        "dhcp_mac": "52-54-00-30-8e-45",
        "tags": ["compute", "anything", "any", "new"],
        "facts": {
          "memorysize_mb": "995.05",
          "facterversion": "2.0.1",
      "architecture": "x86_64",
          "architecture": "x86_64",
          ...
        },
        "state": {
          "installed": false
      "physicalprocessorcount": "1",
        },
        "hostname": "client-l.watzmann.net",
        "root_password": "secret",
      "netmask_eth0": "255.255.255.0",
      "ipaddress_lo": "127.0.0.1",
        "last_checkin": "2014-05-21T03:45:47+02:00"
      },
      "policy": {
        "name": "client-l",
        "repo": "centos-6.6",
        "task": "ubuntu",
        "broker": "noop",
        "enabled": true,
        "hostname_pattern": "client-l.watzmann.net",
        "root_password": "secret",
        "tags": ["client-l"],
        "nodes": { "count": 0 }
      }
    }
~~~
#### Sample Hook

Here is an example of a basic hook called `counter` that will count the
number of times Razor registers a node. The below also creates a
corresponding directory for the hook type, `counter.hook`, inside the
`hooks` directory. You can store the current count as a configuration entry
with the key `count`. Thus the `configuration.yaml` file might look like
this:

~~~
---
count:
  description: "The current value of the counter"
  default: 0
~~~

To make sure a script runs whenever a node gets bound to a policy, create a
file called `node-bound-to-policy` and place it in the `counter.hook`
folder. Then write this script, which reads in the current configuration
value, increments it, then returns some JSON to update the configuration on
the hook object:

~~~
#! /bin/bash

json=$(< /dev/stdin)

name=$(jq '.hook.name' <<< $json)
value=$(( $(jq '.hook.config.count' <<< $json) + 1 ))

cat <<EOF
{
  "hook": {
    "configuration": {
      "update": {
        "count": $value
      }
    }
  },
  "node": {
    "metadata": {
      $name: $value
    }
  }
}
EOF
~~~

Note that this script uses [`jq`](http://stedolan.github.io/jq/), a bash
JSON manipulation framework. This must be on the `$PATH` in order for
execution to succeed.

Next, create the hook object, which stores the configuration via:

~~~
razor create-hook --name counter --hook-type counter
~~~

Since the configuration is absent from this creation call, the default value
of 0 in `configuration.yaml` is used. Alternatively, this could be set using
`--configuration count=0` or `--c count=0`.

The hook is now ready to go. You can query the existing hooks in a system via
`razor hooks`. To query the current value of the hook's configuration,
`razor hooks counter` will show `count` initially set to 0. When a node gets
bound to a policy, the `node-bound-to-policy` script will be triggered,
yielding a new configuration value of 1.

* * *


[Next: Provisioning in a Brownfield Environment](./razor_brownfield.html)
