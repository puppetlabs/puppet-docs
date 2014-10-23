To enable the repository:

1. Download the "puppetlabs-release" package for your OS version.
    * You can see a full list of these packages on the front page of <https://apt.puppetlabs.com/>. They are all named `puppetlabs-release-<CODE NAME>.deb`. (For Ubuntu releases, the code name is the adjective, not the animal.)
    * Architecture is handled automatically; there is only one package per OS version.
2. Install the package by running `dpkg -i <PACKAGE NAME>`.
3. Run `apt-get update` to get the new list of available packages.

For example, to enable the repository for Ubuntu 12.04 Precise Pangolin:

    wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
    sudo dpkg -i puppetlabs-release-precise.deb
    sudo apt-get update

To enable the repository for Ubuntu 14.04 Trusty Tahr:

    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
    sudo dpkg -i puppetlabs-release-trusty.deb
    sudo apt-get update
