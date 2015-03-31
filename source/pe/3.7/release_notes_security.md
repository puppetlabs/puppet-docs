---
title: "PE 3.8 » Release Notes >> Security and Bug Fixes"
layout: default
subtitle: "Security Fixes"
canonical: "/pe/latest/release_notes_security.html"
---

This page contains information about security fixes in Puppet Enterprise (PE) 3.8. It also contains a select list of those bug fixes that we believe you'll want to learn about.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [New Features](./release_notes.html).

## Puppet Enterprise 3.8 (??/??/15)

### Security Fixes


### Bug Fixes

Puppet Enterprise 3.8 contains a number of performance and documentation improvements, in addition to the fixes that are highlighted below.

#### Browser Crashing Issue

In PE 3.7.2, the browser would crash when the `users` endpoint for Role-Based Access Control (RBAC) returned a `NULL` value for `inherited_role_ids`. A `NULL` value is returned when you delete the user roles for a user group and then view the user. In PE 3.8, this has been fixed and the browser no longer crashes.

###  New PE 3.7.x MCO Servers Were Not Connecting With Older MCollective Agents (posted 12/17/14)

Some customers experienced problems connecting PE 3.7 MCO clients, such as Live Management, with older MCO servers (Puppet agents). Specifically, any MCO servers running on PE 3.3.2 agents and older. To fix this problem, we recommend upgrading your PE agents to 3.7.x so you can continue using activemq heartbeats.


