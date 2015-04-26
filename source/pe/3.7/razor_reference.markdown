---
layout: default
title: " PE 3.8 » Razor » Command Reference"
subtitle: "Razor API Reference"
canonical: "/pe/latest/razor_reference.html"

---

The Razor API is REST-based. The default URL for the API entrypoint is
`https://razor:8151/api`.

The Razor API is considered stable, and clients can expect that operations
that work against this version of the API to continue working against
future versions of the Razor API, with one caveat: clients *must* ignore
anything in responses they receive from the server that they do not
understand. We reserve the right to add additional information anywhere in
the API in future versions. This will be the main mechanism by which this
API will evolve and grow over time.

The API uses JSON exclusively, and all requests must set the HTTP
`Content-Type` header to `application/json` and must `Accept`
`application/json` in the response.

**Note:** The following sections contain some example URLs that might be
  structured differently from the URLs your server uses.

### Common Attributes

Two attributes are commonly used to identify objects:

* `id` can be used as a GUID for an object. A `GET` request against a URL
with an `id` attribute produces a representation of the object.
* `name` is used for a short, human-readable reference to an object,
generally only unique amongst objects of the same type on the same server.

### `/api` reference

By default, API calls are sent over HTTPS with TLS/SSL. The default URL for
the API entrypoint is `https://razor:8151/api`. Everything underneath
`/api` is part of the public API and adheres to Razor's stability
guarantees.

The top-level entrypoint serves as the start for navigating through the
Razor command and query facilities. The response is a JSON object with the
following keys:

* `collections`: read-only queries available on this server.
* `commands`: the commands available on this server.
  * `version`: the version of Razor that is running on the server. The
    version should only be used for diagnostic purposes and for bug
    reporting, and never to decide whether the server supports a certain
    operation or not.

Each of those keys contains a JSON array, with a sequence of JSON objects
that have the following keys:

 * `name`: a human-readable label.
 * `rel`: a "spec URL" that indicates the type of contained data.  Use this to discover the endpoint that you want to follow, rather than the `name`.
 * `id`: the URL of this entity.

### `/svc` URLs
The `/svc` namespace is an internal namespace, used for communication with

the iPXE client, the microkernel, and other internal components of
Razor. Since Razor deals with installing machines from scratch, there are
no existing security considerations in place when making `/svc` calls.

This namespace is not enumerated under `/api` as it is considered private
API, and may change in incompatible ways from release to release.

In fact, it is considered good practice to make `/svc` URLs only available
to that part of the network that contains nodes that need to be provisioned
and keep the rest of the network from accessing it.

## Commands

The list of commands that the Razor server supports is returned as part of
a request to `GET /api` in the `commands` array. Clients can identify
commands using the `rel` attribute of each entry in the array, and should
make their POST requests to the URL given in the `id` attribute.

The `id` URL for each command supports the following HTTP methods:
* `GET`: retrieve information about the command, such as a help text and
  machine-readable information about the parameters this command takes
* `POST`: execute the command. Command parameters are supplied in a JSON
  document in the body of the `POST` request

Commands are generally asynchronous and return a status code of `202
Accepted` on success. The response from a command generally has the form

   {
     "result":"Policy win2012r2 disabled",
     "command":"http://razor:8088/api/collections/commands/74"
   }

Here, `result` is a human-readable explanation of what the command did, and
`command` points into the collection of all the commands that were ever run
against this server. Performing a `GET` against the `command` URL provides
additional information about the execution of this command, such as the
status of the command, the parameters sent to the server, and details about
errors.

## Repo Commands

### Create new repo (`create-repo`)

There are three flavors of repositories:

* Those where Razor unpacks ISOs for you and serves their contents.
* Those that reference content available on another server (for example, on a mirror you maintain).
* Those where Razor only creates a stub directory which you can fill manually with content.

The `task` parameter is mandatory in all three variants of this command,
and indicates the default task that should be used when installing machines
using this repository. The `task` parameter can be overridden at the policy
level. If you're not using a task, reference the stock task `noop`.

#### Have Razor Unpack an ISO

To have Razor unpack an ISO for you and serve its contents, create your
repo with the `iso-_url` property. The server downloads and unpacks the ISO
image into its file system:

    {
      "name": "fedora19",
      "iso_url": "file:///tmp/Fedora-19-x86_64-DVD.iso"
      "task": "puppet"
    }

#### Point to an Existing Resource

To make a repo that points to an existing resource without loading anything
onto the Razor server, provide a `url` property when you create the
repository:

    {
      "name": "fedora19",
      "url": "http://mirrors.n-ix.net/fedora/linux/releases/19/Fedora/x86_64/os/"
      "task": "noop"
    }

#### Create a Stub Directory

To create an empty directory in the `repo_store_root` and later fill it manually,
create your repo with the `no_content` property.

    {
      "name": "win2012r2",
      "no_content": true
      "task": "noop"
    }

Once this command finishes, you can log into your Razor server and fill the
directory `$repo_store_root/$repo_name` with the actual content for the
repository, for example by loopback mounting the install media and copying
it into the repository's directory.

Using this variant of `create-repo` is generally necessary for Windows
install media, as the library that Razor uses to unpack ISO images can not
handle Windows ISO images.

### Delete a repo (`delete-repo`)

The `delete-repo` command accepts a single repo name:

    {
      "name": "fedora16"
    }

This command deletes the repository from Razor's internal database, but
does not remove any content that might be in the `repo_store_root`
directory on the Razor server.

### Update a Repo's Specified Task (`update-repo-task`)

Ensures that a specified repo uses the task this command specifies, setting
the task if necessary. If a node is currently provisioning against the repo
when you run this command, provisioning might fail.

	{
	  "node": "node1",
	  "repo": "my_repo",
	  "task": "other_task"
	}

The following shows how to update a repo’s task to a task called `other_task`.

	{
	  "repo": "my_repo",
	  "no_task": true
	}

## Task Commands

### Create task (`create-task`)

Razor supports both tasks stored in the filesystem and tasks stored in the
database.

For development, we highly recommended storing your tasks in the
file system. Details about that can be found under
[Razor Tasks](/pe/latest/razor_tasks.markdown). Tasks stored in the file
system do not need to be created with the `create-task` command. It
suffices to put their corresponding files into the right place somewhere on the `task_path`.  See [Writing Task Templates](./razor_objects.html#writing-task-templates) for more information.

For production setups, it is usually better to store your tasks in the
database by using the `create-task` command. The body of the `POST` request
for this command has the following form:

    {
      "name": "redhat6",
      "os": "Red Hat Enterprise Linux",
      "boot_seq": {
        "1": "boot_install",
        "default": "boot_local"
      },
      "templates": {
        "boot_install": " ... ERB template for an ipxe boot file ...",
        "installer": " ... another ERB template ..."
      }
    }

The possible properties in the request are:

* `name`: The name of the task; must be unique.
* `os`: The name of the OS; mandatory.
* `description`: Human-readable description.
* `boot_seq`: A hash mapping the boot counter or 'default' to a template.
* `templates`: A hash mapping template names to the actual ERB template text.

## Broker Commands

A broker is responsible for configuring a newly installed node for a
specific configuration management system. For Puppet Enterprise, you will
generally only use brokers with the type `puppet-pe`.

### Create broker (`create-broker`)

To create a broker, post the following to the `create-broker` URL:

    {
      "name": "puppet",
      "configuration": {
         "server": "puppet.example.org"
      },
      "broker_type": "puppet-pe"
    }

The `broker_type` must correspond to a broker that is present on the `broker_path` set in `config.yaml`.
`broker_path` set in `config.yaml`.

The permissible settings for the `configuration` hash depend on the broker
type and are declared in the broker type's `configuration.yaml`. For the
`puppet-pe` broker type, these are:

* `server`: The hostname of the Puppet Master
* `version`: The agent version to install; this defaults to `current` and should only be used in exceptional circumstances
* `windows_download_url`: The download URL for a Windows PE agent installer; defaults to a URL derived from the `version` config. This should only be used in exceptional circumstances

### Delete broker (`delete-broker`)

The `delete-broker` command only requires the name of the broker:

    {
      "name": "small",
    }

It is not possible to delete a broker as long as it is used by a policy.

## Tag Commands

### Create tag (`create-tag`)

To create a tag, use the following in the body of your `POST` request:

    {
      "name": "small",
      "rule": ["=", ["fact", "processorcount"], "2"]
    }

The `name` of the tag must be unique; the `rule` is a match
expression. For more information on tag rules, [see Tags](./razor_objects.html#tags).

### Delete tag (`delete-tag`)

To delete a tag, use the following in the body of your `POST` request:

    {
      "name": "small",
      "force": true
    }

You can't delete a tag while it's being used by a policy, unless you set
the optional `force` parameter to `true`. In that case, Razor removes the
tag from all policies using it and then deletes it.

### Update tag (`update-tag`)

To change the rule for a tag, use the following in the body of your `POST`
request:

    {
      "name": "small",
      "rule": ["<=", ["fact", "processorcount"], "2"],
      "force": true
    }

This changes the rule of the given tag to the new rule. Razor then
reevaluates the tag against all nodes and updates each node's tag attribute
to reflect whether the tag now matches or not.

If the tag is used by any policies, the update is only performed if you set
the optional `force` parameter to `true`. Otherwise, the command returns
status code 400.

## Policy Commands

Policies govern how nodes are provisioned depending on how they are
tagged. Razor maintains an ordered table of policies. When a node boots, Razor traverses this table to find the first eligible policy for that node. A policy might be ineligible for binding to a node if the node does not contain all of the tags on the policy, if the policy is disabled, or if the policy has reached its maximum for the number of allowed nodes.

When you list the `policies` collection, the list is in the order in which
Razor checks policies against nodes.


### Create policy (`create-policy`)

    {
      "name": "a policy",
      "repo": "some_repo",
      "task": "redhat6",
      "broker": "puppet",
      "hostname": "host${id}.example.com",
      "root_password": "secret",
      "max_count": 20,
      "before"|"after": "other policy",
      "node_metadata": { "key1": "value1", "key2": "value2" },
      "tags": ["existing_tag", "another_tag"]
    }

Tags, repos, tasks, and brokers are referenced by name. The `tags` are
optional; a policy with no tags can be applied to a node. The `task`
is also optional; if it is omitted, the `repo`'s task is used. The `repo`
and `broker` entries are required.

The `hostname` parameter defines a simple pattern for the hostnames of
nodes bound to your policy. The "${id}" references each node's DB id.

The `max_count` parameter sets an upper limit on how many nodes can be
bound to your policy at a time. You can specify a positive integer, or make
it unlimited by setting it to `nil`.

Razor considers each policy sequentially, based on its order in a table. By
default, new policies go at the end of the table. To override the default
order, include a `before` or `after` argument referencing an existing
policy by name.

The `node_metadata` parameter lets your policy apply metadata to a node
when it binds. This does not overwrite existing metadata; it only adds keys
that are missing.

### Move policy (`move-policy`)

This command lets you change the order in which razor considers your
policies for matching against nodes. To move an existing policy into a
different place in the order, use the `move-policy` command with a body
like:

    {
      "name": "a policy",
      "before"|"after": "other policy"
    }

This changes the policy table so that `a policy` appears before or after
`other policy`.

### Enable/disable policy (`enable-policy`/`disable-policy`)

To keep a policy from being matched against any nodes, disable it with the
`disable-policy` command. To enable a disabled policy, use the
`enable-policy` command. Both commands use a body like:

    {
      "name": "a policy"
    }

### Modify the max_count for a policy (`modify-policy-max-count`)

The command `modify-policy-max-count` lets you set the maximum number of
nodes that can be bound to a specific policy. The body of the request
should be of the form:

    {
      "name": "a policy"
      "max_count": new-count
    }

`new-count` can be an integer, which must be greater than the number of
nodes that are currently bound to the policy. Alternatively, the
`no_max_count` argument makes the policy unbounded:

	{
      "name": "a policy"
      "no_max_count": true
	}

### Add tags to Policy (`add-policy-tag`)

To add tags to a policy, supply the name of a policy and of the tag:

    {
      "name": "a-policy-name",
      "tag" : "a-tag-name",
    }

To create the tag in addition to adding it to the policy, supply the `rule`
argument:

    {
      "name": "a-policy-name",
      "tag" : "a-new-tag-name",
      "rule": "new-match-expression"
    }

### Remove tags from Policy (`remove-policy-tag`)

To remove tags from a policy, supply the name of a policy and the name of
the tag.

    {
      "name": "a-policy-name",
      "tag" : "a-tag-name",
    }

A policy with no tags can still be applied to any node.

### Update a Policy's Specified Task (`update-policy-task`)

Ensures that a policy uses the task this command specifies. If necessary,
`update-policy-task` sets the task, for example if a policy has already
been created and you want to add a task to it. Note that if a node is
currently provisioning against the policy when you run this command,
provisioning can fail.

The following shows how to update a policy's task to a task called "other_task".

	{
	  "node": "node1",
	  "policy": "my_policy",
	  "task": "other_task"
	}

### Delete policy (`delete-policy`)

To delete a policy, supply the name of a single policy:

    {
      "name": "my-policy"
    }

Note that this does not affect the `installed` status of a node, and therefore can't, by itself, make a node bind to another policy upon reboot.

## Hook Commands

### Create hook (`create-hook`)

To create a new hook, use the `create-hook` command with a body like this:

    {
      "name": "myhook",
      "hook_type": "some_hook",
      "configuration": {"foo": 7, "bar": "rhubarb"}
    }

The `hook_type` parameter refers to a directory with name `some_hook.hook`
on the Razor server's `hook_path`.

The optional `configuration` parameter lets you provide a starting
configuration corresponding to that hook_type.

For more on hooks, see [Hooks](./razor_objects.html#hooks).

### Delete hook (`delete-hook`)

To delete a single hook, provide its name:

    {
      "name": "my-hook"
    }

## Node Commands

### Register a Node (`register-node`)

Register a node with Razor before it is discovered, and potentially
provisioned; in environments in which some nodes have been provisioned
outside of Razor's purview, this command offers a way to tell Razor that a
node is valuable and not eligible for automatic reprovisioning with
Razor. Such nodes are only reprovisioned if they are marked available with
the `reinstall-node` command.

The `register-node` command allows you to perform the same registration
that would happen when a new node checks in, but ahead of time. The
`register-node` command uses the `installed` value to indicate that a node
has already been installed, which signals to Razor that the node should be
ignored, and Razor should act as if it had successfully installed that
node.

In order for this command to be effective, `hw_info` must contain enough
information that the node can successfully be identified based on the
hardware information sent from iPXE when the node boots; this usually
includes the MAC addresses of all network interfaces of the node.

`register-nodes` accepts the following parameters:


* `hw_info`: Required, provides the hardware information for the node.
  This is used to match the node on first boot with the record in the
  database. The `hw_info` can contain all or a subset of the following
  entries:
  * `netN`: The MAC addresses of each network interface, for example `net0`
  or `net2`: The order of the MAC addresses is not significant.
  * `serial`: The DMI serial number of the node.
  * `asset`: The DMI asset tag of the node.
  * `uuid`: DMI UUID of the node.
* `installed`: A boolean flag indicating whether this node should be
  considered installed and therefore not eligible for reprovisioning by
  Razor

**API Example**

Registering a machine before booting it with `installed` set to `true` will
protect it from accidental reinstallation by Razor:

    {
      "hw_info": {
        "net0":   "78:31:c1:be:c8:00",
        "net1":   "72:00:01:f2:13:f0",
        "net2":   "72:00:01:f2:13:f1"
      },
      "installed": true
    }

### Set Node Hardware Info (`set-node-hardware-info`)

When a node's hardware changes, such as a network card being replaced, the
Razor server needs to be informed so it can correctly match the new
hardware to the existing node definition.

The `set-node-hardware-info` command lets you replace the existing hardware
data with new data, prior to booting the modified node on the network. For
example, update node172 with new hardware information as follows:

  {
      "node": "node172",
      "hw_info": {
        "net0":   "78:31:c1:be:c8:00",
        "net1":   "72:00:01:f2:13:f0",
        "net2":   "72:00:01:f2:13:f1"
      }
  }

The format of the `hw_info` is the same as for the `register-node` command,
where you can find more details about it.

### Delete node (`delete-node`)

To remove a single node, provide its name:

    {
      "name": "node17"
    }

>**Note**: If the deleted node boots again at some point, Razor automatically recreates it.

### Reinstall node (`reinstall-node`)

To remove a node's association with any policy and clear its `installed`
flag, provide its name:

    {
      "name": "node17"
    }

Once the node reboots, it boots back into the microkernel, goes through
discovery and tag matching, and can bind to another policy for reinstallation. This command does not change the node's metadata or facts.

### Set node IPMI credentials (`set-node-ipmi-credentials`)

Razor can store IPMI credentials on a per-node basis. These credentials
include a hostname (or IP address), username, and password to use when
contacting the BMC/LOM/IPMI LAN or LANplus service to check or update power
state and other node data. Once IPMI credentials have been set up for a
node, you can use the `reboot-node` and `set-node-desired-power-state`
commands.

These three data items can only be set or reset together, in a single
operation. When you omit a parameter, Razor sets it to `NULL` (representing
no value, or the `NULL` username/password as defined by IPMI).

The structure of a request is:

    {
      "name": "node17",
      "ipmi_hostname": "bmc17.example.com",
      "ipmi_username": null,
      "ipmi_password": "sekretskwirrl"
    }

This command only works with remote IPMI targets, not locally; therefore,
you *must* provide an IPMI hostname.

### Reboot node (`reboot-node`)

If you've associated IPMI credentials with a node, Razor can use IPMI to
trigger a hard power cycle. Just provide the name of the node:

    {
      "name": "node1",
    }

The IPMI communication spec includes some generous internal rate limits to
prevent it from overwhelming the network or host server. If an execution
slot isn't available on the target node, your `reboot-node` command goes
into a background queue, and runs as soon as a slot is available.

This background queue is cumulative and persistent: there are no limits on
how many commands you can queue up, how frequently a node can be rebooted,
or how long a command can stay in the queue. If you restart your Razor
server before the queued commands are executed, they'll remain in the queue
and run after the server restarts.

The `reboot node` command is not integrated with IPMI power state
monitoring, so you can't see power transitions in the record or when
polling the node object.

### Set a node's desired power state (`set-node-desired-power-state`)

By default, Razor checks your nodes' power states every few minutes in the
background. If it detects a node in a non-desired state, Razor issues an
IPMI command directing the node to its desired state.

To set the desired state for a node:

    {
      "name": "node1234",
      "to":   "on"|"off"|null
    }

The `name` parameter identifies the node to change the setting on.
The `to` parameter contains the desired power state to set. Valid values

are `on`, `off`, or `null` (the JSON NULL/nil value), which reflect "power
on", "power off", and "do not enforce power state" respectively.

## Node Metadata Commands

### Modify Node Metadata (`modify-node-metadata`)

Node metadata is a collection of key/value pairs, much like a node's
facts. The difference is that the facts represent what the node tells Razor
about itself, while its metadata represents what you tell Razor about the
node.

The `modify-node-metadata` command lets you add/update or remove individual
metadata keys, or fully clear out a node's metadata:

    {
      "node": "node1",
      "update": {                         # Add or update these keys
          "key1": "value1",
          "key2": "value2",
            ...
      }
      "remove": [ "key3", "key4", ... ],  # Remove these keys
      "no_replace": true                  # Do not replace keys on
                                            # update. Only add new keys
    }

or

    {
      "node": "node1",
      "clear": true                       # Clear all metadata
    }

As above, you can submit multiple updates and/or removes in a single
command. However, `clear` only works on its own.

### Update node metadata (`update-node-metadata`)

The `update-node-metadata` command offers a simplified way to update a
single metadata key; the body for the command must be:

    {
        "node"      : "mode1",
        "key"       : "my_key",
        "value"     : "my_val",
        "no_replace": true
    }

The `no_replace` parameter is optional; if it is `true`, the metadata entry
will not be modified if it already exists.

### Remove Node Metadata (`remove-node-metadata`)

The `remove-node-metadata` command offers a simplified way to remove either
a single metadata entry or all metadata entries on a node:

    {
      "node" : "node1",
      "key"  : "my_key",
    }

or

    {
      "node" : "node1",
      "all"  : true,     # Removes all keys
    }

## Collections

In addition to the supported commands above, a `GET /api` request returns a
list of supported collections in the `collections` array. Each entry
contains at minimum the following keys:

* `name`: A human-readable name for the collection.
* `id`: The endpoint through which the collection can be retrieved (via `GET`).
* `rel`: The type of the collection.

A `GET` request to the `id` of a collection returns a JSON object; the
`spec` property of that object indicates the type of collection, the
`total` indicates how many items there are in the collection in total (not
just how many were returned by the query), and `items` is the actual list
of items in the collection, a JSON array of objects. Each object has the
following properties:

* `id`: A URL that uniquely identifies the object. A `GET` request to this URL provides further detail about the object.
* `spec`: A URL that identifies the type of the object.
* `name`: A human-readable name for the object.

### Object details

Performing a `GET` request against the `id` of an item in a collection
returns further detail about that object. Different types of objects
provide different properties. For example, here is a sample tag listing:

    {
      "spec": "http://api.puppetlabs.com/razor/v1/collections/tags/member",
      "id": "https://razor:8151/api/collections/tags/anything",

* `id`: a URL that uniquely identifies the object.
* `spec`: a URL that identifies the type of the object.
      "name": "anythin",
      "rule": [ "=", 1, 1],
      "nodes": {
        "id": "http://razor:8151/api/collections/tags/anything/nodes",
        "count": 2,
        "name": "nodes"
      },
      "policies": {
        "id": "http://razor:8151/api/collections/tags/anything/policies",
        "count": 0,
        "name": "policies"
      }
    }

References to other resources are represented as a single JSON object (in
the case of a one-to-one relationship) or an array of JSON objects (for a
one-to-many or many-to-many relationship). Each JSON object contains the
following fields:

* `id`: A URL that uniquely identifies the associated object or collection of objects.
* `spec`: The type of the associated object.
* `name`: A human-readable name for the object.
* `count`: The number of objects in the associated collection.

## Querying the Node Collection

You can query nodes based on the following criteria:

* `hostname`: A regular expression to match against hostnames. The results
  include partial matches, so `hostname=example` returns all nodes whose
  hostnames include `example`.
* fields stored in `hw_info`: `mac`, `serial`, `asset`, and `uuid`.

For example, the following queries the UUID to return the associated node:

	/api/collections/nodes?uuid=9ad1e079-b9e3-347c-8b13-9b42cbf53a14'

	{
      "items": [
       {
          "id": "https://razor.example.com:8151/api/collections/nodes/node14",
          "name": "node14",
          "spec": "http://api.puppetlabs.com/razor/v1/collections/nodes/member"
        }],
      "spec": "http://api.puppetlabs.com/razor/v1/collections/nodes"
	}


## Paging collections
The `nodes` and `events` collections are paginated. `GET` requests for them

may include the following parameters to limit the number of items returned:

* `limit`: Only return this many items.
* `start`: Return items starting at `start`.

## The Default Bootstrap iPXE File

A GET request to `/api/microkernel/bootstrap` returns the iPXE script that
you should put on your TFTP server (usually called `bootstrap.ipxe`) The
script gathers information about the node (the `hw_info`) that it sends to
the server and that the server uses to identify the node and determine how
exactly the node should boot.

The URL accepts the parameter `nic_max`, which you should set to the
maximum number of network interfaces that respond to DHCP on any given
node. It defaults to 4.

The URL also accepts an `http_port` parameter, which tells Razor which port
its internal HTTP communications should use, and the `/svc` URLs must be
available through that port. The default install will use 8150 for this.
