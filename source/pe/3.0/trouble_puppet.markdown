---
layout: default
title: "PE 3.0 »  » "
subtitle: " "
canonical: "/pe/latest/trouble_puppet.html"
---

Section Title
-----

### Manifest Compilation and Other Puppet Code Issues with UTF-8 encoding
PE 3 uses an updated version of Ruby, 1.9, that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains UTF-8 characters such as accents or other non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including, but not limited to, downloading a Forge module where some piece of metadata (e.g., author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code to the ASCII character set only, including any code comments or metadata. Puppet Labs is working on cleaning up character encoding issues in Puppet and the various libraries it interfaces with.


* * * 

- [Next: ](./foo.html)
