---
layout: default
title: "Puppet on Windows"
nav: windows.html
---

Puppet on Windows
=====

Summary
-----

**Puppet can manage Microsoft Windows systems alongside Unix-like systems,** as of Puppet 2.7.6 and Puppet Enterprise 2.5. Windows nodes can apply manifests locally, and can fetch and apply compiled configurations from a puppet master server. 

Puppet on Windows is mostly similar to Puppet on other systems, with **several important differences:**

* Windows nodes can't serve as puppet masters, so Windows agent nodes have to contact a Unix-like puppet master server.
* The resource types are slightly different: Not all of the Unix types work on Windows, and there are some Windows-specific types.
* The backslashes used in Windows file paths have to be handled carefully when writing manifests.
* Windows's user and group permissions don't match the Unix model. This affects the steps to take when triggering a Puppet run manually. 
* Puppet's configuration directories and working directories are in different places on Windows.


still Puppet, but several things are different

This set of references covers how to 

There are several differences from managing 


Since Windows is such a different environment from the POSIX systems Puppet has always supported, 
was originally released for Unix-like systems, but as of version 2.7.6, it can also