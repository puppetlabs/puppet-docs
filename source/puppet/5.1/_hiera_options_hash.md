### The options hash

Hierarchy levels are configured in [hiera.yaml](./hiera_config_yaml_5.html). When calling a backend function, Hiera passes a modified version of that configuration as a hash.

The options hash contains the following keys:

* `path` --- The absolute path to a file on disk. Only present if the user set one of the `path`, `paths`, `glob`, or `globs` settings. Hiera ensures the file exists before passing it to the function.

  > **Note:** If your backend uses data files, use the context object's [`cached_file_data` method][method_cached_file] to read them.
* `uri` --- A URI that your function can use to locate a data source. Only present if the user set `uri` or `uris`. Hiera doesn't verify the URI before passing it to the function.
* Every key from the hierarchy level's `options` setting. In your documentation, make sure to list any options your backend requires or accepts. Note that the `path` and `uri` keys are reserved.

For example: this hierarchy level in hiera.yaml...

``` yaml
  - name: "Secret data: per-node, per-datacenter, common"
    lookup_key: eyaml_lookup_key # eyaml backend
    datadir: data
    paths:
      - "secrets/nodes/%{trusted.certname}.eyaml"
      - "secrets/location/%{facts.whereami}.eyaml"
      - "common.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
```

...would result in several different options hashes (depending on the current node's facts, whether the files exist, etc.), but they would all resemble the following:

``` ruby
{
  'path' => '/etc/puppetlabs/code/environments/production/data/secrets/nodes/web01.example.com.eyaml',
  'pkcs7_private_key' => '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem',
  'pkcs7_public_key' => '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem'
}
```

In your function's signature, you can validate the options hash by using [the Struct data type](./lang_data_abstract.html#struct) to restrict its contents. In particular, note that you can disable all of the `path(s)` and `glob(s)` settings for your backend by disallowing the `path` key in the options hash.
