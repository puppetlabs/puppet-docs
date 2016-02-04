To enable the Puppet Collection 1 repository, first choose the package based on your operating system and version. The packages are located in the [`yum.puppetlabs.com`](https://yum.puppetlabs.com) repository and named using the following convention:

    puppetlabs-release-<COLLECTION>-<OS ABBREVIATION>-<OS VERSION>.noarch.rpm

For instance, the package for Puppet Collection 1 on Red Hat Enterprise Linux 7 (RHEL 7) is `puppetlabs-release-pc1-el-7.noarch.rpm`.

Next, use the `rpm` tool as root with the `upgrade` (`-U`) flag, and optionally the `verbose` (`-v`), and `hash` (`-h`) flags:

    sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    
The `rpm` tool outputs its progress:

    Retrieving https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    Preparing...                          ################################# [100%]
    Updating / installing...
    1:puppetlabs-release-pc1-0.9.2-1.el################################# [100%]