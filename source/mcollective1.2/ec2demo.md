---
layout: default
title: EC2 Demo
disqus: true
canonical: "/mcollective/ec2demo.html"
---
[Amazon Console]: https://console.aws.amazon.com/ec2/
[Puppet based Service]: http://code.google.com/p/mcollective-plugins/wiki/AgentService
[Puppet based Package]: http://code.google.com/p/mcollective-plugins/wiki/AgentPuppetPackage
[NRPE]: http://code.google.com/p/mcollective-plugins/wiki/AgentNRPE
[Meta Registration]: http://code.google.com/p/mcollective-plugins/wiki/RegistrationMetaData
[URL Tester]: http://code.google.com/p/mcollective-plugins/wiki/AgentUrltest
[Registration]: /mcollective1.2/reference/plugins/registration.html
[Registration Monitor]: http://code.google.com/p/mcollective-plugins/wiki/AgentRegistrationMonitor

# {{page.title}}
We've created an Amazon hosted demo of mcollective that can give you a quick feel
for how things work without all the hassle of setting up from scratch.

The demo uses the new Amazon CloudFormation technology that you can access using the [Amazon Console].
Prior to following the steps in the demo please create a SSH keypair and register it under the EC2
tab in the console.

The video below shows how to get going with the demo and runs through a few of the availbable options.
For best experience please maximise the video.

The two passwords requested during creation is completely arbitrary you can provide anything there and
past entering them on the creation page you don't need to know them again later.  They are used internally
to the demo without you being aware of them.

You'll need to enter the url _http://mcollective-101-demo.s3.amazonaws.com/cloudfront`_`demo.json_ into the
creation step.

<embed src="http://blip.tv/play/hfMOgqejeAA" type="application/x-shockwave-flash" width="640" height="419" allowscriptaccess="always" allowfullscreen="true" />

## Agents
The images all have the basic agents going as well as some community ones:

 * [Puppet based Service]
 * [Puppet based Package]
 * [NRPE]
 * [Meta Registration]
 * [URL Tester]

## Registration
The main node will have [Registration] setup and the community [Registration Monitor] agent,
look in */var/tmp/mcollective* for meta data from all your nodes.
