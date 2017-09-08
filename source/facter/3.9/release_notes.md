---
layout: default
title: "Facter release notes"
---

This page documents the history of the Facter 3.9 series.

## Facter 3.9.0

Released August 17, 2017.

This is a feature and bug-fix release of Facter.

-   [All issues resolved in Facter 3.9.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.9.0%27)

### New Features

-   [FACT-1742](https://tickets.puppetlabs.com/browse/FACT-1742): Facter 3.9.0 adds a new `hypervisors` fact for virtualization providers that uses [libwhereami](https://github.com/puppetlabs/libwhereami/), an optional new dependency enabled by default in Puppet Platform 5.2 builds of Facter.

    The new fact recognizes multiple hypervisors in nested virtualization environments, and includes metadata about each hypervisor where available. The `hypervisor` fact and libwhereami are the first steps toward improved virtualzation support in future releases of Facter. They also reduce its dependence on the external tool `virt-what`, which has a few detection bugs and requires root to run.

    This new feature should therefore also remediate discrepancies in Facter's output when run as root and as a non-root user under virtualized environments.

### Bug fixes

-   [FACT-1728](https://tickets.puppetlabs.com/browse/FACT-1728): Facter 3.9.0 provides an improved error message when `facter -p` is specified but Puppet cannot be loaded.
-   [FACT-1731](https://tickets.puppetlabs.com/browse/FACT-1731): Facter 3.9.0 correctly reports `virtual` and `is_virtual` facts when using FreeBSD's bhyve hypervisor.
