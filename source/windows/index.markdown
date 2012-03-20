---
layout: default
title: "Puppet on Windows"
nav: windows.html
---

Puppet on Windows
=====

Summary
-----

## Overview
### Supported Platforms
Puppet agent functionality is supported on the following Windows&#174; systems:

    * Windows Server 2003 and 2003 R2
    * Windows Server 2008 and 2008 R2
    * Windows 7

## Overview

The 2.7.6 release of puppet adds support for running puppet agents on Microsoft Windows platforms. The scope of work completed includes the following:

* The following puppet applications:
    * apply
    * agent
    * resource
    * inspect
* Managing the following resource types: 
    * file
    * user
    * group
    * scheduled_task (new type; not cron)
    * package (MSI)
    * service
    * exec
    * host

Running a puppet master on Windows is not supported, nor are there plans to support it.
