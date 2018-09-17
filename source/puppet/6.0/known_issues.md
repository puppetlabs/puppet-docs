---
layout: default
toc_levels: 1234
title: "Puppet 6.0 known issues"
---

As known issues are discovered in Puppet 6.0 and its patch releases, they'll be added here. Once a known issue is resolved, it is listed as a resolved issue in the release notes for that release, and removed from this list.

Puppet 6.0

- We are no longer deprecating CA-related settings (see PUP-9027 for list of settings that were deprecated and are being undeprecated). We are no longer removing these settings in Puppet 6. ([PUP-9116](https://tickets.puppetlabs.com/browse/PUP-9116)
- We did not quite finish the support for the Binary data type in time for 6.0.0. Before you start to use Binary in your manifests for anything except File content, you should be aware of the ticket PUP-9110 as it could introduce changes that may affect you. ([PUP-9110](https://tickets.puppetlabs.com/browse/PUP-9110)

