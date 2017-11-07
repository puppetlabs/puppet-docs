---
layout: default
title: "Config Files: csr_attributes.yaml"
canonical: "/puppet/latest/config_file_csr_attributes.html"
---

[csr_attributes]: /puppet/3.8/configuration.html#csrattributes

The `csr_attributes.yaml` file defines custom data for new certificate signing requests (CSRs). It can set:

* CSR attributes (transient data used for pre-validating requests)
* Certificate extension requests (permanent data to be embedded in a signed certificate)

This file is only consulted when a new CSR is created (e.g. when an agent node is first attempting to join a Puppet deployment). It cannot modify existing certificates.

> **Note:** For details on how to use this file, see the [documentation for CSR attributes and certificate extensions](./ssl_attributes_extensions.html).

## Location

The `csr_attributes.yaml` file is located at `$confdir/csr_attributes.yaml` by default. Its location is configurable with the [`csr_attributes` setting][csr_attributes].

The location of the `confdir` depends on your OS. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Example

    ---
    custom_attributes:
      1.2.840.113549.1.9.7: 342thbjkt82094y0uthhor289jnqthpc2290
    extension_requests:
      pp_uuid: ED803750-E3C7-44F5-BB08-41A04433FE2E
      pp_image_name: my_ami_image
      pp_preshared_key: 342thbjkt82094y0uthhor289jnqthpc2290

## Format

The `csr_attributes` file must be a YAML hash containing one or both of the following keys:

* `custom_attributes`
* `extension_requests`

The value of each key must also be a hash, where:

* Each key is a valid [object identifier (OID)](http://en.wikipedia.org/wiki/Object_identifier). Note that [Puppet-specific OIDs][puppet_oids] may optionally be referenced by short name instead of by numeric ID. (In the example above, `pp_uuid` is a short name for a Puppet-specific OID.)
* Each value is an object that can be cast to a string (that is, numbers are allowed but arrays are not).

### Allowed OIDs for Custom Attributes

Custom attributes can use any public or site-specific OID, **with the exception of the OIDs used for core X.509 functionality.** This means you can't re-use existing OIDs for things like subject alternative names.

One useful OID is the "challengePassword" attribute --- `1.2.840.113549.1.9.7`. This is a rarely-used corner of X.509 which can easily be repurposed to hold a pre-shared key. The benefit of using this instead of an arbitrary OID is that it will appear by name when using OpenSSL to dump the CSR to text; OIDs that `openssl req` can't recognize will be displayed as numerical strings.

Also note that the Puppet-specific OIDs listed below can also be used in CSR attributes.

### Allowed OIDs for Extension Requests

Extension request OIDs **must** be under the "ppRegCertExt" (`1.3.6.1.4.1.34380.1.1`) or "ppPrivCertExt" (`1.3.6.1.4.1.34380.1.2`) OID arcs.

Puppet provides several registered OIDs (under "ppRegCertExt") for the most common kinds of extension information, as well as a private OID range ("ppPrivCertExt") for site-specific extension information. The benefits of using the registered OIDs are:

* They can be referenced in `csr_attributes.yaml` using their short names instead of their numeric IDs.
* When using Puppet tools to print certificate info, they will appear using their descriptive names instead of their numeric IDs.

The private range is available for any information you want to embed into a certificate that isn't already in wide use elsewhere. It is completely unregulated, and its contents are expected to be different in every Puppet deployment.

[puppet_oids]: #puppet-specific-registered-ids

#### Puppet-Specific Registered IDs

{% partial ./_registered_oids.md %}
