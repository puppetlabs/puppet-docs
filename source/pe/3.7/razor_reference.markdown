---
layout: default
title: " PE 3.8 » Razor » Command Reference"
subtitle: "Razor API Reference"
canonical: "/pe/latest/razor_reference.html"

---

The Razor API is REST-based. For best results, use the following as the base URL for your calls:  `http://razor:8150/api`.

**Note:** The following sections contain some example URLs that might be structured differently from the URLs your server uses.

###Common Attributes
Two attributes are commonly used to identify objects:

+ `id` can be used as a GUID for an object. A `GET` request against a URL with an `id` attribute produces a representation of the object.
+ `name` is used for a short, human-readable reference to an object, generally only unique amongst objects of the same type on the same server.

### `/api` reference
The base URL `http://razor:8150/api` fetches the top-level entry point for navigating through the Razor command and query facilities. This is a JSON object with the following keys:

  * `collections`: read-only queries available on this server.
  * `commands`: the commands available on this server.

Each of those keys contains a JSON array, with a sequence of JSON objects that have the following keys:

 * `name`: a human-readable label.
 * `rel`: a "spec URL" that indicates the type of contained data.  Use this to discover the endpoint that you want to follow, rather than the `name`.
 * `id`: the URL to follow to get at this content.

### `/svc` URLs

The `/svc` namespace is an internal namespace, used for communication with the iPXE client, the microkernel, and other internal components of Razor.

This namespace is not enumerated under `/api`.

## Commands

The list of commands that the Razor server supports is returned as part of a request to `GET /api` in the `commands` array. Clients can identify commands using the `rel` attribute of each entry in the array, and should make their POST requests to the URL given in the `url` attribute.

Any command's help documentation can be queried via a GET (rather than POST, which executes the command) on the command's endpoint,
e.g. `GET /api/commands/create-policy`.

Commands are generally asynchronous and return a status code of `202
Accepted` on success. The `url` property of the response generally refers to an entity that is affected by the command and can be queried to determine when the command has finished.

### Create new repo (`create-repo`)

There are three flavors of repositories:

* Those where Razor unpacks ISOs for you and serves their contents.
* Those that are somewhere else (for example, on a mirror you maintain).
* Those where a stub directory is created and the contents can be entered manually.

That the `task` parameter is mandatory for creating all three of these types of repositories. The `task` parameter can be overridden at the policy level. If you're not using a task, reference the stock task `noop`.

#### Have Razor Unpack an ISO

To have Razor unpack an ISO for you and serve its contents, create your repo with the `iso-_url` property. The server downloads and unpacks the ISO image into its file system:

    {
      "name": "fedora19",
      "iso_url": "file:///tmp/Fedora-19-x86_64-DVD.iso"
      "task": "puppet"
    }

#### Point to an Existing Resource

To make a repo that merely points to an existing resource without loading anything onto the Razor server, provide a `url` property when you create the repository:

    {
      "name": "fedora19",
      "url": "http://mirrors.n-ix.net/fedora/linux/releases/19/Fedora/x86_64/os/"
      "task": "noop"
    }

####Create a Stub Directory

To create a stub directory in `repo-store` and load it manually, create your repo with the `no_content` property. This is useful for ISOs that you can't extract normally, e.g. due to forward references:

    {
      "name": "fedora19",
      "no_content": true
      "task": "noop"
    }


### Delete a repo (`delete-repo`)

The `delete-repo` command accepts a single repo name:

    {
      "name": "fedora16"
    }

### Create task (`create-task`)

Razor supports both tasks stored in the filesystem and tasks stored in the database.

For development, we highly recommended storing your tasks in the filesystem. Details about that can be found under [Razor Tasks](/pe/latest/razor_tasks.markdown).

For production setups, it is usually better to store your tasks in the database. To create a task, clients post the following to the `/spec/create_task` URL:

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

name        | The name of the task; must be unique
os          | The name of the OS; mandatory
description | Human-readable description
boot_seq    | A hash mapping the boot counter or 'default' to a template
templates   | A hash mapping template names to the actual ERB template text

### Create broker (`create-broker`)

To create a broker, post the following to the `create-broker` URL:

    {
      "name": "puppet",
      "configuration": {
         "server": "puppet.example.org",
         "environment": "production"
      },
      "broker_type": "puppet"
    }

The `broker_type` must correspond to a broker that is present on the
`broker_path` set in `config.yaml`.

The permissible settings for the `configuration` hash depend on the broker type and are declared in the broker type's `configuration.yaml`.

### Delete broker (`delete-broker`)

To delete a broker, post its name to the `/spec/delete_broker` command:

    {
      "name": "small",
    }

You can't delete a broker if it's being used by a policy.

### Create tag (`create-tag`)

To create a tag, post the following to the `/spec/create_tag`
command:

    {
      "name": "small",
      "rule": ["=", ["fact", "processorcount"], "2"]
    }

The `name` of the tag must be unique; the `rule` is a match expression.

### Delete tag (`delete-tag`)

To delete a tag, post its name to the `/spec/delete_tag` command:

    {
      "name": "small",
      "force": true
    }

You can't delete a tag while it's being used by a policy, unless you set the optional `force` parameter to `true`. In that case, Razor removes the tag from all policies using it and then deletes it.

### Update tag (`update-tag`)

To change the rule for a tag, post the following to the
`/spec/update_tag_rule` command:

    {
      "name": "small",
      "rule": ["<=", ["fact", "processorcount"], "2"],
      "force": true
    }

This changes the rule of the given tag to the new rule. Razor then reevaluates the tag against all nodes and updates each node's tag attribute to reflect whether the tag now matches or not.

If the tag is used by any policies, the update is only performed if you set the optional `force` parameter to `true`. Otherwise, the command returns status code 400.

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

Tags, repos, tasks, and brokers are referenced by name.

The `hostname` parameter defines a simple pattern for the hostnames of nodes bound to your policy. The "${id}" references each node's DB id.

The `max_count` parameter sets an upper limit on how many nodes can be bound to your policy at a time. You can specify a positive integer, or make it unlimited by setting it to `nil`.

Razor considers each policy sequentially, based on its order in a table. By default, new policies go at the end of the table. To override the default order, include a `before` or `after` argument referencing an existing policy by name.

The `node_metadata` parameter lets your policy apply metadata to a node when it binds. This is NON AUTHORITATIVE in that it does not overwrite existing metadata; it only adds keys that are missing.

### Move policy (`move-policy`)

This command lets you change the order in which razor considers your policies for matching against nodes. To move an existing policy into a different place in the order, use the `move-policy` command with a body like:

    {
      "name": "a policy",
      "before"|"after": "other policy"
    }

This changes the policy table so that `a policy` appears before or after `other policy`.

### Enable/disable policy (`enable-policy`/`disable-policy`)

To keep a policy from being matched against any nodes, disable it with the `disable-policy` command. To enable a disabled policy, use the `enable-policy` command. Both commands use a body like:

    {
      "name": "a policy"
    }

### Modify the max_count for a policy (`modify-policy-max-count`)

The command `modify-policy-max-count` lets you set the maximum number of nodes that can be bound to a specific policy. The body of the request should be of the form:

    {
      "name": "a policy"
      "max_count": new-count
    }

The `new-count` can be an integer, which must be greater than the number of nodes that are currently bound to the policy, or `null` to make the policy unbounded.

### Add tags to Policy (`add-policy-tag`)

To add tags to a policy, supply the name of a policy and of the tag:

    {
      "name": "a-policy-name",
      "tag" : "a-tag-name",
    }

To create the tag in addition to adding it to the policy, supply the `rule` argument:

    {
      "name": "a-policy-name",
      "tag" : "a-new-tag-name",
      "rule": "new-match-expression"
    }

### Remove tags from Policy (`remove-policy-tag`)

To remove tags from a policy, supply the name of a policy and the name of the tag.

    {
      "name": "a-policy-name",
      "tag" : "a-tag-name",
    }

### Delete policy (`delete-policy`)

To delete a policy, supply the name of a single policy:

    {
      "name": "my-policy"
    }

Note that this does not affect the `installed` status of a node, and
therefore can't, by itself, make a node bind to another policy upon reboot.

### Create hook (`create-hook`)

To create a new hook, use the `create-hook` command with a body like this:

    {
      "name": "myhook",
      "hook_type": "some_hook",
      "configuration": {"foo": 7, "bar": "rhubarb"}
    }

The `hook_type` parameter refers to a .hook file in the Razor server's `hooks` directory. The above example would point to `hooks/some_hook.hook`.

The optional `configuration` parameter lets you provide a starting configuration corresponding to that hook_type.

For more on, see [Razor Hooks](./razor_hooks).

### Delete hook (`delete-hook`)

To delete a single hook, provide its name:

    {
      "name": "my-hook"
    }

### Delete node (`delete-node`)

To remove a single node, provide its name:

    {
      "name": "node17"
    }

>**Note**: If the deleted node boots again at some point, Razor automatically recreates it.

### Reinstall node (`reinstall-node`)

To remove a node's association with any policy and clear its `installed` flag, provide its name:

    {
      "name": "node17"
    }

Once the node reboots, it boots back into the microkernel, goes through discovery and tag matching, and can be bound to another policy. This command does not change the node's metadata or facts.

### Set node IPMI credentials (`set-node-ipmi-credentials`)

Razor can store IPMI credentials on a per-node basis. These credentials include a hostname (or IP address), username, and password to use when contacting the BMC/LOM/IPMI LAN or LANplus service to check or update power state and other node data.

These three data items can only be set or reset together, in a single operation. Partial updates must be handled client-side. This eliminates conflicting update and partial update combination surprises for users. If you omit a parameter, Razor sets it to NULL (representing no value, or the NULL username/password as defined by IPMI).

The structure of a request is:

    {
      "name": "node17",
      "ipmi_hostname": "bmc17.example.com",
      "ipmi_username": null,
      "ipmi_password": "sekretskwirrl"
    }

This command only works with remote IPMI targets, not locally; therefore, you *must* provide an IPMI hostname if you provide either a username or a password.

### Reboot node (`reboot-node`)

If you've associated IPMI credentials with a node, Razor can use IPMI to trigger a hard power cycle. Just provide the name of the node:

    {
      "name": "node1",
    }

The RBAC pattern for this command is: `reboot-node:${node}`

The IPMI communication spec includes some generous internal rate limits to prevent it from overwhelming the network or host server. If an execution slot isn't available on the target node, your `reboot-node` command goes into a background queue, and runs as soon as a slot is available.

This background queue is cumulative and persistent: there are no limits on how many commands you can queue up, how frequently a node can be rebooted, or how long a command can stay in the queue. If you restart your Razor server before the queued commands are executed, they'll remain in the queue and run after the server restarts.

If an IPMI request fails (ipmitool reports it is unable to communicate with the node), Razor retries the request. The output from ipmitool isn't specific, so you can't tell if the command never went through, or was delivered but failed to reboot the system.

The `reboot node` command is not integrated with IPMI power state monitoring, so you can't see power transitions in the record or when polling the node object.

### Set a node's desired power state (`set-node-desired-power-state`)

By default, Razor checks your nodes' power states every few minutes in the background. If it detects a node in a non-desired state, Razor issues an IPMI command directing the node to its desired state.

To set the desired state for a node:

    {
      "name": "node1234",
      "to":   "on"|"off"|null
    }

The `name` parameter identifies the node to change the setting on.

The `to` parameter contains the desired power state to set. Valid values are `on`, `off`, or `null` (the JSON NULL/nil value), which reflect "power on", "power off", and "do not enforce power state" respectively.

### Modify node metadata (`modify-node-metadata`)

Node metadata is a collection of key => value pairs, much like a node's facts. The difference is that the facts represent what the node tells Razor about itself, while its metadata represents what you tell Razor about the node.

The `modify-node-metadata` command lets you add/update or remove individual metadata keys, or fully clear out a node's metadata:

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

As above, you can submit multiple updates and/or removes in a single command. However, `clear` only works on its own.

### Update node metadata (`update-node-metadata`)

The `update-node-metadata` command is a shortcut to `modify-node-metadata` that streamlines updating a single key via the command line or a GET request:

    {
        "node"      : "mode1",
        "key"       : "my_key",
        "value"     : "my_val",
        "no_replace": true       #Optional: don't replace existing keys
    }

### Remove Node Metadata (`remove-node-metadata`)

The `remove-node-metadata` command is a shortcut to `modify-node-metadata` that streamlines removing either a single key or all keys on a node via the command line or a GET request:

    {
        "node" : "node1",
        "key"  : "my_key",
    }

or

    {
        "node" : "node1",
        "all"  : true,     # Removes all keys
    }

## Set Node Hardware Info (`set-node-hardware-info`)

When a node's hardware changes, such as a network card being replaced, the Razor server needs to be informed so it can correctly match the new hardware to the existing node definition.

The `set-node-hardware-info` command lets you replace the existing hardware data with new data, prior to booting the modified node on the network. For example, update node172 with new hardware information as follows:

  {
      "node": "node172",
      "hw_info": {
        "net0":   "78:31:c1:be:c8:00",
        "net1":   "72:00:01:f2:13:f0",
        "net2":   "72:00:01:f2:13:f1",
        "serial": "xxxxxxxxxxx",
        "asset":  "Asset-1234567890",
        "uuid":   "Not Settable"
      }
  }

## Collections

In addition to the supported commands above, a `GET /api` request returns a list of supported collections in the `collections` array. Each entry contains at minimum the following keys:

`url`  | the endpoint through which the collection can be retrieved (via `GET`)
`spec` | the 'type' of collection
`name` | a human-readable name for the collection.

A `GET` request to a collection endpoint yields a list of JSON objects, each of which has at minimum the following fields:

id   | a URL that uniquely identifies the object
spec | a URL that identifies the type of the object
name | a human-readable name for the object

Different types of objects might specify other properties by defining additional key-value pairs. For example, here is a sample tag listing:

    [
      {
        "spec": "http://localhost:8150/spec/object/tag",
        "id": "http://localhost:8150/api/collections/objects/14",
        "name": "virtual",
        "rule": [ "=", [ "fact", "is_virtual" ], true ]
      },
      {
        "spec": "http://localhost:8150/spec/object/tag",
        "id": "http://localhost:8150/api/collections/objects/27",
        "name": "group 4",
        "rule": [
          "in", [ "fact", "dhcp_mac" ],
          "79-A8-C3-39-E4-BA",
          "6C-35-FE-B7-BD-2D",
          "F9-92-DF-E0-26-5D"
        ]
      }
    ]

In addition, references to other resources are represented as a single JSON object (in the case of a one-to-one relationship) or an array of JSON objects (for a one-to-many or many-to-many relationship). Each JSON object contains the following fields:

url    | a URL that uniquely identifies the object
obj_id | a short numeric identifier
name   | a human-readable name for the object

If the reference object is in an array, the `obj_id` field serves as a unique identifier within the array.

## Querying the node collection

You can query nodes based on the following criteria:
* `hostname`: a regular expression to match against hostnames. The results include partial matches, so `hostname=foo` returns all nodes whose hostnames include `foo`.
* Hardware info (`mac`, `serial`, `asset`, and `uuid`) as stored in `hw_info`.

## Other things

### The default bootstrap iPXE file

A GET request to `/api/microkernel/bootstrap` returns an iPXE script that can be used to bootstrap nodes that have just PXE booted (it culminates in chain loading from the Razor server).

The URL accepts the parameter `nic_max` which you should set to the maximum number of network interfaces that respond to DHCP on any given node. It defaults to 4.
