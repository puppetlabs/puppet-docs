---
layout: default
title: "Background Reference: What are Certificates and PKI?"
---


[index]: ./index.html
[public_key]: ./public_key.html
[tls_ssl]: ./tls_ssl.html
[x509]: http://tools.ietf.org/html/rfc5280
[certificate_anatomy]: ./cert_anatomy.html
[file_extensions]: http://en.wikipedia.org/wiki/X.509#Certificate_filename_extensions

> This article is [part of a series][index]. The previous article covered the concept of [public key cryptography][public_key].


A public key infrastructure (PKI) is a way to associate public keys with trusted information about their owners. This makes public key cryptography significantly more useful, since each participant doesn't have to keep a personal list of all known public keys.

The PKI used in SSL/TLS is defined by [the X.509 standard][x509]. Puppet and Puppet Enterprise use OpenSSL's implementation of the X.509 PKI.

## Certificates

A **certificate** is a cryptographic identification document that contains:

* A _public key_
* _Metadata_ about the certificate and its owner
* A _signature_ from the certificate authority (CA), which is a trusted third party

These three parts work together to form a useful unit of trust:

* The public key lets you determine whether the entity you're talking to possesses the corresponding private key, and enables secure communication with them.
* The metadata tells you who that entity is, what they are allowed to do, and how long their certificate is valid.
* The signature proves that someone you trust has done a background check on the key pair's owner, and has gone on record stating that the metadata in the certificate is correct. It also prevents tampering with any of the information in the certificate: if any part is changed, the signature will fail to validate.

### Certificate Storage

Certificates are usually stored in some encoded format. The most common format is PEM (privacy-enhanced mail), but certificates may also be stored in archives such as Java keystores. These encoded formats are not human-readable, and need to be dumped into a different format to be inspected by users.

A list of the most common file formats is available at [Wikipedia's page about the X.509 standard.][file_extensions]

(Puppet stores certificates in PEM format, and the CA tools include a `puppet cert print` command for dumping certificates to the terminal.)

### Contents of a Certificate

For more details about the metadata available in a certificate, such as the difference between the CN and the DN, please see [the appendix on certificate anatomy][certificate_anatomy].

## Certificate Authorities (CAs)

Participants in a PKI generally agree ahead of time to trust a small number of **certificate authorities (CAs).** The CAs that are trusted before any other infrastructure is set up are called "root" CAs; later, some root CAs might issue "intermediate" or "chained" CA certificates, which are allowed to sign new certificates but can also be validated and revoked like normal certificates.

Fundamentally, a CA is just a trusted person or institution that controls a key pair. The following steps are what differentiate the CA from any other participant in the PKI:

* Other participants agree to trust that key pair's owner as a CA. For a root CA, this is usually a social/legal/contractual agreement that originates outside of the PKI. For an intermediate CA, participants will trust it because they trust the root CA that endorses it.
* The CA either creates or obtains a special certificate, whose metadata states that the CA is allowed to sign new certificates. (This is a rare permission that most certificates do not have.)
    * For intermediate CAs, this certificate is issued by another (probably root) CA. Root CAs will use their own key pair to craft a _self-signed certificate._ (That is, the signature is provided by the same key pair that the certificate describes.) This is why the decision to trust a root CA happens outside of the PKI: their certificates amount to a tautological "Trust me because you trust me."
* The CA certificate is distributed to other participants in the PKI. This is often done out-of-band as part of some bootstrapping process. (For example, the root CA certificates used by web browsers can be bundled with the executable and installed alongside it. Most modern operating systems also ship with root CA certificates included.)

At this point, other participants can use the CA's certificate to verify signatures on any certificates that claim to be vetted by that CA. If the signature fails to validate, they will consider that certificate forged and decline to trust it.

## Certificate Signing Requests (CSRs)

Once the foundation of CA trust is established, participants can send **certificate signing requests (CSRs)** to the CA. The process depends on the CA; it might involve a ream of paperwork, or an email and a phone call, or an HTTP request to some automated system.

A CSR is a specially formatted cryptographic document that contains the applicant's public key and any metadata (name, etc.) that the applicant wants to have in their certificate. (In terms of content, it's just a certificate minus the CA signature.)

The CA can double-check this metadata, verify that the key pair belongs to the applicant, and perform any background checks it considers necessary. It will then choose whether or not to sign the request with its private key.

Signing the request will create a new certificate for the participant that requested it. That participant will then have to retrieve the certificate from the CA. (The process for doing so will vary depending on the CA's preferences.) Once the participant has it, they can present the certificate to other participants and use their private key to prove themselves as the certificate's rightful owner. Other participants can use the CA's signature to prove that the metadata in the certificate was vetted by that CA.

## Certificate Revocation Checking

Trusted certificates sometimes need to become untrusted, often as a result of a security breach. To handle this, a CA will keep track of which certificates are now untrusted, and will somehow make that information available to PKI participants.

This is one of the harder parts of a PKI to manage correctly --- keeping revocation info up to date and making sure that each participant is configured to check for it is more complicated than it seems.

### Certificate Revocation Lists (CRLs)

The traditional way to manage revocation info is with a **certificate revocation list (CRL),** which contains the serial numbers of any certificates that should no longer be trusted.

Participants in the PKI should regularly retrieve a copy of each CA's CRL, and should double-check certificates against it when checking their validity.

This is the method of revocation checking that Puppet uses.

### Online Certificate Status Protocol (OCSP)

CRLs are relatively expensive to update over the network, since they grow over time. This means participants tend to update them only occasionally, which raises the chances of using out-of-date info and allowing a compromised certificate through.

OCSP ([RFC 6960](http://tools.ietf.org/html/rfc6960)) is a protocol that assumes participants are always on a network. It gives up on the idea of long-lived local revocation data, and focuses on making revocation checks fast and cheap.

Whenever a participant is verifying a certificate, they make a request to an entity who has up-to-date revocation data for the issuing CA. (This entity is called an "OCSP responder".) The OCSP responder either confirms the validity of that cert, states that it's been revoked, or doesn't respond in time; in the latter two cases, the participant should reject the cert.

### OCSP Stapling

The problem with OCSP is that it requires frequent extra network calls to third parties. On the client side, this has both performance and security issues (someone now knows which certificates you've needed to verify over time); it also puts a major traffic burden on responders.

OCSP stapling ([RFC 6066](http://tools.ietf.org/html/rfc6066)) attempts to reduce that impact. Instead of leaving revocation checks to the client, any entity that expects to be _presenting_ a certificate should periodically request an OCSP response from an OCSP responder. These responses are stamped with a relatively short expiration date, and they are signed by the CA that issued the certificate.

This means the certificate presenter can pass the pre-fetched OCSP response directly to other participants, who can use the CA signature and expiration date to verify that the certificate was valid very recently. If the stapled OCSP response isn't valid anymore, the client can ask the OCSP server itself.

OCSP stapling is considered the state of the art for revocation checking on the public web, although it isn't universally implemented yet.


## Certificate Lifespans

Each certificate has a period of time for which it is valid; before or after this timespan, the certificate should not be trusted. The validity period is embedded in the certificate's metadata, and is assigned by the CA when signing the certificate.

When checking a certificate's validity, participants in a PKI should also ensure that the certificate has not expired.


## Certificates and Puppet: The Puppet CA

Puppet includes built-in tools for creating and managing a CA. This allows Puppet to be used in deployments where a suitable PKI is not already present. Using the built-in CA also provides some extra conveniences when bringing new nodes online; since agent nodes already know how the Puppet CA works, they can automatically request certificates when they first attempt to contact the puppet master. (By default, these certificates must be manually signed by an admin, although automatic signing can be configured.)

In Puppet's default configuration, a CA will be automatically created the first time you start the puppet master server.

The Puppet CA consists of the following components:

* Several HTTPS services provided by the puppet master, which accept incoming CSRs and serve the CA cert, the CRL, and signed certificates.
    * Note that in sites with more than one puppet master server, only one should act as the CA. This is covered in [the guide to configuring multiple masters](/guides/scaling_multiple_masters.html#centralize-the-certificate-authority).
* The CA's on-disk files, which include the CA certificate, the CA private key, any stored CSRs, an inventory of previously signed certificates (as well as copies of them), and the CRL.
* Command-line tools for viewing pending CSRs and signing, examining, and revoking certificates.
* Additional HTTPS services that allow certificates to be signed and revoked. (Since these can be dangerous, they are configured to be inaccessible by default.)
* In Puppet Enterprise, the PE console also includes a tool for signing certificate requests.



> Sidebar: Attacks on PKI Trust
> -----
>
> The central idea of a PKI is that you can vet and then trust a small number of entities, and they will subsequently tell you whether to trust any number of other entities. Small initial decision, large ongoing utility.
>
> Due to the shape of this trust arrangement, most attacks on a PKI will tend to fit a certain number of fundamental patterns:
>
> * **Subvert the CA's owner.** If you can coerce or manipulate the person or organization behind the CA, you can easily obtain fraudulent certificates that are indistinguishable from legitimate ones. These can be used to impersonate other participants in a man-in-the-middle attack, or to provide legitimacy for some other shenanigans. The only way for other participants to recover is to burn that CA permanently, which will have hugely disruptive effects; any participants with certificates from that CA will need to become re-certified under a new CA.
> * **Subvert the CA's credentials.** If you can steal the CA's private key or get temporary access to it, you can issue your own forged certificates and do basically the same thing as above. Since the CA won't know about these certificates, you may end up with duplicated serial numbers, but these are only a problem if someone who has seen your forged certificates in the wild can correlate them with the set of all legit certificates. (Basically: if the CA gets wind of it, the gig is up.) Duped serial numbers can also make it difficult for the CA to effectively revoke your forged certificates. The only way for other participants to recover is to stop trusting that CA's certificate permanently and either replace it or stop trusting the entity behind the CA. All existing participants will need to be re-certified with the new CA credentials.
> * **Trick the CA.** If the CA is lax in its background checks, a rogue participant may submit fraudulent metadata (for example, using the name of an organization they don't actually represent) and have it signed into a legit certificate. This may allow them to impersonate other actors or exercise permissions they shouldn't have. To recover, the CA must revoke that certificate and all participants must be using good certificate revocation checking when validating certificates.
>     * (A fun example was Puppet's [CVE-2011-3872](http://puppetlabs.com/security/cve/cve-2011-3872), where the CA could be configured to trick _itself_ into silently adding forged metadata to agent certificates.)
> * **Subvert participants' credentials.** If you can get access to a participant's private key, you can impersonate them at will. To recover, the CA will need to revoke their certificate and they will need to get re-certified.
> * **Subvert a participant's list of trusted CAs.** If you can insert an evil CA certificate into a user's collection of CA certificates, they will often trust certificates issued by that rogue CA. (This could be done by, e.g., redirecting a user to a doctored browser executable with bogus root CAs inserted. It could also be done with a trojan or other means of partial control over the user's computer.) To recover, the user would need to be keeping track of their trusted CAs, and would need to remove the evil one and patch whatever vulnerability allowed it to be placed there.
> * **Attack the implementation.** If you can find a vulnerability in the protocol that is using the PKI --- for example, the BEAST and CRIME attacks on SSL/TLS, the Heartbleed attack on OpenSSL, and the occasional straight-up cipher crack --- you may be able to steal information from or insert information into the secure channel without actually needing to attack the PKI itself. To recover or defend, the participants must make sure they're using a version of their protocol that isn't vulnerable to that attack.
> * **Attack outside the protocol.** If the target terminates SSL and sends unencrypted traffic over leased fiber, attack the leased fiber. Or get a keylogger onto the target's machine, or something; the point is, cheating is easier and more effective than fussing with a PKI or a secure protocol.
>
> In short: protect your private keys, make sure you actually trust the CA (in intentions _and_ competence), stay up to date on protocol exploits, and above all keep an eye on the unsecured portions of your system.


## Summary

This article was longer than the others in this series, so a recap is in order:

* Trust originates outside the PKI, and is a prerequisite for joining it: if you're participating, you've agreed to trust a specific person or institution to diligently check other participants' credentials. Sometimes this agreement is active; other times, it's tacit, like when you install a web browser.
* A certificate has three parts: public key, metadata, and signature from the CA. Without all three, it's not a certificate.
* The CA issues all certificates. If it's a certificate at all, the CA has seen it and approved it.
* Because the CA approves all certificate metadata, participants don't have to keep a list of all the public keys they'll need to know about; instead, they can just trust any valid certificate they are shown.
* Because certificates include public keys, only their rightful owner can present them as ID. A stolen cert is inert without a stolen private key.
* The CA can also revoke certificates, but that only works if everybody regularly checks for revoked certificates (via a traditional CRL or more modern means). This is even harder to ensure than it sounds.
* Puppet has built-in tools to make managing a CA easier. These are covered in other documentation.


## Next in This Series

The next chapter in this series, [What is TLS/SSL][tls_ssl], explains how certificates can be used to create secure _and_ authenticated channels of communication over a network. [Continue reading...][tls_ssl]
