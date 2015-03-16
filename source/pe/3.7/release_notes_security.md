---
title: "PE 3.7 » Release Notes >> Security and Bug Fixes"
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

In PE 3.7.2, the browser would crash when the `users` endpoint for Role-Based Access Control (RBAC) returned a `NULL` value for `inherited_role_ids`. This issue has been fixed in PE 3.8.

