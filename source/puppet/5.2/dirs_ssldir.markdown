---
layout: default
title: "Directories: SSLdir"
---


[ssldir]: ./configuration.html#ssldir
[cadir]: ./configuration.html#cadir
[cacrl]: ./configuration.html#cacrl
[cacert]: ./configuration.html#cacert
[cakey]: ./configuration.html#cakey
[capub]: ./configuration.html#capub
[cert_inventory]: ./configuration.html#certinventory
[caprivatedir]: ./configuration.html#caprivatedir
[capass]: ./configuration.html#capass
[csrdir]: ./configuration.html#csrdir
[serial]: ./configuration.html#serial
[signeddir]: ./configuration.html#signeddir
[requestdir]: ./configuration.html#requestdir
[hostcsr]: ./configuration.html#hostcsr
[certdir]: ./configuration.html#certdir
[hostcert]: ./configuration.html#hostcert
[localcacert]: ./configuration.html#localcacert
[hostcrl]: ./configuration.html#hostcrl
[privatedir]: ./configuration.html#privatedir
[passfile]: ./configuration.html#passfile
[privatekeydir]: ./configuration.html#privatekeydir
[hostprivkey]: ./configuration.html#hostprivkey
[publickeydir]: ./configuration.html#publickeydir
[hostpubkey]: ./configuration.html#hostpubkey
[vardir]: ./dirs_vardir.html
[confdir]: ./dirs_confdir.html
[certname]: ./configuration.html#certname
[print_settings]: ./config_print.html



Puppet stores its certificate infrastructure in the `ssldir` directory. This directory has a similar structure on all Puppet nodes, whether they are agent nodes, Puppet master servers, or the certificate authority (CA) master.

{:.concept}
## Location of the `ssldir` directory

By default, the `ssldir` directory is located at `$confdir/ssl`. For more information about the `confdir` folder, see [confdir][confdir].

Its location can be configured with the [`ssldir` setting][ssldir]. To see what the location is on one of your nodes, run `puppet config print ssldir`.

> **Note:** Some third-party Puppet packages for Linux put the ssldir in the [vardir][] instead of the [confdir][]. The right place for it in the filesystem hierarchy is debatable; the contents are automatically generated and will tend to grow, but are also important, relatively difficult to replace, and can be considered configuration.
>
> If a distro changes the `ssldir` directory location, it will do so by setting `ssldir` in the `$confdir/puppet.conf` file, usually in the `[main]` section. You can find out its location by running `puppet config print ssldir`.

{:.concept}
## What the `ssldir` directory contains

The `ssldir` directory contains Puppet certificates, private keys, certificate signing requests (CSRs), and other cryptographic documents.

The `ssldir` directory on Agent nodes and Puppet masters contain a private key (`private_keys/<certname>.pem`), a public key (`public_keys/<certname.pem>`), a signed certificate (`certs/<certname>.pem`), a copy of the CA certificate (`certs/ca.pem`), and a copy of the certificate revocation list (CRL) (`crl.pem`). They usually also retain a copy of their CSR after submitting it (`certificate_requests/<certname>.pem`). If these files don't exist, they are either generated locally or requested from the CA Puppet master.

Since agent and master credentials are identified by [certname][], a Puppet agent process and Puppet master process running on the same server can use the same credentials.

The `ssldir` directory for the Puppet CA, which runs on the CA Puppet master server, contains similar credentials: private and public keys, certificate, master copy of the CRL. It also maintains a list of all signed certificates in the deployment, a copy of each signed certificate, and an incrementing serial number for new certificates. All of the CA's data is stored in the `ca` subdirectory, to keep it separated from any general Puppet credentials on the same server.

{:.reference}
## The `ssldir` directory structure

All of the files and directories in the `ssldir` directory have corresponding Puppet settings, which can be used to individually change their locations. However, this is generally not recommended.

The permissions mode of the `ssldir` directory should be 0771, and it and every file it contains should be owned by the user that Puppet runs as: root or Administrator on Puppet agent nodes, and defaulting to `puppet` or `pe-puppet` on a Puppet master server. Ownership and permissions in the `ssldir` directory should be managed automatically.

The `ssldir` has the following structure:

* `ca` _(directory)_ --- Contains all files used by Puppet's built-in certificate authority (CA). This directory must exist only on the CA Puppet master server. Mode: 0755. Setting: [`cadir`][cadir].
    * `ca_crl.pem` --- The master copy of the certificate revocation list (CRL) managed by the CA. Mode: 0644. Setting: [`cacrl`][cacrl].
    * `ca_crt.pem` --- The CA's self-signed certificate. This cannot be used as a Puppet master or Puppet agent certificate; it can only be used to sign certificates. Mode: 0644. Setting: [`cacert`][cacert].
    * `ca_key.pem` --- The CA's private key. Tied for most security-critical file in the entire Puppet certificate infrastructure. Mode: 0640. Setting: [`cakey`][cakey].
    * `ca_pub.pem` --- The CA's public key. Mode: 0644. Setting: [`capub`][capub].
    * `inventory.txt` --- A list of all certificates the CA has signed, along with their serial numbers and validity periods. Mode: 0644. Setting: [`cert_inventory`][cert_inventory].
    * `private` _(directory)_ --- Contains only one file. Mode: 0750. Setting: [`caprivatedir`][caprivatedir].
        * `ca.pass` --- The (randomly generated) password to the CA's private key. Tied for most security-critical file in the entire Puppet certificate infrastructure. Mode: 0640. Setting: [`capass`][capass].
    * `requests` _(directory)_ --- Contains certificate signing requests (CSRs) that were received but have not yet been signed. The CA deletes CSRs from this directory after signing them. Mode: 0755. Setting: [`csrdir`][csrdir].
        * `<name>.pem` --- Individual CSR files.
    * `serial` --- A file containing the serial number for the next certificate the CA will sign. This is incremented with each new certificate signed. Mode: 0644. Setting: [`serial`][serial].
    * `signed` _(directory)_ --- Contains copies of all certificates the CA has signed. Mode: 0755. Setting: [`signeddir`][signeddir].
        * `<name>.pem` --- Individual signed certificate files.
* `certificate_requests` _(directory)_ --- Contains any CSRs generated by this node in preparation for submission to the CA. CSRs persist in this directory even after they have been submitted and signed. Mode: 0755. Setting: [`requestdir`][requestdir].
    * `<certname>.pem` --- This node's CSR. Mode: 0644. Setting: [`hostcsr`][hostcsr].
* `certs` _(directory)_ --- Contains any signed certificates present on this node. This includes the node's own certificate, as well as a copy of the CA certificate (for use when validating certificates presented by other nodes). Mode: 0755. Setting: [`certdir`][certdir].
    * `<certname>.pem` --- This node's certificate. Mode: 0644. Setting: [`hostcert`][hostcert].
    * `ca.pem` --- A local copy of the CA certificate. Mode: 0644. Setting: [`localcacert`][localcacert].
* `crl.pem` --- A copy of the certificate revocation list (CRL) retrieved from the CA, for use by Puppet agent or Puppet master. Mode: 0644. Setting: [`hostcrl`][hostcrl].
* `private` _(directory)_ --- Usually does not contain any files. Mode: 0750. Setting: [`privatedir`][privatedir].
    * `password` --- The password to a node's private key. Usually not present. The conditions in which this file would exist are not defined. Mode: 0640. Setting: [`passfile`][passfile].
* `private_keys` _(directory)_ --- Contains any private keys present on this node. This should generally only include the node's own private key, although on the CA it might also contain any private keys created by the `puppet cert generate` command. It will never contain the private key for the CA certificate. Mode: 0750. Setting: [`privatekeydir`][privatekeydir].
    * `<certname>.pem` --- This node's private key. Mode: 0600. Setting: [`hostprivkey`][hostprivkey].
* `public_keys` _(directory)_ --- Contains any public keys generated by this node in preparation for generating a CSR. Mode: 0755. Setting: [`publickeydir`][publickeydir].
    * `<certname>.pem` --- This node's public key. Mode: 0644. Setting: [`hostpubkey`][hostpubkey].

