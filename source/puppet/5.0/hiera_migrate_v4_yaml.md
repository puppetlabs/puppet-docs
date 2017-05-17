---
title: "Hiera: Convert an experimental (version 4) hiera.yaml to version 5"
toc: false
---

[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html

[v5_defaults]: ./hiera_config_yaml_5.html#the-defaults-key
[custom_hash]: ./hiera_custom_data_hash.html

If you used the experimental version of Puppet lookup (Hiera 5's predecessor), you might have some [version 4 hiera.yaml files][v4] in your environments and modules. Hiera 5 can use these as-is, and they'll keep working until Puppet 6. But you'll need to convert them eventually, especially if you want to use any backends other than YAML or JSON.

Luckily, these formats are very similar, and converting them is simple.

A version 4 hiera.yaml usually looks something like this:

``` yaml
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 4
datadir: data
hierarchy:
  - name: "Nodes"
    backend: yaml
    path: "nodes/%{trusted.certname}"

  - name: "Exported JSON nodes"
    backend: json
    paths:
      - "nodes/%{trusted.certname}"
      - "insecure_nodes/%{facts.networking.fqdn}"

  - name: "virtual/%{facts.virtual}"
    backend: yaml

  - name: "common"
    backend: yaml
```

To convert it to version 5, make the following changes:

* Change the value of the `version` key to `5`.
* Add a file extension to every file path --- use `"common.yaml"`, not `"common"`. **This is the easiest thing to miss.**
* If any hierarchy levels are missing a `path`, you must add one. In version 5, `path` no longer defaults to the value of `name`.
* If there's a top-level `datadir` key, change it to [a `defaults` key][v5_defaults]. While you're at it, you can set a default backend. For example:

  ``` yaml
  defaults:
    datadir: data
    data_hash: yaml_data
  ```

* In each hierarchy level, delete the `backend` key and replace it with a `data_hash` key. (If you set a default backend in the `defaults` key, you can omit it here.)

  v4 backend      | v5 equivalent
  ----------------|--------------
  `backend: yaml` | `data_hash: yaml_data`
  `backend: json` | `data_hash: json_data`

After being converted to version 5, the example from above would look like this:

``` yaml
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 5
defaults:
  datadir: data          # Datadir has moved into `defaults`.
  data_hash: yaml_data   # Default backend: New feature in v5.
hierarchy:
  - name: "Nodes"        # Can omit `backend` if using the default.
    path: "nodes/%{trusted.certname}.yaml"   # Add file extension!

  - name: "Exported JSON nodes"
    data_hash: json_data        # Specifying a non-default backend.
    paths:
      - "nodes/%{trusted.certname}.json"
      - "insecure_nodes/%{facts.networking.fqdn}.json"

  - name: "Virtualization platform"
    path: "virtual/%{facts.virtual}.yaml"   # Name and path are now separated.

  - name: "common"
    path: "common.yaml"
```


For full syntax details, see [the hiera.yaml version 5 reference][v5].

## Delete the `environment_data_provider` and `data_provider` settings

If you used the experimental version of Puppet lookup, you had to use a setting to enable it for an environment or module. Hiera 5 doesn't need these settings, and you can delete them. Remove any of the following:

* `environment_data_provider` in puppet.conf.
* `environment_data_provider` in environment.conf.
* `data_provider` in a module's metadata.json.

## What about experimental-style data provider functions?

Puppet lookup had some partially-baked custom backend support, where you could set `data_provider = function` and create a function with a magic name that returned a hash.

If you actually used that, you don't have to throw your work away; you can convert your function to a Hiera 5 `data_hash` backend as follows:

* Your original function took no arguments. Change its signature to accept two arguments: a `Hash` and a `Puppet::LookupContext` object. You don't have to do anything with these; you just have to accept them. For more info, see [the documentation for data hash backends][custom_hash].
* Delete the data provider setting, as described in the previous section.
* Create a [version 5 hiera.yaml][v5] file for the affected environment or module, and add a hierarchy level as follows:

  ``` yaml
  - name: <ARBITRARY NAME>
    data_hash: <NAME OF YOUR FUNCTION>
  ```

  It dosen't need a `path`, `datadir`, or any other options.
