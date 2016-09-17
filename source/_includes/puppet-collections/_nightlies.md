## Nightly repositories

We provide automatically built [nightly repositories](https://nightlies.puppetlabs.com/) for *nix operating systems containing packages of **pre-release software not intended for production use**. The nightly repositories require that you also have the standard Puppet Collection repository enabled.

### Nightly?

Our automated systems create new "nightly" repositories for builds that pass our acceptance testing on the most popular platforms. This means we might not technically release builds nightly. However, they still represent bleeding-edge Puppet builds **that are not intended for production use.**

### Nightly repository contents

Each nightly repo contains a single product. We make nightly repositories for Puppet Server, Puppet Agent (including its related tools), and PuppetDB.

### Latest vs. specific commit

There are two kinds of nightly repository for each product:

-   The "-latest" repository stays around forever and always contains the latest build. We publish new packages to this repository every day or two, and are good for persistent canary systems.

-   The other repositories are all named after a specific git commit. They contain a single build, so you can reliably install the same version on many systems. These repositories are useful when testing a specific build, such to help Puppet test an impending release announced on the [puppet-users mailing list](https://groups.google.com/forum/#!forum/puppet-users).

    We delete single-commit repositories a week or two after we create them, so if you want to keep the packages available, import them into your local repository.

### Enabling nightly repositories on Yum-based systems

1.  Enable the main Puppet Collection repository, as described [above](#yum-based-systems).

2.  In a web browser, go to <https://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.

3.  Click through to your repository's `repo_configs/rpm` directory, and identify the `.repo` file that applies to your operating system. This looks like `pl-puppet-agent-<COMMIT>-el-7-x86_64.repo`.

4.  Download the `.repo` file into the system's `/etc/yum.repos.d/` directory. For example, to install the RHEL 7 puppet-agent nightly repository for commit 732e883, run:

    ``` bash
    cd /etc/yum.repos.d
    sudo wget https://nightlies.puppetlabs.com/puppet-agent/732e883733fe5e5989afe330e3c5cea00b678d1e/repo_configs/rpm/pl-puppet-agent-732e883733fe5e5989afe330e3c5cea00b678d1e-el-7-x86_64.repo
    ```

5.  Upgrade or install the product.

### Enabling nightly repositories on Apt-based systems

1.  Enable the main Puppet Collection repository, as described [above](#apt-based-systems).

2.  In a web browser, go to <https://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.

3.  Click through to your repository's `repo_configs/deb` directory, and identify the `.list` file that applies to your operating system. This looks like `pl-puppet-agent-<COMMIT>-xenial.list`.

4.  Download the `.list` file into the system's `/etc/apt/sources.list.d/` directory. For example, to install the Ubuntu 16.04 (Xenial) puppet-agent nightly repository for commit 732e883, run:

    ``` bash
    cd /etc/apt/sources.list.d
    sudo wget https://nightlies.puppetlabs.com/puppet-agent/732e883733fe5e5989afe330e3c5cea00b678d1e/repo_configs/deb/pl-puppet-agent-732e883733fe5e5989afe330e3c5cea00b678d1e-xenial.list
    ```

5.  Run `sudo apt-get update`.

6.  Upgrade or install the product.
