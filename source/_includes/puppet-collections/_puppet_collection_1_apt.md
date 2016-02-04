To enable the Puppet Collection 1 repository, first choose the package based on your operating system and version. The packages are located in the [`apt.puppetlabs.com`](https://apt.puppetlabs.com) repository and named using the following convention:

    puppetlabs-release-<COLLECTION>-<VERSION CODE NAME>.deb

For instance, the release package for Puppet Collection 1 on Debian 7 "Wheezy" is `puppetlabs-release-pc1-wheezy.deb`. For Ubuntu releases, the code name is the adjective, not the animal.

Next, download the release package and install it as root using the `dpkg` tool and the `install` flag (`-i`):

    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb
    sudo dpkg -i puppetlabs-release-pc1-wheezy.deb

Finally, run `apt-get update` after installing the release package to update the `apt` package lists.