---
layout: default
title: "Deprecated Web Servers"
---

[puppet server]: /puppetserver/2.1/services_master_puppetserver.html
[rack]: ./services_master_rack.html
[webrick]: ./services_master_webrick.html
[server project]: https://tickets.puppetlabs.com/browse/server

Currently, it's possible to run a Puppet master server under [Puppet Server][], [Rack][], and [WEBrick][]. Over the next year, we want to provide a smaller number of better-supported options and unify the runtime environment onto the much better-performing JVM/Clojure/JRuby combination of Puppet Server. 

In Puppet 5.0, we plan to consolidate the network stack onto Puppet Server and will remove support for Rack and WEBrick masters. This will also enable the Clojure Certificate Authority (CA), which was first delivered as a compatible drop-in replacement for the Ruby CA with Puppet Server 1.0, to become the single CA codebase, and enable fixes for long-standing issues with both the user interaction and the underlying implementation. 

This means that users running the standalone `puppet master` application or Passenger-based puppetmasters should start evaluating Puppet Server during the 4.x series so you're ready for Puppet 5. Most sites which have migrated so far work fine under Puppet Server, but if you are doing custom work at the Apache/Nginx or Rack layers at your site that aren't covered by the documentation, please file a bug in the [SERVER project][] in Puppet Labs' JIRA describing your configuration. Puppet Server uses the Jetty web server, which is highly configurable and can probably do what you need with a little coaxing.

When implementing Puppet Server, also note that the legacy Ruby-based authentication methods and [`auth.conf`][] configuration file format are deprecated in favor of [`trapperkeeper-authorization`][] and the new HOCON `auth.conf` implemented in Puppet Server 2.2.
