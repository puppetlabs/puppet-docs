---
layout: default
title: Screen Casts
disqus: true
canonical: "/mcollective/screencasts.html"
---
[blip]: http://mcollective.blip.tv/
[slideshare]: http://www.slideshare.net/mcollective
[ec2demo]: /mcollective1.2/ec2demo.html
[Terminology]: /mcollective1.2/terminology.html
[SimpleRPCIntroduction]: /mcollective1.2/simplerpc/
[DDL]: /mcollective1.2/simplerpc/ddl.html

# {{page.title}}
We believe screen casts give the best introduction to new concepts, we've recorded
quite a few that compliments the documentation.

There's a [blip] channel that has all the videos, you can subscribe and follow there.
There is also a [slideshare] site where presentations will go that we do at conferences and events.

## Introductions and Guides
<ol>
<li><a href="#introduction">Introducing MCollective</a></li>
<li><a href="#ec2_demo">EC2 Hosted Demo</a></li>
<li><a href="#message_flow">Message Flow, Terminology and Components</a></li>
<li><a href="#writing_agents">Writing Agents</a></li>
<li><a href="#simplerpc_ddl">Detailed information about the DDL</a></li>
</ol>

## Tools built using MCollective
<ol>
<li><a href="#simplerpc_ddl_irb">SimpleRPC DDL IRB</a></li>
<li><a href="#mcollective_deployer">Software Deployer used by developers</a></li>
<li><a href="#exim">Managing clusters of Exim Servers</a></li>
<li><a href="#server_provisioner">Bootstrapping Puppet on EC2</a></li>
</ol>

<a name="introduction">&nbsp;</a>

### Introduction
[This video](http://blip.tv/file/3808541) introduces the basic concepts behind MCollective.  It predates the
SimpleRPC framework but is still valid today.

<embed src="http://blip.tv/play/hfMOgenPYQA" type="application/x-shockwave-flash" width="640" height="338" allowscriptaccess="always" allowfullscreen="true"></embed>

<a name="ec2_demo">&nbsp;</a>

### EC2 Based Demo
Sometimes you just want to know if a tool is right for you by getting hands on experience
we've made a EC2 hosted demo where you can fire up as many nodes in a cluster as you want and
get some experience.

View the [ec2demo] page for more about this.

<embed src="http://blip.tv/play/hfMOgfSIRgA" type="application/x-shockwave-flash" width="640" height="385" allowscriptaccess="always" allowfullscreen="true"></embed>

<a name="message_flow"> </a>

### Message Flow, Terminology and Components
This video introduce the messaging concepts you need to know about when using MCollective,
it shows how the components talk with each other and what software needs to be installed where
on your network.  Recommended you view this prior to starting your deployment.

We also have a page detailing the [Terminology]

<div style="width:640px" id="__ss_4853323"><strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/mcollective/mcollective-message-flow-terminology-and-components" title="Architecture, Flow and Terminology">Architecture, Flow and Terminology</a></strong><object id="__sse4853323" width="640" height="532"><param name="movie" value="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=messageflow-100727191919-phpapp01&rel=0&stripped_title=mcollective-message-flow-terminology-and-components" /><param name="allowFullScreen" value="true"/><param name="allowScriptAccess" value="always"/><embed name="__sse4853323" src="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=messageflow-100727191919-phpapp01&rel=0&stripped_title=mcollective-message-flow-terminology-and-components" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="532"></embed></object><div style="padding:5px 0 12px">View more <a href="http://www.slideshare.net/">webinars</a> from <a href="http://www.slideshare.net/mcollective">Marionette Collective</a>.</div></div>
<a name="writing_agents">&nbsp;</a>

### How to write an Agent, DDL and Client
Writing agents are easy, we have good documentation that can be used as a reference, [this
video](http://blip.tv/file/3808928) should show you how to tie it all together though.
See the [SimpleRPC Introduction][SimpleRPCIntroduction] for reference wiki pages after viewing this video.

<embed src="http://blip.tv/play/hfMOgenSZAA" type="application/x-shockwave-flash" width="640" height="388" allowscriptaccess="always" allowfullscreen="true"></embed>

<a name="simplerpc_ddl">&nbsp;</a>

### The SimpleRPC DDL
The Data Definition Lanauge helps your clients produce more user friendly output, it ensures
input gets validated, shows online help and enable dynamic generation of user interfaces.
The [DDL] wiki page gives more information once you've watched this video.

<embed src="http://blip.tv/play/hfMOgemKNAA" type="application/x-shockwave-flash" width="640" height="424" allowscriptaccess="always" allowfullscreen="true"></embed>

<a name="simplerpc_ddl_irb">&nbsp;</a>

### SimpleRPC DDL enhanced IRB
A custom IRB shell that supports command completion based on the SimpleRPC DDL

<embed src="http://blip.tv/play/hfMOgf3rJgA" type="application/x-shockwave-flash" width="640" height="348" allowscriptaccess="always" allowfullscreen="true"></embed>

<a name="mcollective_deployer"> </a>

### Software Deployer using MCollective
We sometimes do comissioned work based on MCollective, this is a deployer we wrote using SimpleRPC.
This deployer is used by developers to deploy applications live into production using a defined
API and process.

<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/Fqt2SgnQn3k&amp;hl=en_US&amp;fs=1?rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/Fqt2SgnQn3k&amp;hl=en_US&amp;fs=1?rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>

<a name="exim"> </a>

### Managing Exim Clusters
A command line and Dialog based UI written to manage clusters of Exim Servers.

The code for this is [open source](http://github.com/puppetlabs/mcollective-plugins/tree/master/agent/exim/)
unfortunately it predates SimpleRPC, we hope to port it soon.

<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/kNvoQCpJ1V4&amp;hl=en_US&amp;fs=1?rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/kNvoQCpJ1V4&amp;hl=en_US&amp;fs=1?rel=0" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>

<a name="server_provisioner"> </a>

### Bootstrapping Puppet on EC2 with MCollective
Modern cloud environments present a lot of challenges to your automated, using MCollective and
some of the existing opensource agents and plugins we can completely automate the entire process
of provisioning EC2 nodes with Puppet.

Full detail is available [on this blog post](http://www.devco.net/archives/2010/07/14/bootstrapping_puppet_on_ec2_with_mcollective.php)

<embed src="http://blip.tv/play/hfMOge3ibQA" type="application/x-shockwave-flash" width="640" height="461" allowscriptaccess="always" allowfullscreen="true"></embed>
