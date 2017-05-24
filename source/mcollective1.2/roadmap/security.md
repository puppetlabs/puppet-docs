---
layout: default
title: Security Enhancements
disqus: true
canonical: "/mcollective/index.html"
---

[Jordan Sissel]: http://www.semicomplete.com/

# {{page.title}}

|                    |         |
|--------------------|---------|
|Target release cycle|**1.1.x**|

## Overview

Security is provided by the security plugins, today we have SSL and PSK based
ones.  These provide enough for 1.0.0 release but some possibilities for
enhancement has been identified.

## Improved unique message IDs

The unique IDs we generate for messages should be improved, perhaps based on
industry standard UUID code.

## Replay Protection

At present we do not have any protection against someone injecting old requests
even ones that are signed by certificates etc, given the broadcast nature of
mcollective it isn't overly hard to get hold of these messages.

We should add a timestamp to each message that both the client and server will
use for max-age determination, any message older than the configured time will
be ignored.  The timestap should form part of the data that the security plugins
sign and verify so that it cannot be tampered with.

Internally in the security plugin a cache should be kept for messages seen
during the valid validity period and we should reject duplicates.  This will
effectively stop reply attacks.

We should do this cache in the base class and not in the security plugins
themselve so that the implimentation of this feature is standard across all
plugins.

## Certificate Management

More advanced plugins like ones based on SSH will need to retrieve public
certificates from nodes.  We should add a message type that does not invoke any
actions in agents but just invoke a method on security plugins that will return
their public keys.

This isn't fully fledged out but [Jordan Sissel] had some ideas around this while
writing his SSH security plugin.
