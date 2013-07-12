---
layout: default
title: "PE 2.0 » Console » Accessing"
canonical: "/pe/latest/console_accessing.html"
---

* * *

&larr; [Installing: What gets installed where?](./install_what_and_where.html) --- [Index](./) --- [Console: Navigating the Console](./console_navigating.html) &rarr;

* * *

Accessing the Console
=====

The console is Puppet Enterprise's web GUI. Use it to:

* Browse and edit resources on your nodes
* Trigger Puppet runs at will
* View reports and activity graphs
* Assign Puppet classes to nodes
* View inventory data
* Track compliance audits
* Invoke MCollective agents on your nodes

Browser Requirements
-----

Puppet Labs supports the following browsers for use with the console:

- Chrome (current versions)
- Firefox 3.5 and higher
- Safari 4 and higher
- Internet Explorer 9 and higher

Although we plan to fully support Internet Explorer 8 in the near future, it currently stalls indefinitely when trying to load the console's live management page. Other browsers may or may not work, and have not been intensively tested with the console. 

Reaching the Console
-----

The console will be served as a website over SSL, on whichever port you chose when installing the console role. 

Let's say your console server is `console.domain.com`. If you chose to use the default port of 443, you can omit the port from the URL and would reach the console by navigating to:

<big><strong><code>https://console.domain.com</code></strong></big>

If you chose to use port 3000, you would reach it at:

<big><strong><code>https://console.domain.com:3000</code></strong></big>

Note the **`https`** protocol handler --- you cannot reach the console over plain `http`.

Accepting the Console's Certificate
-----

The console uses an SSL certificate created by your own local Puppet certificate authority. Since this authority is specific to your site, web browsers won't know it or trust it, and you'll have to add a security exception in order to access the console. 

**This is safe to do.** Your web browser will warn you that the console's identity hasn't been verified by one of the external authorities it knows of, but that doesn't mean it's untrustworthy: since you or another administrator at your site is in full control of which certificates the Puppet certificate authority signs, the authority verifying the site is _you._ 

### Accepting the Certificate in Google Chrome or Chromium

Use the "Proceed anyway" button on Chrome's warning page.

![Screenshot: Chrome showing an untrusted cert warning, with the 'Proceed anyway' button highlighted][cert_chrome]

### Accepting the Certificate in Mozilla Firefox

Click "I Understand the Risks" to reveal more of the page, then click the "Add Exception..." button. On the dialog this raises, click the "Confirm Security Exception" button.

Step 1:

![Screenshot: Firefox's untrusted cert warning, with two controls highlighted][cert_firefox1]

Step 2:

![Screenshot: Firefox's cert details dialog, with the confirm button highlighted][cert_firefox2]

### Accepting the Certificate in Apple Safari

Click the "Continue" button on the warning dialog. 

![Screenshot: Safari's untrusted cert dialog, with the continue button highlighted][cert_safari]

### Accepting the Certificate in Microsoft Internet Explorer

Click the "Continue to this website (not recommended)" link on the warning page. 

![Screenshot: IE's untrusted cert page, with the continue link highlighted][cert_ie]

[cert_chrome]: ./images/console/accessing_cert_chrome.png
[cert_firefox1]: ./images/console/accessing_cert_firefox1.png
[cert_firefox2]: ./images/console/accessing_cert_firefox2.png
[cert_safari]: ./images/console/accessing_cert_safari.png
[cert_ie]: ./images/console/accessing_cert_ie.png
[login]: ./images/console/accessing_login.png



Logging In
-----

For security, the console requires a user name and password for access. Use the user and password you chose when you installed the console role, or get credentials from your site's lead administrator.

![Screenshot: a login dialog asking for credentials][login]

Since the console is the main point of control for your infrastructure, you will probably want to decline your browser's offer to remember its password. 

* * *

&larr; [Installing: What gets installed where?](./install_what_and_where.html) --- [Index](./) --- [Console: Navigating the Console](./console_navigating.html) &rarr;

* * *

