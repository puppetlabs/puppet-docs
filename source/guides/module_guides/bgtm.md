---
layout: default
nav: /_includes/best_practice_guides.html
title: Beginner's Guide to Modules
---

[structure]: ./images/bgtmclassstructure.png
[main]: ./images/bgtmntpinit.png
[install]: ./images/bgtmntpinstall.png
[config]: ./images/bgtmntpconfig.png
[service]: ./images/bgtmntpservice.png


This module guide will help you learn how to create fantastic modules by introducing Puppet Labs' module best practice [standards and architecture](/guides/style_guide.html). Contributors to this guide have spent years creating Puppet modules, falling into every pitfall, trap, and mistake you could hope to make. This guide is intended to help you avoid our mistakes through an approachable introduction to module best practices.

##Requirements

Before reading this guide we recommend that you become familiar with [Puppet](/learning/modules1.html) such that you have a basic understanding of the Puppet [language](/learning/#contents), you know what constitutes a [class](/learning/modules1.html#classes), and you know how to put together a [basic module](/learning/modules1.html#the-modulepath).

##Step One: Giving Your Module Purpose

Before you begin writing your module, you must define what it will do. Defining the range of your module's work helps you avoid accidentally creating a sprawling monster of a module that is unwieldy and difficult to work with. Your module should have one area of responsibility. For example, a good module addresses installing MySQL but **does not address** installing another program/service that requires MySQL.

To help plan your module appropriately, ask yourself some questions:

* What task do you need your module to accomplish?
* What work is your module addressing?
* What higher function should your module have within your Puppet environment?

(*Tip: If you describe the function of your module and you find yourself using the word 'and', it's time to split the module at the 'and'*.)

It is standard practice for Puppet users to have upwards of 200 modules in their environment. Each module in your environment should contain related resources that enable it to accomplish a task, the simpler the better. Puppet Labs best practice strongly recommends creating multiple modules when and where applicable. The practice of having many small, focused modules is encouraged, as it promotes code reuse and turns modules into building blocks rather than full solutions.

As an example, let's take a look at the [puppetlabs/puppetdb](http://forge.puppetlabs.com/puppetlabs/puppetdb) module. This module deals solely with the the setup, configuration and management of PuppetDB. However, PuppetDB stores its data in a PostgreSQL database. Rather than having the module manage PostgreSQL, the author included the [puppetlabs/postgresql](http://forge.puppetlabs.com/puppetlabs/postgresql) module as a dependency, leveraging the postgresql module's classes and resources to build out the right configuration for PuppetDB. Similarly, the puppetdb module needs to manipulate puppet.conf in order to operate PuppetDB. Instead of having the puppetdb module handle it internally, the author took advantage of the [puppetlabs/inifile](http://forge.puppetlabs.com/puppetlabs/inifile) module to enable puppetdb to make only the required edits to puppet.conf.

##Step Two: Module Structure

The ideal module is one that is designed to manage a single piece of software from installation through setup, configuration, and service management.

We acknowledge that there are many variations in software that modules may manage. A large majority of modules should be able to follow this best practices structure. However, we acknowledge that this structure may not be appropriate for some. Where possible, we will call out this incompatibility and recommend best practice alternatives.

This section will cover:

* [2a. How to design your module's classes](#a-class-design)
* [2b. How to develop useful parameters](#b-parameters)
* [2c. How best to order your classes (rather than resources)](#c-ordering), and
* [2d. How to leverage and utilize dependencies](#d-dependencies)

To demonstrate a real-world best practices standard module, we will walk through the structure of the [puppetlabs/ntp](http://forge.puppetlabs.com/puppetlabs/ntp) module.

###2a: Class Design

Module development follows a similar [principle](http://www.amazon.com/dp/0201485672/?tag=stackoverfl08-20) as software development, essentially: "good software is comprised of many small, easily tested things composed together." A good module is comprised of small, self-contained classes that do one thing only. Classes within a module are similar to functions in programming, using parameters to perform related steps that create a coherent whole.

In general, best practices naming convention states that the file must be named the same as the class or definition that is contained within (with the sole exception of the [main class](#module)), and classes must be named after their function.

In terms of class structure we recommend the following (more detail below):

![module class structure][structure]

*Note: Following this structure will, in some cases, necessitate the use of the anchor pattern. Please [see below](#anchoring) for more information on anchoring.*

#### `module`

The main class of any module must share the name of the module and be located in the `init.pp` file. The name and location of the main module class is extremely important, as it guides the [autoloader](/puppet/2.7/reference/lang_namespaces.html#autoloader-behavior) behavior. The main class of a module is its interface point and ought to be the only parameterized class if possible. Limiting the parameterized classes to just the main class allows you to control usage of the entire module with the inclusion of a single class.  This class should provide sensible defaults so that a user can get going with `include module`.

For instance, this is how the ntp module's main class is structured:

{% highlight ruby %}
    class ntp (
      $autoupdate        = $ntp::params::autoupdate,
      $config            = $ntp::params::config,
      $config_template   = $ntp::params::config_template,
      $driftfile         = $ntp::params::driftfile,
      $keys_enable       = $ntp::params::keys_enable,
      $keys_file         = $ntp::params::keys_file,
      $keys_controlkey   = $ntp::params::keys_controlkey,
      $keys_requestkey   = $ntp::params::keys_requestkey,
      $keys_trusted      = $ntp::params::keys_trusted,
      $package_ensure    = $ntp::params::package_ensure,
      $package_name      = $ntp::params::package_name,
      $panic             = $ntp::params::panic,
      $preferred_servers = $ntp::params::preferred_servers,
      $restrict          = $ntp::params::restrict,
      $servers           = $ntp::params::servers,
      $service_enable    = $ntp::params::service_enable,
      $service_ensure    = $ntp::params::service_ensure,
      $service_manage    = $ntp::params::service_manage,
      $service_name      = $ntp::params::service_name,
      $udlc              = $ntp::params::udlc
    ) inherits ntp::params {
{% endhighlight %}

#### `module::install`

The install class must be located in the `install.pp` file, and should contain all of the resources related to getting the software the module manages onto the node.

The install class must be named `module::install`, as ntp demonstrates:

{% highlight ruby %}
    class ntp::install inherits ntp {

      package { 'ntp':
        ensure => $package_ensure,
        name   => $package_name,
      }

    }
{% endhighlight %}

#### `module::config`

The resources related to configuring the installed software should be placed in a config class. The config class must be named `module::config` and must be located in the `config.pp` file.

See, for example, the ntp module:

{% highlight ruby %}
    class ntp::config inherits ntp {

      if $keys_enable {
        $directory = dirname($keys_file)
        file { $directory:
          ensure  => directory,
          owner   => 0,
          group   => 0,
          mode    => '0755',
          recurse => true,
        }
      }

      file { $config:
        ensure  => file,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template($config_template),
      }

    }
{% endhighlight %}

#### `module::service`

The remaining service resources, and anything else related to the running state of the software, should be contained in the service class. The service class must be named `module::service` and must be located in the `service.pp` file.

For example,

{% highlight ruby %}
    class ntp::service inherits ntp {

      if ! ($service_ensure in [ 'running', 'stopped' ]) {
        fail('service_ensure parameter must be running or stopped')
      }

      if $service_manage == true {
        service { 'ntp':
          ensure     => $service_ensure,
          enable     => $service_enable,
          name       => $service_name,
          hasstatus  => true,
          hasrestart => true,
        }
      }

    }
{% endhighlight %}

### 2b: Parameters

Parameters form the public API of your module.  They are the most important interface you expose, and care should be taken to give a good balance to the number and variety of parameters so users can customize their interactions with the module. Below, we will walk through best practices for naming and developing parameters.

####Naming

Naming consistency is imperative for community comprehension and assists in troubleshooting and collaborating on module development. Best practices recommend the pattern of `thing_property` for naming parameters.

For example, in the ntp module

{% highlight ruby %}
    class ntp::install inherits ntp {

      package { 'ntp':
        ensure => $package_ensure,
        name   => $package_name,
      }

    }
{% endhighlight %}

If you have a parameter that toggles an entire function on and off, the naming convention can be amended to `thing_manage`. This applies, in particular, to Boolean toogles such as managing the installation altogether. The `thing_manage` convention allows you to wrap all of the resources in an `if $package_manage {}` test.

Consistent naming across modules helps with the readability and usability of your code. While Puppet Labs doesn't have a set of standards for parameters to conform to, there's a community project working to establish one. If you care about name standardization, offer issues and pull requests [here](https://github.com/stdmod/puppet-modules/blob/master/Parameters_List.md).

####Number

If you want to maximize the usability of your module without requiring users to modify it, you should make it more flexible through the addition of parameters. Adding parameters enables more customized use of your module.  While this can feel frustrating as an author, best practice is to embrace parameters rather than avoid them.

You must not hardcode data in your modules, and having more parameters is the best alternative. Hardcoded data results in an inflexible module that requires manifest changes in order for it to be used in slightly different circumstances.

Adding parameters that allow you to override templates is an anti-pattern to avoid.  Parameters that allow overriding templates lead to end users overriding your template with a custom template that contains hardcoded additional parameters. Hardcoding parameters in a template should be avoided, as it leads to stagnation and inhibits flexibility over time.  It is far better to create more parameters and modify the original template, or have a parameter which accepts an arbitrary chunk of text added to the template, than it is to override the template with a customized one.

For an example of a module that capitalizes on offering many parameters, please see [puppetlabs/apache](http://forge.puppetlabs.com/puppetlabs/apache).

###2c: Ordering

Best practices recommend basing your requires, befores, and other ordering-related dependencies on classes rather than resources.  Class-based ordering allows you to shield the implementation details of each class from the other classes. You can do things like:

{% highlight ruby %}
    file { 'configuration':
      ensure  => present,
      require => Class['module::install'],
    }
{% endhighlight %}

Rather than making a require to several packages,  the above ordering allows you to refactor and improve `module::install` without having to adjust the manifests of other classes to match the changes.

####Containment and Anchoring

Classes do not _automatically_ contain the classes they declare. (This is because classes may be declared in several places via `include` and similar functions. Most of these places shouldn't contain the class, and trying to contain it everywhere would cause huge problems.)

Thus, if you want to allow other modules to form ordering relationships with your module, you should ensure that your main class(es) will explicitly _contain_ any subordinate classes they declare. For more information and context, you can see [the Containment page of the Puppet reference manual](/puppet/latest/reference/lang_containment.html).

In Puppet 3.4.0 / Puppet Enterprise 3.2 and later, you can contain classes by using [the `contain` function](/references/latest/function.html#contain) on them. To support versions prior to 3.4.0 / PE 3.2, you must use the **anchor pattern** to hold those classes in place. See below for an example of anchoring. (*Note: anchoring requires [puppetlabs-stdlib](http://forge.puppetlabs.com/puppetlabs/stdlib)*.)

Two resources to anchor things to:

{% highlight ruby %}
    anchor { 'module::begin': }
    anchor { 'module::end' }
{% endhighlight %}

The anchoring:

{% highlight ruby %}
    Anchor['module::begin'] ->
      Class['module::install'] ->
      Class['module::config']  ->
      Class['module::service'] ->
    Anchor['module::end']
{% endhighlight %}

This enforces ordering, so `::install` will happen before `::config`, and
`::config` before `::service`.

For a real world example of anchoring in action, please see Hunter's [puppet-wordpress](https://github.com/hunner/puppet-wordpress/blob/master/manifests/init.pp) module.

###2d: Dependencies

If your module's functionality depends on another module, then you must  list these dependencies and include them directly, rather than indirectly hoping they are included in the catalog.

This means you must `include x` in your `init.pp` to ensure the dependency is included in the catalog. You must also add the dependency to the [Modulefile](/guides/style_guide.html#module-metadata) and `.fixtures.yml`. (`.fixtures.yml` is a file used exclusively by rspec to pull in dependencies required to successfully run unit tests.)

##Step Three: Module Testing

Congratulations! You have written a module that accomplishes a task; has appropriate names, classes, and parameters;  is ordered correctly; and that lists its dependencies. Now you must ensure that the module works in a variety of conditions, and that the options and parameters of your module work together to an appropriate end result.  We have several testing frameworks available to help you write unit and acceptance tests.

###rspec-puppet

Rspec-Puppet provides a unit-testing framework for Puppet. It extends RSpec to allow the testing framework to understand Puppet catalogs, the artifact it specializes in testing.  You can write tests, as in the below example, to test that aspects of your module work as intended.

    it { should contain_file('configuration') }

RSpec lets you provide facts, like `osfamily`, in order to test the module in various scenarios. A typical use case for Puppet Labs is iteration over a list of operating systems, asserting that the package and service should exist in the catalog for every operating system we support.

You can read more at [http://rspec-puppet.com/](http://rspec-puppet.com/).

###rspec-system

[Rspec-system](https://github.com/puppetlabs/rspec-system) is an acceptance/integration testing framework that provisions, configures, and uses various [Vagrant](http://www.vagrantup.com/) virtual machines to apply your puppet module to a real machine and then test things (such as ensuring a package is installed or a service is running) from the command line within the VM.

At Puppet Labs, we use rspec-system to do things like build a Debian virtual machine, run the apache module on it, then ensure we can curl to http://localhost:80 and retrieve the contents of a virtual host.

###serverspec

[Serverspec](http://serverspec.org/) provides additional testing constructs (such as `be_running` and `be_installed`) for rspec-system, and allows you to abstract away details of the underlying distribution when testing. It lets you write tests like:

    describe service('httpd') do
      it { should be_running }
    end

It then knows how to translate `be_running` into shell commands for different distributions.

###puppetlabs-spec-helper

The [puppetlabs-spec-helper](https://github.com/puppetlabs/puppetlabs_spec_helper) is a gem that automates some of the tasks required to test modules.  It provides a number of default rake tasks that allow you to standardize testing across modules, and it provides some glue code between rspec-puppet and actual modules.  Most of the time you need do nothing more than add it to the Gemfile of the project and add the following the to the Rakefile:

    require 'puppetlabs_spec_helper/rake_tasks'

##Step Four: Module versioning

Modules, like any other piece of software, must be versioned and released when changes are made.  We use and recommend using [SemVer](http://semver.org/). It sets out the exact rules around when to increment major versions and so forth.

Once you've decided on the new version number, you must increase the version number metadata in the Modulefile. Versioning within the Modulefile allows you to build Puppet environments by picking and choosing specific versions of a module or set of modules.

It also allows you to create a list of dependencies in the Modulefile of your modules with specific versions of dependent modules, which ensures your module isn't used with an ancient dependency that won't work. Versioning also enables workflow management by allowing you to easily use different versions of modules in different environments.

##Step Five: Module releasing

We encourage you to publish your modules on the [Puppet Forge](http://forge.puppetlabs.com). Sharing your modules allows other users to write improvements to the modules you make available and contribute them back to you, effectively giving you free improvements to your modules! Additionally, publishing your modules to the Forge helps foster community among Puppet users, and allows other Puppet community members to download and use your module in order to avoid reinventing the wheel. If the Puppet community routinely releases and hacks on modules on the Forge, the quality of available Puppet modules increases dramatically and gives you access to more modules to download and modify for your own purposes. Details on how to publish modules to the Puppet Forge can be found [here](/puppet/latest/reference/modules_publishing.html).

##Community Resources

[All the module basics](/puppet/latest/reference/modules_fundamentals.html) (part of the Puppet Reference Guide)

[Pro Puppet](http://www.apress.com/9781430260400) (an in-depth guide to Puppet by Spencer Krum, Ben Kero, William Van Hevelingen, Jeff McCune and James Turnbull)

[Puppet Types and Providers](http://shop.oreilly.com/product/0636920026860.do) (a book on extending Puppet's resource model by Dan Bode & Nan Liu)

[The Puppet Forge](http://forge.puppetlabs.com)

`#puppet` on IRC

[Puppet Users mailing list](https://groups.google.com/forum/#!forum/puppet-users)

