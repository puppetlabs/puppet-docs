---
layout: default
title: "PE 3.7 » "Configuring Your PE Infrastructure"
subtitle: "Configuring and Tuning Your PE Infrastructure"
canonical: "/pe/latest/config_intro.html"
---

Once you've installed Puppet Enterprise (PE), you'll likely want to configure some settings to get it working optimally for your environment. For example, you might want to add your own certificate to the whitelist, or increase the max-threads setting for tk-jetty, or configure the number of JRuby instances. This section contains information on two main methods for configuring PE: using the PE console or adding a key to Hiera (this latter approach is sometimes referred to as a Hiera override).

In general, only profile classes starting with `puppet_enterprise::profile` should be applied and configured via the node classifier in the console. Classes that aren't `profile` classes should be applied and configured using Hiera.

>**Note**: Before you make configuration changes, review the information on [preconfigured groups](./console_classes_groups_preconfigured_groups.html). You can badly damage your PE installation if you remove some classes, which are detailed on that page.

## Configure Settings Using the PE Console

Change settings in the PE console as follows.

1. In the console, on the **Classification** page, click the node group that contains the class you want to work with.
2. Locate the class you added in the list of classes.
3. Click the **Parameter name** down arrow, and select the parameter you want from the list.
4. Add a value for the parameter, and then click **Add parameter**.

### Example: Configure Settings Using the PE Console

The following steps demonstrate how to attach your own certificate.

1. On the **PE Certificate Authority** node group page, click the **Classes** tab.
2. Locate `puppet_enterprise::profile::certificate_authority`, and in the **Parameter name** box, select `client_whitelist`.
3. In the **Value** box, add the name for your certificate, such as `example.puppetlabs.vm`, and then click **Add parameter**.
4. Click **Commit 1 change**.

## Configure Settings With Hiera

You can also configure settings with Hiera. We recommend that you use this option in cases where the setting you want is not part of the `puppet_enterprise::profile` class.

In your Hiera .yaml file, add the setting you want to configure. For example, to increase or decrease the number of JRuby instances, you would tune the `jruby_max_active_instances` setting with the following code:

	`puppet_enterprise::master::puppetserver::jruby_max_active_instances:<number of instances>`
