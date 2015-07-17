## Puppet Agent and Operating System Support Life Cycles

In PE 2015.2 and Puppet 4.0 and onwards, the same Puppet agent packages are used in our open source and Puppet Enterprise ecosystems. Because of this, we've set the following guidelines for managing Puppet agent life cycles.

#### Community-Supported Operating Systems

Puppet agents that run on community-supported operating systems will follow the life cycles determined by the suppliers of the operating systems. Essentially Puppet Labs will stop supporting an agent within 30 days of that platform's end-of-life (EOL) date. For example, Fedora 20 goes EOL June 23, 2015. This means that on or around June 23, Puppet Labs will no longer provide fixes, updates, or support for either the Puppet Enterprise or Open Source Puppet versions of that agent.

This includes the following community-supported operating systems:

- Debian
- Fedora (only available in Open Source Puppet)
- Ubuntu (non LTS) (only available in Open Source Puppet)

#### Enterprise-class Operating Systems

Puppet agents that run on enterprise operating systems will follow the extended support life cycles determined by the suppliers of the operating systems. After an enterprise-class agent platform reaches EOL, Puppet Labs *may* continue to support it in Puppet Enterprise. Please note that supporting an OS past EOL is solely at the discretion of Puppet Labs.

This includes the following enterprise-class operating systems:

- CentOS
- Mac OS X
- Oracle Enterprise Linux
- Red Hat Enterprise Linux
- Scientific Linux
- Suse Linux Enterprise Server
- Solaris
- Ubuntu LTS
- Microsoft Windows Server
