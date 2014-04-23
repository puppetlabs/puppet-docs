---
layout: default
title: "Background Reference: What is HTTPS?"
---


[index]: ./index.html
[tls_ssl]: ./tls_ssl.html
[passenger]: /guides/passenger.html
[certificate_anatomy]: ./cert_anatomy.html

> This article is [part of a series][index]. The previous article covered the basics of [the TLS/SSL protocol][tls_ssl].

Since SSL is a relatively generic protocol, it is usually used to wrap a more specific protocol, like HTTP or SMTP.

HTTPS is the standard HTTP protocol wrapped with SSL --- an SSL connection is established as described in the previous article, then the client sends normal HTTP requests to the server over the secure channel. When the server responds, it also uses the secure channel.

The entire HTTP protocol is wrapped, including headers; this means that even URLs, parameters, and POST data will be encrypted.

HTTPS and Puppet
-----

Puppet uses HTTPS for all of its traffic; puppet agent nodes act as clients and request their catalogs from the puppet master server.

Since Puppet uses HTTPS, it requires a certificate-based PKI, which in turn requires public key cryptography. (Hence the prior articles in this series.)

### Client Authentication

Most of Puppet's HTTP endpoints require client authentication, so the puppet master can ensure nodes are authorized before serving configuration catalogs.

This means that both puppet master servers and puppet agent nodes must have their own certificates.

However, certain endpoints can be used without client authentication, mostly so that new nodes can retrieve a copy of the CA certificate, submit CSRs, and retrieve their signed certificates.

Ports
-----

Technically, any port can be used to serve HTTPS. On the web, the usual convention is port 443.

Puppet usually uses port 8140 instead, since its traffic doesn't really resemble web traffic.

Persistence of SSL/Certificate Data in HTTPS Applications
-----

Since the entire HTTP protocol passes through the secure channel established by the SSL connection, the HTTP server and client don't have any direct involvement with the connection or the certificates. Likewise, any application logic will be several levels removed from the SSL details.

In practice, though, other levels of an application will usually want access to some SSL-related information:

* The client application usually wants to examine the certificate metadata after the connection is established, since the server's identity and permissions are relevant to application-level authorization decisions. (For example, a user could check the identity of a server before deciding whether to enter sensitive information into a web form.)
* If client authentication is enabled, the server application will want to know whether the authentication succeeded, and will want to examine the results.

Thus, most SSL implementations have some means to publish connection and certificate data, so it can be used by higher layers of the protocol stack.

An example of this is Apache's `mod_ssl` module. If it's [configured with the `StdEnvVars` option](http://httpd.apache.org/docs/2.2/mod/mod_ssl.html#envvars), it will publish extensive SSL and certificate information as environment variables with predictable names. These variables can then be used by Apache itself, or by any application being spawned and managed by another Apache module (e.g. `mod_cgi`, `mod_passenger`, or `mod_php`). (This is how the puppet master accesses client certificate information when [running under Passenger][passenger].)

SSL Termination and Proxying
-----

Large server-side HTTPS applications often need to be split into multiple semi-independent components or services, in order to accommodate better resiliency or performance. SSL is often the first component to go; even in cases where most of the application runs as a single process, SSL is computationally expensive enough to be worth splitting out.

A single component that handles SSL in a service-oriented-architecture is called an _SSL terminating proxy._ SSL proxies work under basically the same requirements as the SSL component of a purely local application stack --- they must validate certificates and provide a secure channel, and they may need to publish connection and certificate information for use by other components of the stack. They also introduce one additional requirement: the network between the proxy and the application server must be very secure, as sensitive information will be passing along it in cleartext.

[ssl_terminating_proxy]: ./images/ssl_terminating_proxy.png

![A drawing of an SSL terminating proxy removing SSL and sending a second unencrypted HTTP request with certificate data embedded in the headers.][ssl_terminating_proxy]

SSL terminating proxies work by handling the incoming connection, then sending a second unencrypted HTTP request to the real application server. When the proxy receives a reply, it will forward it to the client along the original secure connection.

If the application needs any SSL or certificate data, the proxy can be configured to publish it by inserting the data into the HTTP headers of the request it sends to the backend application server.

An example of this is a puppet master running with the Nginx + Unicorn stack:

* Nginx terminates SSL, and inserts the SSL client authentication status and client certificate DN into the HTTP headers of a new request. It sends this request to the Unicorn workers.
* A Unicorn worker receives the unencrypted request, and, according to the common gateway interface (CGI) standard, publishes all HTTP header information as CGI variables, including the SSL information inserted by Nginx. It uses the Rack interface to translate the HTTP request into a request to the puppet master application.
* The puppet master application reads SSL information from pre-arranged environment variables, and uses its auth.conf configuration to decide whether to serve the request. If yes, it uses its own application logic to decide what the request should be. Any response passes back through the Unicorn worker and Nginx to make its way to the puppet agent client.


End of Series
-----

At this point, you should understand enough about the fundamentals to understand any documentation on this site about managing Puppet's certificates, CA, and HTTPS authorization tools.

For a little more practical depth, you may also want to see the [appendix on certificate anatomy.][certificate_anatomy]
