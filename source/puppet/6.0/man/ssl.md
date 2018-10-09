---
layout: default
built_from_commit: 5bfb65354358d6544a36b0195b4d703708a4123d
title: 'Man Page: puppet ssl'
canonical: "/puppet/latest/man/ssl.html"
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-ssl</code> - <span class="man-whatis">Manage SSL keys and certificates for puppet SSL clients</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>Manage SSL keys and certificates for an SSL clients needed
to communicate with a puppet infrastructure.</p>

<h2 id="USAGE">USAGE</h2>

<p>puppet ssl <var>action</var> [--certname <var>NAME</var>]</p>

<h2 id="ACTIONS">ACTIONS</h2>

<dl>
<dt>submit_request</dt><dd><p>Generate a certificate signing request (CSR) and submit it to the CA. If a private and
public key pair already exist, they will be used to generate the CSR. Otherwise a new
key pair will be generated. If a CSR has already been submitted with the given <code>certname</code>,
then the operation will fail.</p></dd>
<dt>download_cert</dt><dd><p>Download a certificate for this host. If the current private key matches the downloaded
certificate, then the certificate will be saved and used for subsequent requests. If
there is already an existing certificate, it will be overwritten.</p></dd>
<dt class="flush">verify</dt><dd><p>Verify the private key and certificate are present and match, verify the certificate is
issued by a trusted CA, and check revocation status.</p></dd>
</dl>


</div>
