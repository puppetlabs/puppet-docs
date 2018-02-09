---
layout: default
title: "SSL configuration: autosigning certificate requests"
---

[external_ca]: ./config_ssl_external_ca.html
[csr_attributes]: ./ssl_attributes_extensions.html

## CSRs, certificates, and autosigning

Before Puppet agent nodes can retrieve their configuration catalogs, they need a signed certificate from the local Puppet certificate authority (CA). When using Puppet's built-in CA (that is, not [using an external CA][external_ca]), agents will submit a certificate signing request (CSR) to the CA Puppet master and will retrieve a signed certificate once one is available.

By default, these CSRs must be manually signed by an admin user, using either the `puppet cert` command or the "node requests" page of the Puppet Enterprise console.

Alternately, you can configure the CA Puppet master to automatically sign certain CSRs to speed up the process of bringing new agent nodes into the deployment.

> **Important security note:** Autosigning CSRs will change the nature of your deployment's security, and you should be sure you understand the implications before configuring it. Each kind of autosigning has its own security impact.

## Disabling autosigning

By default, the `autosign` setting in the `[master]` section of the CA Puppet master's `puppet.conf` file is set to `$confdir/autosign.conf`, which means the basic autosigning functionality is enabled upon installation. However, depending on your installation method, there might not be a whitelist at that location once the Puppet master is running.

-   In open source Puppet, `autosign.conf` doesn't exist by default.
-   In monolithic Puppet Enterprise (PE) installations, where all required services run on one server, `autosign.conf` exists on the master, but it is empty by default because the master doesn't need to whitelist other servers.
-   In split PE installations, where services like PuppetDB can run on different servers, `autosign.conf` exists on the CA master and contains a whitelist of other required hosts.

If the `autosign.conf` file is empty or doesn't exist, the whitelist is effectively empty. The CA Puppet master therefore doesn't autosign any certificates until the default `autosign.conf` file, or the `autosign` setting's path if configured, is a non-executable whitelist file with properly formatted content or a custom policy executable that the Puppet user has permission to run.

To _explicitly_ disable autosigning, set `autosign = false` in the `[master]` section of the CA Puppet master's `puppet.conf`, which disables CA autosigning even if the `autosign.conf` file or a custom policy executable exists.

For more information about the different autosigning methods, see [basic autosigning][inpage_basic] and [policy-based autosigning][inpage_policy]. For more information about the `autosign` setting in `puppet.conf`, see the [configuration reference](./configuration.html#autosign).

## Naïve autosigning

Naïve autosigning causes the CA to autosign **all** CSRs.

### Enabling naïve autosigning

To enable naïve autosigning, set `autosign = true` in the `[master]` section of the CA Puppet master's `puppet.conf`.

### Security implications of naïve autosigning

**Never do this in a production deployment.** Naïve autosigning is suitable only for temporary test deployments incapable of serving catalogs containing sensitive information.

## Basic autosigning (autosign.conf)

[inpage_basic]: #basic-autosigning-autosignconf

In basic autosigning, the CA uses a config file containing a whitelist of certificate names and domain name globs. When a CSR arrives, the requested certificate name is checked against the whitelist file. If the name is present (or covered by one of the domain name globs), the certificate is autosigned; if not, it is left for manual review.

### Enabling basic autosigning

The `autosign.conf` whitelist file's location and contents are described in [its documentation](./config_file_autosign.html).

Puppet looks for `autosign.conf` at the path configured in the [`autosign` setting][autosign setting] in the `[master]` section of `puppet.conf`. The default path is `$confdir/autosign.conf`, and the default `confdir` path depends on your operating system. [See the confdir documentation for more information.](./dirs_confdir.html)

If the `autosign.conf` file pointed to by the `autosign` setting is a file that the Puppet user can execute, Puppet instead attempts to run it as a custom policy executable even if it contains a valid `autosign.conf` whitelist.

> **Note:** In open source Puppet, no `autosign.conf` file exists by default. In Puppet Enterprise, the file exists by default but might be empty. In both cases, the basic autosigning feature is technically enabled by default but doesn't autosign any certificates because the whitelist is effectively empty.
>
> The CA Puppet master therefore doesn't autosign any certificates until the `autosign.conf` file contains a properly formatted whitelist or is a custom policy executable that the Puppet user has permission to run, or until the `autosign` setting is pointed at a whitelist file with properly formatted content or a custom policy executable that the Puppet user has permission to run.

### Security implications of basic autosigning

Because any host can provide any certname when requesting a certificate, basic autosigning is essentially **insecure**. Use it only when you fully trust any computer capable of connecting to the Puppet master.

With basic autosigning enabled, an attacker that guesses an unused certname allowed by `autosign.conf` can obtain a signed agent certificate from the Puppet master. The attacker could then obtain a configuration catalog, which can contain sensitive information depending on your deployment's Puppet code and node classification.

## Policy-based autosigning

[inpage_policy]: #policy-based-autosigning

In policy-based autosigning, the CA will run an external policy executable every time it receives a CSR. This executable will examine the CSR and tell the CA whether the certificate is approved for autosigning. If the executable approves, the certificate is autosigned; if not, it is left for manual review.

### Enabling policy-based autosigning

To enable policy-based autosigning, set `autosign = <policy executable file>` in the `[master]` section of the CA Puppet master's `puppet.conf`.

The policy executable file **must be executable by the same user as the Puppet master.** If not, it will be treated as a certname whitelist file.

### Custom policy executables

A custom policy executable can be written in any programming language; it just has to be executable in a \*nix-like environment. The Puppet master will pass it the certname of the request (as a command line argument) and the PEM-encoded CSR (on stdin), and will expect a `0` (approved) or non-zero (rejected) exit code.

Once it has the CSR, a policy executable can extract information from it and decide whether to approve the certificate for autosigning. This is most useful if you are [embedding additional information in the CSR][csr_attributes] when you provision your nodes.

If you aren't embedding additional data, the CSR will contain only the node's certname and public key. This can still provide more flexibility and security than `autosign.conf`, as the executable can do things like query your provisioning system, CMDB, or cloud provider to make sure a node with that name was recently added.

### Security implications of policy-based autosigning

Policy-based autosigning can be both fast and extremely secure, _depending on how you manage the information the policy executable is using._ For example:

-   If you embed a unique pre-shared key in each node when you provision it, and provide your policy executable with a database of these keys, your autosigning security will be as good as your handling of the keys --- as long as it's impractical for an attacker to acquire a PSK, it will be impractical for them to acquire a signed certificate.
-   If nodes running on a cloud service embed their instance UUIDs in their CSRs, and your executable queries the cloud provider's API to check that a node with that UUID exists in your account, your autosigning security will be as good as the security of the cloud provider's API. If an attacker can impersonate a legit user to the API and get a list of node UUIDs, or if they can create a rogue node in your account, they can acquire a signed certificate.

As you can see, you must think things through carefully when designing your CSR data and signing policy. As long as you can arrange reasonable end-to-end security for secret data on your nodes, you should be able to rig up a secure autosigning system.

### Policy executable API

The API for policy executables is as follows:

-   **Run environment:** The executable will be run once for each incoming CSR.
    -   It will be executed by the Puppet master process and will run as the same user as the Puppet master.
    -   The Puppet master process will _block until the executable finishes running._ We expect policy executables to finish in a timely fashion; if they do not, it's possible for them to tie up all available Puppet master threads and deny service to other agents. If an executable needs to perform network requests or other potentially expensive operations, the author is in charge of implementing any necessary timeouts, possibly bailing and exiting non-zero in the event of failure. Alternatively, signing requests consume JRubies on a Puppet Server master but might not block all requests while the pool contains available JRubies, and won't block non-Ruby requests.
-   **Arguments:** The executable must allow a single command line argument. This argument will be the Subject CN (certname) of the incoming CSR.
    -   No other command line arguments should be provided.
    -   The Puppet master should never fail to provide this argument.
-   **Stdin:** The executable will receive the entirety of the incoming CSR on its stdin stream. The CSR will be encoded in PEM format.
    -   The stdin stream will contain nothing but the complete CSR.
    -   The Puppet master should never fail to provide the CSR on stdin.
-   **Exit status:** The executable must exit with a status of `0` if the certificate should be autosigned; it must exit with a non-zero status if it should not be autosigned.
    -   The Puppet master will treat all non-zero exit statuses as equivalent.
-   **Stdout and stderr:** Anything the executable emits on stdout or stderr will be copied to the Puppet master's log output at the `debug` log level. Puppet will otherwise ignore the executable's output; only the exit code is considered significant.

