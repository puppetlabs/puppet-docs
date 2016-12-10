---
layout: default
title: "Config files: custom_trusted_oid_mapping.yaml"
---

[extensions]: ./ssl_attributes_extensions.html
[mapping_setting]: ./configuration.html#trustedoidmappingfile
[pup-4617]: https://tickets.puppetlabs.com/browse/PUP-4617
[csr_attributes]: ./config_file_csr_attributes.html
[trusted]: ./lang_facts_and_builtin_vars.html#trusted-facts
[registered]: ./ssl_attributes_extensions.html#puppet-specific-registered-ids

The `custom_trusted_oid_mapping.yaml` file lets you set your own short names for [certificate extension][extensions] object identifiers (OIDs), which can make [the `$trusted` variable][trusted] more useful.

It is only valid on a Puppet master server; in Puppet apply, the compiler doesn't add certificate extensions to `$trusted`.

## More about certificate extensions

When a node requests a certificate, it can ask the CA to include some additional, permanent metadata in that cert. (Puppet agent uses [the `csr_attributes.yaml` file][csr_attributes] to decide what extensions to request.)

If the CA signs a certificate with extensions included, those extensions are available as [trusted facts][trusted] in the top-scope `$trusted` variable. Your manifests or node classifier can then use those trusted facts to decide which nodes can receive which configurations.

By default, the [Puppet-specific registered OIDs][registered] appear as keys with convenient short names in the `$trusted[extensions]` hash, and any other OIDs appear as raw numerical IDs. You can use the `custom_trusted_oid_mapping.yaml` file to map other OIDs to short names, which will replace the numerical OIDs in `$trusted[extensions]`.

For more info, see:

* [CSR Attributes and Certificate Extensions][extensions]
* [The `csr_attributes.yaml` File][csr_attributes]
* [Trusted Facts][trusted]

### Limitations of OID mapping

Mapping OIDs in this file _only_ affects the keys in the `$trusted[extensions]` hash. It does not affect:

* What an agent can request in its `csr_attributes.yaml` file --- anything but Puppet-specific registered extensions must still be numerical OIDs.
* What you see when you run `puppet cert print` --- mapped extensions will still be displayed as numerical OIDs. (Improving cert display is planned as [PUP-4617][].)

## Location

The OID mapping file is located at `$confdir/custom_trusted_oid_mapping.yaml` by default. Its location is configurable with [the `trusted_oid_mapping_file` setting][mapping_setting].

The location of the `confdir` depends on your OS. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html


## Example

    ---
    oid_mapping:
      1.3.6.1.4.1.34380.1.2.1.1:
        shortname: 'myshortname'
        longname: 'My Long Name'
      1.3.6.1.4.1.34380.1.2.1.2:
        shortname: 'myothershortname'
        longname: 'My Other Long Name'

## Format

The `custom_trusted_oid_mapping.yaml` must be a YAML hash containing a single key called `oid_mapping`.

The value of the `oid_mapping` key must be a hash whose keys are numerical OIDs. The value for each OID must be a hash with two keys:

* `shortname` for the one-word name that will be used in the `$trusted[extensions]` hash.
* `longname` for a more descriptive name (not currently used for anything).
