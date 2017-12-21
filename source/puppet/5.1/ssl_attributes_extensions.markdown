---
layout: default
title: "SSL configuration: CSR attributes and certificate extensions"
---

[cert_request]: ./subsystem_agent_master_comm.html#check-for-keys-and-certificates
[csr_attributes]: ./configuration.html#csrattributes
[confdir]: ./configuration.html#confdir
[autosign_policy]: ./ssl_autosign.html#policy-based-autosigning
[autosign_basic]: ./ssl_autosign.html#basic-autosigning-autosignconf
[puppet_oids]: #puppet-specific-registered-ids
[trusted_hash]: ./lang_facts_and_builtin_vars.html#trusted-facts
[oid_map]: ./config_file_oid_map.html

When Puppet agent nodes request their certificates, the certificate signing request (CSR) usually contains only their certname and the necessary cryptographic information. However, agents can also embed more data in their CSR. This extra data can be useful for [policy-based autosigning][autosign_policy] and adding new [trusted facts][trusted_hash].

Embedding additional data into CSRs is mostly useful when:

* Large numbers of nodes are regularly created and destroyed as part of an elastic scaling system.
* You are willing to build custom tooling to make certificate autosigning more secure and useful.

It might also be useful in deployments where Puppet is used to deploy private keys or other sensitive information, and you want extra control over which nodes receive this data.

If your deployment doesn't match one of these descriptions, you might not need this feature.

## Timing: When data can be added to CSRs and certificates

When Puppet agent starts the process of requesting a catalog, it first checks whether it has a valid signed certificate. If it does not, it generates a key pair, crafts a CSR, and submits it to the certificate authority (CA) Puppet master. The steps are [covered in more detail in the reference page about agent/master HTTPS traffic][cert_request].

For all practical purposes, a certificate is locked and immutable as soon as it is signed. For any data to persist in the certificate, it has to be added to the CSR _before_ the CA signs the certificate.

This means **any desired extra data must be present _before_ Puppet agent attempts to request its catalog for the first time.**

Practically speaking, you should populate any extra data when provisioning the node. If you mess up, see [Recovering From Failed Data Embedding](#recovering-from-failed-data-embedding) below.

## Data location and format

Extra data for the CSR is read from the `csr_attributes.yaml` file in Puppet's [`confdir`][confdir]. (The location of this file can be changed with [the `csr_attributes` setting][csr_attributes].)

The `csr_attributes` file must be a YAML hash containing one or both of the following keys:

* `custom_attributes`
* `extension_requests`

The value of each key must also be a hash, where:

* Each key is a valid [object identifier (OID)](http://en.wikipedia.org/wiki/Object_identifier) --- [Puppet-specific OIDs][puppet_oids] can optionally be referenced by short name instead of by numeric ID.
* Each value is an object that can be cast to a string (that is, numbers are allowed but arrays are not).

See the respective sections below for information about how each hash is used and recommended OIDs for each hash.

## Custom attributes (transient CSR data)

**Custom Attributes** are pieces of data that are _only_ embedded in the CSR. The CA can use them when deciding whether to sign the certificate, but they are discarded after that and aren't transferred to the final certificate.

### Default behavior

The `puppet cert list` command doesn't display custom attributes for pending CSRs, and [basic autosigning (autosign.conf)][autosign_basic] doesn't check them before signing.

### Configurable behavior

If you use [policy-based autosigning][autosign_policy], your policy executable receives the complete CSR in PEM format. The executable can extract and inspect the custom attributes, and use them when deciding whether to sign the certificate.

The simplest use is to embed a pre-shared key of some kind in the custom attributes. A policy executable can compare it to a list of known keys and autosign certificates for any pre-authorized nodes.

A more complex use might be to embed an instance-specific ID and write a policy executable that can check it against a list of your recently requested instances on a public cloud, like EC2 or GCE.

If you use Puppet Server 2.5.0 or newer, you can also sign requests using authorization extensions and the `--allow-authorization-extensions` flag for `puppet cert sign`.

### Manually checking for custom attributes in CSRs

You can check for custom attributes by using OpenSSL to dump a PEM-format CSR to text format. Do this by running:

``` bash
openssl req -noout -text -in <name>.pem
```

In the output, look for a section called "Attributes," which generally appears below the "Subject Public Key Info" block:

```
Attributes:
    challengePassword        :342thbjkt82094y0uthhor289jnqthpc2290
```

### Recommended OIDs for attributes

Custom attributes can use any public or site-specific OID, **with the exception of the OIDs used for core X.509 functionality.** This means you can't re-use existing OIDs for things like subject alternative names.

One useful OID is the "challengePassword" attribute --- `1.2.840.113549.1.9.7`. This is a rarely-used corner of X.509 that can easily be repurposed to hold a pre-shared key. The benefit of using this instead of an arbitrary OID is that it appears by name when using OpenSSL to dump the CSR to text; OIDs that `openssl req` can't recognize are displayed as numerical strings.

You can also use the Puppet-specific OIDs [referenced below][puppet_oids] in the section on extension requests.

## Extension requests (permanent certificate data)

**Extension requests** are pieces of data that are _transferred to the final certificate_ (as **extensions**) when the CA signs the CSR. They persist as trusted, immutable data, that cannot be altered after the certificate is signed.

They can also be used by the CA when deciding whether or not to sign the certificate.

### Default behavior

When signing a certificate, Puppet's CA tools transfer any extension requests into the final certificate.

You can access certificate extensions in manifests as `$trusted[extensions][<EXTENSION OID>]`.

Any OIDs in the ppRegCertExt range ([see below][puppet_oids]) appear using their short names. By default, any other OIDs appear as plain dotted numbers, but you can use [the `custom_trusted_oid_mapping.yaml` file][oid_map] to assign short names to any other OIDs you use at your site. If you do, those OIDs will appear in `$trusted` as their short names instead of their full numerical OID.

See [the page on facts and special variables][trusted_hash] for more information about `$trusted`.

Visibility of extensions is somewhat limited:

* The `puppet cert list` command _does not_ display custom attributes for any pending CSRs, and [basic autosigning (autosign.conf)][autosign_basic] doesn't check them before signing. Either use [policy-based autosigning][autosign_policy] or inspect CSRs manually with the `openssl` command (see below).
* The `puppet cert print` command _does_ display any extensions in a signed certificate, under the "X509v3 extensions" section.

Puppet's authorization system (`auth.conf`) does not use certificate extensions, but [Puppet Server's authorization system](/puppetserver/latest/config_file_auth.html), which is based on `trapperkeeper-authorization`, can use extensions in the ppAuthCertExt OID range, and requires them for requests to write access rules.

### Configurable behavior

If you use [policy-based autosigning][autosign_policy], your policy executable receives the complete CSR in PEM format. The executable can extract and inspect the extension requests, and use them when deciding whether to sign the certificate.

### Manually checking for extensions in CSRs and certificates

You can check for extension requests in a CSR by using OpenSSL to dump a PEM-format CSR to text format. Do this by running:

``` bash
openssl req -noout -text -in <name>.pem
```

In the output, look for a section called "Requested Extensions," which generally appears below the "Subject Public Key Info" and "Attributes" blocks:

```
Requested Extensions:
    pp_uuid:
    .$ED803750-E3C7-44F5-BB08-41A04433FE2E
    1.3.6.1.4.1.34380.1.1.3:
    ..my_ami_image
    1.3.6.1.4.1.34380.1.1.4:
    .$342thbjkt82094y0uthhor289jnqthpc2290
```

Note that every extension is preceded by any combination of two characters (`.$` and `..` in the above example) that contain ASN.1 encoding information. Since OpenSSL is unaware of Puppet's custom extensions OIDs, it's unable to properly display the values.

Any Puppet-specific OIDs (see below) appear as numeric strings when using OpenSSL.

You can check for extensions in a signed certificate by running `puppet cert print <name>`. In the output, look for the "X509v3 extensions" section. Any of the Puppet-specific registered OIDs (see below) appear as their descriptive names:

```
X509v3 extensions:
    Netscape Comment:
        Puppet Ruby/OpenSSL Internal Certificate
    X509v3 Subject Key Identifier:
        47:BC:D5:14:33:F2:ED:85:B9:52:FD:A2:EA:E4:CC:00:7F:7F:19:7E
    Puppet Node UUID:
        ED803750-E3C7-44F5-BB08-41A04433FE2E
    X509v3 Extended Key Usage: critical
        TLS Web Server Authentication, TLS Web Client Authentication
    X509v3 Basic Constraints: critical
        CA:FALSE
    Puppet Node Preshared Key:
        342thbjkt82094y0uthhor289jnqthpc2290
    X509v3 Key Usage: critical
        Digital Signature, Key Encipherment
    Puppet Node Image Name:
        my_ami_image
```

### Recommended OIDs for extensions

Extension request OIDs **must** be under the "ppRegCertExt" (`1.3.6.1.4.1.34380.1.1`), "ppPrivCertExt" (`1.3.6.1.4.1.34380.1.2`), or "ppAuthCertExt" (`1.3.6.1.4.1.34380.1.3`) OID arcs.

Puppet provides several registered OIDs (under "ppRegCertExt") for the most common kinds of extension information, a private OID range ("ppPrivCertExt") for site-specific extension information, and an OID range for safe authorization to Puppet Server ("ppAuthCertExt").

There are several benefits to using the registered OIDs:

* You can reference them in `csr_attributes.yaml` with their short names instead of their numeric IDs.
* You can access them in `$trusted[extensions]` with their short names instead of their numeric IDs.
* When using Puppet tools to print certificate info, they will appear using their descriptive names instead of their numeric IDs.

The private range is available for any information you want to embed into a certificate that isn't already in wide use elsewhere. It is completely unregulated, and its contents are expected to be different in every Puppet deployment.

You can use [the `custom_trusted_oid_mapping.yaml` file][oid_map] to set short names for any private extension OIDs you use. Note that this only enables the short names in the `$trusted[extensions]` hash.

#### Puppet-specific registered IDs

{% partial ./_registered_oids.md %}

## AWS attributes and extensions population example

You can use an automated script (possibly using cloud-init or a similar tool) to populate the `csr_attributes.yaml` file when you provision a node.

As an example, you can enter the following script into the "Configure Instance Details —> Advanced Details" section when provisioning a new node from the AWS EC2 dashboard:

``` bash
#!/bin/sh
if [ ! -d /etc/puppetlabs/puppet ]; then
   mkdir /etc/puppetlabs/puppet
fi
cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
custom_attributes:
    1.2.840.113549.1.9.7: mySuperAwesomePassword
extension_requests:
    pp_instance_id: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    pp_image_name:  $(curl -s http://169.254.169.254/latest/meta-data/ami-id)
YAML
```

Assuming your image has the `erb` binary available, this populates the attributes file with the AWS instance ID, image name, and a pre-shared key to use with policy-based autosigning.

## Troubleshooting

### Recovering from failed data embedding

When first testing this feature, you might fail to embed the right information in a CSR or certificate and want to start over for your test nodes. (This is not really a problem once your provisioning system is changed to populate the data, but it can happen pretty easily when doing things manually.)

To start over, do the following:

**On the test node:**

* Turn off Puppet agent, if it's running.
* Check whether a CSR is present; it will be at `$ssldir/certificate_requests/<name>.pem`. If it exists, delete it.
* Check whether a certificate is present; it will be at `$ssldir/certs/<name>.pem`. If it exists, delete it.

**On the CA Puppet master:**

* Check whether a signed certificate exists; use `puppet cert list --all` to see the complete list. If it exists, revoke and delete it with `puppet cert clean <name>`.
* Check whether a CSR for the node exists; it will be in `$ssldir/ca/requests/<name>.pem`. If it exists, delete it.

After you've done that, you can start over.
