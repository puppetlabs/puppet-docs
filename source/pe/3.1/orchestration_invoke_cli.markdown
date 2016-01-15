---
layout: default
title: "PE 3.1 » Orchestration » Invoking Actions"
subtitle: "Invoking Orchestration Actions"
canonical: "/pe/latest/orchestration_invoke_cli.html"
---

[master_server]: ./install_basic.html#the-puppet-master-role
[install_certname]: ./install_basic.html#puppet-agent-questions
[console_inventory]: ./console_reports.html#viewing-inventory-data
[core_facts]: /facter/1.7/core_facts.html
[nav_live]: ./console_navigating_live_mgmt.html

About This Page
-----

Puppet Enterprise (PE) has two ways to invoke orchestration actions:

* The live management page of the PE console
* The Linux command line on the puppet master server

This page covers only the command line. See [the Navigating Live Management page of this manual][nav_live] for instructions on using live management to invoke actions.

> **Note:** Although you will be running these commands on the Linux command line, they can invoke orchestration actions on both \*nix and Windows machines.

### MCollective Documentation

Puppet Enterprise's orchestration engine, MCollective, has its own section of the documentation site, which includes more complete details and examples for command line orchestration usage.

This page covers basic CLI usage and all PE-specific information; for more details, see the following pages from the MCollective docs:

* [MCollective Command Line Usage](/mcollective/reference/basic/basic_cli_usage.html)
* [Filtering](/mcollective/reference/ui/filters.html)

Logging In as `peadmin`
-----

To run orchestration commands, you must log in to [the puppet master server][master_server] as the special `peadmin` user account, which is created during installation.

> **Note:** Puppet Enterprise 3.0 does not support adding more orchestration user accounts.
>
> This means that, while it is possible (albeit complex) to allow other accounts on other machines to invoke orchestration actions, upgrading to a future version of PE may disable access for these extra accounts, requiring you to re-enable them manually. We do not provide instructions for enabling extra orchestration accounts.

By default, the `peadmin` account cannot log in with a password. We recommend two ways to log in:

### Using Sudo

Anyone able to log into the puppet master server as an admin user with full root `sudo` privileges can become the `peadmin` user by running:

    $ sudo -i -u peadmin

This is the default way to log in as the `peadmin` user. It means that orchestration commands can only be issued by the group of users who can fully control the puppet master.

### Adding SSH Keys

If you wish to allow other users to run orchestration commands without giving them full control over the puppet master, you can add their public SSH keys to `peadmin`'s authorized keys file.

You can use Puppet's [`ssh_authorized_key` resource type](/puppet/3.3/reference/type.html#sshauthorizedkey) to do this, or add keys manually to the `/var/lib/peadmin/.ssh/authorized_keys` file.


The `mco` Command
-----

All orchestration actions are invoked with the `mco` executable. The `mco` command always requires a **subcommand** to invoke actions.

> **Note:** For security, the `mco` command relies on a config file (`/var/lib/peadmin/.mcollective`) which is only readable by the `peadmin` user. PE automatically configures this file; it usually shouldn't be modified by users.

### Subcommands

The `mco` command has several subcommands, and it's possible to add more --- run `mco help` for a list of all available subcommands. The default subcommands in Puppet Enterprise 3.0 are:

**Main subcommand:**

* `rpc`

This is the general purpose orchestration client, which can invoke actions from any MCollective agent plugin.

**Special-purpose subcommands:**

These subcommands only invoke certain kinds of actions but have some extra UI enhancements to make them easier to use than the equivalent `mco rpc` command.

* `puppet`
* `package`
* `service`

**Help and support subcommands:**

These subcommands can display information about the available agent plugins and subcommands.

* `help` --- displays help for subcommands.
* `plugin` --- the `mco plugin doc` command can display help for agent plugins.
* `completion` --- a helper for shell completion systems.

**Inventory and reporting subcommands:**

These subcommands can retrieve and summarize information from Puppet Enterprise agent nodes.

* `ping` --- pings all matching nodes and reports on response times
* `facts` --- displays a summary of values for a single fact across all systems
* `inventory` --- general reporting tool for nodes, collectives, and subcollectives
* `find` --- like ping, but doesn't report response times

Getting Help on the Command Line
-----

You can get information about **subcommands**, **actions**, and **other plugins** on the command line.

### Subcommand Help

Use one of the following commands to get help for a specific subcommand:

    $ mco help <SUBCOMMAND>
    $ mco <SUBCOMMAND> --help

### List of Plugins

To get a list of the available plugins, which includes MCollective agent plugins, data query plugins, discovery methods, and validator plugins, run `mco plugin doc`.

### Agent Plugin Help

Related orchestration **actions** are bundled together in **MCollective agent plugins**. (Puppet-related actions are all in the `puppet` plugin, etc.)

To get detailed info on a given plugin's **actions** and their required **inputs**, run:

    $ mco plugin doc <PLUGIN>

If there is also a **data plugin** with the same name, you may need to prepend `agent/` to the plugin name to disambiguate:

    $ mco plugin doc agent/<PLUGIN>

Invoking Actions
-----

[actions]: ./orchestration_actions.html

Orchestration actions are invoked with either the general purpose `rpc` subcommand or one of the special-purpose subcommands. Note that _unless you specify a filter,_ orchestration commands will be run on **every server in your Puppet Enterprise deployment**; make sure you know what will happen before confirming any potentially disruptive commands. For more info on filters, [see "Filtering Actions" below.](#filtering-actions)

### The `rpc` Subcommand

The most useful subcommand is `mco rpc`. This is **the general purpose orchestration client**, which can invoke actions from **any** MCollective agent plugin. [See "List of Built-In Actions" for more information about agent plugins.][actions]

**Example:**

    $ mco rpc service restart service=httpd

The general form of an `mco rpc` command is:

    $ mco rpc <AGENT PLUGIN> <ACTION> <INPUT>=<VALUE>

For a list of available agent plugins, actions, and their required inputs, see ["List of Built-In Actions"][actions] or [the "Getting Help" header above](#getting-help-on-the-command-line).

### Special-Purpose Subcommands

Although `mco rpc` can invoke any action, sometimes a special-purpose application can provide a more convenient interface.

> **Example:**
>
>     $ mco puppet runall 5
>
> The `puppet` subcommand's special `runall` action is able to run many nodes without exceeding a certain load of concurrent runs. It does this by repeatedly invoking the `puppet` agent's `status` action, and only sending a `runonce` action to the next node if there's enough room in the concurrency limit.
>
> This uses the same actions that the `mco rpc` command can invoke, but since `rpc` doesn't know that the output of the `status` action is relevant to the timing of the `runonce` action, it can't provide that improved UI.

Each special-purpose subcommand (`puppet`, `service`, and `package`) has its own CLI syntax. For example, `mco service` puts the name of the service before the action to mimic the format of the more common platform-specific service commands:

    $ mco service httpd status

Run `mco help <SUBCOMMAND>` to get specific help for each subcommand.


Filtering Actions
-----

By default, orchestration actions affect **all** PE nodes. You can limit any action to a smaller set of nodes by specifying a **filter.**

    $ mco service pe-httpd status --with-fact fact_is_puppetconsole=true

> **Note:** For more details about filters, see the following pages from the MCollective docs:
>
> * [MCollective CLI Usage: Filters](/mcollective/reference/basic/basic_cli_usage.html#selecting-request-targets-using-filters)
> * [Filtering](/mcollective/reference/ui/filters.html)

All command line orchestration actions can accept the same filter options, which are listed under the "Host Filters" section of any `mco help <SUBCOMMAND>` text:

    Host Filters
        -W, --with FILTER                Combined classes and facts filter
        -S, --select FILTER              Compound filter combining facts and classes
        -F, --wf, --with-fact fact=val   Match hosts with a certain fact
        -C, --wc, --with-class CLASS     Match hosts with a certain config management class
        -A, --wa, --with-agent AGENT     Match hosts with a certain agent
        -I, --wi, --with-identity IDENT  Match hosts with a certain configured identity

Each type of filter lets you specify a type of metadata and a desired value. The orchestration action will only run on nodes where that data has that desired value.

Any number of fact, class, and agent filters can also be combined in a single command; this will make it so nodes must match _every_ filter to run the action.

### Matching Strings and Regular Expressions

Filter values are usually simple strings. These must match _exactly_, and are case-sensitive.

Most filters can also accept regular expressions as their values; these are surrounded by forward slashes and are interpreted as [standard Ruby regular expressions](http://www.ruby-doc.org/core/Regexp.html). (You can even turn on various options for a subpattern, such as case insensitivity --- `-F "osfamily=/(?i:redhat)/"`.) Unlike plain strings, they accept partial matches.

### Filtering by Identity

A node's "identity" is the same as its Puppet certname, [as specified during installation][install_certname]. Identities will almost always be unique per node.

    $ mco puppet runonce -I web3balancer.example.com

* You can use the `-I` or `--with-identity` option multiple times to create a filter that matches multiple specific nodes.
* You cannot combine the identity filter with other filter types.
* The identity filter accepts regular expressions.

### Filtering by Fact, Class, and Agent

* **Facts** are the standard Puppet Enterprise facts, which are available in your Puppet manifests and can be [viewed as inventory information][console_inventory] in the PE console. [A list of the core facts is available here.][core_facts] Use the `-F` or `--with-fact` option with a `fact=value` pair to filter on facts.
* **Classes** are the Puppet classes that are assigned to a node. This includes classes assigned in the console, assigned via Hiera, declared in `site.pp`, or declared indirectly by another class. Use the `-C` or `--with-class` option with a class name to filter on classes.
* **Agents** are MCollective agent plugins. Puppet Enterprise's default plugins are available on every node, so filtering by agent makes more sense if you are distributing custom plugins to only a subset of your nodes. For example, if you made an emergency change to a custom plugin that you distribute with Puppet, you could filter by agent to trigger an immediate Puppet run on all affected systems. (`mco puppet runall 5 -A my_agent`) Use the `-A` or `--with-agent` option to filter on agents.

Since mixing classes and facts is so common, you can also use the `-W` or `--with` option to supply a mixture of class names and `fact=value` pairs.

### Compound "Select" Filters

The `-S` or `--select` option accepts arbitrarily complex filters. Like `-W`, it can accept a mixture of class names and `fact=value` pairs, but it has two extra tricks:

#### Boolean Logic

The `-W` filter always combines facts and classes with "and" logic --- nodes must match all of the criteria to match the filter.

The `-S` filter lets you combine values with nested Boolean "and"/"or"/"not" logic:

    $ mco service httpd restart -S "((customer=acme and osfamily=RedHat) or domain=acme.com) and /apache/"

#### Data Plugins

In addition, the `-S` filter lets you use **data plugin queries** as an additional kind of metadata.

Data plugins can be tricky, but are very powerful. To use them effectively, you must:

1. Check the list of data plugins with `mco plugin doc`.
2. Read the help for the data plugin you want to use, with `mco plugin doc data/<NAME>`. Note any required _input_ and the available _outputs._
3. Use the `rpcutil` plugin's `get_data` action on a single node to check the format of the output you're interested in. This action requires `source` (the plugin name) and `query` (the input) arguments:

        $ mco rpc rpcutil get_data source="fstat" query="/etc/hosts" -I web01

    This will show all of the outputs for that plugin and input on that node.
4. Construct a query fragment of the format `<PLUGIN>('<INPUT>').<OUTPUT>=<VALUE>` --- note the parentheses, the fact that the input must be in quotes, the `.output` notation, and the equals sign. Make sure the value you're searching for matches the expected format, which you saw when you did your test query.
5. Use that fragment as part of a `-S` filter:

        $ mco find -S "fstat('/etc/hosts').md5=/baa3772104/ and osfamily=RedHat"

You can specify multiple data plugin query fragments per `-S` filter.

> The MCollective documentation includes a page on [writing custom data plugins.](/mcollective/reference/plugins/data.html) Installing custom data plugins is similar to installing custom agent plugins; see [Adding New Actions](./orchestration_adding_actions.html) for details.

### Testing Filters With `mco find`

Before invoking any potentially disruptive action, like a service restart, you should test the filter with `mco find` or `mco ping` to make sure your command will act on the nodes you expect.


Batching and Limiting Actions
-----

By default, orchestration actions run **simultaneously** on all of the targeted nodes. This is fast and powerful, but is sometimes not what you want:

* Sometimes you want the option to cancel out of an action with control-C before all nodes have run it.
* Sometimes, like when retrieving inventory data, you want to run a command on just a sample of nodes and don't need to see the results from everything that matches the filter.
* Certain actions may consume limited capacity on a shared resource (such as the puppet master server), and invoking them on a "thundering herd" of nodes can disrupt that resource.

In these cases, you can **batch** actions to run all of the matching nodes in a controlled series, or **limit** them to run only a subset of the matching nodes.


### Batching

* Use the `--batch <SIZE>` option to invoke an orchestration action on only `<SIZE>` nodes at once. PE will invoke it on the first `<SIZE>` nodes, wait briefly, invoke it on the next batch, and so on.
* Use the `--batch-sleep <SECONDS>` option to control how long PE should sleep between batches.

### Limiting

* Use the `--limit <COUNT>` option to invoke an action on only `<COUNT>` matching nodes. `<COUNT>` can be an absolute number or a percentage. The nodes will be chosen randomly.
* Use the `-1` or `--one` option to invoke an action on just one matching node, chosen randomly.

* * *

- [Next: Controlling Puppet](./orchestration_puppet.html)
