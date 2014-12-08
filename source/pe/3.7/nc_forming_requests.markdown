---
title: "Node Classifier 1.0 >> API >> Forming Requests"
layout: default
subtitle: "Forming Node Classifier Requests"
canonical: "/pe/latest/nc_forming_requests.html"
---

# Forming Requests for the Node Classifier v1 API

This page provides general information about making well-formed HTTP(S) requests to the node classifier v1 API.

## Port and Path

By default, the node classifier service listens on port 4433 and all endpoints are relative to the `/classifier-api/` path. So, for example, the full URL for the `/v1/groups` endpoint on localhost would be `https://localhost:4433/classifier-api/v1/groups`.

## Authentication

You'll need to authenticate requests to the Node Classifier's API using a certificate listed in RBAC's certificate whitelist, located at `/etc/puppetlabs/console-services/rbac-certificate-whitelist`. Note that if you edit this file, you'll need to restart the `pe-console-services` service for it to take effect.

You do not need to use an agent certificate for authentication; you may also use `puppet cert generate` to create a new cert specifically for use with the API.

## Content-Type Required

All PUT and POST requests with non-empty bodies should have the `Content-Type` header to be set to `application/json`.

## Example Query

The following query will return a list of all groups that exist in the node classifier, along with their associated metadata.

`curl https://<DNS NAME OF CONSOLE>:4433/classifier-api/v1/groups --cert /etc/puppetlabs/puppet/ssl/certs/<WHITELISTED CERTNAME>.pem --key /etc/puppetlabs/puppet/ssl/private_keys/<WHITELISTED CERTNAME>.pem --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem -H "Content-Type: application/json"`
