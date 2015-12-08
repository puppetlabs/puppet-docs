Package                              | Contents
-------------------------------------|----------------------------------------------
[`puppet-agent`](./about_agent.html) | Puppet, [Facter](/facter/), [Hiera](/hiera/), [MCollective](/mcollective), `pxp-agent`, root certificates, and prerequisites like [Ruby](https://www.ruby-lang.org/) and [Augeas](http://augeas.net/)
`puppetserver`                       | [Puppet Server](/puppetserver/); depends on `puppet-agent`
`puppetdb`                           | [PuppetDB](/puppetdb/)
`puppetdb-termini`                   | Plugins to let [Puppet Server talk to PuppetDB](/puppetdb/latest/connect_puppet_master.html)