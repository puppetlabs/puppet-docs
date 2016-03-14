## Puppet Agent and Operating System Support Life Cycles

In PE 2015.2 and Puppet 4.0 and onwards, the same Puppet agent packages are used in our open source and Puppet Enterprise ecosystems. Because of this, we've set the following guidelines for managing Puppet agent life cycles.

#### Community-Supported Operating Systems

On community-supported operating systems, we support Puppet agent for the OS's own life cycle. Essentially Puppet Labs will stop supporting an agent within 30 days of that platform's end-of-life (EOL) date. For example, Fedora 20 goes EOL June 23, 2015. This means that on or around June 23, Puppet Labs will no longer provide fixes, updates, or support for either the Puppet Enterprise or Open Source versions of that agent.

This covers the following community-supported operating systems:

- Debian
- Fedora
- Ubuntu (non LTS)

#### Enterprise-Class Operating Systems

On enterprise operating systems, we support Puppet agent for _at least_ the OS's own life cycle. In Puppet Enterprise, Puppet Labs will continue to support certain enterprise-class agent platforms after they reach EOL. Please note that supporting an OS past EOL is solely at the discretion of Puppet Labs.

This covers the following enterprise operating systems:

- CentOS
- Mac OS X
- Oracle Enterprise Linux
- Red Hat Enterprise Linux
- Scientific Linux
- Suse Linux Enterprise Server\*
- Solaris\*
- AIX\*
- Ubuntu LTS
- Microsoft Windows Server

(\* denotes PE-only platforms, which we don't provide open source agent packages for.)
