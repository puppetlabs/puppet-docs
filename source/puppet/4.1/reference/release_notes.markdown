---
layout: default
title: "Puppet 4.1 Release Notes"
---




DEFINITELY NO NOTES NEEDED

* [PUP-4441: Create test to show that Webrick doesn't start if the "puppet" user and group do not exist](https://tickets.puppetlabs.com/browse/PUP-4441)
* [PUP-4360: create puppetversion acceptance test](https://tickets.puppetlabs.com/browse/PUP-4360)
* [PUP-4419: create acceptance to ensure client does not overwrite server-set variables](https://tickets.puppetlabs.com/browse/PUP-4419)
* [PUP-4471: Acceptance test ensuring puppet apply works when an ENC returns an environment](https://tickets.puppetlabs.com/browse/PUP-4471)
* [PUP-4044: AIO acceptance tests copies multiple versions of repo configs to the SUT](https://tickets.puppetlabs.com/browse/PUP-4044)
* [PUP-4404: Spec tests on Windows expect environment setup](https://tickets.puppetlabs.com/browse/PUP-4404)
* [PUP-4424: puppet-agent#stable should track puppet_for_the_win#stable](https://tickets.puppetlabs.com/browse/PUP-4424)
* [PUP-4437: Update the "puppet-agent" Repo for 4.0.1 to Incorporate Fix for PUP-4390](https://tickets.puppetlabs.com/browse/PUP-4437)
* [PUP-3559: Allow splat in interpolation to unfold and shrinkwrap](https://tickets.puppetlabs.com/browse/PUP-3559)
    it's a wontfix.
* [PUP-4343: Add test(s) for the File resource links attribute](https://tickets.puppetlabs.com/browse/PUP-4343)
* [PUP-4344: Add test(s) for the File resource manage_symlinks attribute](https://tickets.puppetlabs.com/browse/PUP-4344)
* [PUP-4347: Add test(s) for the File resource ignore attribute](https://tickets.puppetlabs.com/browse/PUP-4347)
* [PUP-4466: add acceptance: ensure functions can be written/execute in puppet language](https://tickets.puppetlabs.com/browse/PUP-4466)
* [PUP-3596: Ensure Language Specification specifies behavior of undef resource param](https://tickets.puppetlabs.com/browse/PUP-3596)
* [PUP-4233: Create node configs for puppet-passenger AIO acceptance tests](https://tickets.puppetlabs.com/browse/PUP-4233)
* [PUP-4234: Create pre-suites for puppet-passenger AIO acceptance tests](https://tickets.puppetlabs.com/browse/PUP-4234)


NOT SURE, NEED HELP

* [PUP-735: Status unchanged when "Could not apply complete catalog"](https://tickets.puppetlabs.com/browse/PUP-735)
* [PUP-3814: Duplicated error output](https://tickets.puppetlabs.com/browse/PUP-3814)
* [PUP-4231: File resources with defined content don't output contents with ensure=>present](https://tickets.puppetlabs.com/browse/PUP-4231)
* [PUP-4359: puppetversion fact is missing](https://tickets.puppetlabs.com/browse/PUP-4359)
* [PUP-4365: Audit puppet as non-root testing](https://tickets.puppetlabs.com/browse/PUP-4365)
* [PUP-4373: Windows ADSI User groups property should behave similarly to Groups members property](https://tickets.puppetlabs.com/browse/PUP-4373)
* [PUP-4499: The size_type is dropped when inferring common type for String types](https://tickets.puppetlabs.com/browse/PUP-4499)
* [PUP-4551: TypeCalculator.generalize() produces bad types for Struct](https://tickets.puppetlabs.com/browse/PUP-4551)
* [PUP-4552: Resource parameter validation uses TypeCalculator.infer instead of infer_set](https://tickets.puppetlabs.com/browse/PUP-4552)
* [PUP-2862: Validate that default value expression for param does not define variable](https://tickets.puppetlabs.com/browse/PUP-2862)
* [PUP-3988: remove logic for "single feature" hostname in 4.0 validator](https://tickets.puppetlabs.com/browse/PUP-3988)
* [PUP-4388: Remove START option in /etc/default/puppet on Debian](https://tickets.puppetlabs.com/browse/PUP-4388)
* [PUP-4527: Add list of symbolic migrations available to MigrationChecker API](https://tickets.puppetlabs.com/browse/PUP-4527)
* [PUP-3884: Investigate AIO puppet agent upgrade](https://tickets.puppetlabs.com/browse/PUP-3884)
    Hey, did upgrader changes happen for this release?
* [PUP-4532: Enable passenger testing in aardwolf](https://tickets.puppetlabs.com/browse/PUP-4532)
    And are passenger packages new for 4.1?

### General Bug Fixes

* [PUP-4394: Regression: Webrick fails to start if the puppet user and group don't exist](https://tickets.puppetlabs.com/browse/PUP-4394)
* [PUP-4420: Executable external facts broken in 4.0.0: not executable on agent](https://tickets.puppetlabs.com/browse/PUP-4420)
* [PUP-4436: With a gem install of puppet, when run as root, 'puppet {agent|apply}' fail](https://tickets.puppetlabs.com/browse/PUP-4436)
* [PUP-4461: manifest changes are ignored when using hiera_include](https://tickets.puppetlabs.com/browse/PUP-4461)
* [PUP-4607: External facts no longer load from pluginsync'ed directory](https://tickets.puppetlabs.com/browse/PUP-4607)


### Resource Type and Provider Improvements

* [PUP-400: Manage hidden windows packages](https://tickets.puppetlabs.com/browse/PUP-400)
* [PUP-3618: Include pkgng provider for FreeBSD](https://tickets.puppetlabs.com/browse/PUP-3618)
* [PUP-4351: Default service type and package provider not set on Cumulus Linux](https://tickets.puppetlabs.com/browse/PUP-4351)
* [PUP-4362: Portage package provider does not list all installed packages](https://tickets.puppetlabs.com/browse/PUP-4362)
* [PUP-4382: Test to retrieve version of latest of pkgng package is broken](https://tickets.puppetlabs.com/browse/PUP-4382)
* [PUP-4491: Adding user to group fails](https://tickets.puppetlabs.com/browse/PUP-4491)
* [PUP-3908: Tidy type is too verbose when working of directories containing lot of files](https://tickets.puppetlabs.com/browse/PUP-3908)
* [PUP-3968: Cache the zypper list-updates output](https://tickets.puppetlabs.com/browse/PUP-3968)
* [PUP-4198: Add install_options feature to pip provider](https://tickets.puppetlabs.com/browse/PUP-4198)



### New Language Features


* [PUP-4374: Splatting attributes into an amended attribute block isn't supported](https://tickets.puppetlabs.com/browse/PUP-4374)
* [PUP-4385: Can't write WOMANS HAT emoji with \uXXXX unicode escapes](https://tickets.puppetlabs.com/browse/PUP-4385)
* [PUP-4483: Add NotUndef type to the set of Puppet types](https://tickets.puppetlabs.com/browse/PUP-4483)
* [PUP-2080: Support functions written in pp](https://tickets.puppetlabs.com/browse/PUP-2080)
* [PUP-2894: lvalue comma asignment should splat* an array](https://tickets.puppetlabs.com/browse/PUP-2894)
* [PUP-4193: Add pattern matching to the Puppet DSL](https://tickets.puppetlabs.com/browse/PUP-4193)
* [PUP-4443: splat-assign multiple variables from a hash](https://tickets.puppetlabs.com/browse/PUP-4443)

#### New Built-In `$server_facts` Variable (Opt-In)

* [PUP-2630: Server-set global variables like $::environment get overwritten by client facts](https://tickets.puppetlabs.com/browse/PUP-2630)



### Language Bug Fixes

* [PUP-3895: EPP validator should error when specified template file does not exist](https://tickets.puppetlabs.com/browse/PUP-3895)
* [PUP-4178: defined() function returns true for undef and empty string, and false for "main"](https://tickets.puppetlabs.com/browse/PUP-4178)
* [PUP-4378: Resource collectors can be assigned to variables by abusing chaining statements](https://tickets.puppetlabs.com/browse/PUP-4378)
* [PUP-4379: Future parser interpolation with [] after variable prefixed with underscore](https://tickets.puppetlabs.com/browse/PUP-4379)
* [PUP-4398: Splat unfolding not supported in method call syntax](https://tickets.puppetlabs.com/browse/PUP-4398)
* [PUP-4428: The 'err' logging function cannot be called as a statement](https://tickets.puppetlabs.com/browse/PUP-4428)
* [PUP-4462: Single backslash before $ blocks interpolation in heredoc with no escapes enabled](https://tickets.puppetlabs.com/browse/PUP-4462)
* [PUP-4463: split with just Regexp (unparameterized type) splits on whitespace](https://tickets.puppetlabs.com/browse/PUP-4463)
* [PUP-4500: Common type of two strings where only one has values is too restricted](https://tickets.puppetlabs.com/browse/PUP-4500)
* [PUP-4511: Types Array[?], Hash[?,?], and Optional[?] are not assignable to themselves](https://tickets.puppetlabs.com/browse/PUP-4511)
* [PUP-4520: Future parser is not correctly handling the default case of a case statement](https://tickets.puppetlabs.com/browse/PUP-4520)
* [PUP-4447: error message when using $name/$title variables could be more expressive](https://tickets.puppetlabs.com/browse/PUP-4447)


### New Deprecations

* [PUP-4435: Deprecate Puppet WEBrick and Rack servers](https://tickets.puppetlabs.com/browse/PUP-4435)


### API Changes

* [PUP-4438: Add required_repeated_param to 4.x function API](https://tickets.puppetlabs.com/browse/PUP-4438)




