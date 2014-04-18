---
layout: default
title: "Background Reference: SSL and Related Topics"
toc: false
---

[wiki_pki]: http://en.wikipedia.org/wiki/Public_key_infrastructure
[wiki_tls]: http://en.wikipedia.org/wiki/Transport_Layer_Security

Puppet's network communications and security are all based on HTTPS, which secures traffic using X.509 certificates. It includes its own CA tools to provide PKI functionality to the whole deployment, although an existing CA can also be used.

These tools and protocols can sometimes present a steep learning curve for new Puppet users. This series provides background knowledge about how SSL and certificates work, and is aimed at giving new Puppet users enough fluency with these concepts to read and understand the rest of the SSL documentation on this site.

> **A note about depth:** This background information is vastly simplified and glosses over a great many implementation details; its goal is basic competency, not expertise. But if you're interested in learning more, it should provide enough context and vocabulary to research these topics in more depth. (The Wikipedia pages on [PKI][wiki_pki] and [TLS/SSL][wiki_tls] may be a good starting place; after that, we recommend hitting the library or your local technical book store.)

Table of Contents
-----

We recommend reading these articles in order, as each one lays foundations for the next.

[**What is Public Key Cryptography?**](./public_key.html)

Public key crypto is a family of tools for encrypting and verifying information. This brief article explains why it's useful.

[**What are Certificates and PKI?**](./certificates_pki.html)

A PKI is a way to associate public keys with trusted information about their owners, using documents called certificates. This slightly longer article explains how that trust works, and what pieces have to come together before a certificate can exist.

[**What is TLS/SSL?**](./tls_ssl.html)

Certificates can be used to create secure _and_ authenticated channels of communication over a network. You've probably already used one of those channels today. This article explains this practical use for certificates, and the benefits it provides.

[**What is HTTPS?**](./https.html)

HTTP is a useful protocol for building applications, and it can be tunneled over TLS/SSL. This article explains how that works. It also explains how other parts of an HTTP-based application can gain access to certificate information and use it to authorize participants.

[**Appendix: Anatomy of a Certificate**](./cert_anatomy.html)

This page shows several example certificates and points out their most important features, in order to highlight the lessons covered in the previous articles.

