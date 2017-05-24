---
layout: default
title: Using with Puppet
disqus: true
canonical: "/mcollective/reference/integration/puppet.html"
---
[FactsRLFacter]: http://code.google.com/p/mcollective-plugins/wiki/FactsRLFacter
[PluginSync]: http://docs.reductivelabs.com/guides/plugins_in_modules.html
[AgentPuppetd]: http://code.google.com/p/mcollective-plugins/wiki/AgentPuppetd
[AgentPuppetca]: http://github.com/puppetlabs/mcollective-plugins/tree/master/agent/puppetca/
[AgentPuppetRal]: http://github.com/puppetlabs/mcollective-plugins/tree/master/agent/puppetral/
[PuppetCommander]: http://github.com/puppetlabs/mcollective-plugins/tree/master/agent/puppetd/commander/
[RapidRuns]: http://www.devco.net/archives/2010/08/05/rapid_puppet_runs_with_mcollective.php
[EC2Bootstrap]: http://www.devco.net/archives/2010/07/14/bootstrapping_puppet_on_ec2_with_mcollective.php
[PuppetRalBlog]: http://www.devco.net/archives/2010/07/07/puppet_resources_on_demand.php
[SchedulingPuppet]: http://www.devco.net/archives/2010/03/17/scheduling_puppet_with_mcollective.php
[ManagingPuppetd]: http://www.devco.net/archives/2009/11/30/managing_puppetd_with_mcollective.php
[CloudBootstrap]: http://vuksan.com/blog/2010/07/28/bootstraping-your-cloud-environment-with-puppet-and-mcollective/
[ServiceAgent]: http://code.google.com/p/mcollective-plugins/wiki/AgentService
[PackageAgent]: http://code.google.com/p/mcollective-plugins/wiki/AgentPackage
[Facter2YAML]: http://www.semicomplete.com/blog/geekery/puppet-facts-into-mcollective.html

# {{page.title}}

If you're a Puppet user you are supported in both facts and classes filters.

There are a number of community plugins related to Puppet:

 * Manage the Puppetd, request runs, enable and disable - [AgentPuppetd]
 * Manage the Puppet CA, sign, list and revoke certificates - [AgentPuppetca]
 * Use the Puppet Ral to create resources on demand, a distributed *ralsh* - [AgentPuppetRal]
 * Schedule your puppetd's controlling concurrency and resource usage - [PuppetCommander]
 * The [ServiceAgent] and [PackageAgent] use the Puppet RAL to function on many operating systems

There are also several blog posts related to Puppet and MCollective:

 * Running puppet on a number of nodes as quick as possible - [RapidRuns]
 * Bootstrapping a Puppet + EC2 environment with Puppet - [EC2Bootstrap]
 * Using the Puppet RAL with MCollective - [PuppetRalBlog]
 * General scheduling of Puppet Runs - [SchedulingPuppet]
 * Managing Puppetd - [ManagingPuppetd]
 * Bootstrapping your cloud environment - [CloudBootstrap]

## Facts
There is a [community plugin to enable Facter][FactsRLFacter] as a fact source.

So you can use the facts provided by Facter in filters, reports etc.

{% highlight console %}
$ mco find --with-fact lsbdistrelease=5.4
{% endhighlight %}

This includes facts pushed out with [Plugin Sync][PluginSync].

A less resource intensive approach has can be found [here][Facter2YAML], it converts the Puppet scope into a YAML file that the YAML fact source then loads.  This is both less resource intensive and much faster.

## Class Filters
Puppet provides a list of classes applied to a node by default in */var/lib/puppet/classes.txt* or */var/lib/puppet/state/classes.txt* (depending on which Puppet version you are using. The latter is true for 0.23.0 onwards) , we'll use this data with *--with-class* filters.

You should configure MCollective to use this file by putting the following in your *server.cfg*


{% highlight ini %}
classesfile = /var/lib/puppet/classes.txt
{% endhighlight %}

or if using Puppet 0.23.0 and onwards

{% highlight ini %}
classesfile = /var/lib/puppet/state/classes.txt
{% endhighlight %}

You can now use your classes lists in filters:

{% highlight console %}
$ mco find --with-class /apache/
{% endhighlight %}
