[node_name_fact]: ./configuration.html#nodenamefact
[node_name_value]: ./configuration.html#nodenamevalue

> #### Note on Non-Certname Node Names
>
> Although it's possible to set something other than the [certname][] as the node name (using either the [`node_name_fact`][node_name_fact] or [`node_name_value`][node_name_value] setting), we don't generally recommend it. It allows you to re-use one node certificate for many nodes, but it reduces security, makes it harder to reliably identify nodes, and can interfere with other features.
>
> Setting a non-certname node name is **not officially supported** in Puppet Enterprise.
