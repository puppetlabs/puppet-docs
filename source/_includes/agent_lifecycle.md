## Puppet agent and operating system support life cycles

In PE 2015.2 and open source Puppet 4.0 and onward, we use the same Puppet agent packages in our open source and Puppet Enterprise ecosystems. Because of this, we've set the following guidelines for managing Puppet agent life cycles.

#### Community-supported operating systems

On community-supported operating systems, we support Puppet agent for the OS's life cycle. Essentially, Puppet stops supporting an agent 30 days after that platform's end-of-life (EOL) date. For example, Fedora 20 reached its EOL on June 23, 2015. This means that on or around July 23, Puppet stopped providing fixes, updates, or support for either the Puppet Enterprise or open source versions of that agent.

This guideline covers the following community-supported operating systems:

-   Debian
-   Fedora
-   Ubuntu (non-LTS)

#### Enterprise-class operating systems

On enterprise-class operating systems, we support Puppet agent for _at least_ the OS's life cycle. In Puppet Enterprise, Puppet continues to support certain enterprise-class agent platforms after their EOL, though we do so solely at our own discretion.

This covers the following enterprise operating systems:

-   AIX\*
-   CentOS
-   Microsoft Windows Server
-   OS X
-   Oracle Enterprise Linux
-   Red Hat Enterprise Linux
-   Scientific Linux
-   Solaris\*
-   Suse Linux Enterprise Server\*
-   Ubuntu LTS

(\* denotes PE-only platforms, for which we don't provide open-source agent packages.)
