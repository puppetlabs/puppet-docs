---
title: "Subsystems: Agent/Master HTTPS Communications"
layout: default
canonical: "/puppet/latest/reference/subsystem_agent_master_comm.html"
---

[rest_api]: /guides/rest_api.html
[authconf]: /guides/rest_auth_conf.html
[facts]: ./lang_variables.html#facts-and-built-in-variables
[catalog]: ./lang_summary.html#compilation-and-catalogs
[file]: ./type.html#file
[static]: ./indirection.html#catalog



The puppet agent and the puppet master server communicate via HTTPS over host-verified SSL.

> **Note on verification:** If the agent does not yet have its own certificate, it will make several unverified requests before it can switch to verified mode. In these requests, the agent doesn't identify itself to the master and doesn't check the master's cert against the CA. In the descriptions below, assume every request is host-verified unless stated otherwise.

The agent/master HTTP interface is REST-like, but varies from strictly RESTful design in several ways. The endpoints used by the agent are detailed in the [HTTP API reference][rest_api]. Note that all HTTP endpoints are preceded by the environment being used. Note also that access to each individual endpoint is controlled by [auth.conf][authconf] on the master.

## Diagram

This flow diagram illustrates the pattern of agent-side checks and HTTPS requests to the puppet master during a single Puppet run.

[See below the image for a textual description of this process](#check-for-keys-and-certificates), which explains the illustrated steps in more detail.

[![An illustration of the process described below -- this diagram contains no new content, but is simply a visual interpretation of everything from "check for keys and certificates" on down.](./images/agent-master-https-sequence-small.gif)](./images/agent-master-https-sequence-large.gif)

## Check for Keys and Certificates

1. Does the agent have a private key at `$ssldir/private_keys/<name>.pem`?
    * If no, generate one.
2. Does the agent have a copy of the CA certificate at `$ssldir/certs/ca.pem`? 
    * If no, fetch it. (Unverified GET request to `/certificate/ca`. Since the agent is retrieving the foundation for all future trust over an untrusted link, this could be vulnerable to MITM attacks, but it's also just a convenience; you can make this step unnecessary by distributing the CA cert as part of your server provisioning process, so that agents never ask for a CA cert over the network. If you do this, an attacker could temporarily deny Puppet service to brand new nodes, but would be unable to take control of them with a rogue puppet master.)
3. Does the agent have a signed certificate at `$ssldir/certs/<name>.pem`?
    * If yes, skip the following section and continue to "request node object."
    * (If it has a cert but it doesn't match the private key, bail with an error.)

## Obtain a Certificate (if necessary)

Note that if the agent has submitted a certificate signing request, an admin user will need to run `puppet cert sign <name>` on the CA puppet master before the agent can fetch a signed certificate. (Unless autosign is enabled.) Since incoming CSRs are unverified, you can use fingerprints to prove them, by comparing `puppet agent --fingerprint` on the agent to `puppet cert list` on the CA master.

1. Try to fetch an already-signed certificate from the master. (Unverified GET request to `/certificate/<name>`.)
    * If it gets one, skip the rest of this section and continue to "request node object."
    * (If it gets one that doesn't match the private key, bail with an error.)
2. Determine whether the agent has already requested a certificate signing: Look for `$ssldir/certificate_requests/<name>.pem`.
    * If this file exists, the agent will bail, assuming it needs user intervention on the master. If `waitforcert` is enabled, it will wait a few seconds and start this section over.
3. Double-check with the master whether the agent has already requested a certificate signing; the agent may have just lost the local copy of the request. (Unverified GET request to `/certificate_request/<name>`.)
    * If this request doesn't 404, the agent will bail, assuming it needs user intervention on the master. If `waitforcert` is enabled, it will wait a few seconds and start this section over.
4. If the agent has reached this step, it has never requested a certificate, so request one now. (Unverified PUT request to `/certificate_request/<name>`.)
5. Return to the first step of this section, in case the master has autosign enabled; if it doesn't, the agent will end up bailing at step 2.

## Request Node Object and Switch Environments

1. Do a GET request to `/node/<name>`.
    * If successful, read the environment from the node object.
        * If the node object has one: In all subsequent requests during this run, use this environment instead of the one in the agent's config file.
    * If unsuccessful, or if the node object had no environment set, continue using the environment from the agent's config file.

> **Note:** This step was added in Puppet 3.0.0, to allow an ENC to centrally assign nodes to environments. The lenient failure mode is because many users' [auth.conf][authconf] files didn't allow access to node objects, since that rule was only added to the default auth.conf in Puppet 2.7.0 and many people don't update their config files for every upgrade.

## Fetch Plugins

If `pluginsync` is enabled on the agent:

1. Do a GET request to `/file_metadatas/plugins` with `recurse=true` and `links=manage`. This is a special file server mountpoint that scans the `lib` directory of every module. Note the funky Rails-esque endpoint pluralization on `file_metadata`.
2. Check whether any of the discovered plugins need to be downloaded.
    * If so, do a GET request to `/file_content/plugins/<file>` for each one.

## Request Catalog While Submitting Facts

1. Do a POST request to `/catalog/<name>`, where the post data is all of the node's [facts][] encoded as JSON. Receive a compiled [catalog][] in return.

> **Note:** This used to be a GET request with facts encoded as base64-encoded zlib-compressed JSON submitted as a URL parameter. This would sometimes cause failures with certain web servers and a large amount of facts, and was changed to a POST in Puppet 2.7.0. GETs should still work in Puppet 3 if something other than an agent tries one, but agents will use POSTs.
>
> Note also that submitting facts isn't necessarily logically bound to requesting a catalog, and could be done out of band on a different schedule; this is just the way Puppet happens to do it, because the original design assumptions were that relevant facts could change at any moment and you'd always want to guarantee the most recent data. We're experimenting with other ways, some of which might turn out to be better ideas.

## Make File Source Requests While Applying Catalog

[File][] resources can specify file contents as either a `content` or `source` attribute. Content attributes go into the catalog, and puppet agent needs no additional data. Source attributes only put references into the catalog, and may require additional HTTPS requests.

If you are using the normal compiler, then for each file source, puppet agent will:

1. Do a GET request to `/file_metadata/<something>`.
2. Compare the metadata to the state of the file on disk.
    * If it is in sync, move on to the next file source.
    * If it is out of sync, do a GET request to `/file_content/<something>` for the current content.

If you are using the [static compiler][static], all file metadata is embedded in the catalog. For each file source, puppet agent will:

1. Compare the embedded metadata to the state of the file on disk.
    * If it is in sync, move on to the next file source.
    * If it is out of sync, do a GET request to `/file_bucket_file/md5/<checksum>` for the current content.

Note that this is cheaper in terms of network traffic, but potentially more expensive during catalog compilation. Large amounts of files, especially recursive directories, will amplify the effect in both directions.

## Submit Report

If `report` is enabled on the agent:

1. Do a PUT request to `/report/<name>`. The content of the PUT should be a Puppet report object in YAML format.

> **Note:** Yes, using PUT for this is not quite proper, but that's how it was implemented. It may change in the future.
