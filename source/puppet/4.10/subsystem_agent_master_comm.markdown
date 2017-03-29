---
title: "Subsystems: Agent/master HTTPS communications"
layout: default
---

[http_api]: ./http_api/http_api_index.html
[authconf]: ./config_file_auth.html
[facts]: ./lang_variables.html#facts-and-built-in-variables
[catalog]: ./lang_summary.html#compilation-and-catalogs
[file]: ./type.html#file
[static]: ./indirection.html#catalog
[keepalive_setting]: ./configuration.html#httpkeepalivetimeout



Puppet agent and Puppet master communicate via host-verified HTTPS.

> **Note on verification:** If the agent does not yet have its own certificate, it will make several unverified requests before it can switch to verified mode. In these requests, the agent doesn't identify itself to the master and doesn't check the master's cert against the CA. In the descriptions below, assume every request is host-verified unless stated otherwise.

The HTTPS endpoints Puppet uses are detailed in the [HTTP API reference][http_api]. Note that access to each individual endpoint is controlled by [auth.conf][authconf] on the master.

## Persistent connections/Keep-alive

When acting as an HTTPS client, Puppet will try to re-use connections in order to reduce TLS overhead, by sending `Connection: Keep-Alive` in the HTTP request. This helps improve performance for runs with dozens of HTTPS requests.

Puppet will only cache verified HTTPS connections, so it excludes the unverified connections a new agent makes to request a new certificate. Puppet also will not cache connections when a custom HTTP connection class has been specified. (This is an esoteric use case that most users will never see.)

You can use [the `http_keepalive_timeout` setting][keepalive_setting] to configure the keepalive duration. It must be shorter than the maximum keepalive allowed by the Puppet master web server.

An HTTP server can disable persistent connections ([Apache example](http://httpd.apache.org/docs/current/mod/core.html#keepalive)). If so, Puppet will request that the connection be kept open as usual, but the server will decline by sending `Connection: close` in the HTTP response and Puppet will start a new connection for its next request.


## Diagram

This flow diagram illustrates the pattern of agent-side checks and HTTPS requests to the Puppet master during a single Puppet run.

[See below the image for a textual description of this process](#check-for-keys-and-certificates), which explains the illustrated steps in more detail.

> **Note:** This diagram is out of date; it uses the HTTPS endpoints from Puppet 3.x. We will update this diagram sometime in the future.

[![An illustration of the process described below -- this diagram contains no new content, but is simply a visual interpretation of everything from "check for keys and certificates" on down.](./images/agent-master-https-sequence-small.gif)](./images/agent-master-https-sequence-large.gif)

## Check for keys and certificates

1. Does the agent have a private key at `$ssldir/private_keys/<NAME>.pem`?
    * If no, generate one.
2. Does the agent have a copy of the CA certificate at `$ssldir/certs/ca.pem`?
    * If no, fetch it. (Unverified GET request to `/certificate/ca`. Since the agent is retrieving the foundation for all future trust over an untrusted link, this could be vulnerable to MITM attacks, but it's also just a convenience; you can make this step unnecessary by distributing the CA cert as part of your server provisioning process, so that agents never ask for a CA cert over the network. If you do this, an attacker could temporarily deny Puppet service to brand new nodes, but would be unable to take control of them with a rogue Puppet master.)
3. Does the agent have a signed certificate at `$ssldir/certs/<NAME>.pem`?
    * If yes, skip the following section and continue to "request node object."
    * (If it has a cert but it doesn't match the private key, bail with an error.)

## Obtain a certificate (if necessary)

Note that if the agent has submitted a certificate signing request, an admin user will need to run `puppet cert sign <NAME>` on the CA Puppet master before the agent can fetch a signed certificate. (Unless autosign is enabled.) Since incoming CSRs are unverified, you can use fingerprints to prove them, by comparing `puppet agent --fingerprint` on the agent to `puppet cert list` on the CA master.

1. Try to fetch an already-signed certificate from the master. (Unverified GET request to `/puppet-ca/v1/certificate/<NAME>`.)
    * If it gets one, skip the rest of this section and continue to "request node object."
    * (If it gets one that doesn't match the private key, bail with an error.)
2. Determine whether the agent has already requested a certificate signing: Look for `$ssldir/certificate_requests/<NAME>.pem`.
    * If this file exists, the agent will bail, assuming it needs user intervention on the master. If `waitforcert` is enabled, it will wait a few seconds and start this section over.
3. Double-check with the master whether the agent has already requested a certificate signing; the agent might have just lost the local copy of the request. (Unverified GET request to `/puppet-ca/v1/certificate_request/<NAME>`.)
    * If this request doesn't 404, the agent will bail, assuming it needs user intervention on the master. If `waitforcert` is enabled, it will wait a few seconds and start this section over.
4. If the agent has reached this step, it has never requested a certificate, so request one now. (Unverified PUT request to `/puppet-ca/v1/certificate_request/<NAME>`.)
5. Return to the first step of this section, in case the master has autosign enabled; if it doesn't, the agent will end up bailing at step 2.

## Request node object and switch environments

1. Do a GET request to `/puppet/v3/node/<NAME>`.
    * If successful, read the environment from the node object.
        * If the node object has one: In all subsequent requests during this run, use this environment instead of the one in the agent's config file.
    * If unsuccessful, or if the node object had no environment set, continue using the environment from the agent's config file.

> **Note:** This step was added in Puppet 3.0.0, to allow an ENC to centrally assign nodes to environments. The lenient failure mode is because many users' [auth.conf][authconf] files didn't allow access to node objects, since that rule was only added to the default auth.conf in Puppet 2.7.0 and many people don't update their config files for every upgrade.

## Fetch plugins

If `pluginsync` is enabled on the agent:

1. Do a GET request to `/puppet/v3/file_metadatas/plugins` with `recurse=true` and `links=manage`. This is a special file server mountpoint that scans the `lib` directory of every module. Note the funky Rails-esque endpoint pluralization on `file_metadata`.
2. Check whether any of the discovered plugins need to be downloaded.
    * If so, do a GET request to `/puppet/v3/file_content/plugins/<FILE>` for each one.

## Request catalog while submitting facts

1. Do a POST request to `/puppet/v3/catalog/<NAME>`, where the post data is all of the node's [facts][] encoded as JSON. Receive a compiled [catalog][] in return.

> **Note:** This used to be a GET request with facts encoded as base64-encoded zlib-compressed JSON submitted as a URL parameter. This would sometimes cause failures with certain web servers and a large amount of facts, and was changed to a POST in Puppet 2.7.0. GETs should still work in Puppet 3 if something other than an agent tries one, but agents will use POSTs.
>
> Note also that submitting facts isn't necessarily logically bound to requesting a catalog, and could be done out of band on a different schedule; this is just the way Puppet happens to do it, because the original design assumptions were that relevant facts could change at any moment and you'd always want to guarantee the most recent data.

## Make file source requests while applying catalog

[File][] resources can specify file contents as either a `content` or `source` attribute. Content attributes go into the catalog, and Puppet agent needs no additional data. Source attributes only put references into the catalog, and might require additional HTTPS requests.

If you are using the normal compiler, then for each file source, Puppet agent will:

1. Do a GET request to `/puppet/v3/file_metadata/<SOMETHING>`.
2. Compare the metadata to the state of the file on disk.
    * If it is in sync, move on to the next file source.
    * If it is out of sync, do a GET request to `/puppet/v3/file_content/<SOMETHING>` for the current content.

If you are using the [static compiler][static], all file metadata is embedded in the catalog. For each file source, Puppet agent will:

1. Compare the embedded metadata to the state of the file on disk.
    * If it is in sync, move on to the next file source.
    * If it is out of sync, do a GET request to `/puppet/v3/file_bucket_file/md5/<CHECKSUM>` for the current content.

Note that this is cheaper in terms of network traffic, but potentially more expensive during catalog compilation. Large amounts of files, especially recursive directories, will amplify the effect in both directions.

## Submit report

If `report` is enabled on the agent:

1. Do a PUT request to `/puppet/v3/report/<NAME>`. The content of the PUT should be a Puppet report object in YAML format.
