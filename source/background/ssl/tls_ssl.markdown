---
layout: default
title: "Background Reference: What is TLS/SSL?"
---


[index]: ./index.html
[certs]: ./certificates_pki.html
[https]: ./https.html

> This article is [part of a series][index]. The previous article covered the concepts of [certificates and PKI][certs].

TLS ("transport layer security") is a protocol that uses an X.509 PKI to create secure and authenticated channels of network communication. SSL ("secure socket layer") is an older version of that same protocol, which is still in widespread use.

> A Note on Names
> -----
>
> "TLS" and "SSL" both refer to essentially the same thing. Informally, many people (including us at Puppet Labs) often just say "SSL" to refer to any combination of TLS and SSL, mostly because old habits die hard.
>
> Most tools can use multiple versions of the protocol, and the combination of versions they support will often cross the arbitrary TLS/SSL boundary. (Usually something like SSL 3.0, TLS 1.0, and TLS 1.1.) Since clients and servers can negotiate versions on the fly, the exact protocol you'll be using at any given moment depends on the configuration of every tool that might interact with the system.

Participants and Their Tools
-----

SSL always has two participants: a client, which initiates the connection, and a server, which accepts incoming connections. (These are flexible identities: Depending on how a system works, the same entity may act as a client sometimes and a server at other times.)

The server **must always** have a certificate signed by a CA that the client trusts.

In some applications (including Puppet), the client must also have a certificate. (Note any references to "client authentication" below for details about how client certificates work.)

There are several versions of the SSL protocol, and several cyphers supported by each version. The server and client must both support some shared version of the SSL protocol and a shared cypher. This becomes a trade-off between compatibility and security: newer protocol and cypher versions are considered more secure, but if a server stops supporting them too early, it may not be able to serve older clients that are still in use. Conversely, a client that needs to talk to many different servers (e.g. a web browser) may have to support older and less secure protocol versions to avoid being denied service by older or misconfigured servers.

Starting an SSL Connection
-----

After a client starts the process, an SSL connection involves the following procedures:

* The client and server negotiate to figure out which cipher and protocol version to use.
* The server presents its certificate.
    * The client software validates that certificate, based on its list of trustworthy CAs, the CRLs it has available, and the validity period of the certificate. If it won't validate, the client bails.
* **Optionally,** the client can present a certificate of its own to the server. The client will also sign a piece of server-provided data to prove that it possesses the corresponding private key. The server will validate the client certificate before continuing.
    * This only happens if the server explicitly requests **client authentication.** Most HTTPS sites on the web don't require client authentication. Puppet, however, does (for some services).
* The client sends a temporary "session" key to the server, encrypted so that only the owner of the server certificate can read it.
* Both client and server use that session key to encrypt all subsequent traffic in the connection, using a symmetric cypher. (Using a public key cypher wouldn't be appropriate, since the client doesn't always provide a public key.)

Specific Advantages of an SSL Connection
-----

After the connection starts, the two parties have the following tools and extra information:

### Both Parties

Both parties have access to an encrypted communication channel, which can't be eavesdropped on.

### The Client

Since the client has seen the server's certificate, it has a bunch of extra information about the server:

* It knows it is talking to the rightful owner of the server certificate (since only the rightful owner could have decrypted that session key).
* It knows the CA verified any metadata in the certificate.
* It can use any metadata in the server certificate to **authenticate** and **authorize** the server. Some of this authorization may be simple and automatic, and some may require more consideration. As an example, consider what a web browser and its user do in a standard web HTTPS connection:
    * Web SSL certificates contain a list of domain names that are allowed to present that certificate. The web browser automatically checks for the domain name it contacted in that list. If it isn't included, the browser can refuse to let the user continue.
    * Certificates also list the name of the organization that was issued the certificate, and web browsers present that name to the user. (Usually behind a little padlock icon.) If the user checks that organization name and doesn't believe that it matches the rightful operator of the website they think they're visiting, they may choose to distrust and bail.
    * A website may ask for sensitive information that the user is only willing to share with certain trusted parties. If the user checks the organization name in the certificate and doesn't wish to share that information with that organization, they may decide not to provide it.

### The Server

If client authentication wasn't requested, the server doesn't know anything in particular about the client --- any authentication of the client's identity or authorization of its permissions has to happen by some other means, like the login form on a web page.

If client authentication **was** requested (and accepted), the server has information comparable to what the client gets:

* It knows it is talking to the rightful owner of the client certificate, since the client proved itself when providing the certificate.
* It knows the CA verified any metadata in the certificate.
* It can use any metadata in the client certificate to **authenticate** and **authorize** the client.
    * For example, the server may protect certain resources by only allowing certain clients to access them. This could be done by maintaining a list of allowed client names, or by looking for some token that was embedded in the client's certificate when it was signed.


Next in This Series
-----

The next chapter in this series, [What is HTTPS][https], explains how SSL can be used to secure HTTP connections. It also explains how other parts of an HTTP-based application can gain access to certificate information and use it to authorize participants. [Continue reading...][https]
