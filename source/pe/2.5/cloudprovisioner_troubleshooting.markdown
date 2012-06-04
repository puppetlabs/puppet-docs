---
nav: pe25.html
layout: default
title: "PE 2.5 » Cloud Provisioning » Troubleshooting"
subtitle: "Finding Common Errors"
---

Troubleshooting
---------------

### Missing .fog file or credentials

If you attempt to provision without creating a `.fog` file or without
populating the file with appropriate credentials you'll see the following error:

On VMware:

    $ puppet node_vmware list
    notice: Connecting ...
    err: Missing required arguments: vsphere_username, vsphere_password, vsphere_server
    err: Try 'puppet help node_vmware list' for usage

On Amazon Web Services:

    $ puppet node_aws list
    err: Missing required arguments: aws_access_key_id,
    aws_secret_access_key
    err: Try 'puppet help node_aws list' for usage

Add the appropriate file or missing credentials to the existing file to resolve
this issue.

 [Next: Compliance Basics](./compliance_basics.html) 

