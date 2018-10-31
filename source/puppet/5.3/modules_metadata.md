---
layout: default
title: "Module metadata and metadata.json"
---

[module data]: ./hiera_layers.html
[hiera_yaml_4]: ./hiera_config_yaml_4.html

Your modules must contain a `metadata.json` file, which tracks important information about the module and can configure certain features. This file is located in the module's main directory, outside any subdirectories.

If you created your module with Puppet Development Kit, the `metadata.json` is completed with information you provided during the module creation interview or, if you skipped the interview, with PDK default values. You can manually edit the values in the `metadata.json` file as needed. The `metadata.json` file is used by several Puppet subsystems:

* The `puppet module` command uses `metadata.json` to display module information and prepare modules for publishing.
* The Forge requires `metadata.json` and uses it to create the module's info page and to provide dependency and other information to users installing the module.

{:.example}
### metadata.json example 

``` json
{
  "name": "puppetlabs-ntp",
  "version": "6.1.0",
  "author": "Puppet Inc",
  "summary": "Installs, configures, and manages the NTP service.",
  "license": "Apache-2.0",
  "source": "https://github.com/puppetlabs/puppetlabs-ntp",
  "project_page": "https://github.com/puppetlabs/puppetlabs-ntp",
  "issues_url": "https://tickets.puppetlabs.com/browse/MODULES",
  "dependencies": [
    { "name":"puppetlabs/stdlib","version_requirement":">= 4.13.1 < 5.0.0" }
  ],
  "data_provider": "hiera",
  "operatingsystem_support": [
    {
      "operatingsystem": "RedHat",
      "operatingsystemrelease": [
        "5",
        "6",
        "7"
      ]
    },
    {
      "operatingsystem": "CentOS",
      "operatingsystemrelease": [
        "5",
        "6",
        "7"
      ]
    }
  ],
  "requirements": [
    {
      "name": "puppet",
      "version_requirement": ">= 4.5.0 < 5.0.0"
    }
  ],
  "description": "NTP Module for Debian, Ubuntu, CentOS, RHEL, OEL, Fedora, FreeBSD, ArchLinux, Amazon Linux and Gentoo."
}
```

{:.concept}
## Formatting `metadata.json`

A `metadata.json` file uses standard JSON syntax, and contains a single JSON object. A JSON object is a map of keys to values; it's sometimes called a hash and is equivalent to a Ruby or Puppet hash.

{:.reference}
## Available `metadata.json` keys

The main JSON object in `metadata.json` can contain only certain keys.

<table>
  <tr>
      <th>Key</th>
      <th>Required?</th>
      <th>Description</th>
  </tr>
  <tr>
    <td>name</td>
    <td>Required</td>
    <td>The full name of your module, including the Puppet Forge username ("username-module").</td>
  </tr>
  <tr>
    <td>version</td>
    <td>Required</td>
    <td>The current version of your module. This should follow semantic versioning.</td>
  </tr>
  <tr>
    <td>author</td>
    <td>Required</td>
    <td>The person who gets credit for creating the module. If absent, this key defaults to the username portion of the name key.</td>
  </tr>
  <tr>
    <td>license</td>
    <td>Required</td>
    <td>The license under which your module is made available. License metadata should match an identifier provided by SPDX.</td>
  </tr>
  <tr>
    <td>summary</td>
    <td>Required</td>
    <td>A one-line description of your module.</td>
  </tr>
  <tr>
    <td>source</td>
    <td>Required</td>
    <td>The source repository for your module.</td>
  </tr>
  <tr>
    <td>dependencies</td>
    <td>Required</td>
    <td>An array of other modules that your module depends on to function. See the related topic about specifying dependencies for more details.</td>
  </tr>
  <tr>
    <td>requirements</td>
    <td>Optional</td>
    <td> <p>A list of external requirements for your module, given in the form:</p>
    
    <p>"requirements": [ {"name": "puppet", "version_requirement": "4.x"}].</p>
    
    <p> For details, see the related topic about specifying Puppet version requirements.</p>
    </td>
  </tr>
  <tr>
    <td>project_page</td>
    <td>Optional</td>
    <td>A link to your module's website to be included on the Forge.</td>
  </tr>
  <tr>
    <td>issues_url</td>
    <td>Optional</td>
    <td>A link to your module's issue tracker.</td>
  </tr>
  <tr>
    <td>operatingsystem_support</td>
    <td>Optional</td>
    <td>An array of operating systems your module is compatible with. See the related topic about specifying operating system compatibility for more details.</td>
  </tr>
  <tr>
    <td>tags</td>
    <td>Recommended: four to six tags</td>
    <td> <p>An array of key words to help people find your module (not case sensitive). For example: ["mysql", "database", "monitoring"]</p> <p>Tags cannot contain whitespace. Certain tags are prohibited, including profanity and anything resembling the $::operatingsystem fact (such as redhat, rhel, debian, solaris, aix, windows, or osx). Use of prohibited tags lowers your module's quality score on the Forge.</p>
    </td>
  </tr>
</table>

Related topics:

* [Semantic versioning](http://semver.org/)
* [SPDX](http://spdx.org/licenses/)
* [Specifying dependencies][inpage_deps]
* [Specifying requirements][inpage_require]
* [Specifying operating system compatibility][inpage_os]

{:.section}
### Deprecated keys

* `types`: Resource type documentation generated by older versions of the `puppet module` command as part of `puppet module build`. **Remove this key from your `metadata.json`.**

* `data_provider`: The experimental Puppet lookup feature used this key to enable module data. It's no longer necessary, because [Hiera 5's module layer][module data] is automatically enabled if a `hiera.yaml` file is present.

  The `data_provider` key accepts the following values:

    * `null` (or key is absent): In Puppet 4.9 and later, automatically configure module data if hiera.yaml is present. In Puppet 4.3 through 4.8, disable module data.
    * `"none"`: Disable module data.
    * `"hiera"`: In Puppet 4.9 and later, same as `null` or absent. In 4.3 through 4.8, enable module data using a [`hiera.yaml` (version 4) file][hiera_yaml_4].
    * `"function"`: Uses a hash returned by a function named `<MODULE NAME>::data`.

{:.concept}
## Specifying dependencies in modules

[inpage_deps]: #specifying-dependencies-in-modules

If your module depends on functionality in another module, you can express this in the `dependencies` key of `metadata.json`.

The `dependencies` key accepts an array of hashes. This key is required, but if your module has no dependencies, you can pass an empty array.

The hash for each dependency must contain `"name"` and `"version_requirement"` keys. For example:

``` json
"dependencies": [
  { "name": "puppetlabs/stdlib", "version_requirement": ">= 3.2.0 < 5.0.0" },
  { "name": "puppetlabs/firewall", "version_requirement": ">= 0.0.4" },
  { "name": "puppetlabs/apt", "version_requirement": ">= 1.1.0 < 2.0.0" },
  { "name": "puppetlabs/concat", "version_requirement": ">= 1.0.0 < 2.0.0" }
]
```

After you've created your module and gone through the metadata dialog, you must manually edit the `metadata.json` file to include the dependency information. For information about how to format dependency versions, see the related topic about version specifiers in module metadata.

Related topics:

* [Version specifiers in module metadata](#version-specifiers-in-module-metadata)

{:.concept}
## Specifying Puppet version requirements in modules 

[inpage_require]: #specifying-puppet-version-requirements-in-module

The `requirements` key specifies external requirements for the module, particularly the Puppet version required. Although you can express any requirement here, the Puppet Forge module pages and search function support only the "puppet" requirement for Puppet version.

Specify requirements in the following format:

* "name": The name of the requirement.
* "version_requirement": A semver version range similar to dependencies.

```json
"requirements": [
  {"name": "puppet”, “version_requirement”: ">= 4.5.0 < 5.0.0"}
]
```

For Puppet Enterprise versions, specify the core Puppet version of that version of Puppet Enterprise. For example, Puppet Enterprise 2017.1 contained Puppet 4.9. We do not recommend expressing requirements for Puppet versions earlier than 3.0, because they do not follow semantic versioning.

For information about formatting version requirements, see the related topic about version specifiers in module metadata.


{:.concept}
## Specifying operating system compatibility in modules

[inpage_os]: #specifying-operating-system-compatibility-in-modules

If you are publishing your module to the Forge, we highly recommend that you include `operatingsystem_support` in `metadata.json`. Even if you do not intend to publish your module, including this information can be helpful for tracking your work.

This key accepts an array of hashes, where each hash contains `operatingsystem` and `operatingsystemrelease` keys.

* `operatingsystem` should be a string. The Puppet Forge uses this for search filters.
* `operatingsystemrelease` should be an array of strings. The Puppet Forge displays these versions on module pages, and you can format them in whatever way makes sense for the OS in question.

``` json
"operatingsystem_support": [
  {
  "operatingsystem":"RedHat",
  "operatingsystemrelease":[ "5.0", "6.0" ]
  },
  {
  "operatingsystem": "Ubuntu",
  "operatingsystemrelease": [
    "12.04",
    "10.04"
    ]
  }
]
```

{:.concept}
## Version specifiers in module metadata

Your module metadata specifies your own module's version as well as the versions for your module's dependencies and requirements. When you specify a version for a module dependency or requirement, you can use several version specifiers that allow multiple versions.

We strongly recommend following the [Semantic Versioning](http://semver.org/spec/v1.0.0.html) specification for versioning your module. This helps others rely on your modules without being surprised by changes you make.

You can take advantage of semantic version when you specify dependencies or requirements in your metadata. For example, if you want to allow updates but avoid breaking changes, you can specify a range of acceptable versions, such as a major version with any minor version:

```json
"dependencies": [
  { "name": "puppetlabs/stdlib", "version_requirement": "4.x" },
]
```

If a dependency is not installed, the `puppet module` command installs the most recent specified version of that dependency. If the dependency is already installed at a version accepted in the module's `metadata.json` (even if not the latest version), Puppet doesn't update the dependency.

The version specifiers allowed in module dependencies are:

Format   | Description
----------------|:---------------
`1.2.3` | A specific version.
`> 1.2.3` | Greater than a specific version.
`< 1.2.3` | Less than a specific version.
`>= 1.2.3` | Greater than or equal to a specific version.
`<= 1.2.3` | Less than or equal to a specific version.
`>= 1.0.0 < 2.0.0` | Range of versions; both conditions must be satisfied. (This example would match 1.0.1 but not 2.0.1.)
`1.x` | A semantic major version. (This example would match 1.0.1 but not 2.0.1, and is shorthand for `>= 1.0.0 < 2.0.0`.)
`1.2.x` | A semantic major and minor version. (This example would match 1.2.3 but not 1.3.0, and is shorthand for `>= 1.2.0 < 1.3.0`.)

**Note:** You cannot mix semantic versioning shorthand (.x) with greater than or less than versioning syntax. For example, the following are not allowed:

* `>= 3.2.x`
* `< 4.x`

{:.section}
### Best practice: Set an upper bound for version 

When you specify versions for dependencies or requirements, set the upper version boundary in your version range; for example, `1.x` (any version of `1`, but less than `2.0.0`) or `>= 1.0.0 < 3.0.0` (greater than or equal to `1.0.0`, but less than `3.0.0`). If your module is compatible with the latest released versions of its dependencies, set the upper bound to exclude the next, unreleased major version.

Without this upper bound, users might run into compatibility issues across major version boundaries, where incompatible changes occur. It is better to be conservative and set an upper bound, and then release a newer version of your module after a major version release of the dependency. Otherwise, you could suddenly have to fix broken dependencies.

If your module is compatible with only one major or minor version, you can use the semantic major/minor version shorthand (e.g., `1.x`). If your module is compatible with versions crossing major version boundaries, such as with `stdlib`, you can set your supported version range to the next unreleased major version. For example:

```json
  "dependencies": [
{ "name": "puppetlabs/stdlib", "version_requirement": ">= 3.2.0 < 5.0.0" }
```

In this example, the current version of `stdlib` is 4.8.0, and version 5.0.0 is not yet released. Under the rules of semantic versioning, 5.0.0 is likely to have incompatibilities, but every version of 4.x should be compatible. We don't know yet if the module will be compatible with 5.x. So we set the upper bound of the version dependency to less than the next known incompatible release (or major version).

