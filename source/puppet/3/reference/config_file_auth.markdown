---
layout: default
title: "Config Files: auth.conf"
---

[rest_authconfig]: /references/3.stable/configuration.html#restauthconfig


Access to Puppet's HTTPS API is configured in `auth.conf`.

## About Puppet's HTTPS API

When running in the standard agent/master arrangement, puppet agent nodes receive all of their configurations by contacting the puppet master over HTTPS. In general, a single configuration run includes:

* Fetching a node object (to read the node's environment)
* Fetching plugins
* Requesting a catalog (and submitting the node's facts as POST data in the request)
* Fetching file metadata and contents while applying the catalog
* Submitting a report after applying the catalog

All of these are provided as HTTPS services (sometimes called "endpoints") by the puppet master server. Additionally, the puppet master provides other services, some of which are used less frequently by agent nodes (such as the CA services) and some of which shouldn't be used by agent nodes at all (such as the `certificate_status` service, which can sign and revoke certificates).

Since not all agent nodes should have access to all services, and since certain services should have restricted access (for example, nodes should not be able to request some other node's configuration catalog), the puppet master keeps a list of access rules for all of its HTTPS services. These rules can be edited in `auth.conf`.

## Location

The `auth.conf` file is located at `$confdir/auth.conf` by default. (`/etc/puppetlabs/puppet/auth.conf` in Puppet Enterprise, and `/etc/puppet/auth.conf` in open source Puppet.)

Its location is configurable with the [`rest_authconfig` setting][rest_authconfig].

## Example

    # Example auth.conf:

    path /
    auth true
    environment override
    allow magpie.example.com

    path /certificate_status
    auth true
    environment production
    allow magpie.example.com

    path /facts
    method save
    auth true
    allow magpie.example.com

    path /facts
    auth true
    method find, search
    allow magpie.example.com, dashboard.example.com, finch.example.com

## Format

**[See the HTTPS access control documentation for full details about the `auth.conf` file](/guides/rest_auth_conf.html).**

