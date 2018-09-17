---
layout: default
toc_levels: 1234
title: "Puppet 6.0 Release Notes"
---

This page lists the changes in Puppet 6.0 and its patch releases. You can also view [known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](../5.1/release_notes.html), [Puppet 5.2](../5.2/release_notes.html), [Puppet 5.3](../5.3/release_notes.html), and [Puppet 5.4](../5.4/release_notes.html) release notes, because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](../4.10/release_notes.html) and [Puppet 4.9 release notes](../4.9/release_notes.html).

## Puppet 6.0

Released 18 September 2018

**{description of release)**


### New features and improvements

- The following types were moved from the Puppet core codeblock to supported modules on the Forge. This change enables easier composability and reusability of the Puppet codebase and enables development to proceed more quickly without fear of destabilizing the rest of Puppet. These types are repackaged back into Puppet agent, so you don't have to install them separately. See the module readmes for information.

    - augeas
    - cron
    - host
    - mount
    - scheduled_task
    - selboolean
    - selmodule
    - ssh_authorized_key
    - sshkey
    - yumrepo
    - zfs
    - zone
    - zpool

- The following types were also moved to modules, but these are not supported and they are not repackaged into Puppet agent. If you need to use them, you must install the modules separately.

    - k5login
    - mailalias
    - maillist

- The following subcommands were deprecated in Puppet 5.5.6 and slated for removal in Puppet 6.0. While they are still deprecated, they have not yet been removed. 


    -   `ca_name`
    -   `cadir`
    -   `cacert`
    -   `cakey`
    -   `capub`
    -   `cacrl`
    -   `caprivatedir`
    -   `csrdir`
    -   `signeddir`
    -   `capass`
    -   `serial`
    -   `autosign`
    -   `allow_duplicate_certs`
    -   `ca_ttl`
    -   `cert_inventory`

### Bug fixes

- Improvement	PUP-9093	With rich-data turned on for a catalog (now the default) a Report could contain rich data in reported events, and that was not good because nothing downstream from the agent is prepared to handle rich data. This is now fixed so that data in reported events are stringified when needed.
- Improvement	PUP-9091	The deprecation for illegal top level constructs is now an error.
- Bug	PUP-9079	Attempt to use the reserved attribute names {{__ptype}} and {{__pvalue}} in custom {{Object}} data types will now raise an error instead of producing bad result when serializing such objects.
- Bug	PUP-8976	It was not possible to use a hash key `__pcore_type` in a hash as that would trigger the special handling during serialization. Now in Puppet 6.0.0, the special key has changed to `__ptype` and it is not also possible to use that as a key in a hash and still be able to serialize it (for example use it in a catalog).
- Improvement	PUP-8967	When the agent is configured with a list of servers (via server_list), it will now request server status from the "status" endpoint instead of the "node" endpoint.
- Bug	PUP-8943	The selmodule type is now more strict about checking if a module has already been loaded, and should no longer consider modules such as "bar" and "foobar" to be the same module.
- Bug	PUP-8908	Puppet now considers resources that have failed to restart when notified from another resource as failed, and will mark them as such in reports. Reports also now include the `failed_to_restart` status for individual resources, instead of only including a total count of `failed_to_restart` resources in the resource metrics section. This also bumps the report format version to 10.
- Bug	PUP-8733	Fix an issue running in JRuby where we didn't store autoloaded paths in the same way that the JRuby implementation did, leading to a bug where a type or provider could get loaded more than once.
- Bug	PUP-8696	Puppet's autoloader methods now require a non-nil environment. This is a breaking API change, but should not affect any user extensions like 3x functions.
Puppet sometimes used the configured environment instead of the current environment to autoload. This mainly affected agents when loading provider features. 
Calling Puppet::Parser::Functions.autoloader.load* methods are deprecated, and will issue a warning if strict mode is set to warning or error. Instead use Scope#call_function("myfunction") to call other functions from within a function.
- Bug	PUP-8694	When comparing Numeric to Timestamp or Timespan it did not work to compare with the Numeric value first. This is now fixed. 
- Task	PUP-8683	The http_read_timeout default changed from infinite to 10 minutes. This prevents the agent from hanging if there are network disruptions after the agent has sent an HTTP request and is waiting for a response which might never arrive. 

Similarly, the runtimeout default also changed from infinite to 1 hour.
- Improvement	PUP-8667	The Tidy resource type now uses the debug log level for its "File does not exist" message, instead of the info level. This means that resources of this type will no longer emit the message by default when the target of the resource has already been cleaned from disk.
- Sub-task	PUP-8656	With this change - if the user has distributed the CRL chain "out of band" - then the agent will successfully load it and use it to verify its connection to other Puppet infrastructure (for example the master). It expects the CRL chain to be one or more PEM encoded CRLs concatenated together (the same format as a cert bundle). This fixes the "Agent-side CRL checking is not possible" caveat on in our External CA documentation: https://puppet.com/docs/puppet/5.5/config_ssl_external_ca.html#option-2-puppet-server-functioning-as-an-intermediate-ca
- Bug	PUP-8545	When processing malformed plist files, we used to use /dev/stdout which can cause Ruby to complain. We now use '-' instead which means to use stdout when processing the plist file with plutil.
T- ask	PUP-8530	Trusted server facts are always enabled and have been deprecated since 5.0. Removes the setting and conditional logic.
- Task	PUP-8528	The write_only_yaml node terminus was used to "determine the list of 
nodes that the master knows about" and predated widespread puppetdb 
adoption. The write_only_yaml has been deprecated since 4.10.5, and 
this commit removes it. Note this should result in a puppetserver speedup as it no longer will need to serialize node data as YAML to disk during a compile.
- Bug	PUP-8484	Puppet 6 now requires ruby 2.3 or greater, and will error when running on older ruby versions. Several code paths relating to old ruby behavior have been removed.
- Bug	PUP-8483	Puppet requires ruby 2.3 or greater.
- Bug	PUP-8476	EPP comments {{<%# Like this %>}} always trimmed preceding whitespace. This is different from ERB making it more difficult to migrate ERB templates to EPP. There was also no way of making EPP preserve those spaces. 

Now, EPP comment does not trim preceding whitespace by default, and a new left trimming tag {{<%#-}} has been added. 

This is a backwards incompatibility in that code like this: 
{code} 
Before <%# comment %>after 
{code} 
resulted in the string {{"Beforeafter"}}, whereas now it will be "Before after".
- Improvement	PUP-8320	The {{filter}} function did not accept truthy value returned from the block as indication of values to include in the result. Only exactly boolean {{true}} was earlier accepted.
- Improvement	PUP-7834	Puppet now uses YAML.safe_load consistently to ensure only known classes are loaded.
- Task	PUP-7601	The LDAP node terminus has been removed.
- Task	PUP-7433	Restructure puppet's Gemfile so that bundler installs puppet's runtime, feature-related, and test dependencies by default. The development and documentation groups can be installed using: bundle install --with development documentation.
- Task	PUP-7157	Puppet now uses the shared gem dependency for semantic_puppet, rather than loading its own vendored version.
- Task	PUP-7115	Puppet now loads semantic_puppet from a shared gem directory, so that Puppet, Puppet agent, and Puppet Server all require and use the same version of the gem. (~>1.0.x)
- Epic	PUP-6893	Puppet now requires ruby 2.3 or greater. We removed code paths for older ruby support, e.g. 1.8.7, relaxed our gem dependencies to include gems that require ruby 2 or up, and now test puppet PRs against JRuby 9k.
- Bug	PUP-6344	Total time now reports the measured time of the run instead of a sum of other run times.
- Bug	PUP-5985	Features defined using a block or a list of libraries now behave the same, so the following are equivalent: 

Puppet.features.add(:my_feature) do 
require 'mylib' 
end 

Puppet.features.add(:my_feature, libs: ['my_lib']) 

Previously the result of the block was always cached. With this change only true or false return values are cached. To indicate that the state of the feature is unknown and may become available later, the block should return nil.
- Improvement	PUP-4242	Errors will be reported for module puppet files declaring things in a namespace inconsistent with their directory and file location.
- Bug	PUP-2838	Generating graphs of catalogs (Eg: puppet apply --graph) now correctly handles resources with double quotes in the title.



### Deprecations

- The `computer`, `macauthorization`, and `mcx` types and providers have been moved to a module: https://forge.puppet.com/puppetlabs/macdslocal_core. It is not being repackaged into puppet-agent for 6.0
- The Nagios types no longer ship with Puppet, and are now available as the `puppetlabs/nagios_core` module from the Forge.
- The Cisco network device types no longer ship with Puppet. These types and providers have been deprecated in favor of the `puppetlabs/cisco_ios` module, which is available on the Forge.
    



