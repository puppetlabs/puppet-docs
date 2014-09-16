---
layout: default
title: "PE 3.2 » Console » Accessing"
subtitle: "Accessing the Console"
canonical: "/pe/latest/console_accessing.html"
---

The console is Puppet Enterprise's web GUI. Use it to:

* Manage node requests to join the puppet deployment
* Assign Puppet classes to nodes and groups
* View reports and activity graphs
* Trigger Puppet runs on demand
* Browse and compare resources on your nodes
* View inventory data
* Invoke orchestration actions on your nodes
* Manage console users and their access privileges

Browser Requirements
-----

For the browser requirements, see [system requirements](/pe/3.2/install_system_requirements.html#browser).

Reaching the Console
-----

The console will be served as a website over SSL, on whichever port you chose when installing the console role.

Let's say your console server is `console.domain.com`. If you chose to use the default port of 443, you can omit the port from the URL and can reach the console by navigating to:

<big><strong><code>https://console.domain.com</code></strong></big>

If you chose to use port 3000, you would reach the console at:

<big><strong><code>https://console.domain.com:3000</code></strong></big>

Note the **`https`** protocol handler --- you cannot reach the console over plain `http`.

Accepting the Console's Certificate
-----

The console uses an SSL certificate created by your own local Puppet certificate authority. Since this authority is specific to your site, web browsers won't know it or trust it, and you'll have to add a security exception in order to access the console.

**This is safe to do.** Your web browser will warn you that the console's identity hasn't been verified by one of the external authorities it knows of, but that doesn't mean it's untrustworthy. Since you or another administrator at your site is in full control of which certificates the Puppet certificate authority signs, the authority verifying the site is _you._

### Accepting the Certificate in Google Chrome or Chromium

Step 1: 

![Screenshot: Chrome showing an untrusted cert warning, with the 'Proceed anyway' button highlighted][cert_chrome1]

Step 2: 

![Screenshot: Chrome showing an untrusted cert warning, with the 'Proceed to IP address' button highlighted][cert_chrome2]

### Accepting the Certificate in Mozilla Firefox

Click __I Understand the Risks__ to reveal more of the page, then click the __Add Exception...__ button. On the dialog this raises, click the __Confirm Security Exception__ button.

Step 1:

![Screenshot: Firefox's untrusted cert warning, with two controls highlighted][cert_firefox1]

Step 2:

![Screenshot: Firefox's cert details dialog, with the confirm button highlighted][cert_firefox2]

### Accepting the Certificate in Apple Safari

Click the __Continue__ button on the warning dialog.

![Screenshot: Safari's untrusted cert dialog, with the continue button highlighted][cert_safari]

### Accepting the Certificate in Microsoft Internet Explorer

Click the __Continue to this website (not recommended)__ link on the warning page.

![Screenshot: IE's untrusted cert page, with the continue link highlighted][cert_ie]

[cert_chrome1]: ./images/console/accessing_cert_chrome1.png
[cert_chrome2]: ./images/console/accessing_cert_chrome2.png
[cert_firefox1]: ./images/console/accessing_cert_firefox1.png
[cert_firefox2]: ./images/console/accessing_cert_firefox2.png
[cert_safari]: ./images/console/accessing_cert_safari.png
[cert_ie]: ./images/console/accessing_cert_ie.png
[login]: ./images/console/accessing_login.png
[client_cert_dialog]: ./images/client_cert_dialog.png



Logging In
-----

For security, accessing the console requires a user name and password. PE allows three different levels of user access: read, read-write, and admin. If you are an admin setting up the console or accessing it for the first time, use the user and password you chose when you installed the console. Otherwise, you will need to get credentials from your site's administrator. See the [User Management page](./console_auth.html) for more information on managing console user accounts.

![Screenshot: a login dialog asking for credentials][login]

Since the console is the main point of control for your infrastructure, you will probably want to decline your browser's offer to remember its password.


* * *

- [Next: Navigating the Console](./console_navigating.html)
