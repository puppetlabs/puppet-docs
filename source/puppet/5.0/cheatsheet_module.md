---
layout: default
title: Module cheat sheet
---


[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: ./plugins_in_modules.html
[publishing]: ./modules_publishing.html
[template]: ./READMEtemplate.txt
[forge]: https://forge.puppet.com/
[documentation]: ./modules_documentation.html


A quick reference to Puppet module terms and concepts.

For detailed explanations of Puppet modules, see the related topics about modules.

Related topics:

* [Module fundamentals][fundamentals]: How to use and write Puppet modules.
* [Installing modules][installing]: How to install pre-built modules from the Puppet Forge.
* [Publishing modules][publishing]: How to publish your modules to the Puppet Forge.
* [Using plug-ins][plugins]: How to arrange plug-ins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [Documenting modules][documentation]: A module README template and information on providing directions for your module.

**Example Module: `/etc/puppetlabs/puppet/modules/apache`**

{:.section}
### manifests

This directory holds the module's Puppet code.

* Each `.pp` file should contain one and only one class or defined type.
* Filenames and class/defined type names are related; see the examples below.
* Within a module, the special `$module_name` variable always contains the module's name.

**apache/manifests/init.pp**

```
class apache {
...
}
```

`init.pp` is special; it should contain a class (or defined type) with the same name as the module.

**apache/manifests/vhost.pp**

```
define apache::vhost 
($port, $docroot) 
{
...
}
```

Other classes (and defined types) should be named
`modulename::filename` (without the .pp extension).


**apache/manifests/config/ssl.pp**

```
class apache::config::ssl {
...
}
```

Subdirectories add intermediate namespaces.

{:.section}
### files

Nodes can download any files in this directory from Puppet's built-in file server.

* Use the source attribute to download file contents from the server.
* Use puppet:/// URIs to specify which file to fetch.
* Files in this directory are served at `puppet:///modules/modulename/
filename`.


**apache/files/httpd.conf**

To fetch this file:

```
file {'/etc/apache2/httpd.conf':
  ensure => file,
  source => 'puppet:///modules/apache/httpd.conf',
}
```

**apache/files/extra/ssl**

Puppet's file server can navigate any subdirectories:

```
file {'/etc/apache2/httpd-ssl.conf':
  ensure => file,
  source => 'puppet:///modules/apache/extra/ssl',
}
```

{:.section}
### lib

This directory holds Ruby plugins, which can add features to Puppet and Facter.

Capache/lib/puppet/type/apache_setting.rb**
A custom type.

**apache/lib/puppet/parser/functions/htpasswd.rb**
A custom function.

apache/lib/facter/apache_confdir.rb**
A custom fact.

{:.section}
### templates

This directory holds ERB templates.

* Use the template function to create a string by rendering a template.
* Use the content attribute to fill file contents with a string.
* Template files are referenced as modulename/filename.erb.

**apache/templates/vhost.erb**

To use this template:

```
file     {'/etc/apache2/sites-enabled/wordpress.conf':
  ensure => file,
  content => template('apache/vhost.erb'),
}
```

