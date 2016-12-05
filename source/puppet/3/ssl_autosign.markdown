---
layout: default
title: "SSL Configuration: Autosigning Certificate Requests"
canonical: "/puppet/latest/reference/ssl_autosign.html"
---

[external_ca]: ./config_ssl_external_ca.html
[csr_attributes]: ./ssl_attributes_extensions.html


CSRs, Certificates, and Autosigning
-----

Before puppet agent nodes can retrieve their configuration catalogs, they need a signed certificate from the local Puppet certificate authority (CA). When using Puppet's built-in CA (that is, not [using an external CA][external_ca]), agents will submit a certificate signing request (CSR) to the CA puppet master and will retrieve a signed certificate once one is available.

By default, these CSRs must be manually signed by an admin user, using either the `puppet cert` command or the "node requests" page of the Puppet Enterprise console.

Alternately, you can configure the CA puppet master to automatically sign certain CSRs to speed up the process of bringing new agent nodes into the deployment.


> **Important security note:** Autosigning CSRs will change the nature of your deployment's security, and you should be sure you understand the implications before configuring it. Each kind of autosigning has its own security impact.


Disabling Autosigning
-----

By default, the CA puppet master will use the `$confdir/autosign.conf` file as a whitelist; [see "Basic Autosigning" below][inpage_basic]. Since this file doesn't exist by default, autosigning is implicitly disabled, and the CA will not autosign any certificates.

To _explicitly_ disable autosigning, you can set `autosign = false` in the `[master]` block of the CA puppet master's puppet.conf. This will cause the CA to never autosign even if an autosign.conf file is written later.

Naïve Autosigning
-----

Naïve autosigning causes the CA to autosign **all** CSRs.

### Enabling Naïve Autosigning

To enable naïve autosigning, set `autosign = true` in the `[master]` block of the CA puppet master's puppet.conf.

### Security Implications of Naïve Autosigning

**You should never do this in a production deployment.** Naïve autosigning is only suitable for temporary test deployments that are incapable of serving catalogs containing sensitive information.

Basic Autosigning (autosign.conf)
-----

[inpage_basic]: #basic-autosigning-autosignconf

In basic autosigning, the CA uses a config file containing a whitelist of certificate names and domain name globs. When a CSR arrives, the requested certificate name is checked against the whitelist file. If the name is present (or covered by one of the domain name globs), the certificate is autosigned; if not, it is left for manual review.

### Enabling Basic Autosigning

To enable basic autosigning, set `autosign = <whitelist file>` in the `[master]` block of the CA puppet master's puppet.conf. The whitelist file must **not** be executable by the same user as the puppet master; otherwise it will be treated as a policy executable.

> **Note:** Basic autosigning is enabled by default and looks for a whitelist located at `$confdir/autosign.conf`. For more info, see [the page on the confdir](./dirs_confdir.html).

### The `autosign.conf` File

The `autosign.conf` whitelist file is a list of certnames or domain name globs (one per line) whose certificate requests will automatically be signed.

    rebuilt.example.com
    *.scratch.example.com
    *.local

Note that domain name globs do not function as normal globs: an asterisk can only represent one or more subdomains at the front of a certname that resembles a fully-qualified domain name. (That is, if your certnames don't look like FQDNs, you can't use `autosign.conf` to full effect.)

### Security Implications of Basic Autosigning

Since any host can provide any certname when requesting a certificate, basic autosigning should only be used in situations where you fully trust any computer able to connect to the puppet master.

With basic autosigning enabled, an attacker able to guess an unused certname allowed by `autosign.conf` would be able to obtain a signed agent certificate from the puppet master. They would then be able to obtain a configuration catalog, which may or may not contain sensitive information (depending on your deployment's Puppet code and node classification).


Policy-Based Autosigning
-----

> **Version note:** Policy-based autosigning is only available in Puppet 3.4 and later.

In policy-based autosigning, the CA will run an external policy executable every time it receives a CSR. This executable will examine the CSR and tell the CA whether the certificate is approved for autosigning. If the executable approves, the certificate is autosigned; if not, it is left for manual review.

### Enabling Policy-Based Autosigning

To enable policy-based autosigning, set `autosign = <policy executable file>` in the `[master]` block of the CA puppet master's puppet.conf.

The policy executable file **must be executable by the same user as the puppet master.** If not, it will be treated as a certname whitelist file.

### Custom Policy Executables

A custom policy executable can be written in any programming language; it just has to be executable in a \*nix-like environment. The puppet master will pass it the certname of the request (as a command line argument) and the PEM-encoded CSR (on stdin), and will expect a `0` (approved) or non-zero (rejected) exit code.

Once it has the CSR, a policy executable can extract information from it and decide whether to approve the certificate for autosigning. This is most useful if you are [embedding additional information in the CSR][csr_attributes] when you provision your nodes.

If you aren't embedding additional data, the CSR will contain only the node's certname and public key. This can still provide more flexibility and security than `autosign.conf`, as the executable can do things like query your provisioning system, CMDB, or cloud provider to make sure a node with that name was recently added.

### Security Implications of Policy-Based Autosigning

Policy-based autosigning can be both fast and extremely secure, _depending on how you manage the information the policy executable is using._ For example:

* If you embed a unique pre-shared key in each node when you provision it, and provide your policy executable with a database of these keys, your autosigning security will be as good as your handling of the keys --- as long as it's impractical for an attacker to acquire a PSK, it will be impractical for them to acquire a signed certificate.
* If nodes running on a cloud service embed their instance UUIDs in their CSRs, and your executable queries the cloud provider's API to check that a node with that UUID exists in your account, your autosigning security will be as good as the security of the cloud provider's API. If an attacker can impersonate a legit user to the API and get a list of node UUIDs, or if they can create a rogue node in your account, they can acquire a signed certificate.

As you can see, you must think things through carefully when designing your CSR data and signing policy. As long as you can arrange reasonable end-to-end security for secret data on your nodes, you should be able to rig up a secure autosigning system.


### Policy Executable API

The API for policy executables is as follows:

* **Run environment:** The executable will be run once for each incoming CSR.
    * It will be executed by the puppet master process and will run as the same user as the puppet master.
    * The puppet master process will _block until the executable finishes running._ We expect policy executables to finish in a timely fashion; if they do not, it's possible for them to tie up all available puppet master threads and deny service to other agent nodes. If an executable needs to perform network requests or other potentially expensive operations, the author is in charge of implementing any necessary timeouts, possibly bailing and exiting non-zero in the event of failure.
    * (Note that under a Rack server like Passenger, there are generally multiple puppet master processes available at any given time, so policy executables have a little bit of leeway.)
* **Arguments:** The executable must allow a single command line argument. This argument will be the Subject CN (certname) of the incoming CSR.
    * No other command line arguments should be provided.
    * The puppet master should never fail to provide this argument.
* **Stdin:** The executable will receive the entirety of the incoming CSR on its stdin stream. The CSR will be encoded in PEM format.
    * The stdin stream will contain nothing but the complete CSR.
    * The puppet master should never fail to provide the CSR on stdin.
* **Exit status:** The executable must exit with a status of `0` if the certificate should be autosigned; it must exit with a non-zero status if it should not be autosigned.
    * The puppet master will treat all non-zero exit statuses as equivalent.
* **Stdout and stderr:** Anything the executable emits on stdout or stderr will be copied to the puppet master's log output at the `debug` log level. Puppet will otherwise ignore the executable's output; only the exit code is considered significant.

