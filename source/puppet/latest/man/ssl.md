---
layout: default
built_from_commit: 221ddc1eb591dc76585f70699c4f5848396204fb
title: 'Man Page: puppet ssl'
canonical: "/puppet/latest/man/ssl.html"
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-ssl</code> - <span class="man-whatis">Manage SSL keys and certificates for puppet SSL clients</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Manage SSL keys and certificates for SSL clients needing
to communicate with a puppet infrastructure.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet ssl <var>action</var> [-h|--help] [-v|--verbose] [-d|--debug] [--localca] [--target CERTNAME]</p>

<h2 id="OPTIONS">OPTIONS</h2>

<ul>
<li><p>--help:
Print this help message.</p></li>
<li><p>--verbose:
Print extra information.</p></li>
<li><p>--debug:
Enable full debugging.</p></li>
<li><p>--localca
Also clean the local CA certificate and CRL.</p></li>
<li><p>--target CERTNAME
Clean the specified device certificate instead of this host's certificate.</p></li>
</ul>


<h2 id="ACTIONS">ACTIONS</h2>

<dl>
<dt>bootstrap</dt><dd><p>Perform all of the steps necessary to request and download a client
certificate. If autosigning is disabled, then puppet will wait every
<code>waitforcert</code> seconds for its certificate to be signed. To only attempt
once and never wait, specify a time of 0. Since <code>waitforcert</code> is a
Puppet setting, it can be specified as a time interval, such as 30s,
5m, 1h.</p></dd>
<dt>submit_request</dt><dd><p>Generate a certificate signing request (CSR) and submit it to the CA. If
a private and public key pair already exist, they will be used to generate
the CSR. Otherwise a new key pair will be generated. If a CSR has already
been submitted with the given <code>certname</code>, then the operation will fail.</p></dd>
<dt>download_cert</dt><dd><p>Download a certificate for this host. If the current private key matches
the downloaded certificate, then the certificate will be saved and used
for subsequent requests. If there is already an existing certificate, it
will be overwritten.</p></dd>
<dt class="flush">verify</dt><dd><p>Verify the private key and certificate are present and match, verify the
certificate is issued by a trusted CA, and check revocation status.</p></dd>
<dt class="flush">clean</dt><dd><p>Remove the private key and certificate related files for this host. If
<code>--localca</code> is specified, then also remove this host's local copy of the
CA certificate(s) and CRL bundle. if <code>--target CERTNAME</code> is specified, then
remove the files for the specified device on this host instead of this host.</p></dd>
<dt class="flush">show</dt><dd><p>Print the full-text version of this host's certificate.</p></dd>
</dl>


</div>
