---
layout: default
title: "PE 3.8 » Console » Grouping and Classifying Nodes"
subtitle: "Grouping and Classifying Nodes"
canonical: "/pe/latest/console_classes_groups.html"
---


[lang_classes]: /puppet/3.8/reference/lang_classes.html
[learn]: /learning/
[forge]: http://forge.puppetlabs.com
[modules]: /puppet/3.8/reference/modules_fundamentals.html
[topscope]: /puppet/3.8/reference/lang_scope.html#top-scope

To start classifying your nodes, go to the Puppet Enterprise (PE) console and click **Classification**. This takes you to a list of node groups. 

PE comes with the following preconfigured node groups to help you manage your PE infrastructure. To learn more about these preconfigured node groups, see [Preconfigured Node Groups](./console_classes_groups_preconfigured_groups.html). 

   ![viewing list of node groups][all_node_groups]

You should create two different types of node groups in PE: *environment node groups* and *classification node groups*. Environment node groups set the environment that a node should be in. Classification node groups set the classification data that your nodes will receive. You add your classes, parameters, and variables to classification node groups. When your individual nodes match a node group, they receive all of the classification specified for that node group. 

> **Important**
>
> The node classifier uses role-based access control (RBAC) to manage access to tasks. To check your access to the tasks described on this page, see the [RBAC documentation](./rbac_intro.html).

### Creating Environment Node Groups

The only role of an environment node group is to set the environment for your nodes. Environment node groups should **not** contain any classification data.

PE comes with two preconfigured environment node groups: the **Production environment** node group and the **Agent-specified environment** node group.

The **Production environment** comes with a rule that matches all nodes. This ensures that your nodes get the production environment, unless specified otherwise.

The **Agent-specified environment** node group omits the environment specification when the agent reports back to the master for catalog compilation. Use this environment if you need to preserve an agent-specified environment in your installation. For more information, see [The Agent-Specified Environment Node Group](./console_classes_groups_preconfigured_groups.html#the-agent-specified-environment-node-group). 

To create a new environment node group:

1. In the **Node group name** box, enter a name that describes the role of this environment node group, such as "Test environment". 
2. In the **Parent name** box, set the parent to be **Production Environment**. All environment node groups that you add to PE should have the **Production Environment** as the parent. This is important because child groups override the settings specified in parent groups. Child groups match a subset of the nodes that are in the parent group (based on the node matching rules you set), and by setting a new environment (and the **This is an environment group** checkbox in see step 5), you will successfully set an overriding environment for the subset of nodes that match the child group.  
3. In the **Environment** box, specify the environment that you want to enforce for the nodes that match this node group. If you haven’t [set up any environments](/puppet/3.8/reference/environments.html) yet, you will only see the  **production** and **agent-specified** environments in the drop-down list.
4. Click **Add group** to add the environment node group.
5. **This step is very important and should not be skipped.** In the list of node groups, find the new group that you just created and click it. Click **Edit node group metadata**. Select the **This is an environment group** checkbox. The environment will not be enforced unless you select this checkbox.
6. Click the commit button to commit your change.

**Note:** For more information on using environments, see [Working With Environments](./console_classes_groups_environment_override.html).
    
### Creating Classification Node Groups

The role of a classification node group is to assign classification (classes, parameters, and variables) to nodes.

1. To add a new classification node group, in the **Node group name** box in the **Classification** page, enter a name that describes the function of the nodes that match this node group. For example, "web servers."
    
2. In the **Parent name** box, select the name of the classification node group that you want to set as the parent to this node group. Classification node groups inherit classes, parameters, and variables from their parent node group. By default, the parent node group is the **default** node group. 

    Node group inheritance is an important feature in node classification that can save you a lot of time. For example, if you have a class that needs to be assigned to all of a node group’s descendent node groups, then you can assign it once in the parent node group and avoid having to assign it in each descendent node group. For an overview of node group inheritance, see [How Does Inheritance Work?](./console_classes_groups_inheritance.html).
    
3. In the **Environment** box, you can specify an environment for filtering the classes and parameters that are available for selection in this node group. You are not actually setting an environment here, you did that when you [set up the environment node groups](#creating-environment-node-groups). 

    For example, if you want to apply some test classification data to your development web server nodes, you would [add the nodes to your test environment through the environment node group](#creating-environment-node-groups), and then set the test environment here in the classification node group so that only your test classification is available for selection. 

     **Important:** Do not select **This is an environment group**. This option should only be set when you are configuring *environment node groups*. 

4. To finish creating the node group, click **Add Group**.

[Editing Node Groups](./console_classes_groups_making_changes.html#editing-groups)

[Deleting Node Groups](./console_classes_groups_making_changes.html#deleting-groups)


### Adding Nodes to a Node Group
To apply a node group’s environment, classes, parameters, and variables to your nodes, you need to include the node in that node group. There are two ways to add nodes to a node group:

1. Create rules that match node facts (dynamic)

2. Individually pin nodes to the node group (static)


#### Adding Nodes Dynamically
Rules are by far the most powerful and scalable way to include nodes in a node group. You can create rules in a node group that are used to match [node facts](/facter/2.3/core_facts.html). When nodes match the rules in a node group, they are classified with all of the classification data (classes, parameters, and variables) that has been set for the node group.

When nodes no longer match the rules of a node group, the classification data for that node group no longer applies to the node.

> **Note:** Structured facts (arrays and hash map values) are not supported when using the console to enter facts.

**To add a rule:**

1. In the **Classification** page, click **Rules**.

2. Select a **Fact**.

    When you click in the **Fact** field, a list of known facts appears. These are the facts that are stored in [PuppetDB](/puppetdb/2.3/#what-data). They include things like the operating system (`operatingsystem`), the amount of memory (`memorytotal`), and the primary IP address (`ipaddress`).

    > **Tip:** The list of facts uses autosuggest with fuzzy matching. As you type a search string in **Fact**, the list filters to show facts that contain the search string anywhere within the fact name. In other words, if you are looking for `uptime_days`, you can simply type “time.”

3. Specify an **Operator** and **Value** for the fact.

    You can get really specific about the nodes that you want to match by setting **Operator** to **matches regex** or **does not match regex** and specifying a regular expression for **Value**.

    > **Note:** The **greater than**, **greater than or equal to**, **less than**, and **less than or equal to** operators can only be used with facts that have a numeric value.

    Once you have entered the **Fact**, **Operator**, and **Value**, the number of nodes that match your new rule will appear under **Node matches**. This is a great way to confirm that you have specified a valid rule.

    As an example of how you could specify a rule, say that you have set up a **Web Servers** node group and now you want to add all of your web servers to this node group. You can do this by creating a rule similar to:

    &nbsp;&nbsp;&nbsp;"hostname"&nbsp;&nbsp;&nbsp;**matches regex**&nbsp;&nbsp;&nbsp;"web"

    If at any point you change the role of one of the web server nodes and remove “web” from the name, that node no longer matches the rule for being included in the **Web Servers** node group and will no longer be configured with the classes that have been applied by the node group.
    
4. Whenever you make a change in the node classifier, you need to commit the change. At the lower right of the page, click the commit button. 

> **Note**: In the **Rules** tab, there is an option that let’s you select whether your nodes need to match **All** rules before they are added to the node group, or if they should be added when they match **Any** of the rules.

#### Adding Nodes Statically
If you have a node that needs to be in a node group regardless of the rules that have been specified for that node group, you can *pin* the node to the node group. A pinned node is not affected by rules and will remain in the node group until you manually remove it. Adding a pinned node essentially creates the rule `<the certname of your node>` **is** `<the certname>`, and includes this rule along with the other fact-based rules.

**To pin a node to a node group:**

1. In the **Rules** tab, scroll down to the pinned nodes section below the rules.

2. In the **Certname** field, enter the [certname](/references/3.8.latest/configuration.html#certname) of the node.

3. Click **Pin node**, and then click the commit button.

[Removing Nodes From a Node Group](./console_classes_groups_making_changes.html#removing-nodes-from-group)

### Adding Classes to a Node Group

The next thing you’ll want to do is add classes to your node group. [Classes][lang_classes] are the blocks of Puppet code used to configure your nodes and assign resources to them. To add a class to a group, first create the class in a module. You'll then need to install the module.

> #### Creating Puppet Classes
>
> Before you can add a class to a node group, you need to make the class available to the Puppet master. This means that the class must be located in an installed [module][modules]. There are two ways to get modules:
>
> 1. [Download modules from the Puppet Forge][forge]. In addition to the many public modules that are available, the Puppet Forge also provides supported modules and approved modules. Supported modules are rigorously tested with PE and are supported by Puppet Labs via the usual [support channels](http://puppetlabs.com/services/customer-support). Approved modules have passed PuppetLabs quality and reliability standards and are recommended by Puppet Labs for use with PE.
>
> 2. [Write your own classes][lang_classes], and put them in a [module][modules].
>
> **Tip:** If you are new to Puppet and have not written Puppet code before, [follow the Learning Puppet tutorial][learn], which walks you through the basics of Puppet code, classes, and modules.

**To add a class to a node group:**

1. On the **Classification** page, click the node group that you want to add the class to, and then click **Classes**.

2. Under **Add new class**, click the **Class name** field.

   A list of classes appears. These are the classes that the Puppet master knows about and are available in the environment that you have set for the node group. The list filters as you type. Filtering is not limited to the start of a class name, you can also type substrings from anywhere within the class name. Select the class when it appears in the list.

3. Click **Add class** and then click the commit button.

> **Note:** If you created a new class within the last three minutes, it may not appear in the list of available classes yet. There are two things that need to happen before the class appears in the list:
>
> 1. The node classifier needs to retrieve classes from the master. (By default, the node classifier retrieves classes from the master every 3 minutes. To change the default setting, see [Configuring and Tuning the Console](./console_config.html#tuning-the-classifier-synchronization-period)).
>
> 2. The [environment cache needs to refresh](/references/latest/configuration.html#environmenttimeout). (By default, the environment cache refreshes every 3 minutes.)
>
> To override the default refresh period and force the node classifier to retrieve the classes from the master immediately, click the **Refresh** button.

[Removing Classes From a Node Group](./console_classes_groups_making_changes.html#removing-classes-from-a-group)

### Defining the Data Used by Classes
You can use either parameters or variables to define the data used by classes. Parameters are scoped to the class, while variables are scoped to the node group.

#### Setting Class Parameters

Classes will automatically use default parameters and values, or parameters and values inherited from parent node groups. However, if the nodes in a node group need to be an exception to the general case, you can override default and parent values by specifying new parameter values.

**To add a parameter:**

1. In **Classes**, click the **Parameter name** drop-down list under the appropriate class and select the parameter to add. The drop-down list shows all of the parameters that are available in the node group’s environment.

2. When you select a parameter, the **Value** field is automatically populated with the default value. To change the value, type the new value in the **Value** field.

> ##### Tips on specifying parameter and variable values
>
> Parameters and variables can be structured as JSON. If they cannot be parsed as JSON, they will be treated as strings.
>
> Parameters and variables can be specified using the following data types and syntax:
>
>    * Strings (e.g. `"centos"`)
		- Variable-style syntax, which interpolates the result of referencing a fact (e.g. `"I live at $ipaddress."`)
		- Expression-style syntax, which interpolates the result of evaluating the embedded expression (e.g. `${$os["release"]["full"]}`)
>    * Booleans (e.g. `true` or `false`)
>    * Numbers (e.g. `123`)
>    * Hashes (e.g. `{"a": 1}`)
>    * Arrays (e.g. `["1","2.3"]`)
>
> **Variable-style syntax**
>
> Variable-style syntax uses a dollar sign ($) followed by a Puppet fact name.
>
> Example: `"I live at $ipaddress"`
>
> Variable-style syntax is interpolated as the value of the fact. For example, `$ipaddress` resolves to the value of the `ipaddress` fact.
>
> Indexing cannot be used in variable-style syntax because the indices are treated as part of the string literal. For example, given the following fact:
>
> `processors => {"count" => 4, "physicalcount" => 1}`,
>
> if you use variable-style syntax to specify `$processors[count]`, the value of the `processors` fact is interpolated but it is followed by a literal "[count]". After interpolation, this example becomes `{"count" => 4,"physicalcount" => 1}[count]`.
>
> **Note:** Do not use the `::` top-level scope indication because the console is not aware of Puppet's variable scope.
>
> **Expression-style syntax**
>
> Use expression-style syntax when you need to index into a fact (`${$os[release]}`), refer to trusted facts (`"My name is ${trusted[certname]}"`), or delimit fact names from strings (`"My ${os} release"`).
>
> The following is an example of using expression-style syntax to access the full release number of an operating system:
>
> 		${$os["release"]["full"]}
>
> Expression-style syntax uses:
>
> * an initial dollar sign and curly brace (`${`), followed by
> * a legal Puppet fact name preceded by an optional dollar sign, followed by
> * any number of index expressions (the quotations around indices are optional but are required if the index string contains spaces or square brackets), followed by
> * a closing curly brace (`}`).
>
> Indices in expression-style syntax can be used to access individual fields of structured facts, or to refer to trusted facts. Use strings in an index if you want to access the keys of a hashmap. If you want to access a particular item or character in an array or string based on the order in which it is listed, you can use an integer (zero-indexed).
>
> Examples of legal expression-style interpolation:
>
> * `${os}`
> * `${$os}`
> * `${$os[release]}`
> * `${$os['release']}`
> * `${$os["release"]}`
> * `${$os[2]}` (accesses the value of the third (zero-indexed) key-value pair in the `os` hash)
> * `${$os[release][2]}` (accesses the value of the third key-value pair in the `release` hash)
>
> In the PE console, an index can only be simple string literals or decimal integer literals. An index cannot include variables or operations (such as string concatenation or integer arithmetic).
>
> Examples of illegal expression-style interpolation:
>
> * `${$::os}`
> * `{$os[$release]}`
> * `${$os[0xff]}`
> * `${$os[6/3]}`
> * `${$os[$family + $release]}`
> * `${$os + $release}`
>
> **Trusted facts**
>
> Trusted facts are considered to be keys of a hashmap called `trusted`. This means that all trusted facts must be interpolated using expression-style syntax. For example, the certname trusted fact would be expressed like this: `"My name is ${trusted[certname]}"`. Any trusted facts that are themselves structured facts can have further index expressions to access individual fields of that trusted fact. For an overview of trusted facts, see the [Puppet Reference Manual](/puppet/latest/reference/lang_facts_and_builtin_vars.html#trusted-facts).
>
> **Note:** Regular expressions, resource references, and other keywords (such as ‘undef’) are not supported.

[Editing Parameters](./console_classes_groups_making_changes.html#editing-parameters)

[Deleting Parameters](./console_classes_groups_making_changes.html#deleting-parameters)

#### Setting Variables

Variables set in the console become [top-scope variables available to all Puppet manifests][topscope]. When you define a variable, any class in the node group that references the variable will be given the value that you set here.

**To set a variable:**

1. To access a node group's variables, on the **Classification** page, select the node group.

2. Click **Variables**.

3. For **Key**, enter the name of the variable.

4. For **Value**, enter the value that you want to assign to the variable.

5. Click **Add variable**, and then click the commit button.

> **Note**: For information on the permitted syntax for specifying variable values, see "Tips on specifying parameter and variable values" in [Setting Class Parameters](#setting-class-parameters).

> **Note:** Nodes can match multiple node groups, and node groups are not necessarily arranged in a strict hierarchy. It is therefore possible for two equal node groups to contribute conflicting values for variables and class parameters. Conflicting values will cause a Puppet run on an agent to fail.

[Editing variables](./console_classes_groups_making_changes.html#editing-variables)

[Deleting variables](./console_classes_groups_making_changes.html#deleting-variables)

### Viewing the Nodes That Are in a Node Group

**To view all nodes that currently match the rules specified for a node group:**

1. To go to the node group details, on the **Classification** page, click the node group.

2. Click **Matching nodes**.

   You will see the number of nodes that match the node group’s rules, along with a list of the names of matching nodes. The matching nodes list is updated as rules are added, deleted, and edited. Don’t forget that [nodes must match rules in ancestor node groups](./console_classes_groups_inheritance.html#how-does-inheritance-work?) as well as the rules of the current node group before they are actually considered to be a matching node.

> **Note**: If you have not set any rules for this node group yet, there will not be any matching nodes.

### Viewing Node Information
Each node in a PE deployment has its own node details page in the PE console. This is where you can view a list of the node groups that a node currently matches, and the classes and top-scope variables that are currently assigned to a node. To view this page:

<ol>
<li>In the top navigation, click <strong>Nodes</strong>.</li>

<li> From the list of nodes, click the specific node that you want to view.</li>

<dl>
<dt>Member Groups</dt>
<dd>Shows a list of node groups the node currently matches, based on the rules that have been specified for those node groups. Also shows the node group’s environment and parent node group.</dd>

<dt>Variables</dt>
<dd>Shows a list of variables that have been applied to the node. These variables have been applied to the node because they have been set for node groups that the node currently matches. <strong>Source Group</strong> shows the node group in which the variable is set.</dd>

<dt>Classes</dt>
<dd>Shows the classes that have been applied to the node. These classes have been applied because the node matches rules set in a node group containing these classes. <strong>Source Group</strong> shows the node group through which the class was applied.</dd>
</dl>
</ol>

[all_node_groups]: ./images/console/all_node_groups.png


* * *

- [Next: Making Changes in the Node Classifier](./console_classes_groups_making_changes.html)
