---
layout: default
title: "Hiera 3: Complete Example"
description: "Learn how to use Hiera to pull site-specific data out of your manifests with this walkthrough."
---

[hiera_lookup]: ./puppet.html#hiera-lookup-functions
[puppet-vmwaretools]: https://github.com/craigwatson/puppet-vmwaretools
[ntp_module]: http://forge.puppetlabs.com/puppetlabs/ntp
[hiera.yaml]: ./configuring.html
[Hiera command line tool]: ./command_line.html
[ntp_init.pp]: https://github.com/puppetlabs/puppetlabs-ntp/blob/master/manifests/init.pp
[template directory]: https://github.com/puppetlabs/puppetlabs-ntp/blob/master/templates
[hiera_datasources]: ./data_sources.html
[hiera_include]: ./puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude
[automatic parameter lookup]: ./puppet.html#automatic-parameter-lookup
[special hash and array lookups]: ./lookup_types.html
[class_parameters]: /puppet/latest/reference/lang_classes.html#class-parameters-and-variables

{% partial /hiera/_hiera_update.md %}

In this example, we'll use the popular [Puppet Labs ntp module][ntp_module], an exemplar of the package/file/service pattern in common use among Puppet users. We'll start simply, using Hiera to provide the ntp module with parameter data based on particular nodes in our organization. Then we'll use Hiera to assign the `ntp` class provided by the module to specific nodes.

##  What Can We Do With Hiera?

Let's get started by looking at the ntp module. It does all of its work in a single `ntp` class, which lives in [the `init.pp` manifest][ntp_init.pp]. The `ntp` class also evaluates some ERB templates stored in the module's [template directory][]. So, what can we do with Hiera?

### Express Organizational Information

The `ntp` class takes five parameters:

- servers
- restrict
- autoupdate
- enable
- template

Most of these parameters reflect decisions we have to make about each of the nodes to which we'd apply the `ntp` class: Can it act as a time server for other hosts? (`restrict`), which servers should it consult? (`servers`), or  should we allow Puppet to automatically update the ntp package or not? (`autoupdate`).

Without Hiera, we might find ourselves adding organizational data to our module code as default parameter values, reducing how shareable it is. We might find ourselves repeating configuration data in our site manifests to cover minor differences in configuration between nodes.

With Hiera, we can move these decisions into a hierarchy built around the facts that drive these decisions, increase sharability, and repeat ourselves less.

### Classify Nodes With Hiera

We can also use Hiera to assign classes to nodes using the [hiera_include][] function, adding a single line to our `site.pp` manifest, then assigning classes to nodes within Hiera instead of within our site manifests. This can be a useful shortcut when we're explicitly assigning classes to specific nodes within Hiera, but it becomes very powerful when we implicitly assign classes based on a node's characteristics. In other words, we'll show you how you don't need to know the name of every VMWare guest in your organization to make sure they all have a current version of VMWare Tools installed.

## Describing Our Environment

For purposes of this walkthrough, we'll assume a situation that looks something like this:

- We have two ntp servers in the organization that are allowed to talk to outside time servers. Other ntp servers get their time data from these two servers.
- One of our primary ntp servers is very cautiously configured --- we can't afford outages, so it's not allowed to automatically update its ntp server package without testing. The other server is more permissively configured.
- We have a number of other ntp servers that will use our two primary servers.
- We have a number of VMWare guest operating systems that need to have VMWare Tools installed.

### Our Environment Before Hiera

How did things look before we decided to use Hiera? Classes are assigned to nodes via the Puppet site manifest (`/etc/puppetlabs/code/environments/production/manifests/sites.pp` for Puppet open source), so here's how our site manifest might have looked:

~~~ ruby
node "kermit.example.com" {
  class { "ntp":
    servers    => [ '0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst','3.us.pool.ntp.org iburst'],
    autoupdate => false,
    restrict   => [],
    enable     => true,
  }
}

node "grover.example.com" {
  class { "ntp":
    servers    => [ 'kermit.example.com','0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst'],
    autoupdate => true,
    restrict   => [],
    enable     => true,
  }
}

node "snuffie.example.com", "bigbird.example.com", "hooper.example.com" {
  class { "ntp":
    servers    => [ 'grover.example.com', 'kermit.example.com'],
    autoupdate => true,
    enable     => true,
  }
}
~~~

## Configuring Hiera and Setting Up the Hierarchy

All Hiera configuration begins with `hiera.yaml`. You can read a [full discussion of this file][hiera.yaml], including where you should put it depending on the version of Puppet you're using.  Here's the one we'll be using for this walkthrough:

~~~ yaml
---
:backends:
  - yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - common
~~~

Step-by-step:

`:backends:` tells Hiera what kind of data sources it should process. In this case, we'll be using YAML files.

`:yaml:` configures the YAML data backend, telling Hiera to look in `/etc/puppetlabs/code/environments/<ENVIRONMENT>/hieradata` for YAML data sources.

`:hierarchy:` configures the data sources Hiera should consult. Puppet users commonly separate their hierarchies into directories to make it easier to get a quick top-level sense of how the hierarchy is put together. In this case, we're keeping it simple:

- A single `nodes/` directory will contain any number of files named after some node's certname, read from the `$trusted['certname']` variable. (E.g., `/etc/puppetlabs/code/environments/production/hieradata/nodes/grover.example.com.yaml`) This lets us specifically configure any given node with Hiera. Not every node needs to have a file in `nodes/` --- if it's not there, Hiera will just move onto the next hierarchy level.
- Next, the `common` data source (the `/etc/puppetlabs/code/environments/production/hieradata/common.yaml` file) will provide any common or default values we want to use when Hiera can't find a match for a given key elsewhere in our hierarchy. In this case, we're going to use it to set common ntp servers and default configuration options for the ntp module.

> **Hierarchy and facts note:** When constructing a hierarchy, keep in mind that most [facts][] are self-reported by each node, which means they're useful but aren't necessarily trustworthy. The special [`$trusted` hash][trusted] and [`$server_facts` hash][server_facts] are the only variables that are verified by the Puppet master.

[facts]: /puppet/latest/reference/lang_facts_and_builtin_vars.html
[trusted]: /puppet/latest/reference/lang_facts_and_builtin_vars.html#trusted-facts
[server_facts]: /puppet/latest/reference/lang_facts_and_builtin_vars.html#serverfacts-variable

> **Puppet master note:** If you modify `hiera.yaml` between agent runs, you'll have to restart your Puppet master for your changes to take effect.

### Configuring for the Command Line

The [Hiera command line tool][] is useful when you're in the process of designing and testing your hierarchy. You can use it to mock in
facts for Hiera to look up without having to go through cumbersome trial-and-error Puppet runs.

This version of Hiera uses the same default config file on the command line as it does via Puppet, so your existing config should already work.

## Writing the Data Sources

Now that we've got Hiera configured, we're ready to return to the ntp module and take a look at the `ntp` class's parameters.

> **Learning About Hiera Data Sources:** This example won't cover all the data types you might want to use, and we're only using one of two built-in data backends (YAML). For a more complete look at data sources, please see our guide to [writing Hiera data sources][hiera_datasources], which includes more complete examples written in JSON and YAML.

### Identifying Parameters

We need to start by figuring out the parameters required by the `ntp` class. So let's look at the [ntp module's `init.pp` manifest][ntp_init.pp], where we see five:

- **servers** --- An array of time servers; `UNSET` by default. Conditional logic in `init.pp` provides a list of ntp servers maintained by the respective maintainers of our module's supported operating systems.
- **restrict** --- An array of restrict directives; different values based on operating system by default
- **autoupdate** --- Whether to update the ntp package automatically or not; `false` by default
- **enable** --- Whether to start the ntp daemon on boot; `true` by default
- **template** --- The name of the template to use to configure the ntp service. This is `undef` by default, and it's configured within the `init.pp` manifest with some conditional logic.


> * [See the Puppet language reference for more about class parameters.][class_parameters]

### Making Decisions and Expressing Them in Hiera

Now that we know the parameters the `ntp` class expects, we can start making decisions about the nodes on our system, then expressing those decisions as Hiera data. Let's start with kermit and grover: The two nodes in our organization that we allow to talk to the outside world for purposes of timekeeping.

#### `kermit.example.com.yaml`

We want one of these two nodes, `kermit.example.com`, to act as the primary organizational time server. We want it to consult outside time servers, we won't want it to update its ntp server package by default, and we definitely want it to launch the ntp service at boot. So let's write that out in YAML, making sure to express our variables as part of the `ntp` namespace to insure Hiera will pick them up as part of its [automatic parameter lookup][].

~~~ yaml
---
ntp::restrict:
  -
ntp::autoupdate: false
ntp::enable: true
ntp::servers:
  - 0.us.pool.ntp.org iburst
  - 1.us.pool.ntp.org iburst
  - 2.us.pool.ntp.org iburst
  - 3.us.pool.ntp.org iburst
~~~

Since we want to provide this data for a specific node, and since we're using the certname to identify unique nodes in our hierarchy, we need to save this data in the `/etc/puppetlabs/code/environments/production/hieradata/nodes` directory as `kermit.example.com.yaml`.

Once you've saved that, let's do a quick test using Puppet apply:

    $ puppet apply --certname=kermit.example.com -e "notice(hiera('ntp::servers'))"

The value You should see this:

    Notice: Scope(Class[main]): ["0.us.pool.ntp.org iburst", "1.us.pool.ntp.org iburst", "2.us.pool.ntp.org iburst", "3.us.pool.ntp.org iburst"]

That's just the array of outside ntp servers and options, which we expressed as a YAML array and which Hiera is converting to a Puppet-like array. The module will use this array when it generates configuration files from its templates.


> **Something Went Wrong?** If, instead, you get `nil`, `false`, or something else completely, you should step back through your Hiera configuration making sure:
>
> - Your `hiera.yaml` file matches the example we provided
> - You've saved your `kermit.example.com` data source file with a `.yaml` extension
> - Your data source file's YAML is well formed
> - You restarted your Puppet master if you modified `hiera.yaml`
{: #something-went-wrong }

Provided everything works and you get back that array of ntp servers, you're ready to configure another node.

#### `grover.example.com.yaml`

Our next ntp node, `grover.example.com`, is a little less critical to our infrastructure than kermit, so we can be a little more permissive with its configuration: It's o.k. if grover's ntp packages are automatically updated. We also want grover to use kermit as its primary ntp server. Let's express that as YAML:

~~~ yaml
---
ntp::restrict:
  -
ntp::autoupdate: true
ntp::enable: true
ntp::servers:
  - kermit.example.com iburst
  - 0.us.pool.ntp.org iburst
  - 1.us.pool.ntp.org iburst
  - 2.us.pool.ntp.org iburst
~~~

As with `kermit.example.com`, we want to save grover's Hiera data source in the `/etc/puppetlabs/code/environments/production/hieradata/nodes` directory using its certname for the file name: `grover.example.com.yaml`. We can once again test it with Puppet apply:

    $ puppet apply --certname=grover.example.com -e "notice(hiera('ntp::servers'))"
    Notice: Scope(Class[main]): ["kermit.example.com iburst", "0.us.pool.ntp.org iburst", "1.us.pool.ntp.org iburst", "2.us.pool.ntp.org iburst"]

#### `common.yaml`

So, now we've configured the two nodes in our organization that we'll allow to update from outside ntp servers. However, we still have a few nodes to account for that also provide ntp services. They depend on kermit and grover to get the correct time, and we don't mind if they update themselves. Let's write that out in YAML:

~~~ yaml
---
ntp::autoupdate: true
ntp::enable: true
ntp::servers:
  - grover.example.com iburst
  - kermit.example.com iburst
~~~

Unlike kermit and grover, for which we had slightly different but node-specific configuration needs, we're comfortable letting any other node that uses the ntp class use this generic configuration data. Rather than creating a node-specific data source for every possible node on our network that might need to use the ntp module, we'll store this data in `/etc/puppetlabs/code/environments/production/hieradata/common.yaml`. With our very simple hierarchy, which so far only looks for the certnames, any node with a certname that doesn't match the nodes we have data sources for will get the data found in `common.yaml`. Let's test against one of those nodes:

    $ puppet apply --certname=snuffie.example.com -e "notice(hiera('ntp::servers'))"
    Notice: Scope(Class[main]): ["kermit.example.com iburst", "grover.example.com iburst"]

#### Modifying Our `site.pp` Manifest

Now that everything has tested out from the command line, it's time to get a little benefit from this work in production.

If you'll remember back to our pre-Hiera configuration, we were declaring a number of parameters for the `ntp` class in our `site.pp` manifest, like this:

~~~ ruby
node "kermit.example.com" {
  class { "ntp":
    servers    => [ '0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst','3.us.pool.ntp.org iburst'],
    autoupdate => false,
    restrict   => [],
    enable     => true,
  }
}
~~~

In fact, we had three separate stanzas of that length. But now that we've moved all of that parameter data into Hiera, we can significantly pare down `site.pp`:

~~~ ruby
node "kermit.example.com", "grover.example.com", "snuffie.example.com" {
  include ntp
  # or:
  # class { "ntp": }
}
~~~

That's it.

Since Hiera is automatically providing the parameter data from the data sources in its hierarchy, we don't need to do anything besides assign the `ntp` class to the nodes and let Hiera's parameter lookups do the rest. In the future, as we change or add nodes that need to use the `ntp` class, we can:

* Quickly copy data source files to cover cases where a node needs a specialized configuration.
* If the new node can work with the generic configuration in `common.yaml`, we can say `include ntp` in our `site.pp` without writing any new Hiera data.
* Since Hiera looks up each parameter individually, we can also write a new YAML file that, for example, only changes `ntp::autoupdate` --- Hiera will get the rest of the parameters from `common.yaml`.

If you're interested in taking things a step further, using the decision-making skills you picked up in this example to choose which nodes even get a particular class, let's keep going.

## Assigning a Class to a Node With Hiera

In the first part of our example, we were concerned with how to use Hiera to provide data to a parameterized class, but we were assigning the classes to nodes in the traditional Puppet way: By making `class` declarations for each node in our `site.pp` manifest. Thanks to the `hiera_include` function, you can assign nodes to a class the same way you can assign values to class parameters: Picking a facter fact on which you want to base a decision, adding to the hierarchy in your `hiera.yaml` file, then writing data sources.

### Using `hiera_include`

Where last we left off, our `site.pp` manifest was looking somewhat spare. With the `hiera_include` function, we can pare things down even further by picking a key to use for classes (we recommend `classes`), then declaring it in our `site.pp` manifest:

~~~ ruby
hiera_include('classes')
~~~

From this point on, you can add or modify an existing Hiera data source to add an array of classes you'd like to assign to matching nodes. In the simplest case, we can visit each of kermit, grover, and snuffie and add this to their YAML data sources in `/etc/puppetlabs/code/environments/production/hieradata/nodes`:

~~~ yaml
"classes" : "ntp",
~~~

modifying kermit's data source, for instance, to look like this:

~~~ yaml
---
classes: ntp
ntp::restrict:
  -
ntp::autoupdate: false
ntp::enable: true
ntp::servers:
  - 0.us.pool.ntp.org iburst
  - 1.us.pool.ntp.org iburst
  - 2.us.pool.ntp.org iburst
  - 3.us.pool.ntp.org iburst
~~~

`hiera_include` requires either a string with a single class, or an array of classes to apply to a given node. Take a look at the "classes" array at the top of our kermit data source to see how we might add three classes to kermit:

~~~ yaml
---
classes:
  - ntp
  - apache
  - postfix
ntp::restrict:
 -
ntp::autoupdate: false
ntp::enable: true
ntp::servers:
  - 0.us.pool.ntp.org iburst
  - 1.us.pool.ntp.org iburst
  - 2.us.pool.ntp.org iburst
  - 3.us.pool.ntp.org iburst
~~~

We can test which classes we've assigned to a given node with the Hiera command line tool:

    $ puppet apply --certname=kermit.example.com -e "notice(hiera('classes'))"
    ["ntp", "apache", "postfix"]

> **Note:** The `hiera_include` function will do an [array merge lookup](./lookup_types.html#array-merge), which can let more specific data sources **add to** common sources instead of **replacing** them. This helps you avoid repeating yourself.

#### Using Facts to Drive Class Assignments

That demonstrates a very simple case for `hiera_include`, where we knew that we wanted to assign a particular class to a specific host by name. But just as we used the `$trusted['certname']` fact to choose which of our nodes received specific parameter values, we can use that or any other fact to drive class assignments. In other words, you can assign classes to nodes based on characteristics that aren't as obvious as their names, creating the possibility of configuring nodes based on more complex characteristics.

Some organizations might choose to make sure all their Macs have Homebrew installed, or assign a `postfix` class to nodes that have a mail server role expressed through a custom fact, or assign a `vmware_tools` class that installs and configures VMWare Tools packages on every host that returns `vmware` as the value for its `virtual` fact.

In fact, let's use that last case for this part of the walkthrough: Installing VMWare Tools on a virtual guest. There's a [puppet-vmwaretools][] module on the Puppet Forge that addresses just this need. It takes two parameters:

- **version** --- The version of VMWare Tools we want to install
- **working_dir** --- The directory into which we want to install VMWare

Two ways we might want to use Hiera to help us organize our use of the class this module provides include making sure it's applied to all our VMWare virtual hosts, and configuring where it's installed depending on the guest operating system for a given virtual host.

So let's take a look at our `hiera.yaml` file and make provisions for two new data sources. We'll create one based on the `virtual` fact, which will return `vmware` when a node is a VMWare-based guest.  We'll create another based on the `osfamily` fact, which returns the general family to which a node's operating system belongs (e.g. "Debian" for Ubuntu and Debian systems, or "RedHat" for RHEL, CentOS, and Fedora systems):

~~~ yaml
---
:backends:
  - yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - "virtual/%{::virtual}"
  - "osfamily/%{::osfamily}"
  - common
~~~

Next, we'll need to create directories for our two new data sources:

    `mkdir /etc/puppetlabs/code/environments/production/hieradata/virtual; mkdir /etc/puppetlabs/code/environments/production/hieradata/osfamily`

In our `virtual` directory, we'll want to create the file `vmware.yaml`. In this data source, we'll be assigning the `vmwaretools` class, so the file will need to look like this:

~~~ yaml
---
classes: vmwaretools
~~~

Next, we need to provide the data for the `vmwaretools` class parameters. We'll assume we have a mix of Red Hat and Debian VMs in use in our organization, and that we want to install VMWare Tools in `/opt/vmware` in our Red Hat VMs, and `/usr/local/vmware` for our Debian VMs.  We'll need `RedHat.yaml` and `Debian.yaml` files in the `/etc/puppetlabs/code/environments/production/hieradata/osfamily` directory.

`RedHat.yaml` should look like this:

~~~ yaml
---
vmwaretools::working_dir: /opt/vmware
~~~

`Debian.yaml` should look like this:

~~~ yaml
---
vmwaretools::working_dir: /usr/local/vmware
~~~

That leaves us with one parameter we haven't covered: the `version` parameter. Since we don't need to vary which version of VMWare Tools any of our VMs are using, we can put that in `common.yaml`, which should now look like this:

~~~ yaml
---
vmwaretools::version: 8.6.5-621624
ntp::autoupdate: true
ntp::enable: true
ntp::servers:
  - grover.example.com iburst
  - kermit.example.com iburst
~~~

Once you've got all that configured, go ahead and test with the Hiera command line tool:

    $ hiera vmwaretools::working_dir osfamily=RedHat
    /opt/vmware

    $ hiera vmwaretools::working_dir osfamily=Debian
    /usr/local/vmware

    $ hiera vmwaretools::version
    8.6.5-621624

    $ hiera classes ::virtual=vmware
    vmwaretools

If everything worked, great. If not, [consult the checklist we provided earlier](#something-went-wrong) and give it another shot.

## Exploring Hiera Further

We hope this walkthrough gave you a good feel for the things you can do with Hiera. There are a few things we didn't touch on, though:

* We didn't discuss how to use Hiera in module manifests, preferring to highlight its ability to provide data to parameterized classes. Hiera also provides a [collection of functions][hiera_lookup] that allow you to use Hiera within a module. Tread carefully here, though: Once you start requiring Hiera for your module to work at all, you're reducing its shareability and potentially closing it off to some users.
* We showed how to conduct priority lookups with Hiera; that is, retrieving data from the hierarchy based on the first match for a given key. This is the only way to use Hiera with parameterized classes, but Hiera's lookup functions include [special hash and array lookups][], allowing you to collect data from sources throughout your hierarchy, or to selectively override your hierarchy's normal precedence. This allows you to declare, for instance, certain base values for all nodes, then layer on additional values for nodes that match differing keys, receiving all the data back as an array or hash.

