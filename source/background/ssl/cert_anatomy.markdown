---
layout: default
title: "Background Reference: X.509 Certificate Anatomy"
---

[pem]: http://en.wikipedia.org/wiki/X.509#Certificate_filename_extensions
[der]: http://en.wikipedia.org/wiki/Distinguished_Encoding_Rules
[altnames]: /puppet/latest/reference/configuration.html#dnsaltnames
[extensions]: /puppet/3/reference/ssl_attributes_extensions.html
[certs]: ./certificates_pki.html
[ssldir]: /puppet/latest/reference/dirs_ssldir.html
[certname]: /puppet/latest/reference/configuration.html#certname
[lang_node]: /puppet/latest/reference/lang_node_definitions.html
[enc]: /guides/external_nodes.html
[index]: ./index.html
[ca_name]: /puppet/latest/reference/configuration.html#caname
[wiki_x509]: http://en.wikipedia.org/wiki/X.509



> This article is [part of a series][index].

As described in the background reference article about [certificates and PKI][certs], certificates are documents containing a public key, metadata, and a signature.

This appendix will inspect two certificates and point out notable pieces of metadata, explaining their significance to Puppet's SSL usage when applicable.

A Master or Agent Certificate
-----

The certificates used by puppet master servers and puppet agent nodes are essentially the same; the only real difference is that puppet master certs sometimes contain alternate DNS names the master is allowed to use.

In this case, we will be inspecting the certificate of a node named `magpie.example.com`, which is allowed to present itself as a puppet master via the hostnames `magpie`, `magpie.example.com`, `puppet`, and `puppet.example.com`.

### PEM File

A certificate is stored on disk as a [.pem file][pem] in puppet's `certdir`. The `certdir` is part of Puppet's `ssldir` hierarchy, which is documented elsewhere ([Puppet reference manual » important directories and files » ssldir][ssldir]). Another copy of the certificate is stored in the CA's `signed` directory. (The `puppet cert print` command uses this copy, which is why it can only be used on the CA node.)

The name of the "privacy enhanced mail" (PEM) extension is somewhat misleading, since it has nothing to do with email; it's just a historical quirk of X.509 implementations.

The .pem file is double-encoded: first in the [distinguished encoding rules (DER) format][der] defined by the X.690 standard, then in Base64. Neither format is meant to be human-readable.

    $ cat $(puppet master --configprint certdir)/magpie.example.com.pem
    -----BEGIN CERTIFICATE-----
    MIIFpDCCA4ygAwIBAgIBAzANBgkqhkiG9w0BAQsFADArMSkwJwYDVQQDDCBQdXBw
    ZXQgQ0E6IG1hZ3BpZS5wdXBwZXRsYWJzLmxhbjAeFw0xMjEwMjEyMjE3MDlaFw0x
    NzEwMjEyMjE3MDlaMBUxEzARBgNVBAMMCm1hZ3BpZS5sYW4wggIiMA0GCSqGSIb3
    DQEBAQUAA4ICDwAwggIKAoICAQDbWERBuPuRw/61V9KMek5hxAbuw2V1gFM7+5uX
    kmxMYPg26NAezhfbkHxHkUxKKbPu9lYA4Nn6LVASBwTex+NH5RsJFP3OKLGxKG4J
    c99Ef6u+f1ZeRX1s+72tOZWPn3qz1Cw3fPf4DOqRFLmh9BEfFvP6asC62a0mfFLX
    JW++WczmyQvv+tZcFw6Arg5KM6OT/RGni0XfPhbfMeBsRbgAhGrL9Sk95kHnIj0x
    orqrXuYkkxzCTQ2dcd2oiV0hZIKIJcX1pxtTlm4N0SxQzXsUL4evsnvUioGoeZAX
    F40prCg9Sc6orHc5k3JDUS0QZp+SLcSwUNoFQJW7H7jjhIDEpp3Nz9YHJWDThfKb
    /L/q6TNYE0zFFLbyeUgpAeAFYadBI/ZzCICYIAaw9UPvz8mjgYooxxDwKzoYTJAj
    pA52kHScJ6tO+KYJ+B0yJXFdfVvj13NowetD44Qlyq/QRfqwkvjKqwCWwr7i1dv8
    KmryJcJYv//X/FiP7ukbnsAY4lDNYhunCkvshWpN+fZqD6ySXfucsfnqCoAHKTFR
    WdXf8ciK5d7noqpjeROaDiuU2PdWZe5z+YnTmvhK7UMa8soGkniqZ9cc/LHKnZjC
    MbbL7gvvl0hLI5ciVPk1ifzvTrF0PcUjM1877dXBYZR1ycsOR1MTPVmf4cJLGl7G
    l2JAcQIDAQABo4HoMIHlMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgWgMEsG
    A1UdEQREMEKCCm1hZ3BpZS5sYW6CFW1hZ3BpZS5wdXBwZXRsYWJzLmxhboIGcHVw
    cGV0ghVwdXBwZXQucHVwcGV0bGFicy5sYW4wNwYJYIZIAYb4QgENBCoWKFB1cHBl
    dCBSdWJ5L09wZW5TU0wgSW50ZXJuYWwgQ2VydGlmaWNhdGUwHQYDVR0OBBYEFEe8
    1RQz8u2FuVL9ourkzAB/fxl+MCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMBBggrBgEF
    BQcDAjANBgkqhkiG9w0BAQsFAAOCAgEATPn8PKE+ImZnBkN2pFYY25F4F3i1xVe0
    mKYZzjHHvl3fxKUckpr9XepkzZDWR0n0FPmhn8+2oBcpMFBNR4a0jvGYDA9UMqvV
    lblKqbkuewM70xmeOv1//HKZ2qArK0Ob3HpYZbZvJYEYqPdYKdra1fi9I7tlLIyG
    WU8JZ29juVEO34J5csRt3SymPI64vdx1IQb0/x7l97e6cHoU7ICz7nZSuYqbkA6D
    cBPDkqVRfxkCM9REsYbHCSq4HJoXIPuyFGX8hFSGwNygiQkRON0AGmPK7QLL6Dwg
    u7H+ZLsZDyLmtUzLlfOTJTTsxrKuWvc+t9CEt6K/cSXZlYaZIogMDsJ2gzEzEccE
    PT7CPKbCUyEhxRLgMn8EHvc89KiizqNrHbVSRZMVl3IqJyyqPLW1xfrjpXOKiZKM
    jbqbi/TcNxXF5zERKDxmnOJT91SUGHpT8OqrCr8NDn4n8YrLxUMyPy0X06cSIS1A
    UizgvFBD3qFOc4tTuNMt8bww4/b5svPni+AwE7UjQiiVXFXiO+evNKTI8C8v8CqU
    qX0aQU4WWSg1QLW6Lbx7+BwtTAVUOqar+YuyVUBhyXV4sKTfZHxexQQ+F2QarFFH
    uvhOrN29lEi5yZiNpm6FdEX94DR7Xwnvuj2ivpzaEl1UBljhFQsNDdF9Ek0qpoDv
    kOSa/MMipuE=
    -----END CERTIFICATE-----

### Text Output

To inspect a certificate, you must first dump it to a text format.

* On the CA puppet master node, this can be done with the `puppet cert print <name>` command.
* The `openssl x509 -text -noout -in <file>` command will also work and is not restricted to the CA puppet master, although it requires a full file path. Note that it also will not use friendly names for any Puppet-specific certificate extensions (explained further below).

Here's the certificate from above in human-readable form:

<pre><code>
$ sudo puppet cert print magpie.example.com
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 3 (0x3)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=Puppet CA: magpie.example.com
        Validity
            Not Before: Oct 21 22:17:09 2012 GMT
            Not After : Oct 21 22:17:09 2017 GMT
        Subject: CN=magpie.lan
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (4096 bit)
                Modulus (4096 bit):
                    00:db:58:44:41:b8:fb:91:c3:fe:b5:57:d2:8c:7a:
                    4e:61:c4:06:ee:c3:65:75:80:53:3b:fb:9b:97:92:
                    6c:4c:60:f8:36:e8:d0:1e:ce:17:db:90:7c:47:91:
                    4c:4a:29:b3:ee:f6:56:00:e0:d9:fa:2d:50:12:07:
                    04:de:c7:e3:47:e5:1b:09:14:fd:ce:28:b1:b1:28:
                    6e:09:73:df:44:7f:ab:be:7f:56:5e:45:7d:6c:fb:
                    bd:ad:39:95:8f:9f:7a:b3:d4:2c:37:7c:f7:f8:0c:
                    ea:91:14:b9:a1:f4:11:1f:16:f3:fa:6a:c0:ba:d9:
                    ad:26:7c:52:d7:25:6f:be:59:cc:e6:c9:0b:ef:fa:
                    d6:5c:17:0e:80:ae:0e:4a:33:a3:93:fd:11:a7:8b:
                    45:df:3e:16:df:31:e0:6c:45:b8:00:84:6a:cb:f5:
                    29:3d:e6:41:e7:22:3d:31:a2:ba:ab:5e:e6:24:93:
                    1c:c2:4d:0d:9d:71:dd:a8:89:5d:21:64:82:88:25:
                    c5:f5:a7:1b:53:96:6e:0d:d1:2c:50:cd:7b:14:2f:
                    87:af:b2:7b:d4:8a:81:a8:79:90:17:17:8d:29:ac:
                    28:3d:49:ce:a8:ac:77:39:93:72:43:51:2d:10:66:
                    9f:92:2d:c4:b0:50:da:05:40:95:bb:1f:b8:e3:84:
                    80:c4:a6:9d:cd:cf:d6:07:25:60:d3:85:f2:9b:fc:
                    bf:ea:e9:33:58:13:4c:c5:14:b6:f2:79:48:29:01:
                    e0:05:61:a7:41:23:f6:73:08:80:98:20:06:b0:f5:
                    43:ef:cf:c9:a3:81:8a:28:c7:10:f0:2b:3a:18:4c:
                    90:23:a4:0e:76:90:74:9c:27:ab:4e:f8:a6:09:f8:
                    1d:32:25:71:5d:7d:5b:e3:d7:73:68:c1:eb:43:e3:
                    84:25:ca:af:d0:45:fa:b0:92:f8:ca:ab:00:96:c2:
                    be:e2:d5:db:fc:2a:6a:f2:25:c2:58:bf:ff:d7:fc:
                    58:8f:ee:e9:1b:9e:c0:18:e2:50:cd:62:1b:a7:0a:
                    4b:ec:85:6a:4d:f9:f6:6a:0f:ac:92:5d:fb:9c:b1:
                    f9:ea:0a:80:07:29:31:51:59:d5:df:f1:c8:8a:e5:
                    de:e7:a2:aa:63:79:13:9a:0e:2b:94:d8:f7:56:65:
                    ee:73:f9:89:d3:9a:f8:4a:ed:43:1a:f2:ca:06:92:
                    78:aa:67:d7:1c:fc:b1:ca:9d:98:c2:31:b6:cb:ee:
                    0b:ef:97:48:4b:23:97:22:54:f9:35:89:fc:ef:4e:
                    b1:74:3d:c5:23:33:5f:3b:ed:d5:c1:61:94:75:c9:
                    cb:0e:47:53:13:3d:59:9f:e1:c2:4b:1a:5e:c6:97:
                    62:40:71
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            Puppet Node UUID:
                ED803750-E3C7-44F5-BB08-41A04433FE2E
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name:
                DNS:magpie, DNS:magpie.example.com, DNS:puppet, DNS:puppet.example.com
            Netscape Comment:
                Puppet Ruby/OpenSSL Internal Certificate
            X509v3 Subject Key Identifier:
                47:BC:D5:14:33:F2:ED:85:B9:52:FD:A2:EA:E4:CC:00:7F:7F:19:7E
            X509v3 Extended Key Usage: critical
                TLS Web Server Authentication, TLS Web Client Authentication
            Puppet Node Preshared Key:
                kctITjOTrHthecjqnE73729109ehta
            Puppet Node Image Name:
                debian_6_vcenter_template_rev8
    Signature Algorithm: sha256WithRSAEncryption
        4c:f9:fc:3c:a1:3e:22:66:67:06:43:76:a4:56:18:db:91:78:
        17:78:b5:c5:57:b4:98:a6:19:ce:31:c7:be:5d:df:c4:a5:1c:
        92:9a:fd:5d:ea:64:cd:90:d6:47:49:f4:14:f9:a1:9f:cf:b6:
        a0:17:29:30:50:4d:47:86:b4:8e:f1:98:0c:0f:54:32:ab:d5:
        95:b9:4a:a9:b9:2e:7b:03:3b:d3:19:9e:3a:fd:7f:fc:72:99:
        da:a0:2b:2b:43:9b:dc:7a:58:65:b6:6f:25:81:18:a8:f7:58:
        29:da:da:d5:f8:bd:23:bb:65:2c:8c:86:59:4f:09:67:6f:63:
        b9:51:0e:df:82:79:72:c4:6d:dd:2c:a6:3c:8e:b8:bd:dc:75:
        21:06:f4:ff:1e:e5:f7:b7:ba:70:7a:14:ec:80:b3:ee:76:52:
        b9:8a:9b:90:0e:83:70:13:c3:92:a5:51:7f:19:02:33:d4:44:
        b1:86:c7:09:2a:b8:1c:9a:17:20:fb:b2:14:65:fc:84:54:86:
        c0:dc:a0:89:09:11:38:dd:00:1a:63:ca:ed:02:cb:e8:3c:20:
        bb:b1:fe:64:bb:19:0f:22:e6:b5:4c:cb:95:f3:93:25:34:ec:
        c6:b2:ae:5a:f7:3e:b7:d0:84:b7:a2:bf:71:25:d9:95:86:99:
        22:88:0c:0e:c2:76:83:31:33:11:c7:04:3d:3e:c2:3c:a6:c2:
        53:21:21:c5:12:e0:32:7f:04:1e:f7:3c:f4:a8:a2:ce:a3:6b:
        1d:b5:52:45:93:15:97:72:2a:27:2c:aa:3c:b5:b5:c5:fa:e3:
        a5:73:8a:89:92:8c:8d:ba:9b:8b:f4:dc:37:15:c5:e7:31:11:
        28:3c:66:9c:e2:53:f7:54:94:18:7a:53:f0:ea:ab:0a:bf:0d:
        0e:7e:27:f1:8a:cb:c5:43:32:3f:2d:17:d3:a7:12:21:2d:40:
        52:2c:e0:bc:50:43:de:a1:4e:73:8b:53:b8:d3:2d:f1:bc:30:
        e3:f6:f9:b2:f3:e7:8b:e0:30:13:b5:23:42:28:95:5c:55:e2:
        3b:e7:af:34:a4:c8:f0:2f:2f:f0:2a:94:a9:7d:1a:41:4e:16:
        59:28:35:40:b5:ba:2d:bc:7b:f8:1c:2d:4c:05:54:3a:a6:ab:
        f9:8b:b2:55:40:61:c9:75:78:b0:a4:df:64:7c:5e:c5:04:3e:
        17:64:1a:ac:51:47:ba:f8:4e:ac:dd:bd:94:48:b9:c9:98:8d:
        a6:6e:85:74:45:fd:e0:34:7b:5f:09:ef:ba:3d:a2:be:9c:da:
        12:5d:54:06:58:e1:15:0b:0d:0d:d1:7d:12:4d:2a:a6:80:ef:
        90:e4:9a:fc:c3:22:a6:e1
</code></pre> 

In the sections below, we will cover some of the notable features of this output:

* [The Subject (DN, CN, Certname, etc.)](#the-subject-dn-cn-certname-etc)
* [Issuer](#issuer)
* [Validity Period](#validity-period)
* [Alternative DNS Names](#alternative-dns-names)
* [CA Permissions](#ca-permissions)
* [Key Usage](#key-usage)
* [Puppet-Specific Certificate Extensions](#puppet-specific-certificate-extensions)

### The Subject (DN, CN, Certname, etc.)

    Subject: CN=magpie.lan

The **subject** is the owner of the certificate, and the "Subject" field of the certificate contains the subject's **distinguished name (DN).**

The DN is a string that represents the subject's identity. It can consist of several different chunks of information, which are identified by one- or two-letter codes. Any number of these chunks can be appended together (separated by commas) to form a complete DN.

You won't see multiple certificates with the same DN very frequently, since the DN represents the cert owner's identity. Usually a reused DN means that an entity's certificate has been reissued, due to expiration or revocation.

The **common name (CN)** is the most important piece of info in the DN. In this example, the node's CN is `magpie.example.com`.

The CN is the _only_ part of the DN used by Puppet. Puppet's settings and documentation often refer to the CN as the **certname** --- when a node sends a CSR to the CA, it uses the [`certname` setting][certname] to decide what to request as the CN portion of its DN. (Again, note that Puppet nodes will never request other DN components; Puppet only cares about the CN.)

In a certificate presented by a puppet master, the CN will be interpreted as one of the legal hostnames at which the puppet master can provide services. In a certificate presented by a puppet agent node, the CN will be interpreted as that node's name, which is used when finding [node definitions][lang_node] and querying an [ENC][].

In a non-Puppet certificate, other DN components can be seen. Take this example from the [Wikipedia page on X.509 certificates][wiki_x509]:

    Subject: C=US, ST=Maryland, L=Pasadena, O=Brent Baccala,
             OU=FreeSoft, CN=www.freesoft.org/emailAddress=baccala@freesoft.org

This DN includes information about the country (C), state (ST), locality (L), organization (O), and organizational unit (OU). The CN also includes an email address field, which Puppet doesn't do.

### Issuer

    Issuer: CN=Puppet CA: magpie.example.com

This is the distinguished name of the certificate authority (CA) that signed the certificate. It is used to decide which CA certificate to use when validating the certificate.

In Puppet, generally only one CA certificate is in use within a given deployment. If a node is presented with a certificate whose issuer doesn't match the CA it knows about, it will reject the connection. This can be a problem when moving nodes between deployments with distinct CAs, or if you attempt to replace the entire PKI of a Puppet deployment but miss a few files.

### Validity Period

    Validity
        Not Before: Oct 21 22:17:09 2012 GMT
        Not After : Oct 21 22:17:09 2017 GMT

SSL certificates are only valid within a specific span of time, which is set by the CA when it signs the certificate. In Puppet, the duration is configurable, and the validity period always begins at the time at which the CA signs the certificate.

Note that if nodes disagree about what time it is, they may reject otherwise-valid certificates. For example, if a CA is living in the future when it signs a certificate, any nodes living in the present will think that certificate has not become valid yet and will reject it.

### Alternative DNS Names

This field is listed under the "X509v3 extensions" section of the certificate.

    X509v3 Subject Alternative Name:
        DNS:magpie, DNS:magpie.example.com, DNS:puppet, DNS:puppet.example.com

This optional field contains other names that the certificate's owner is allowed to use.

Various types of names exist in the X.509 spec, but in Puppet, only the `DNS:` prefix is used, and each name represents a hostname that the owner is allowed to use when acting as a puppet master server.

This section should generally only be present in a puppet master certificate. Its contents can be configured with the [`dns_alt_names` setting][altnames], which can be specified in the config file or on the command line --- when a node compiles its CSR, it will request any alternate names listed in that setting. The CA will see the requested alternate names, and will decide accordingly whether to sign the certificate.

(Agent nodes are all configured to reach their puppet master at a specific hostname. When the master presents its certificate, they check to make sure the name they called is included in this section of the certificate. This helps prevent man-in-the-middle impersonations of the puppet master --- a certificate that wasn't issued to the puppet master shouldn't have the puppet master's hostname included here.)

### CA Permissions

This field is listed under the "X509v3 extensions" section of the certificate.

    X509v3 Basic Constraints: critical
        CA:FALSE

This field states whether the certificate can be used to sign new certificates. In Puppet agent and master certificates, it should always be false --- this is a CA-only permission.

### Key Usage

These fields are listed under the "X509v3 extensions" section of the certificate.

    X509v3 Key Usage: critical
        Digital Signature, Key Encipherment
    X509v3 Extended Key Usage: critical
        TLS Web Server Authentication, TLS Web Client Authentication

This defines the things the certificate can be used for. If you've read the [series of background articles on SSL][index], there should be no major surprises here. However, one note is that both agent and master certificates have both server and client authentication listed. This is because:

* The puppet master cert is also used by puppet agent running on the puppet master node, in order to request a catalog. (From itself, but rules are rules: it still uses HTTPS to do so.)
* The puppet master server process can sometimes act as a client, requesting services provided by a PuppetDB server, a different puppet master server, or another HTTPS service.
* In certain configurations (mostly the deprecated "puppet kick" feature), the puppet agent process can run an HTTPS server that listens for requests on port 8139.

### Puppet-Specific Certificate Extensions

These fields are listed under the "X509v3 extensions" section of the certificate.

    Puppet Node UUID:
        ED803750-E3C7-44F5-BB08-41A04433FE2E
    Puppet Node Preshared Key:
        kctITjOTrHthecjqnE73729109ehta
    Puppet Node Image Name:
        debian_6_vcenter_template_rev8

These fields are part of the [certificate extensions feature][extensions] added in Puppet 3.4.0. They allow node-specific information to be permanently embedded in a certificate. See the documentation of that feature for [more information][extensions].



A CA Certificate
-----

CA certificates are similar to other certificates, with a few critical differences. CA certs include different sets of permissions, and may have a circular "Issuer" reference.

### PEM File

In Puppet, CA certificate PEM files are stored the same way other certificate PEM files are. The only difference is that the name of the file is `ca.pem`. We'll skip the non-human-readable gibberish this time.

### Text Output

    $ sudo puppet cert print ca
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number: 1 (0x1)
            Signature Algorithm: sha256WithRSAEncryption
            Issuer: CN=Puppet CA: magpie.example.com
            Validity
                Not Before: Oct 14 23:33:44 2012 GMT
                Not After : Oct 14 23:33:44 2017 GMT
            Subject: CN=Puppet CA: magpie.example.com
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                RSA Public Key: (4096 bit)
                    Modulus (4096 bit):
                        00:b7:04:cd:93:84:21:f3:41:e7:0a:c9:a6:2a:07:
                        b1:3d:26:02:29:d7:84:12:e7:73:e8:38:1f:d5:af:
                        aa:fa:48:7a:32:16:b3:d3:8d:97:70:72:d0:51:9c:
                        49:6c:6c:35:17:6b:58:33:0e:5a:7f:e9:aa:5a:85:
                        35:d5:65:13:1d:d5:98:ab:30:93:ab:82:2b:16:7f:
                        39:c1:34:ee:db:cb:cc:db:09:e6:01:03:ec:89:57:
                        54:72:04:91:46:45:d1:b2:fa:b1:00:ab:08:0e:84:
                        ab:81:5a:08:0c:c9:98:dc:6f:4c:36:c6:89:b6:33:
                        ee:5b:42:cc:d0:e2:46:b7:8b:dc:17:65:d9:6b:1a:
                        78:9a:90:55:10:fd:59:36:59:0d:b7:0f:1a:cb:53:
                        d4:01:74:c4:97:8f:6e:31:94:2f:1c:ff:d9:f0:5d:
                        7a:1b:b4:5c:d0:fa:41:00:12:a6:b7:90:88:9a:7e:
                        67:ae:b4:f6:75:07:e4:39:e8:b8:0e:8c:f1:c2:1c:
                        84:cc:bf:06:8c:b3:91:91:2b:22:a7:e4:79:92:b8:
                        63:21:cf:24:77:93:15:af:b1:ed:f1:35:63:03:76:
                        32:e7:b1:fd:15:bc:35:4c:f4:ee:fd:42:b4:be:f9:
                        f9:72:79:fb:d7:5a:d0:ca:ce:91:19:98:01:1a:93:
                        cb:64:6d:b0:60:8b:2e:77:3a:a1:10:f2:15:c6:77:
                        dd:44:38:3b:16:e4:b8:03:9c:04:24:86:9d:0f:ce:
                        20:71:43:02:1e:9b:1f:8f:90:ad:d4:a0:a1:eb:36:
                        75:0e:de:eb:a8:fe:a6:c0:5e:4f:e1:6b:47:c2:de:
                        90:20:f2:7c:c5:30:74:ec:16:54:61:1c:d9:26:0f:
                        2b:00:05:1f:86:e4:83:ba:10:6a:f7:41:b9:4b:3b:
                        5a:e4:9a:20:d6:a5:8a:33:0f:f6:f2:19:ee:c8:b0:
                        90:ec:04:4a:d0:ca:4e:16:cc:e6:7c:79:03:b4:6c:
                        b0:3f:3e:a4:dd:75:47:02:11:14:50:22:16:0d:85:
                        85:df:da:c1:29:30:2a:22:82:d7:ef:21:0e:e8:2d:
                        51:a2:44:24:da:b3:c5:8d:3a:b4:43:18:b1:1a:37:
                        27:9e:c0:ec:16:a2:31:ab:8a:97:2c:cc:b7:60:dd:
                        a2:be:2a:a1:72:f9:e1:b3:2a:9e:8d:76:2b:88:f0:
                        a0:71:3f:2e:8e:4e:71:15:a0:76:46:0e:b7:db:a1:
                        18:ca:6e:2f:3d:9f:3f:2c:85:5b:98:0d:ae:31:0e:
                        5d:58:f0:e9:2d:ce:d5:a9:7c:29:45:04:66:84:6f:
                        e7:07:6c:2e:a9:c1:b0:08:e7:da:a4:ae:99:32:b0:
                        3b:62:0f
                    Exponent: 65537 (0x10001)
            X509v3 extensions:
                X509v3 Basic Constraints: critical
                    CA:TRUE
                X509v3 Subject Key Identifier:
                    47:BC:D5:14:33:F2:ED:85:B9:52:FD:A2:EA:E4:CC:00:7F:7F:19:7E
                X509v3 Key Usage: critical
                    Certificate Sign, CRL Sign
                Netscape Comment:
                    Puppet Ruby/OpenSSL Internal Certificate
        Signature Algorithm: sha256WithRSAEncryption
            0a:27:5b:86:ec:b7:d4:f4:b4:2f:3a:b0:09:7a:72:d8:5f:44:
            c7:38:87:16:b5:99:3f:79:0f:7d:b5:d7:cd:ea:0e:1f:fb:6a:
            93:fe:9e:29:1d:66:0f:0c:cd:9a:ab:90:d4:1f:72:08:b1:53:
            c1:5d:f7:a7:ad:f3:4d:fa:87:79:b9:fb:06:5d:97:cd:1b:01:
            a3:a5:51:20:0d:ff:77:f1:21:25:bc:c3:15:a2:8c:4c:c6:f6:
            7c:39:c3:6c:81:ed:76:88:70:dd:c8:e5:f1:46:3e:da:e9:a2:
            ff:b5:c4:4f:a1:eb:79:e8:c1:05:1f:f8:5a:31:ea:ad:11:4d:
            4f:7c:e6:60:ee:08:78:08:ad:08:b5:12:85:94:c6:39:ac:cc:
            51:71:f3:33:89:79:9b:3c:7a:43:2b:ee:4c:11:00:1c:d9:d2:
            a3:17:2c:4e:53:9b:10:82:9f:89:51:c4:95:12:32:dc:ee:78:
            e5:0a:fe:a0:1d:0d:9f:c9:f3:68:02:9c:93:f8:ad:d4:a5:b4:
            f1:6f:5f:e2:fd:e2:9d:aa:85:2b:67:d2:db:3d:32:a4:14:58:
            40:f7:3a:0a:15:39:1e:f5:70:a5:2d:27:f7:27:34:b5:f5:3e:
            3b:8a:7e:de:be:25:bf:d1:7a:12:1d:aa:2c:41:fe:7d:1f:a4:
            4f:43:34:b6:d2:b5:85:fa:7f:35:65:22:85:89:1a:d5:99:49:
            b3:68:da:41:b6:af:60:af:79:10:88:b5:c7:85:21:5f:02:b3:
            c2:a4:17:f6:ad:e2:5e:f9:95:b3:d5:4c:dd:5b:17:89:a5:70:
            82:02:80:f6:8d:0a:d5:ba:4a:3d:f2:2c:ff:fd:fb:e7:f2:59:
            82:4e:fb:a0:c7:4d:7f:05:3f:12:b1:f8:97:2c:b2:f9:dd:3d:
            f1:3c:60:2e:2f:c5:74:ae:60:59:65:22:5b:d7:0e:d2:87:b5:
            74:37:d5:2a:45:47:b5:46:be:14:53:52:10:1c:62:5d:ea:97:
            ea:a7:e9:de:3b:f1:ac:b1:04:13:e4:19:e9:36:46:2c:46:1c:
            f3:e8:5c:e8:d3:ba:95:77:f7:4d:b6:1b:68:05:ab:0e:98:89:
            bd:14:c3:bc:e4:ac:ef:6e:af:be:c4:5d:3b:89:0c:d0:e5:a6:
            85:85:72:82:82:3f:ba:21:a2:b4:11:99:59:8e:8f:90:cc:e3:
            9e:a7:e4:cc:d4:0d:ab:12:f9:b2:c5:9b:c0:d4:01:ab:a5:5c:
            7c:18:6f:fe:e4:3d:9d:a0:ba:04:8e:54:5f:50:d3:57:82:81:
            5e:fc:ad:87:48:9f:b6:e9:b3:b3:59:81:3f:2b:23:1d:b9:c1:
            de:f4:05:fe:db:b5:a9:b8

As before, the sections below will cover notable features of a CA certificate:

* [The Subject](#the-subject)
* [Issuer](#issuer-1)
* [Validity Period](#validity-period-1)
* [CA Permissions](#ca-permissions-1)
* [Key Usage](#key-usage-1)

### The Subject

    Subject: CN=Puppet CA: magpie.example.com

Much like in other certificates, the "Subject" field contains the owner's **distinguished name.** Note that the CA's DN matches the "Issuer" field in the earlier certificate.

When creating a CA, Puppet will only fill in the common name (CN) portion of the CA's DN --- in this case, the value of the CN is `Puppet CA: magpie.example.com`. This value is taken from the value of the [`ca_name` setting][ca_name] at the time the CA is initialized.

In Puppet, the CA certificate's CN has no particular meaning; it's just a unique descriptive string. (Unlike agent and master certificates, where the CN is treated as a hostname.)

### Issuer

    Issuer: CN=Puppet CA: magpie.example.com

Since this is a [self-signed root CA](./certificates_pki.html#certificate-authorities-cas) certificate, the issuer is the same as the subject.

### Validity Period

    Validity
        Not Before: Oct 14 23:33:44 2012 GMT
        Not After : Oct 14 23:33:44 2017 GMT

Like any other certificate, CAs can expire.

### CA Permissions

This field is listed under the "X509v3 extensions" section of the certificate.

    X509v3 Basic Constraints: critical
        CA:TRUE

This field states whether the certificate can be used to sign new certificates. In a CA certificate, this has to be true.

### Key Usage

This field is listed under the "X509v3 extensions" section of the certificate.

    X509v3 Key Usage: critical
        Certificate Sign, CRL Sign

This is sort of a reiteration of the CA permissions.

Note that the CA certificate actually lacks all of the permissions granted to normal certificates. It **cannot** be used to:

* Sign arbitrary messages
* Encipher arbitrary messages
* Pose as a web server
* Pose as a web client

It can **only** be used to sign certificates and CRLs.
