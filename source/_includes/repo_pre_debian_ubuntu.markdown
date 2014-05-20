After installing the repos, open your `/etc/apt/sources.list.d/puppetlabs.list` file for editing. Locate and uncomment the line that begins with `deb` and ends with `devel`:

    # Puppetlabs devel (uncomment to activate)
    deb http://apt.puppetlabs.com precise devel
    # deb-src http://apt.puppetlabs.com precise devel

To disable the prerelease repo, re-comment the line.
