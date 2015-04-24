---
title: "PE 3.8 » Configuring Your PE Infrastructure"
layout: default
subtitle: "Configuring and Tuning Your PE Infrastructure"
canonical: "/pe/latest/config_intro.html"
---

Once you've installed Puppet Enterprise (PE), you'll likely want to configure and tune some settings to get it working optimally for your environment. For example, you might want to add your own certificate to the whitelist, or increase the max-threads setting for `http` and `https` requests, or configure the number of JRuby instances.

The following pages provide information about settings you might want to tune on the PE components:

- [Configuring and Tuning Puppet Server](./config_puppetserver.html)

- [Configuring and Tuning PuppetDB](./config_puppetdb.html)

- [Configuring and Tuning Node Classifier](./config_nc.html)

- [Configuring and Tuning Orchestration](./config_orchestration.html)

- [Configuring Java Arguments for PE](./config_java_args.html)

There are two main methods for configuring PE: using the PE console or adding a key to Hiera (this latter approach is sometimes referred to as a Hiera override).

In general, only profile classes starting with `puppet_enterprise::profile` should be applied and configured via the node classifier (NC) in the console. Classes that aren't `profile` classes should be applied and configured using Hiera. 

Please also note that when editing or adding any parameters in PE-managed configuration files, use the PE console. Parameter values set in the PE console will override those you've manually set in the configuration files.  

>**Note**: Before you make configuration changes, review the information on [preconfigured node groups](./console_classes_groups_preconfigured_groups.html). You can badly damage your PE installation if you remove some classes, which are detailed on that page.

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

In your default Hiera .yaml file, add the setting you want to configure. The default location for the Hiera defaults is `/var/lib/hiera/defaults.yaml`. If you’ve customized your `hierarchy` or `datadir`, you’ll need to access and edit the default `.yaml` file accordingly.

For example, you can use Hiera to [increase or decrease the number of JRuby instances on the Puppet Server](./config_puppetserver.html#tuning-jruby-on-the-puppet-server), or use it to [tune the number of `max threads` that will accept `https` requests on the Puppet Server](./config_puppetserver.html#tuning-max-threads-on-puppet-server).
