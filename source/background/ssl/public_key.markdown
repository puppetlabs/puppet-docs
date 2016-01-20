---
layout: default
title: "Background Reference: What is Public Key Cryptography?"
---

[certs]: ./certificates_pki.html
[index]: ./index.html
[rsa_explanation]: http://www.muppetlabs.com/~breadbox/txt/rsa.html

> This article is [part of a series][index].

**Public key cryptography** is a family of algorithms and practices for encrypting and verifying information.

The fundamental principle of public key cryptography is that two participants can securely exchange (and verify) information _without sharing any secret key ahead of time._ This allows novel applications that would be impossible with _symmetric cryptography,_ where all participants must have a copy of a shared secret key.

## Key Pairs

In public key cryptography, each participant possesses a **key pair,** which consists of a **public key** and a **private key.** These are both large, nearly-impossible-to-guess numbers, which are mathematically related to each other in a special way. Specifically:

* Any public key has one (and only one) corresponding private key, and vice-versa.
* A private key can't be reverse-engineered from its corresponding public key. (Or at least, doing so isn't practical with current or foreseeable-future technology.)
* Using one part of the key pair, you can perform a calculation that can only be reversed by using the other part.

There are several ways to create these kinds of related numbers, but the actual mathematics are far outside the scope of this guide. (Although [this explanation of the RSA cipher][rsa_explanation] is relatively readable, if you're interested.)

The public key can and should be shared freely. The private key must stay private. If a copy of it is stolen, the thief can impersonate the rightful owner until all other participants have stopped using and trusting the corresponding public key.

## Key Pairs Can Encrypt Information

If you have the _public_ part of a given key pair, you can **encrypt** a message so that it can only be deciphered by whoever possesses the corresponding _private_ key.

Thus, if two parties have each others' public keys, they can each send messages that only the other can decrypt. This allows a secure channel to be created without ever sharing secret information.


## Key Pairs Can Sign Information

> (Note: This only applies to RSA key pairs; DSA key pairs can't sign data.)

If you have the _private_ part of a given key pair, you can **digitally sign** a message. This involves combining the message and the private key to create a string of unique nonsense (a "signature"), which could only have been created by that specific private key.

Later, anyone in possession of the corresponding _public_ key can use the public key and the original message to analyze the signature. This allows them to:

* Prove that whoever signed the message was actually in possession of that private key.
* Determine whether the message was altered after the signature was made.

Thus, signatures can be used both to demonstrate someone's identity and to make information public while still protecting it from forgery or modification.

## The Importance of Identity in Public Key Cryptography

To be useful for real-world purposes, a public key cryptography scheme must be combined with some other system that links known keypairs to some form of _identity._ (Otherwise, they're just big annoying numbers.) This can be a local registry (think handwritten phone book, or SSH keys), a central registry (think DNS), a signature-based system (think driver's licence), or some combination of them.


## Next in This Series

Next, [What are Certificates and PKI][certs] explains how public keys can be bound to identities, using documents called "certificates" that are signed by a trusted third party.