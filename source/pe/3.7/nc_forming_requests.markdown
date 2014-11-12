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

If you have RBAC enabled, you'll need to make requests using a certificate associated with a valid user. See the [RBAC documentation](./rbac_intro.html) for specifics.

## Content-Type Required

All PUT and POST requests with non-empty bodies should have the `Content-Type` header to be set to `application/json`.
