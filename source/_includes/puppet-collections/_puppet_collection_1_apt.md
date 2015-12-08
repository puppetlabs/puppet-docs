To enable the [apt.puppetlabs.com](https://apt.puppetlabs.com) repository:

1. Download the "puppetlabs-release-pc1" package for your distribution version.
    * You can see a full list of these packages on the front page of <https://apt.puppetlabs.com/>. They are all named `puppetlabs-release-pc1-<CODE NAME>.deb`. (For Ubuntu releases, the code name is the adjective, not the animal.)
    * Architecture is handled automatically; there is only one package per distribution version.
2. As root, install the package by running `dpkg -i <PACKAGE NAME>`.
3. As root, run `apt-get update` to get the new list of available packages.

To enable the Puppet Collection 1 repository, first choose the package based on your operating system and version. The packages are located in the [`apt.puppetlabs.com`](https://apt.puppetlabs.com) repository and named using the following convention:

    puppetlabs-release-<COLLECTION>-<VERSION CODE NAME>.deb

For instance, the release package for Puppet Collection 1 on Debian 7 "Wheezy" is `puppetlabs-release-pc1-wheezy.deb`. For Ubuntu releases, the code name is the adjective, not the animal.

Second, download the release package and install it as root using the `dpkg` tool and the `install` flag (`-i`):

    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb
    sudo dpkg -i puppetlabs-release-pc1-wheezy.deb

Finally, run `apt-get update` after installing the release package to update the `apt` package lists.