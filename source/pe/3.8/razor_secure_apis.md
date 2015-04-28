---
layout: default
title: " PE 3.8 » Razor » Making Razor API Calls Secure"
subtitle: "Make Razor API Calls Secure"
canonical: "/pe/latest/razor_secure_apis.html"

---

This section describes how to set up your Razor configuration to make all `/api` calls on port 8151 over HTTPS with TLS/SSL. This is already the default configuration if you're a Puppet Enterprise (PE) user using Razor on a Puppet-managed node; no configuration is required in that case. These steps are intended for those using Razor in an environment that's not Puppet managed, or who want to insert their own CA certificate.

Since Razor deals with installing machines from scratch, there are no existing security considerations in place for the early stages of provisioning. Therefore, messages to the `/svc` namespace, the internal namespace used for communication with the iPXE client, the microkernel, and other internal components of Razor, are not secured. `/api` calls, however, are allowed to change the
Razor server and are eligible for some basic security measures.

To take advantage of this security option, we recommended this setup:

* Leave `/svc` on port 8150 over HTTP.
* Make all `/api` calls on port 8151 over HTTPS with TLS/SSL.

The following sections describe how to set this configuration on your Razor server and client.

## Configure Your Razor Server

1. In your config.yaml file, make sure that `secure_api` is set to `true`.
This will disallow insecure access to `/api` because `secure_api` is a config property that determines whether calls to `/api` must be secure in order to be processed.
2. Self-sign a certificate or use your own ".jks" or ".ks" file. There are several ways to self-sign your own certificate; the most basic is to use the Java `keytool` command, which creates a certificate file called `keystore.jks` in the current working directory. The default password in that command is simply `password`. Fill in the properties as follows:

   		keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass password -keypass password -validity 3600 -keysize 2048 -dname "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=Unknown"


3. Configure Torquebox using the file, `standalone.xml`, to accomplish two things:

	* Add a web connector for HTTPS that uses the .jks/.ks file from the previous step.
	* Add a socket binding to the existing socket binding group.

	The exact location of this file might vary. The command `find / -name standalone.xml` should locate it.

	To add a web connector for HTTPS, make these changes in the web connector:

       	<connector name='http' protocol='HTTP/1.1' scheme='http' socket-binding='http'/>
       	<connector name="https" protocol="HTTP/1.1" scheme="https" socket-binding="https" secure="true">
           	<ssl name="https" key-alias="selfsigned" password="password" certificate-key-file="$PATH_TO_FILE" />
       	</connector>

	The `$PATH_TO_FILE` should be modified to a permanent location for the `keystore.jks` or other .jks/.ks file. `selfsigned` and `password` are both from the command above and may need to change.

   To add a socket binding to the existing socket binding group, include these two lines:


        <socket-binding name='http' port='8150'/>
        <socket-binding name='https' port='8151'/>

4. Restart the razor-server service using the command, `service razor-server restart` on
   most distributions.

The Razor server is now configured to accept HTTP communication on 8150 and
HTTPS communication on 8151.

## Connect Your Razor Client to the New Razor Server Configuration

To connect to this new server configuration requires a few changes:

1. Set the `RAZOR_API` parameter to reference port 8151 over HTTPS. This looks
   something like `export RAZOR_API="https://$server:8151/api"` and for `$server`,
   include the Razor server address.
2. Choose a certificate verification preference from these two options:
   * Bypass certificate verification. The `razor` command can receive the `-k`
     argument to skip this checking procedure. Bypassing certificate verification is less secure but still ensures the transmission of encrypted data over the network.
   * Use a certificate authority (CA) file. The exact steps for this are outside the scope of this document. If you have a `.pem` file that includes the server certificate
     above, that file can be referenced using the command, `export RAZOR_CA_FILE="$PATH/ca.pem"`.

After these changes, the `razor` command will communicate with the Razor server
over TLS/SSL.

* * *


[Next: Razor Objects for Provisioning](./razor_objects.html)