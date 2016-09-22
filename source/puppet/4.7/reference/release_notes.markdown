---
layout: default
toc_levels: 1234
title: "Puppet 4.7 Release Notes"
---


This page lists the changes in Puppet 4.6 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.5 release notes](/puppet/4.5/reference/release_notes.html) and [Puppet 4.4 release notes](/puppet/4.4/reference/release_notes.html).

## Puppet 4.7.0

Released September 22, 2016.

This release addresses a single bug fix.

### Critical bug fix

Previously, the `/environment/:env` route wasn't properly anchored to the start of the path, so routes with other prefixes would also match. Because auth is performed separately based on the path, this allowed requests like `/status/environment/production` to bypass auth checks and retrieve environment catalogs. This also meant that other valid requests ending in `/environment/:foo`, such as for files, would be handled incorrectly.

The `/environment/:env` regular expression is now properly anchored to the beginning of the path, so only explicit environment requests will match.