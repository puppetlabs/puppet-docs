After installing the repos, open your `/etc/yum.repos.d/puppetlabs.repo` file for editing. Locate the `[puppetlabs-devel]` stanza, and change the value of the `enabled` key from `0` to `1`:

    [puppetlabs-devel]
    name=Puppet Labs Devel <%= @dist.capitalize -%> <%= @version -%> - $basearch
    baseurl=https://yum.puppetlabs.com/<%= @dist.downcase -%>/<%= @codename -%>/devel/$basearch
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
    enabled=1
    gpgcheck=1

To disable the prerelease repo, change the value back to `0`.
