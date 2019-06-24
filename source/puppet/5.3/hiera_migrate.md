---
title: "Upgrading to Hiera 5"
---

[layers]: ./hiera_intro.html#Hiera's-three-config-layers
[eyaml_v5]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-hiera-eyaml
[backends]: ./hiera_custom_backends.html
[puppet.conf]: ./config_file_main.html
[automatic]: ./hiera_automatic.html
[legacy_backend]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-legacy-hiera-3-backends
[eyaml_v5]: ./hiera_config_yaml_5.html
[control repo]: {{pe}}/cmgmt_control_repo.html
[v3]: ./hiera_config_yaml_3.html
[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html
[merging]: ./hiera_merging.html
[v5_defaults]: ./hiera_config_yaml_5.html#the-defaults-key
[v5_builtin]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends
[eyaml_v5]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-hiera-eyaml
[hash merge operator]: ./lang_expressions.html#merging
[class inheritance]: ./lang_classes.html#inheritance
[conditional logic]: ./lang_conditional.html
[custom backend system]: ./hiera_custom_backends.html
[functions_puppet]: ./lang_write_functions_in_puppet.html

Upgrading to Hiera 5 offers some major advantages. A real environment data layer means changes to your hierarchy are now routine and testable, using multiple backends in your hierarchy is easier and you can make a custom backend.

> Note: If you're already a Hiera user, you can use your current code with Hiera 5 without any changes to it. Hiera 5 is fully backwards-compatible with Hiera 3, and we won't remove any legacy features until Puppet 6. You can even start using some Hiera 5 features - like module data - without upgrading anything.

Hiera 5 uses the same built-in data formats as Hiera 3. You don't need to do mass edits of any data files.

Updating your code to take advantage of Hiera 5 features involves the following tasks:

Task | Benefit
-----|--------
Enable the environment layer, by giving each environment its own hiera.yaml file. | Future hierarchy changes are cheap and testable. The legacy `hiera()`, `hiera_array()`, etc. functions gain full Hiera 5 powers in any migrated environment, only if there is a hiera.yaml in the environment root.
Convert your global hiera.yaml file to the version 5 format. | You can use new Hiera 5 backends at the global layer.
Convert any experimental (version 4) hiera.yaml files to version 5. | Future-proof any environments or modules where you used the experimental version of Puppet lookup.
In Puppet code, replace `hiera()`/`hiera_array()`/etc. with `lookup()`. | Future-proof your Puppet code.
Use Hiera for default data in modules. | Simplify your modules with an elegant alternative to the "params.pp" pattern.

> Note: Enabling the environment layer takes the most work, but yields the biggest benefits. Focus on that first, then do the rest at your own pace.

{:.concept}
## Use cases for upgrading to Hiera 5

-   hiera-eyaml users
    -   Upgrade now. In Puppet 4.9.3, we added a built-in hiera-eyaml backend for Hiera 5. (It still requires that the hiera-eyaml gem be installed.) See the usage instructions in the hiera.yaml (v5) syntax reference. This means you can move your existing encrypted YAML data into the environment layer at the same time you move your other data.
-   Custom backend users
    -   Wait for updated backends. You can keep using custom Hiera 3 backends with Hiera 5, but they'll make upgrading more complex, because you can't move legacy data to the environment layer until there's a Hiera 5 backend for it. If an updated version of the backend is coming out soon, wait.
    -   If you're using an off-the-shelf custom backend, check its website or contact its developer. If you developed your backend in-house, read the documentation about writing Hiera 5 backends.
-   Custom `data_binding_terminus` users
    -   Upgrade now, and replace it with a Hiera 5 backend as soon as possible. There's a deprecated `data_binding_terminus` setting in the `puppet.conf` file, which changes the behavior of automatic class parameter lookup. It can be set to `hiera` (normal), `none` (deprecated; disables auto-lookup), or the name of a custom plugin.
    -   With a custom `data_binding_terminus`, automatic lookup results are different from function-based lookups for the same keys. If you're one of the few who use this feature, you've already had to design your Puppet code to avoid that problem, so it's safe to upgrade your configuration to Hiera 5. But since we've deprecated that extension point, you will have to replace your custom terminus with a Hiera 5 backend.
    -   If you're using an off-the-shelf plugin, such as Jerakia, check its website or contact its developer.
    -   If you developed your plugin in-house, read the documentation about writing Hiera 5 backends.
    -   Once you have a Hiera 5 backend, integrate it into your hierarchies and delete the `data_binding_terminus` setting.

Related topics: [environment data layer][layers], [usage instructions in the hiera.yaml (v5) syntax reference][eyaml_v5], [writing Hiera 5 backends][backends], [puppet.conf][puppet.conf], [automatic class parameter lookup][automatic].

{:.task}
## Enable the environment layer for existing Hiera data

A key feature in Hiera 5 is per-environment hierarchy configuration. Because you probably store data in each environment, local `hiera.yaml` files are more logical and convenient than a single global hierarchy.

You can enable the environment layer gradually. In migrated environments, the legacy Hiera functions switch to Hiera 5 mode — they can access environment and module data without requiring any code changes.

> Note: Before migrating environment data to Hiera 5, read the introduction to migrating Hiera configurations. In particular, be aware that if you rely on custom Hiera 3 backends, you should upgrade them for Hiera 5 or prepare for some extra work during migration. If your only custom backend is hiera-eyaml, continue upgrading — Puppet 4.9.3 and higher include a Hiera 5 eyaml backend. See the usage instructions in the hiera.yaml (v5) syntax reference.

The process of enabling the environment layer involves the following steps, each of which is described in the instructions below. In each environment, you will:

1.  Check your code for Hiera function calls with "hierarchy override arguments" (as shown later), which will cause errors.

2.  Add a local `hiera.yaml` file.

3.  Update your custom backends if you have them.

4.  Rename the data directory to exclude this environment from the global layer. Unmigrated environments still rely on the global layer, which gets checked before the environment layer. If you want to maintain both migrated and unmigrated environments during the migration process, choose a different data directory name for migrated environments. The new name 'data' is a good choice because it is also the new default (unless you are already using 'data', in which case choose a different name and set datadir in hiera.yaml).

    This process has no particular time limit and shouldn't involve any downtime. Once all of your environments are migrated, you can phase out or greatly reduce the global hierarchy.

    > **Important**: The environment layer does not support Hiera 3 backends. If any of your data uses a custom backend that has not been ported to Hiera 5, omit those hierarchy levels from the environment config and continue to use the global layer for that data. Because the global layer is checked before the environment layer, it's possible to run into situations where you cannot migrate data to the environment layer yet. For example, if your old `:backends` setting was [`custom_backend`, 'yaml'], you can do a partial migration, because the custom data was all going before the YAML data anyway. But if `:backends` was [`yaml`, `custom_backend`], and you frequently use YAML data to override the custom data, you can't migrate until you have a Hiera 5 version of that custom backend. If you run into a situation like this, get an upgraded backend before enabling the environment layer.

5.  Check your Puppet code for classic Hiera functions (`hiera`, `hiera_array`, `hiera_hash`, and `hiera_include`) that are passing the optional hierarchy override argument, and remove the argument.

    In Hiera 5, the hierarchy override argument is an error.

    A quick way to find instances of using this argument is to search for calls with two or more commas. Search your codebase using the following regular expression:

    ```
    hiera(_array|_hash|_include)?\(([^,\)]*,){2,}[^\)]*\)
    ```

    This will result in some false positives, but will help find the errors before you run the code.

    Alternatively, continue to the next step and fix errors as they come up. If you use environments for code testing and promotion, you're probably migrating a temporary branch of your control repo first, then pointing some canary nodes at it to make sure everything works as expected. If you think you've never used hierarchy override arguments, you'll be verifying that assumption when you run your canary nodes. If you do find any errors, you can fix them before merging your branch to production, the same way you would with any work-in-progress code.

    > Note: If your environments are similar to each other, you might only need to check for the hierarchy override argument in function calls  in one environment. If you find none, likely the others won't have many either.

6.  Choose a new data directory name, which you will use  in the next two steps. The default data directory name in Hiera 3 was `<ENVIRONMENT>/hieradata`, and the default in Hiera 5 is `<ENVIRONMENT>/data`. If you used the old default, use the new default. If you were already using `data`, choose something different.

7.  Add a Hiera 5 `hiera.yaml` file to the environment.

    Each environment needs a Hiera config file that works with its existing data. If this is the first environment you're migrating, see converting a version 3 hiera.yaml to version 5. Make sure to reference the new `datadir` name. If you've already migrated at least one environment, copy the `hiera.yaml` file from a migrated environment and make changes to it if necessary.

    Save the resulting file as `<ENVIRONMENT>/hiera.yaml`. For example, `/etc/puppetlabs/code/environments/production/hiera.yaml`.

8.  If any of your data relies on custom backends that have been ported to Hiera 5, install them in the environment. Hiera 5 backends are distributed as Puppet modules, so each environment can use its own version of them.

9.  If you use only file-based Hiera 5 backends, move the environment's data directory by renaming it from its old name (`hieradata`) to its new name (`data`). If you use custom file-based Hiera 3 backends, the global layer still needs access to their data, so you need to sort the files: Hiera 5 data moves to the new data directory, and Hiera 3 data stays in the old data directory. When you have Hiera 5 versions of your custom backends, you can move the remaining files to the new datadir.

    If you use non-file backends that don't have a data directory:

    -   Decide that the global hierarchy is the right place for configuring this data, and leave it there permanently.
    -   Do something equivalent to moving the datadir; for example, make a new database table for migrated data and move values  into place as you migrate environments.
    -   Allow the global and environment layers to use duplicated configuration for this data until the migration is done.

10. Repeat these steps for each environment. If you manage your code by mapping environments to branches in a control repo, you can migrate most of your environments using your version control system's merging tools.

11. After you have migrated the environments that have active node populations, delete the parts of your global hierarchy that you transferred into environment hierarchies.

Related topics: [per-environment hierarchy configuration][layers], [legacy backends][legacy_backend], [usage instructions in the hiera.yaml (v5) syntax reference][eyaml_v5],  [hiera.yaml (v5)][eyaml_v5] [control repo][control repo], [custom backends][backends].

{:.task}
## Convert a version 3 hiera.yaml to version 5

Hiera 5 supports three versions of the `hiera.yaml` file: version 3, version 4, and version 5. If you've been using Hiera 3, your existing configuration is a version 3 `hiera.yaml` file at the global layer.

There are two migration tasks that involve translating a version 3 config to a version 5:

-   Creating new v5 hiera.yaml files for environments.
-   Updating your global configuration to support Hiera 5 backends.

These are essentially the same process, although the global hierarchy has a few special capabilities.

Consider this example `hiera.yaml` version 3 file:

``` yaml
:backends:
  - mongodb
  - eyaml
  - yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost
:eyaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
  :pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
  :pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
:hierarchy:
  - "nodes/%{trusted.certname}"
  - "location/%{facts.whereami}/%{facts.group}"
  - "groups/%{facts.group}"
  - "os/%{facts.os.family}"
  - "common"
:logger: console
:merge_behavior: native
:deep_merge_options: {}
```

To convert this version 3 file to version 5:

1.  Use strings instead of symbols for keys.

    Hiera 3 required you to use Ruby symbols as keys. Symbols are short strings that start with a colon, for example, `:hierarchy`. The version 5 config format lets you use regular strings as keys, although symbols won't (yet) cause errors. You can remove the leading colons on keys.

2.  Remove settings that aren't used anymore.In this example, remove everything except the `:hierarchy` setting:

    -   Delete the following settings completely, which are no longer needed:
        -   `:logger`
        -   `:merge_behavior`
        -   `:deep_merge_options`

    For information on how Hiera 5 supports deep hash merging, see Merging data from multiple sources.

    -   Delete the following settings, but paste them into a temporary file for later reference:
        -   `:backends`
        -   Any backend-specific setting sections, like `:yaml` or `:mongodb`

3.  Add a `version` key, with a value of `5`:

    ``` yaml
    version: 5
    hierarchy:
      # ...
    ```

4.  Set a default backend and data directory.

    If you use one backend for the majority of your data, for example YAML or JSON, set a `defaults` key, with values for `datadir` and one of the backend keys:

    The names of the backends have changed for Hiera 5, and the `backend` setting itself has been split into three settings:

    Hiera 3 backend | Hiera 5 backend setting
    ----------------|------------------------
    `yaml`          | `data_hash: yaml_data`
    `json`          | `data_hash: json_data`
    `eyaml`         | `lookup_key: eyaml_lookup_key`

5.  Translate the hierarchy.

    The version 5 and version 3 hierarchies work differently:

    -   In version 3, hierarchy levels don't have a backend assigned to them, and Hiera loops through the entire hierarchy for each backend.
    -   In version 5, each hierarchy level has one designated backend, as well as its own independent configuration for that backend.

    Consult the previous values for the `:backends` key and any backend-specific settings.

    In the example above, we used `yaml`, `eyaml`, and `mongodb` backends. Your business only uses Mongo for per-node data, and uses eyaml for per-group data. The rest of the hierarchy is irrelevant to these backends. You need one Mongo level and one eyaml level, but still want all five levels in YAML. This means Hiera will consult multiple backends for per-node and per-group data. You want the YAML version of per-node data to be authoritative, so put it before the Mongo version. The eyaml data does not overlap with the unencrypted per-group data, so it doesn't matter where you put it. Put it before the YAML levels. When you translate your hierarchy, you will have to make the same kinds of investigations and decisions.

6.  Remove hierarchy levels that use `calling_module`, `calling_class`, and `calling_class_path`, which were allowed pseudo-variables in Hiera 3.

    Hiera.yaml version 5 does not support these. Remove hierarchy levels that interpolate them.

    Anything you were doing with these variables is better accomplished by using the module data layer, or by using the glob pattern (if the reason for using them was to enable splitting up data into multiple files, and not knowing in advance what they names of those would be)

7.  Translate built-in backends to the version 5 config, where the hierarchy is written as an array of hashes. For hierarchy levels that use the built-in backends, for example YAML and JSON, use the `data_hash` key to set the backend. See Configuring a hierarchy level in the `hiera.yaml` v5 reference for more information.

    Set the following keys:

    -   `name` — A human-readable name.
    -   `path` or `paths` — The path you used in your version 3 `hiera.yaml` hierarchy, but with a file extension appended.
    -   `data_hash` — The backend to use `yaml_data` for YAML, `json_data` for JSON.
    -   `datadir` — The data directory. In version 5, it's relative to the `hiera.yaml` file's directory.

    If you have set default values for `data_hash` and `datadir`, you can omit them.

    ``` yaml
    version: 5
    defaults:
      datadir: data
      data_hash: yaml_data
    hierarchy:
      - name: "Per-node data (yaml version)"
        path: "nodes/%{trusted.certname}.yaml" # Add file extension.
        # Omitting datadir and data_hash to use defaults.

      - name: "Other YAML hierarchy levels"
        paths: # Can specify an array of paths instead of one.
          - "location/%{facts.whereami}/%{facts.group}.yaml"
          - "groups/%{facts.group}.yaml"
          - "os/%{facts.os.family}.yaml"
          - "common.yaml"
    ```

8.  Translate hiera-eyaml backends, which work in a similar way to the other built-in backends. The differences are:

    The `hiera-eyaml` gem has to be installed, and you need a key-pair.
a different backend setting. Instead of `data_hash: yaml`, use `lookup_key: eyaml_lookup_key`.
Each hierarchy level needs an `options` key with paths to the public and private keys. You cannot set a global default for this.

    ``` yaml
    - name: "Per-group secrets"
       path: "groups/%{facts.group}.eyaml"
       lookup_key: eyaml_lookup_key
       options:
         pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
         pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
    ```

9.  Translate custom Hiera 3 backends.

    Check to see if the backend's author has published a Hiera 5 update for it. If so, use that; see its documentation for details on how to configure hierarchy levels for it.

    If there is no update, use the version 3 backend in a version 5 hierarchy at the global layer — it will not work in the environment layer. Find a Hiera 5 compatible replacement, or write Hiera 5 backends yourself.

    For details on how to configure a legacy backend, see Configuring a hierarchy level (legacy Hiera 3 backends) in the `hiera.yaml` (version 5) reference.

    When configuring a legacy backend, use the previous value for its backend-specific settings. In the example, the version 3 config had the following settings for MongoDB:

    ``` yaml
    :mongodb:
      :connections:
        :dbname: hdata
        :collection: config
        :host: localhost
    ```

    So, write the following for a per-node MongoDB hierarchy level:

    ```
    - name: "Per-node data (MongoDB version)"
       path: "nodes/%{trusted.certname}"      # No file extension
       hiera3_backend: mongodb
       options:    # Use old backend-specific options, changing keys to plain strings
         connections:
           dbname: hdata
           collection: config
           host: localhost
    ```

After following these steps, you've translated the example configuration into the following v5 config:

``` yaml
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Per-node data (yaml version)"
    path: "nodes/%{trusted.certname}.yaml" # Add file extension
    # Omitting datadir and data_hash to use defaults.

  - name: "Per-node data (MongoDB version)"
    path: "nodes/%{trusted.certname}"      # No file extension
    hiera3_backend: mongodb
    options:    # Use old backend-specific options, changing keys to plain strings
      connections:
        dbname: hdata
        collection: config
        host: localhost

  - name: "Per-group secrets"
    path: "groups/%{facts.group}.eyaml"
    lookup_key: eyaml_lookup_key
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  - name: "Other YAML hierarchy levels"
    paths: # Can specify an array of paths instead of a single one.
      - "location/%{facts.whereami}/%{facts.group}.yaml"
      - "groups/%{facts.group}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"
```

Related topics: [version 3][v3], [version 4][v4], [version 5][v3],  [global layer][layers], [Merging data from multiple sources][merging],  [set a defaults key][v5_defaults], [Configuring a hierarchy level (built-in backends)][v5_builtin], [Hiera 5 backends][backends], [eyaml usage instructions in the hiera.yaml (v5) syntax reference][eyaml_v5].

{:.task}
## Convert an experimental (version 4) hiera.yaml to version 5

If you used the experimental version of Puppet lookup (Hiera 5's predecessor), you might have some version 4 `hiera.yaml` files in your environments and modules. Hiera 5 can use these, but you will need to convert them, especially if you want to use any backends other than YAML or JSON. Version 4 and version 5 formats are similar.

Consider this example of a version 4 `hiera.yaml` file:

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

To convert to version 5, make the following changes:

1.  Change the value of the `version` key to `5`.

2.  Add a file extension to every file path — use `"common.yaml"`, not `"common"`.

3.  If any hierarchy levels are missing a `path`, add one. In version 5, `path` no longer defaults to the value of `name`.

4.  If there is a top-level `datadir` key, change it to a `defaults` key. Set a default backend. For example:

    ``` yaml
    defaults:
      datadir: data
      data_hash: yaml_data
    ```

5.  In each hierarchy level, delete the `backend` key and replace it with a `data_hash` key. (If you set a default backend in the `defaults` key, you can omit it here.)

    v4 backend      | v5 equivalent
    ----------------|--------------
    `backend: yaml` | `data_hash: yaml_data`
    `backend: json` | `data_hash: json_data`

6.  Delete the `environment_data_provider` and `data_provider` settings, which  enabled Puppet lookup for an environment or module.

    You'll find these settings in the following locations:

    -   `environment_data_provider` in puppet.conf.
    -   `environment_data_provider` in environment.conf.
    -   `data_provider` in a module's metadata.json.

After being converted to version 5, the example looks like this:

```
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

For full syntax details, see the `hiera.yaml` version 5 reference.

Related topics: [defaults key][v5_defaults], [the hiera.yaml version 5 reference][eyaml_v5], [backends][backends].

{:.task}
## Convert experimental data provider functions to a Hiera 5 `data_hash` backend

Puppet lookup had experimental custom backend support, where you could set `data_provider = function` and create a function with a name that returned a hash.
If you used that, you can convert your function to a Hiera 5 `data_hash` backend.

1.  Your original function took no arguments. Change its signature to accept two arguments: a `Hash` and a `Puppet::LookupContext` object. You do not have to do anything with these -  just add them. For more information, see the documentation for data hash backends.

2.  Delete the `data_provider` setting, which enabled Puppet lookup for a module. You can find this setting in a module's `metadata.json`.

3.  Create a version 5 hiera.yaml file for the affected environment or module, and add a hierarchy level as follows:

    ``` yaml
    - name: <ARBITRARY NAME>
      data_hash: <NAME OF YOUR FUNCTION>
    ```

    It does not need a `path`, `datadir`, or any other options.

{:.reference}
## Updated classic Hiera function calls

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are all deprecated. The `lookup` function is a complete replacement for all of these.

Hiera function                | Equivalent `lookup` call
------------------------------|-------------------------
`hiera('secure_server')`      | `lookup('secure_server')`
`hiera_array('ntp::servers')` | `lookup('ntp::servers', {merge => unique})`
`hiera_hash('users')`         | `lookup('users', {merge => hash})` or `lookup('users', {merge => deep})`
`hiera_include('classes')`    | `lookup('classes', {merge => unique}).include`

To prepare for deprecations in future Puppet versions, it's best to revise your Puppet modules to replace the `hiera_*` functions with `lookup`. However, you can adopt all of Hiera 5's new features without updating these function calls. While you're revising, consider refactoring code to use automatic class parameter lookup instead of manual lookup calls. Because automatic lookups can now do unique and hash merges, the use of manual lookup in the form of `hiera_array` and `hiera_hash` are not as important as they used to be. Instead of changing those manual hiera calls to be calls to the `lookup` function, use Automatic Parameter Lookup (API).

Related topics: [automatic class parameter lookup][automatic], [unique and hash merges][merging].

{:.reference}
## Adding Hiera data to a module

Modules need default values for their class parameters. Before, the preferred way to do this was the “params.pp” pattern. With Hiera 5, you can use the “data in modules” approach instead. The following example shows how to replace `params.pp` with the new approach.

> Note: The “params.pp” pattern is still valid, and the features it relies on remain in Puppet. But if you want to use Hiera data instead, you now have that option.

### Module data with the “params.pp” pattern

The “params.pp” pattern takes advantage of the Puppet class inheritance behavior. In short:

-   One class in your module does nothing but set variables for the other classes. This class is called `<MODULE>::params`.
-   This class uses Puppet code to construct values; it uses conditional logic based on the target operating system.
-   The rest of the classes in the module inherit from the params class. In their parameter lists, you can use the params class's variables as default values.
-   When using "params.pp" pattern, the values set in the "params.pp" defined class cannot be used in lookup merges and Automatic Parameter Lookup (APL) - when using this pattern these are only used for defaults when there are no values found in Hiera.

An example params class:

```
# ntp/manifests/params.pp
class ntp::params {
  $autoupdate = false,
  $default_service_name = 'ntpd',

  case $facts['os']['family'] {
    'AIX': {
      $service_name = 'xntpd'
    }
    'Debian': {
      $service_name = 'ntp'
    }
    'RedHat': {
      $service_name = $default_service_name
    }
  }
}
```

A class that inherits from the params class and uses it to set default parameter values:

```
# ntp/manifests/init.pp
class ntp (
  $autoupdate   = $ntp::params::autoupdate,
  $service_name = $ntp::params::service_name,
) inherits ntp::params {
 ...
}
```

### Module data with a one-off custom Hiera backend

With Hiera 5's custom backend system, you can convert an existing params class to a hash-based Hiera backend.

To create a Hiera backend, create a function written in the Puppet language that returns a hash. Using the params class as a starting point:

``` puppet
# ntp/functions/params.pp
function ntp::params(
  Hash                  $options, # We ignore both of these arguments, but
  Puppet::LookupContext $context, # the function still needs to accept them.
) {
  $base_params = {
    'ntp::autoupdate'   => false,
      # Keys have to start with the module's namespace, which in this case is `ntp::`.
    'ntp::service_name' => 'ntpd',
      # Use key names that work with automatic class parameter lookup. This
      # key corresponds to the `ntp` class's `$service_name` parameter.
  }

  $os_params = case $facts['os']['family'] {
    'AIX': {
      { 'ntp::service_name' => 'xntpd' }
    }
    'Debian': {
      { 'ntp::service_name' => 'ntp' }
    }
    default: {
      {}
    }
  }

  # Merge the hashes, overriding the service name if this platform uses a non-standard one:
  $base_params + $os_params
}
```

> Note: The hash merge operator (`+`) is useful in these functions.

Once you have a function, tell Hiera to use it by adding it to the module layer `hiera.yaml`. A simple backend like this one doesn't require `path`, `datadir`, or `options` keys. You have a choice of adding it to the `default_hierarch` if you want the exact same behaviour as with the earlier "params.pp" pattern, and use the regular `hierarchy` if you want the values to be merged with values of higher priority when a merging lookup is specified. You may want to split up the key/values so that some are in the `hierarchy`, and some in the `default_hierarchy`, depending on whether it makes sense to merge a value of not.

Here we add it to the regular hierarchy:

``` yaml
# ntp/hiera.yaml
---
version: 5
hierarchy:
  - name: "NTP class parameter defaults"
    data_hash: "ntp::params"
  # We only need one hierarchy level, since one function provides all the data.
```

With Hiera-based defaults, you can simplify your module's main classes:

-   They do not need to inherit from any other class.
-   You do not need to explicitly set a default value with the `=` operator.
-   Instead APL comes into effect for each parameter without a given value. In the example, the function ntp::params will be called to get the default params, and those can then be either overridden or merged, just as with all values in Hiera.

``` puppet
# ntp/manifests/init.pp
class ntp (
  # default values are in ntp/functions/params.pp
  $autoupdate,
  $service_name,
) {
 ...
}
```

### Module data with YAML data files

You can also manage your module's default data with basic Hiera YAML files, by setting up a hierarchy in your module layer `hiera.yaml` file:

``` yaml
# ntp/hiera.yaml
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "OS family"
    path: "os/%{facts.os.family}.yaml"

  - name: "common"
    path: "common.yaml"
```

Then, put the necessary data files in the data directory:

``` yaml
# ntp/data/common.yaml
---
ntp::autoupdate: false
ntp::service_name: ntpd

# ntp/data/os/AIX.yaml
---
ntp::service_name: xntpd

# ntp/data/os/Debian.yaml
ntp::service_name: ntp
```

You can also use any other Hiera backend to provide your module's data. If you want to use a custom backend that is distributed as a separate module, you can mark that module as a dependency.

Related topics: [class inheritance][class inheritance], [conditional logic][conditional logic], [custom backend system][custom backend system], [write that function in the Puppet language][functions_puppet], [hash merge operator][hash merge operator], [module-layer][layers], [automatic class parameter lookup][automatic].
