---
layout: default
title: Beginner's guide to writing modules
---

[structure]: ./images/bgtmclassstructure.png
[anchor]: ./lang_containment.html#anchor-pattern-containment-for-compatibility-with-puppet--340
[pdk]: {{pdk}}/pdk.html

Learn how to create fantastic modules by introducing module best practices [standards and architecture](./style_guide.html).

Contributors to this guide have spent years creating Puppet modules, falling into every pitfall, trap, and mistake you could hope to make. This guide is intended to help you avoid our mistakes through an approachable introduction to module best practices.

Before you begin, you should be familiar with Puppet such that you have a basic understanding of the Puppet [language](./lang_summary.html), you know what constitutes a [class](./lang_classes.html), and you know how to put together a [basic module](./modules_fundamentals.html).

{:.concept}
## Giving your module purpose

Before you begin writing your module, you must define what it will do.

Defining the range of your module's work helps you avoid accidentally creating a sprawling monster of a module that is unwieldy and difficult to work with. Your module should have one area of responsibility. For example, a good module addresses installing MySQL but **does not address** installing another program/service that requires MySQL.

To help plan your module appropriately, ask yourself some questions:

* What task do you need your module to accomplish?
* What work is your module addressing?
* What higher function should your module have within your Puppet environment?

> **Tip**: If you describe the function of your module and you find yourself using the word 'and', it's time to split the module at the 'and'.

It is standard practice for Puppet users to have upwards of 200 modules in their environment. Each module in your environment should contain related resources that enable it to accomplish a task, the simpler the better. We strongly recommend creating multiple modules when and where applicable. The practice of having many small, focused modules is encouraged, as it promotes code reuse and turns modules into building blocks rather than full solutions.

As an example, let's take a look at the [puppetlabs/puppetdb](http://forge.puppet.com/puppetlabs/puppetdb) module. This module deals solely with the the setup, configuration and management of PuppetDB. However, PuppetDB stores its data in a PostgreSQL database. Rather than having the module manage PostgreSQL, the author included the [puppetlabs/postgresql](http://forge.puppet.com/puppetlabs/postgresql) module as a dependency, leveraging the postgresql module's classes and resources to build out the right configuration for PuppetDB. Similarly, the puppetdb module needs to manipulate puppet.conf in order to operate PuppetDB. Instead of having the puppetdb module handle it internally, the author took advantage of the [puppetlabs/inifile](http://forge.puppet.com/puppetlabs/inifile) module to enable puppetdb to make only the required edits to puppet.conf.

{:.concept}
## Structuring your module

The ideal module manages a single piece of software from installation through setup, configuration, and service management.

We acknowledge that there are many variations in software that modules can manage. A large majority of modules should be able to follow this best practices structure. However, we acknowledge that this structure might not be appropriate for some. Where possible, we call out this incompatibility and recommend best practice alternatives.

This section covers:

* [2a. How to design your module's classes](#a-class-design).
* [2b. How to develop useful parameters](#b-parameters).
* [2c. How best to order your classes (rather than resources)](#c-ordering).
* [2d. How to leverage and utilize dependencies](#d-dependencies).

To demonstrate a real-world best practices standard module, we will walk through the structure of the [puppetlabs/ntp](http://forge.puppet.com/puppetlabs/ntp) module.

{:.concept}
### Class design

A good module is comprised of small, self-contained classes that each do only one thing. Classes within a module are similar to functions in programming, using parameters to perform related steps that create a coherent whole.

In general, the best practice naming convention is that the file must be named the same as the class or definition that is contained within (with the sole exception of the [main class](#module)), and classes must be named after their function.

In terms of class structure we recommend the following (more detail below):

![module class structure][structure]

{:.section}
#### `module`

The main class of any module must share the name of the module and be located in the `init.pp` file. The name and location of the main module class is extremely important, as it guides the [autoloader](./lang_namespaces.html#autoloader-behavior) behavior. The main class of a module is its interface point and ought to be the only parameterized class if possible. Limiting the parameterized classes to just the main class allows you to control usage of the entire module with the inclusion of a single class. This class should provide sensible defaults so that a user can get going with `include module`.

For instance, the main `ntp` class in the `ntp` module looks like this:

```ruby
class ntp (
  Boolean $broadcastclient,
  Stdlib::Absolutepath $config,
  Optional[Stdlib::Absolutepath] $config_dir,
  String $config_file_mode,
  Optional[String] $config_epp,
  Optional[String] $config_template,
  Boolean $disable_auth,
  Boolean $disable_dhclient,
  Boolean $disable_kernel,
  Boolean $disable_monitor,
  Optional[Array[String]] $fudge,
  Stdlib::Absolutepath $driftfile,
 ...
```

{:.section}
#### `module::install`

The install class must be located in the `install.pp` file. It should contain all of the resources related to getting the software that the module manages onto the node.

The install class must be named `module::install`, as in the `ntp` module:

``` ruby
class ntp::install {

  if $ntp::package_manage {

    package { $ntp::package_name:
      ensure => $ntp::package_ensure,
    }

  }

}
```

{:.section}
#### `module::config`

The resources related to configuring the installed software should be placed in a config class. The config class must be named `module::config` and must be located in the `config.pp` file.

For example, see the `module::config` class in the `ntp` module:

``` ruby
class ntp::config {

  #The servers-netconfig file overrides NTP config on SLES 12, interfering with our configuration.
  if $facts['operatingsystem'] == 'SLES' and $facts['operatingsystemmajrelease'] == '12' {
    file { '/var/run/ntp/servers-netconfig':
      ensure => 'absent'
    }
  }

  if $ntp::keys_enable {
    case $ntp::config_dir {
      '/', '/etc', undef: {}
      default: {
        file { $ntp::config_dir:
          ensure  => directory,
          owner   => 0,
          group   => 0,
          mode    => '0775',
          recurse => false,
        }
      }
    }

    file { $ntp::keys_file:
      ensure  => file,
      owner   => 0,
      group   => 0,
      mode    => '0644',
      content => epp('ntp/keys.epp'),
    }
  }
...
```

{:.section}
#### `module::service`

The remaining service resources, and anything else related to the running state of the software, should be contained in the service class. The service class must be named `module::service` and must be located in the `service.pp` file.

For example:

``` ruby
class ntp::service {

  if ! ($ntp::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $ntp::service_manage == true {
    service { 'ntp':
      ensure     => $ntp::service_ensure,
      enable     => $ntp::service_enable,
      name       => $ntp::service_name,
      provider   => $ntp::service_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
```

{:.concept}
### Parameters

Parameters form the public API of your module.

They are the most important interface you expose, and you should take care to balance to the number and variety of parameters so that users can customize their interactions with the module. Below, we walk through best practices for naming and developing parameters.

{:.section}
#### Naming parameters

Naming consistency is imperative for community comprehension and assists in troubleshooting and collaborating on module development.

Best practices recommend the pattern of `thing_property` for naming parameters.

For example, in the `ntp` module

``` ruby
class ntp::install {

  if $ntp::package_manage {

    package { $ntp::package_name:
      ensure => $ntp::package_ensure,
    }

  }

}
```

If you have a parameter that toggles an entire function on and off, the naming convention can be amended to `thing_manage`. This applies, in particular, to Boolean toggles, such as when the module manages the installation altogether. The `thing_manage` convention allows you to wrap all of the resources in an `if $package_manage {}` test, as shown in the `ntp` example above.

Consistent naming across modules helps with the readability and usability of your code.

{:.section}
#### Number of parameters

To maximize the usability of your module, make it flexible by adding parameters. Parameters enable users to customize their use of your module.

You must not hardcode data in your modules, and having more parameters is the best alternative. Hardcoding data in your module makes it inflexible, and means your module requires manifest changes to be used in even slightly different circumstances.

Avoid adding parameters that allow you to override templates. When your parameters allow  template overrides, users can override your template with a custom template that contains additional hardcoded parameters. Hardcoded parameters in templates inhibits flexibility over time. It is far better to create more parameters and then modify the original template, or have a parameter which accepts an arbitrary chunk of text added to the template, than it is to override the template with a customized one.

For an example of a module that capitalizes on offering many parameters, please see [puppetlabs/apache](http://forge.puppet.com/puppetlabs/apache).

{:.concept}
### Ordering

Best practice is to base all order-related dependencies (such as `require` and `before`) on classes rather than resources. Class-based ordering allows you to shield the implementation details of each class from the other classes.

For example:

``` ruby
    file { 'configuration':
      ensure  => present,
      require => Class['module::install'],
    }
```

Rather than making a `require` to several packages, the above ordering allows you to refactor and improve `module::install` without adjusting the manifests of other classes to match the changes.

{:.section}
#### Containment and anchoring

To allow other modules to form ordering relationships with your module, ensure that your main classes explicitly _contain_ any subordinate classes they declare.

Classes do not _automatically_ contain the classes they declare. This is because classes can be declared in several places via `include` and similar functions. To contain classes, use [the `contain` function](./function.html#contain). For more information and context about containment, see [the containment docs](./lang_containment.html).

For example, the `ntp` module uses containment in the main `ntp` class:

```
contain ntp::install
  contain ntp::config
  contain ntp::service
  Class['::ntp::install'] ->
  Class['::ntp::config'] ~>
  Class['::ntp::service']
```

Containment is supported in Puppet 3.4 and later. To support versions prior to Puppet 3.4 (or Puppet Enterprise 3.2), you must use the [anchor pattern][anchor] to hold those classes in place. Anchoring requires [puppetlabs-stdlib](http://forge.puppet.com/puppetlabs/stdlib).

{:.concept}
### Dependencies

If your module's functionality depends on another module, then you must list these dependencies and include them directly.

This means you must `include x` in the main class to ensure the dependency is included in the catalog. You must also add the dependency to the module's [metadata.json](./style_guide.html#module-metadata) and `.fixtures.yml`. (`.fixtures.yml` is a file used exclusively by rspec to pull in dependencies required to successfully run unit tests.)

{:.concept}
## Testing your module

Ensure that the module works in a variety of conditions, and that the options and parameters of your module work together to an appropriate end result.

We recommend several testing frameworks available to help you write unit and acceptance tests. Some of these tools are already included in the Puppet Development Kit (PDK; see the [PDK][pdk] documentation for details.

{:.concept}
### rspec-puppet

RSpec-Puppet provides a unit-testing framework for Puppet. It extends RSpec to allow the testing framework to understand Puppet catalogs, the artifact it specializes in testing. You can write tests, as in the below example, to test that aspects of your module work as intended.

```
it { should contain_file('configuration') }
````

RSpec lets you provide facts, like `osfamily`, in order to test the module in various scenarios.

A typical use of RSpec is to iterate over a list of operating systems, asserting that the package and service should exist in the catalog for every operating system your module supports.

You can read more at [http://rspec-puppet.com/](http://rspec-puppet.com/).

{:.concept}
### puppetlabs-spec-helper

The [puppetlabs-spec-helper](https://github.com/puppetlabs/puppetlabs_spec_helper) is a gem that automates some of the tasks required to test modules.

It's particularly useful in conjunction with rspec-puppet. Puppet-spec-helper provides default rake tasks that allow you to standardize testing across modules, and it provides some glue code between rspec-puppet and actual modules. Usually, you only need to add it to the Gemfile of the project, and then add the following the to the Rakefile:

```
require 'puppetlabs_spec_helper/rake_tasks'
```

{:.concept}
### Beaker-rspec

[Beaker-rspec](https://github.com/puppetlabs/beaker-rspec) is an acceptance/integration testing framework.

It provisions one or more virtual machines on various hypervisors (such as [Vagrant](http://www.vagrantup.com/)) and then checks the result of applying your module in a realistic environment.

{:.section}
#### serverspec

[Serverspec](http://serverspec.org/) provides additional testing constructs (such as `be_running` and `be_installed`) for beaker-rspec. It allows you to abstract away details of the underlying distribution when testing. It lets you write tests like:

    describe service('httpd') do
      it { should be_running }
    end

It then knows how to translate `be_running` into shell commands for different distributions.

{:.concept}
## Versioning your module

Modules, like any other piece of software, must be versioned and released when changes are made. We use and recommend semantic versioning, which sets out specific rules for when to increment major and minor versions.

After you've decided on the new version number, you must increase the version number in the metadata.json.

This allows you to create a list of dependencies in the metadata.json of your modules with specific versions of dependent modules, which ensures your module isn't used with an old dependency that won't work. Versioning also enables workflow management by allowing you to easily use different versions of modules in different environments.

{:.concept}
## Documenting your module

We recommend that you document your module with a README explaining how your module works and a Reference section detailing information about your module's classes, defined types, functions, and resource types and providers.

For guidance, see our modules documentation [guide](./modules_documentation.html)and the [documentation](./style_guide.html#module-documentation) section of the Puppet Language Style Guide.

{:.concept}
## Releasing your module

We encourage you to publish your modules on the [Puppet Forge](http://forge.puppet.com).

Sharing your modules allows other users to write improvements to the modules you make available and contribute them back to you, effectively giving you free improvements to your modules.

Additionally, publishing your modules to the Forge helps foster community among Puppet users, and allows other Puppet community members to download and use your module. If the Puppet community routinely releases and iterates on modules on the Forge, the quality of available modules increases dramatically and gives you access to more modules to download and modify for your own purposes. Details on how to publish modules to the Forge can be found [here](./modules_publishing.html).

{:.concept}
## Community Resources

For beginning module authors, a variety of community resources are available.

[Module basics](./modules_fundamentals.html)

[Puppet Development Kit][pdk]

[Puppet Language Style Guide](./style_guide.html)

[The Forge](http://forge.puppet.com)

The [puppet-users mailing list](https://groups.google.com/forum/#!forum/puppet-users)

`#puppet` on IRC

[Puppet Community on Slack](https://slack.puppet.com/)

