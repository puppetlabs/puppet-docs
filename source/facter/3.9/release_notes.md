---
layout: default
title: "Facter release notes"
---

This page documents the history of the Facter 3.9 series.

## Facter 3.9.1

Released September 26, 2017.

This is a bug-fix release of Facter and libwhereami that addresses potential fatal errors in the new `hypervisors` fact.

-   [All issues resolved in Facter 3.9.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.9.1%27)
-   [All issues resolved in libwhereami 0.1.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27whereami+0.1.2%27)

### Bug fix: Fix `hypervisors` fact resolution when run inside some Windows VMs

When running Facter 3.9.0 in virtualized Windows environments where Windows Management Instrumentation (WMI) values were only partially available, for instance on an OpenStack VM, Facter exited with a fatal `unhandled exception: unable to get from empty array of objects` error. Facter 3.9.1 resolves this issue.

-   [FACT-1749](https://tickets.puppetlabs.com/browse/FACT-1749)

### Bug fix: Prevent failed fact resolutions from stopping Facter

In previous versions of Facter, a failed fact resolution could halt Facter. Facter 3.9.1 resolves this issue by displaying failures as warnings and continuing to resolve other facts.

-   [FACT-1750](https://tickets.puppetlabs.com/browse/FACT-1750)

### Bug fix: Allow `hypervisors` fact to be blocked

The experimental `hypervisors` fact introduced in Facter 3.9.0 can cause Facter to fail in some virtualization environments. In Facter 3.9.1, you can block this fact in [`facter.conf`](./configuring_facter.html).

-   [FACT-1751](https://tickets.puppetlabs.com/browse/FACT-1751)

## Facter 3.9.0

Released September 13, 2017.

This is a feature and bug-fix release of Facter.

-   [All issues resolved in Facter 3.9.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.9.0%27)

### Known issues

-   [FACT-1749](https://tickets.puppetlabs.com/browse/FACT-1749): The `hypervisors` fact introduced in Facter 3.9.0 can cause Facter to fail in virtualized Windows environments where Windows Management Instrumentation (WMI) values are only partially available, for instance on an OpenStack VM.

### New Features

-   [FACT-1742](https://tickets.puppetlabs.com/browse/FACT-1742): Facter 3.9.0 adds a new [`hypervisors` fact](./core_facts.html#hypervisors) for virtualization providers that uses [libwhereami](https://github.com/puppetlabs/libwhereami/), an optional new dependency enabled by default in Puppet Platform 5.2 builds of Facter.

    The new fact recognizes multiple hypervisors in nested virtualization environments, and includes metadata about each hypervisor where available. The `hypervisors` fact and libwhereami are the first steps toward improved virtualzation support in future releases of Facter. They also reduce its dependence on the external tool `virt-what`, which has a few detection bugs and requires root to run.

    This new feature should therefore also remediate discrepancies in Facter's output when run as root and as a non-root user under virtualized environments.

### Bug fixes

-   [FACT-1728](https://tickets.puppetlabs.com/browse/FACT-1728): Facter 3.9.0 provides an improved error message when `facter -p` is specified but Puppet cannot be loaded.
-   [FACT-1731](https://tickets.puppetlabs.com/browse/FACT-1731): Facter 3.9.0 correctly reports `virtual` and `is_virtual` facts when using FreeBSD's bhyve hypervisor.
