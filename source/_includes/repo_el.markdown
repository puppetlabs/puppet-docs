The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following versions of Red Hat Enterprise Linux and distributions based on it:

{% include platforms_redhat_like.markdown %}

Enabling this repository will let you install Puppet in Enterprise Linux 5 without requiring any other external repositories like EPEL. For Enterprise Linux 6, you will need to [enable the Optional Channel](https://access.redhat.com/site/documentation/en-US/OpenShift_Enterprise/1/html/Client_Tools_Installation_Guide/Installing_Using_the_Red_Hat_Enterprise_Linux_Optional_Channel.html) for the rubygems dependency.

To enable the repository, run the command below that corresponds to your OS version and architecture:

#### Enterprise Linux 7

(At this point, RHEL 7 is only available as a 64-bit version, and the derived distros aren't out yet.)

##### x86_64

    $ sudo rpm -ivh http://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-10.noarch.rpm

#### Enterprise Linux 6

##### i386

    $ sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

##### x86_64

    $ sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm

#### Enterprise Linux 5

##### i386

    $ sudo rpm -ivh https://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-7.noarch.rpm

##### x86_64

    $ sudo rpm -ivh https://yum.puppetlabs.com/el/5/products/x86_64/puppetlabs-release-5-7.noarch.rpm

