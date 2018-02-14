---
layout: default
title: "Facter release notes"
---

This page documents the history of the Facter 3.10 series.

## Facter 3.10.0

Released February 14, 2018.

This is a bug-fix release that shipped with Puppet Platform 5.4.0, and includes support for FIPS-enabled systems.

-   [All issues resolved in Facter 3.10.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.10.0%27)

### Bug fixes

-   Previous versions of Facter reported errors when a hostname was exactly 64 bytes long (`HOST_NAME_MAX`) on Linux hosts. Facter 3.10.0 resolves this issue.

-   Facter 3.10.0 updates Facter's cmake configuration to allow for a specific `libdir` target with a suffix, such as "lib64", instead of relying on a hardcoded value.

-   Facter 3.10.0 logs an info message instead of a warning when reporting that SMBIOS serial lookup via `kenv` fails on FreeBSD, where the serial isn't available.

### New features

-   This versions adds a new `fips_enabled` Boolean fact, which checks `/proc/sys/crypto/fips_enabled` to determine whether the system is running in FIPS mode.