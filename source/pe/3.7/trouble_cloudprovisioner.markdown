---
layout: default
title: "PE 3.7 » Troubleshooting » Cloud Provisioner"
subtitle: "Finding Common Problems "
canonical: "/pe/latest/trouble_cloudprovisioner.html"
---

Below are some common issues with the Cloud Provisioner.

### I'm Using Puppet Enterprise 3 and Some `node` Options Don't Work Anymore
Several command options were changed in PE 3. Specifically:

- `--pe-version` has been removed from all `node_<provider>` commands. Users should manually select the desired source for packages and the installation script they wish to use.
- `--name` for the `node_vmware` command has been changed to `--vname`.
- `--tags` for the `node_aws` command has been changed to `--instance_tags`.
- `--group` for the `node_aws` command has been changed to `--security_group`.

### ENC Can't Communicate with Nodes
As of Puppet Enterprise 3.0, SSL is required for all communication between nodes and the ENC. The `--enc-ssl` option has been removed.

### `node_vmware` and `node_aws` Aren't Working

If the [cloud provisioning actions](./cloudprovisioner_overview.html) are failing with an "err: Missing required arguments" message, you need to [create a `~/.fog` file and populate it with the appropriate credentials](./cloudprovisioner_configuring.html).


### Missing .fog File or Credentials

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

Note that versions of fog newer than 0.7.2 may not be fully compatible with Cloud Provisioner. This issue is currently being investigated.

### Certificate Signing Issues

#### Accessing Puppet Master Endpoint

For automatic signing to work, the computer running Cloud Provisioner (i.e. the CP control node) needs to be able to access the Puppet master's `certificate_status` REST endpoint. This can be done in the master's [auth.conf](/guides/rest_auth_conf.html) file as follows:

     path /certificate_status
     method save
     auth yes
     allow {certname}

Note that if the CP control node is on a machine other than the Puppet master, it must be able to reach the Puppet master over port 8140.

#### Generating Per-user Certificates

The CP control node needs to have a certificate that is signed by the Puppet master's CA. While it's possible to use an existing certificate (if, say, the control node was or is an agent node), it's preferable to generate a per-user certificate for a clearer, more explicit security policy.

Start by running the following on the control node:
`puppet certificate generate {certname} --ca-location remote`
Then sign the certificate as usual on the master (`puppet cert sign {certname}`). Lastly, back on the control node again, run:

     puppet certificate find ca --ca-location remote
     puppet certificate find {certname} --ca-location remote
     This should let you operate under the new certname when you run puppet commands with the --certname {certname} option.

* * *

- [Next: Troubleshooting Windows](./trouble_windows.html)
