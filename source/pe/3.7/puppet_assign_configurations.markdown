---
layout: default
title: "PE 3.7 » Puppet » Assigning Configurations to Nodes"
subtitle: "Puppet: Assigning Configurations to Nodes"
canonical: "/pe/latest/puppet_assign_configurations.html"
---

[data_small]: images/puppet/pe-configuration-data-small.png
[data]: images/puppet/pe-configuration-data.png
[lang_params]: /puppet/3.6/reference/lang_classes.html#class-parameters-and-variables
[topscope]: /puppet/3.7/reference/lang_scope.html#top-scope
[node_definitions]: /puppet/3.7/reference/lang_node_definitions.html
[node_inheritance]: /puppet/3.7/reference/lang_node_definitions.html#inheritance
[resource_declarations]: /puppet/3.7/reference/lang_resources.html
[agent_cron]: ./puppet_overview.html#run-from-cron
[classes]: /puppet/3.7/reference/lang_classes.html
[include]: /puppet/3.7/reference/lang_classes.html#using-include
[resource_like]: /puppet/3.7/reference/lang_classes.html#using-resource-like-declarations
[hiera_params]: #assigning-class-parameters-with-hiera
[variable_assign]: /puppet/3.7/reference/lang_variables.html
[functions]: /puppet/3.7/reference/lang_functions.html
[selectors]: /puppet/3.7/reference/lang_conditional.html#selectors
[node_scope]: /puppet/3.7/reference/lang_scope.html#node-scope
[puppetdb_query]: https://forge.puppetlabs.com/dalen/puppetdbquery
[custom_functions]: /guides/custom_functions.html
[hash]: /puppet/3.7/reference/lang_datatypes.html#hashes
[console_add]: ./console_classes_groups.html#classes
[console_assign]: ./console_classes_groups.html#assigning-classes-and-groups-to-nodes
[console_params]: ./console_classes_groups.html#setting-class-parameters
[console_vars]: ./console_classes_groups.html#setting-variables
[enc]: /guides/external_nodes.html
[rake_api]: ./console_rake_api.html
[console_auth]: ./rbac_intro.html
[console_classes]: ./console_classes_groups.html
[forge]: https://forge.puppetlabs.com
[import]: /puppet/3.7/reference/lang_import.html
[hiera_config]: /hiera/1/configuring.html
[hiera_hierarchies]: /hiera/1/hierarchy.html
[core_facts]: /facter/2.2/core_facts.html
[p3_special_vars]: /puppet/3.7/reference/lang_variables.html#facts-and-built-in-variables
[custom_facts]: /guides/custom_facts.html
[hiera_sources]: /hiera/1/data_sources.html
[hiera_cli]: /hiera/1/command_line.html
[hiera_classes]: /hiera/1/puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude
[hiera_array]: /hiera/1/lookup_types.html#array-merge
[hiera_autoparams]: /hiera/1/puppet.html#automatic-parameter-lookup
[hiera_functions]: /hiera/1/puppet.html#hiera-lookup-functions
[dunn]: http://www.craigdunn.org/2012/05/239/
[include_like]: /puppet/3.7/reference/lang_classes.html#include-like-vs-resource-like
[hiera_priority]: /hiera/1/lookup_types.html#priority-default
[data_type]: /puppet/3.7/reference/lang_datatypes.html
[site_pp_vars]: #assigning-variables-with-sitepp
[hiera_arbitrary]: #providing-arbitrary-data
[exported]: /puppet/3.7/reference/lang_exported.html
[site_pp_other_data]: #working-with-other-data-sources
[role_profile_params]: #assigning-class-parameters-with-role-and-profile-modules
[facts]: /puppet/3.7/reference/lang_variables.html#facts-and-built-in-variables
[plugins_in_modules]: /guides/plugins_in_modules.html
[external_facts]: /guides/custom_facts.html#external-facts
[rest_api]: ./nc_index.html


Summary
-----

As we've established, **classes** are named chunks of Puppet code that generally manage a fairly limited piece of configuration. Classes can be assigned directly to nodes.

Each node's complete configuration will be composed of many classes. Puppet Enterprise (PE) provides several facilities for choosing which classes will be assigned to which nodes, as well as for configuring those classes. This page describes the basic concepts of assigning and configuring classes, and details each available source of class and configuration data in PE.

You can also read more about classes in [Puppet Modules and Manifests](./puppet_modules_manifests.html) and [Puppet Overview](./puppet_overview.html).

Basics of Assigning and Configuring Classes
-----

### Assigning Classes

_Assigning_ a class to a node (also called _declaring_ a class, when it's done in a Puppet manifest) causes Puppet to evaluate the resources in that class and add them to that node's configuration catalog.

Before you can assign a class, it must first be available to the Puppet master. This means it must be present in an installed module.

Puppet Enterprise has several methods for assigning classes; these are described in the section on **data sources** below.

### Configuring Classes

Some classes can be assigned with no configuration, but many classes can (or must) be configured to change their behavior. This gives a class the flexibility to meet different needs for different nodes and different infrastructures.

There are two main ways to configure classes in Puppet: using **class parameters** and/or **top-scope variables.** Each module's author dictates which method to use; see the documentation of the classes you are using for local details.

If you are using a diverse set of modules written by many authors, you will likely need to use a mixture of these two methods.

### Class Parameters

Class parameters are a way for classes to explicitly ask for configuration data; see [the Puppet language reference page on classes][lang_params] for more details. Each parameter for a class can be marked as optional or mandatory by the class's author.

Class parameters can be set in the PE Console, Hiera, site.pp, and role/profile modules. In all of these sources except Hiera,
you must make sure that all parameters for a given class **only come from one data source.**  Class parameters from Hiera can co-exist with parameters from one other data source, although in the event of a conflict the other source will override the Hiera values.

Depending on which data sources you use, class parameters may be linked to the place where the class is assigned, or may be specified elsewhere.


### Top-Scope Variables

Instead of defining class parameters, classes may also look up [top-scope][topscope] Puppet variables and use their values as configuration. In older versions of Puppet (0.25 and earlier), this was the only way to configure classes, and it remained more convenient for several more versions. You will still encounter some classes written to use top-scope variables as configuration.

Classes written this way should clearly state which variables to set in their documentation.

Top-scope variables can be set in the PE console, site.pp, and the Puppet agent (in the form of facts). You must make sure that any given variable will **only come from one data source.**

The site.pp file is in a unique position, as it can convert arbitrary data from Hiera, PuppetDB, or an external CMDB into top-scope variables.

Variables to configure a class may come from the place where the class is assigned, or may come from elsewhere.

Data Sources in Puppet Enterprise
-----

In PE, Puppet will use the following **data sources** to configure classes and assign them to nodes:

[ ![The configuration data sources available in Puppet Enterprise][data_small] ][data]

(Click to enlarge.)

> #### Accessibility Note: Description of Diagram
>
> The diagram above shows seven different data sources providing varying kinds of data to the Puppet master. Clockwise from the upper left:
>
> 1. [site.pp (site manifest)](#assigning-configuration-data-with-the-site-manifest-sitepp). Can assign **classes, class parameters,** and **variables.** It is unique in that it can also declare resources outside any class.
> 2. [Hiera](#assigning-configuration-data-with-hiera), which is composed of several levels of hierarchical data sources. Can assign **classes** and **class parameters,** and provide **arbitrary data.**
> 3. [The PE Console](#assigning-configuration-data-with-the-pe-console), which is composed of nodes and groups. Can assign **classes, class parameters**, and **variables.**
> 4. [PuppetDB](#querying-puppetdb-for-supplementary-configuration-data). Can provide **exported resources** and **generated data** (via functions).
> 5. [External CMDB](#querying-an-external-cmdb-for-supplementary-configuration-data) (shown as a cloud to indicate that it is optional and Puppet Enterprise knows nothing about it). Can provide **arbitrary data** (via functions).
> 6. [Puppet agent](#using-puppet-agents-facts-as-hints-for-configuration-data). Can provide facts, which are assigned as top-scope **variables.**
> 7. Puppet modules, which include [two special sub-elements labeled "roles" and "profiles."](#assigning-configuration-data-with-role-and-profile-modules) The set of modules as a whole provides the set of **available classes** which can be assigned by other data sources. The role and profile modules can assign **classes** and **class parameters**.


In this diagram, we can distinguish between two kinds of data sources:

Primary Data Sources                             | Assisting Data Sources
-------------------------------------------------|-----------------------------------------------
PE console, site.pp, Hiera, role/profile modules | Puppet agent (facts), PuppetDB, external CMDBs

* The **primary data sources** can directly assign classes and configuration data to a node; you will use some combination of them to control what configurations your nodes will receive.
* The **assisting data sources** provide other kinds of data. This data can be used directly by modules, or used by a primary data source to help assign configuration data to nodes.

The remainder of  this page describes in detail each of the data sources available to PE. Most users should choose a few primary data sources based on their deployment's needs. To understand the benefits and drawbacks, read the "characteristics" and "recommendations" sections for each data source.

[↑ Back to top](#content)

Assigning Configuration Data with the Site Manifest (site.pp)
-----

### Characteristics

The site manifest (`/etc/puppetlabs/puppet/manifests/site.pp` on the Puppet master server) is a primary data source. It can:

* Assign classes
* Configure classes with parameters
* Configure classes with top-scope (and node-scope) variables
* Convert arbitrary data from other sources into class parameters or variables
* Declare lone resources, outside any class

Site.pp is a normal manifest written in the Puppet language, and is the entry point for the Puppet master server --- catalog compilation always starts with this file. It's the original Puppet data source, predating nearly everything else about Puppet, and it remains very useful for certain use cases.

Site.pp should be managed with version control and deployed to the Puppet master server using a controlled release process. Access to configuration data in site.pp is managed by your organization's specific version control and code deployment procedures.

> ### Recommendations
>
> In general, using site.pp as your only data source is not recommended. Node definitions lack flexibility and can have hidden pitfalls, so users with a reasonably complex deployment should put most of their effort into Hiera or role/profile modules.

### Node Definitions

Site.pp can use [node definitions][node_definitions] (also called node statements) to restrict blocks of Puppet code to a specific node or set of nodes.

{% highlight ruby %}
    node 'web01.example.com' {
      # ...arbitrary puppet code
    }
{% endhighlight %}

* Puppet code **outside** any node definition will be applied to **every** node.
* Puppet code **inside** a node definition will only be applied to nodes that **match** that definition.

Node definitions were Puppet's original way to assign classes to specific nodes, and they remain useful for deployments that are small or have mostly homogeneous groups of systems. See [the node definitions page in the Puppet 3 language reference][node_definitions] for complete details about their syntax and behavior.

In particular, note that if you have **any** node definitions in site.pp, you must also have a node definition named `default`, even if it has nothing in it.

Site.pp can also [import other files][import], as in the common `import nodes/*.pp` pattern --- this will behave as though the code in the imported files was in site.pp.

> **Warning:** Don't attempt to use [node inheritance][node_inheritance] to create hierarchical overrides of class configuration. Derived node definitions can _add classes_ to their parent node, but cannot _reconfigure classes_ (by changing variables or class parameters) that were declared in their parent node.
>
> To set up hierarchical overrides of class configuration, use some combination of Hiera, role/profile modules, and the PE console.

### Assigning Classes With Site.pp

To assign classes in site.pp, use Puppet's standard methods for declaring classes:

- The [`include`][include] function
- [Resource-like class declarations][resource_like]

Declaring a class **outside** any node definition will assign it to every node; declaring it **inside** a node definition will assign it to nodes that match that definition.

Note that in PE 3, you can declare any class with `include` as long as you [use Hiera to assign any mandatory class parameters][hiera_params].

### Assigning Class Parameters With Site.pp

To assign class parameters in site.pp, you **must** use a [resource-like class declaration][resource_like] (either inside or outside a node definition) to assign the class. You **cannot** use site.pp to assign class parameters to classes assigned by another data source.

You **must** make sure that the class is not declared or assigned anywhere else --- with the `include` function, another resource-like declaration, or via Hiera or the PE console. If you get "duplicate declaration" errors, this can mean a class was declared with a resource-like declaration and also assigned by some other data source.

If you declare a class in site.pp _without_ setting its parameters, you can [assign its parameters via Hiera][hiera_params].

### Assigning Variables With Site.pp

Use normal [variable assignment statements][variable_assign] to set variables in site.pp. You can set variables to literal values, or use [functions][] or [selectors][] to make their values dynamic per node. By using functions that query another data source like Hiera, PuppetDB, or an external CMDB, you can convert arbitrary data into top-scope variables.

#### At Top Scope

Variables assigned outside any node definition will exist at true top scope for all nodes.

#### At Node Scope

Variables assigned inside a node definition will exist at [node scope][node_scope], and only for the node(s) that match that definition. Node scope is similar to top scope but has some limitations:

- You cannot use the fully qualified `$::variable` notation to ensure you get the top-scope value; instead, you must always refer to such variables with the local `$variable` notation.
- Node scope variables will be accessible to the following classes:
    - Classes assigned **within that node scope** (Note that if you are using [node inheritance][node_inheritance], classes assigned in the parent node cannot receive variables set by the child node.)
    - Classes assigned **by the PE console**
    - Classes assigned via Hiera, **as long as the `hiera_include` function is used within that node definition** instead of outside any node definition
    - Classes assigned in role/profile modules, as long as the outermost class is declared **within that node scope,** **by the PE console,** or **via `hiera_include` within that node scope**

These node scope complexities are why we do not recommend using node definitions as your primary source of configuration data.

### Working With Other Data Sources

The Puppet code in site.pp can access data from several other data sources and turn it into class parameters, variables, or a list of classes to declare.

- If you are using Hiera to assign classes, you should put a `hiera_include('classes')` statement in site.pp outside any node definition.
- The `hiera`, `hiera_array`, and `hiera_hash` functions can retrieve arbitrary data from Hiera. You can use these function calls directly as class parameters, or assign their values to variables.
- The [PuppetDB query functions][puppetdb_query] can search for data generated by other nodes in your infrastructure --- retrieving, for example, the IP addresses of every server that has the `profile::db_master` class. You can use these function calls directly as class parameters, or assign their values to variables.
- If you use an external CMDB of some kind, you can [write custom functions][custom_functions] to access its data.

  For systems where lookups are fast and cheap, you can call your function directly in class parameters, or assign the value of a function call to a variable. For systems where lookups are slow and resource-intensive, you may wish to only call a lookup once, store a large [hash][] of data in a variable, and access members of that stored hash to assign class parameters and other variables.

### Lone Resources

Unlike most other data sources, site.pp allows you to declare individual resources outside any class. Simply [use normal resource declarations][resource_declarations] outside any node definition, and those resources will be managed on every node in the deployment. Resources inside a node definition will only be managed on the node(s) that match it.

This is mostly useful for resources used to manage Puppet itself, such as a main filebucket or a [Puppet agent cron job][agent_cron]. Other resources should generally go in [classes][].



[↑ Back to top](#content)

* * *

Assigning Configuration Data with the PE Console
-----

### Characteristics

The PE console is a primary data source. It can:

* Use rules to assign classes to nodes
* Configure classes with parameters
* Configure node groups with top-scope variables

The console uses the [external node classifier (ENC) interface][enc] to pass configuration data to Puppet. You can set the console's data by:

* using the graphical user interface
* using [a Rake-based command-line interface][rake_api]
* using the [REST API][rest_api]

Access to configuration data in the console is managed by [the RBAC service][console_auth].

> * For details on assigning classes, parameters, and variables to nodes and groups, see the [Grouping and Classifying Nodes][console_classes] page.

> ### Recommendations
>
> Large sites with well-constructed roles and profiles modules can use the console to assign role classes to nodes. This allows you to use richer tools to build abstract machine descriptions, and more visible tools to assign those descriptions to real machines.

### Nodes and Groups

The console uses *node groups* as its main construct for hierarchical configuration. Nodes can be members of any number of node groups. They inherit the classes and variables from all of their parent node groups, and can override or add to them. Node groups can also have parent node groups, creating chains of hierarchy.

If two (non-chained) node groups have conflicting data, the console has no method for resolving the conflict. The user must ensure that the console has clean classification data with no conflicts.

### Assigning Classes With the Console

In the console, classes are added to node groups. They are then assigned to nodes by creating rules that include a node in the node group's list of matching nodes. You must add a class to the console's list of known classes before you can assign it.

See the [node classification pages](./console_classes_groups.html) for details on assigning classes with the console.

Classes assigned by the node classifier are able to access all top-scope variables from site.pp, as well as top-scope variables from the console.

### Assigning Class Parameters With the Console

You can assign class parameters to a node group. In the group that you want to edit, click **Classes**. Click the Parameter name drop-down list under the appropriate class and select the parameter to add. The drop-down list shows all of the parameters that are available in the node group’s environment.

* See [the Setting Class Parameters section][console_params] of the node classification pages for details.

### Assigning Variables With the Console

You can assign top-scope variables to a node group. These variables will be available to all classes, whether assigned by the node classifier or by any other data source.

* See [the Setting Variables section][console_vars] of the node classification pages for details.


[↑ Back to top](#content)

* * *

Assigning Configuration Data with Hiera
-----

### Characteristics

Hiera is a primary data source. It can:

* Assign classes (with use of `hiera_include` in site.pp)
* Configure classes with parameters
* Provide arbitrary data (accessible from modules or site.pp via lookup functions)

Unlike the PE console, Hiera isn't immediately usable upon install; you must first configure Hiera and its internal data sources ([see below](#configuring-hiera)).

Hiera lets you construct a dynamic hierarchy, which gets resolved for each agent node based on the facts it submits. This allows you to specify configuration data at several levels of the hierarchy, making it easy to maintain default configurations with multiple overrides where necessary.

Hiera's data should be managed with version control and deployed to the Puppet master server using a controlled release process. Access to configuration data in Hiera is managed by your organization’s specific version control and code deployment procedures.

> ### Recommendations
>
> Hiera is one of the most flexible data sources available to PE, and can be very helpful when managing large and complex infrastructures. Puppet Labs recommends that anyone planning a serious PE deployment use Hiera, role/profile modules, or some combination of the two as their main data source. The ability to define a site-appropriate hierarchy lets you set configuration data in a highly automated way with less repetition than some of the other options, and the fact that the data can be managed in version control fits current best practices for critical infrastructure.
>
> The primary drawbacks with the current version of Hiera are:
>
> * The data can be somewhat distant from the places where it takes effect, which can make it more difficult to track the configurations any given node will receive.
> * It's easy to create unwieldy and hard-to-maintain hierarchies if you aren't careful about your architecture.
> * [Checking Hiera data for a node from the command line][hiera_cli] isn't as easy as it could be, since you must manually pass facts to the `hiera` utility to accurately check what data a node will receive.
>
> Please be aware of these pitfalls when organizing your PE data --- keep your hierarchies as simple as you can, and think hard before adding new levels to the hierarchy.

### Configuring Hiera

In order to use Hiera, you must do the following:

#### Edit Hiera.yaml

Edit the `/etc/puppetlabs/puppet/hiera.yaml` file on your Puppet master server, and make the following changes. For complete documentation about this file, see [the Configuring Hiera page][hiera_config] and [the Hierarchies page][hiera_hierarchies] in the Hiera documentation.

1. Choose a main data backend --- YAML or JSON --- and configure it in [the `:backends` setting](/hiera/1/configuring.html#backends).
2. Choose a data directory for your Hiera data source files, and configure it in [the `:datadir` sub-setting](/hiera/1/configuring.html#yaml-and-json) under the `yaml` or `json` settings:

        :yaml:
          :datadir: /etc/puppetlabs/puppet/hieradata

    The datadir will default to `/var/lib/hiera`; the PE installer doesn't create this directory automatically. Ensure that the datadir exists.
3. Create a hierarchy that will work for your site, and configure it in [the `:hierarchy` setting](/hiera/1/configuring.html#hierarchy). See [the Hierarchies page][hiera_hierarchies] in the Hiera documentation for details on effective hierarchies, and [the Core Facts reference][core_facts] and [list of special variables][p3_special_vars] for a list of common facts and variables that may be useful in your hierarchy. If you need some form of classification that isn't included there, you can [write custom facts][custom_facts].

#### Create Hiera Data Sources as Needed

In the datadir you configured in step 2 above, create yaml or json files to contain the data you'll be assigning. See [the Data Sources page][hiera_sources] of the Hiera documentation for details on creating these files.

Each file will correspond to a _possible value_ for _one level_ of the dynamic hierarchy you created. You do not need to create a data source for every possible value of every level; Hiera will skip missing data sources and jump to the next level of the hierarchy. You only need to create the data sources that you care about most.

### Assigning Classes With Hiera

* For complete details about assigning classes with Hiera, see [the Assigning Classes section][hiera_classes] of the "Using Hiera with Puppet page."

To assign classes with Hiera, you must add a `hiera_include('classes')` statement to your site.pp file, preferably outside any node definition. (The `'classes'` portion is an arbitrary string, but we recommend `'classes'` for clarity.)

Next, in any of your Hiera data sources, create `classes` keys. The value of each of these keys should be an array of class names. Puppet will use [an array merge lookup][hiera_array] to assign the classes from every level of the hierarchy to each node.

See the example in [the above-linked documentation][hiera_classes] for details of how this works in practice.

Any classes assigned with Hiera will be evaluated with [include-like][include_like] behavior. This means that you should be careful to avoid using [resource-like][resource_like] declarations on the same classes elsewhere, but any additional include-like declarations or assignments are safe.

### Assigning Class Parameters With Hiera

* For complete details about assigning class parameters with Hiera, see [the Automatic Parameter Lookup section][hiera_autoparams] on "Using Hiera with Puppet."

Hiera is capable of assigning values for any class parameter. This works for all parameters of classes assigned by any data source.

Class parameters from Hiera always have **second priority:** if a value for a given parameter was specified by another data source (e.g. with a [resource-like declaration][resource_like] or parameters in the PE console), the other data source's value will be used.

To assign class parameters with Hiera, create keys of the format `<CLASS NAME>::<PARAMETER NAME>` in any Hiera data source. The value of the key will be the value assigned to the parameter.

Puppet uses a [priority lookup][hiera_priority] to get class parameter values from Hiera; this means it will only get the value from the most specific Hiera data source, and cannot merge values from all levels of the hierarchy. The value can be of any [data type][data_type]. If you need to do an array merge or hash merge lookup for a certain parameter, you should declare the class in a role or profile class and explicitly set the parameter to a `hiera_array` or `hiera_hash` function call.

### Providing Arbitrary Data

* For complete details about retrieving arbitrary data from Hiera, see [the Hiera Lookup Functions section][hiera_functions] of the "Using Hiera with Puppet."

Any Puppet manifest --- including site.pp and classes in modules --- can use the following functions to retrieve arbitrary data from Hiera:

- `hiera`
- `hiera_array`
- `hiera_hash`

The data retrieved by these functions can be assigned to variables or used directly anywhere a function call is permitted. (Resource attributes, class parameters, etc.)

It is possible for normal classes to use these functions, but this is not recommended --- it ties the class's implementation too firmly to the current tools, which is a bad idea when writing modules that will see public release and can add to your code revision burden when next-generation data tools are introduced.

However, using these functions in site.pp or in role/profile modules is often a very good idea, especially when you need to use array merge or hash merge lookups to get a combined value for a class parameter.

Additionally, some users prefer to use resource-like declarations with an explicit Hiera function call rather than rely on Puppet's automatic Hiera parameter lookup; for pre-built Forge modules with many optional parameters, this can function as site-specific documentation of which parameters are being used and what data must be entered into your Hiera data sources.



[↑ Back to top](#content)

* * *

Assigning Configuration Data with Role and Profile Modules
-----

### Characteristics

Role and profile modules are a primary data source. They can:

* Assign classes
* Configure classes with parameters
* Convert arbitrary data from other sources into class parameters
* Declare lone resources, outside any class

Role and profile modules are simply normal Puppet modules with no special features. What sets them apart is their _intent._ Normal modules are (or at least can be) publicly releasable bundles of code that configure a single technology and can work in a variety of infrastructures. Role and profile modules are private, _site-specific_ code that configure **technology stacks** (profiles) and **complete configurations for categories of nodes** (roles).

For example:

* A normal Apache module would configure the Apache web server and offer many configuration options, not all of which would be used at any given site.
* A **profile** class for a web development stack (let's call it `profile::web_dev`) would declare the `apache` class with verbose debugging turned on and very little performance tuning, as well as the `mysql` and `php` classes.
* A **role** class for a dev server being used to develop someone's storefront application (let's call it `role::mystorefront_dev`) would declare the `profile::web_dev` class, as well as an `apache::vhost` resource to create the appropriate virtual host, a `mysql::db` resource to create a database for the application, a `profile::dev_access` class that configured SSH keys for all of the site's developers, a `profile::firewall::dev` class, and a `profile::base` class that managed basic permissions, NTP, etc. If a server was brought online to serve as a mystorefront dev server, you would assign it only **one** class: the `role::mystorefront_dev` class, which would contain a complete description of that node's configuration.

Since role and profile modules are just normal modules, they must be used in conjunction with some other data source, which will be in charge of assigning the role classes to your actual machines.

> ### Recommendations
>
> Role and profile modules are among the most flexible data sources available to PE. They reflect much of what we currently know about best configuration management practices. Although they're an incomplete solution, they offer a lot of control and can sometimes provide a more _knowable_ source of configuration data than simply keeping everything in Hiera.
>
> Since they support managing lone resources as part of a technology stack or node description, role/profile modules work especially well when using complex modules that rely heavily on defined types, such as the OpenStack modules.
>
> If you are going to use site-specific composition modules, we recommend dividing them into the role/profile pattern as follows:
>
> * **Profiles** configure _technology stacks_ in a site-appropriate way. A given node may have many profile classes included in its role.
> * **Role** classes combine multiple profiles and occasional lone resources to create _complete node descriptions._ A given node will only have one role class assigned to it.
>
> For more details on this pattern, we suggest reading [Craig Dunn's roles and profiles post][dunn].


### Assigning Classes With Role and Profile Modules

To assign classes in a role or profile class, use Puppet's standard methods for declaring classes:

- The [`include`][include] function
- [Resource-like class declarations][resource_like]

Note that in PE 3, you can declare any class with `include` as long as you [use Hiera to assign any mandatory class parameters][hiera_params].

### Assigning Class Parameters With Role and Profile Modules

To assign class parameters in a role or profile class, you **must** use a [resource-like class declaration][resource_like] to assign the class. You **cannot** use role or profile classes to assign class parameters to classes that were already assigned by another data source.

You **must** make sure that the class is not declared or assigned anywhere else --- with the `include` function, another resource-like declaration, or via Hiera or the PE console. If you get "duplicate declaration" errors, this can mean a class was declared with a resource-like declaration and also assigned by some other data source.

If you declare a class in a role or profile class _without_ setting its parameters, you can [assign its parameters via Hiera][hiera_params].

Role and profile modules are an ideal place to convert data from an assisting data source (such as PuppetDB, an external CMDB, or Hiera when retrieving arbitrary data) into class parameters. You can use function calls that get data from an external source as the value of any class parameter in a role or profile class --- this allows you to compose multiple data sources into a complete configuration in a knowable and centrally documented way.

### Dealing with Classes that Require Top-Scope Variables

Role and profile modules work best with modern Puppet classes that use class parameters for configuration. However, you may find yourself using classes that require top-scope variables for configuration. Since role and profile modules cannot set top-scope variables, you will need to set them in either [the PE console][console_vars] or [site.pp][site_pp_vars].

If the variables you need don't vary much per node, you can probably manage them in the console. If they will vary widely across your deployment, you should store the data in Hiera and [use Hiera function calls][hiera_arbitrary] to assign variables in site.pp outside any node definition. This will allow you to use detailed hierarchies to determine which values should go to which nodes, without having to wrestle with node scope.

### Lone Resources

Unlike most other data sources, role and profile modules allow you to declare individual resources outside any class. Simply [use normal resource declarations][resource_declarations].

This is particularly useful for complex defined resource types as used in places like the OpenStack modules. It is also useful for simpler defined resource types that are meant to manage _site-specific_ configuration (such as virtual hosts, firewall rules, etc.).



[↑ Back to top](#content)

* * *

Querying PuppetDB for Supplementary Configuration Data
-----

Classes in modules can use [exported resources][exported] to collect information from other nodes; this can work well for things like monitoring, where a service's class can export a resource describing how to monitor the service. However, there are other forms of cross-node data that aren't a great match for exported resources, such as collecting IP addresses of systems running a service and adding them to a whitelist for a second service.

For cases like these, you can use [Eric Dalén's puppetdbquery module][puppetdb_query], which has custom functions for searching PuppetDB. See the module's documentation for details about these functions.

[↑ Back to top](#content)

* * *

Querying an External CMDB for Supplementary Configuration Data
-----

If you use some form of CMDB at your site, you can use its data with Puppet.

To do this, you will need a [Puppet function][functions] that can query your CMDB. It's worth [checking the Puppet Forge][forge] to see if anyone has written a module to interface with your particular CMDB, but most likely you will have to [write a custom function][custom_functions]. This is relatively easy and requires only a small amount of Ruby.

Once you have a function that can query your CMDB, you can [use it in site.pp][site_pp_other_data] or [in role or profile modules][role_profile_params]. For systems where lookups are fast and cheap, you can call your function directly in class parameters, or assign the value of a function call to a variable. For systems where lookups are slow and resource-intensive, you may wish to only call a lookup once, store a large [hash][] of data in a variable, and access members of that stored hash to assign class parameters and other variables.

[↑ Back to top](#content)

* * *

Using Puppet Agent's Facts as Hints for Configuration Data
-----

When requesting catalogs, agent nodes submit a collection of [facts][], which the Puppet master can use as top-scope variables when compiling the catalog.

One strategy for classifying nodes is to use facts to determine what configuration data should be assigned to the node. This is most often seen with Hiera, which can use facts in its dynamic hierarchy, but you can also use conditional statements in site.pp or role/profile modules to determine which classes to declare and which parameters to assign.

If the [built-in core facts][core_facts] aren't sufficient for classifying your nodes, you can:

* Create [custom facts][custom_facts] and [put them in modules][plugins_in_modules]. Custom facts are small, easy pieces of Ruby code, and are distributed to all nodes.
* Distribute [external facts][external_facts] to your nodes. External facts are either static text files or small scripts.

By pre-seeding new nodes with external facts when you deploy them, it's possible to invert control of node classification --- a node can use a special "role fact" to tell the Puppet master what kind of server it was meant to be, and if the Hiera hierarchy or conditional statements in site.pp support it, the node will receive that configuration.

> **Note:** Facts are not trusted data, and can be spoofed by a rogue agent node. Inverting control can be useful for some deployment processes, but it's generally best to not allow nodes to choose what pieces of sensitive information they will receive. If you're inverting control with role facts, be careful with the types of configuration you allow nodes to request.

* * *

- [Next: Puppet Tools](./puppet_tools.html)
