---
layout: default
built_from_commit: c4a6a76fd219bffd689476413985ed13f40ef1dd
title: 'Man Page: puppet ca'
nav: /_includes/references_man.html
canonical: /references/latest/man/ca.html
---

<div class='mp'>
<h2 id="NAME">NAME</h2>
<p class="man-name">
  <code>puppet-ca</code> - <span class="man-whatis">Local Puppet Certificate Authority management.</span>
</p>

<h2 id="SYNOPSIS">SYNOPSIS</h2>

<p>puppet ca <var>action</var></p>

<h2 id="DESCRIPTION">DESCRIPTION</h2>

<p>This provides local management of the Puppet Certificate Authority.</p>

<p>You can use this subcommand to sign outstanding certificate requests, list
and manage local certificates, and inspect the state of the CA.</p>

<h2 id="OPTIONS">OPTIONS</h2>

<p>Note that any setting that's valid in the configuration
file is also a valid long argument, although it may or may not be
relevant to the present action. For example, <code>server</code> and <code>run_mode</code> are valid
settings, so you can specify <code>--server &lt;servername></code>, or
<code>--run_mode &lt;runmode></code> as an argument.</p>

<p>See the configuration file documentation at
<a href="http://docs.puppetlabs.com/references/stable/configuration.html" data-bare-link="true">http://docs.puppetlabs.com/references/stable/configuration.html</a> for the
full list of acceptable parameters. A commented list of all
configuration options can also be generated by running puppet with
<code>--genconfig</code>.</p>

<dl>
<dt>--render-as FORMAT</dt><dd>The format in which to render output. The most common formats are <code>json</code>,
<code>s</code> (string), <code>yaml</code>, and <code>console</code>, but other options such as <code>dot</code> are
sometimes available.</dd>
<dt>--verbose</dt><dd>Whether to log verbosely.</dd>
<dt class="flush">--debug</dt><dd>Whether to log debug information.</dd>
</dl>


<h2 id="ACTIONS">ACTIONS</h2>

<dl>
<dt><code>destroy</code> - Destroy named certificate or pending certificate request.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca destroy</p>

<p><code>DESCRIPTION</code></p>

<p>Destroy named certificate or pending certificate request.</p></dd>
<dt><code>fingerprint</code> - Print the DIGEST (defaults to the signing algorithm) fingerprint of a host's certificate.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca fingerprint [--digest ALGORITHM]</p>

<p><code>DESCRIPTION</code></p>

<p>Print the DIGEST (defaults to the signing algorithm) fingerprint of a host's certificate.</p>

<p><code>OPTIONS</code>
<var>--digest ALGORITHM</var> -
The hash algorithm to use when displaying the fingerprint</p></dd>
<dt><code>generate</code> - Generate a certificate for a named client.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca generate [--dns-alt-names NAMES]</p>

<p><code>DESCRIPTION</code></p>

<p>Generate a certificate for a named client.</p>

<p><code>OPTIONS</code>
<var>--dns-alt-names NAMES</var> -
The comma-separated list of alternative DNS names to use for the local host.</p>

<p>When the node generates a CSR for itself, these are added to the request
as the desired <code>subjectAltName</code> in the certificate: additional DNS labels
that the certificate is also valid answering as.</p>

<p>This is generally required if you use a non-hostname <code>certname</code>, or if you
want to use <code>puppet kick</code> or <code>puppet resource -H</code> and the primary certname
does not match the DNS name you use to communicate with the host.</p>

<p>This is unnecessary for agents, unless you intend to use them as a server for
<code>puppet kick</code> or remote <code>puppet resource</code> management.</p>

<p>It is rarely necessary for servers; it is usually helpful only if you need to
have a pool of multiple load balanced masters, or for the same master to
respond on two physically separate networks under different names.</p></dd>
<dt><code>list</code> - List certificates and/or certificate requests.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca list [--[no-]all]
[--[no-]pending]
[--[no-]signed]
[--digest ALGORITHM]
[--subject PATTERN]</p>

<p><code>DESCRIPTION</code></p>

<p>This will list the current certificates and certificate signing requests
in the Puppet CA.  You will also get the fingerprint, and any certificate
verification failure reported.</p>

<p><code>OPTIONS</code>
<var>--[no-]all</var> -
Include all certificates and requests.</p>

<p><var>--digest ALGORITHM</var> -
The hash algorithm to use when displaying the fingerprint</p>

<p><var>--[no-]pending</var> -
Include pending certificate signing requests.</p>

<p><var>--[no-]signed</var> -
Include signed certificates.</p>

<p><var>--subject PATTERN</var> -
Only include certificates or requests where subject matches PATTERN.</p>

<p>PATTERN is interpreted as a regular expression, allowing complex
filtering of the content.</p></dd>
<dt><code>print</code> - Print the full-text version of a host's certificate.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca print</p>

<p><code>DESCRIPTION</code></p>

<p>Print the full-text version of a host's certificate.</p></dd>
<dt><code>revoke</code> - Add certificate to certificate revocation list.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca revoke</p>

<p><code>DESCRIPTION</code></p>

<p>Add certificate to certificate revocation list.</p></dd>
<dt><code>sign</code> - Sign an outstanding certificate request.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca sign [--[no-]allow-dns-alt-names]</p>

<p><code>DESCRIPTION</code></p>

<p>Sign an outstanding certificate request.</p>

<p><code>OPTIONS</code>
<var>--[no-]allow-dns-alt-names</var> -
Whether or not to accept DNS alt names in the certificate request</p></dd>
<dt><code>verify</code> - Verify the named certificate against the local CA certificate.</dt><dd><p><code>SYNOPSIS</code></p>

<p>puppet ca verify</p>

<p><code>DESCRIPTION</code></p>

<p>Verify the named certificate against the local CA certificate.</p></dd>
</dl>


<h2 id="COPYRIGHT-AND-LICENSE">COPYRIGHT AND LICENSE</h2>

<p>Copyright 2011 by Puppet Labs
Apache 2 license; see COPYING</p>

</div>