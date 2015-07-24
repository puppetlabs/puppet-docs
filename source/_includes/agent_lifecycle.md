## Puppet Agent and Operating System Support Life Cycles

In PE 2015.2 and Puppet 4.0 and onwards, the same Puppet agent packages are used in our open source and Puppet Enterprise ecosystems. Because of this, we've set the following guidelines for managing Puppet agent life cycles.

#### Community-Supported Operating Systems

Puppet agents that run on community-supported operating systems will follow the life cycles determined by the suppliers of the operating systems. Essentially Puppet Labs will stop supporting an agent within 30 days of that platform's end-of-life (EOL) date. For example, Fedora 20 goes EOL June 23, 2015. This means that on or around June 23, Puppet Labs will no longer provide fixes, updates, or support for either the Puppet Enterprise or Open Source versions of that agent.

This covers the following community-supported operating systems:

- Debian
- Fedora (only available in Open Source Puppet)
- Ubuntu (non LTS) (only available in Open Source Puppet)

#### Enterprise-Class Operating Systems

Puppet agents that run on enterprise operating systems will follow the extended support life cycles determined by the suppliers of the operating systems. Puppet Labs will sometimes, at its own discretion, support some enterprise-class agent platforms past their EOL in Puppet Enterprise.

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
