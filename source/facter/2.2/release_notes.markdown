---
layout: default
title: "Facter 2.2: Release Notes"
description: "Facter release notes for all 2.2 versions"
---

This page documents the history of the Facter 2.2 series. (Elsewhere: release notes for [Facter 2.1](../2.1/release_notes.html) and [Facter 2.0](../2.0/release_notes.html)).

Facter 2.2.0
-----

Released August 25, 2014.

Facter 2.2.0 is a backward-compatible features and fixes release in the Facter 2 series. In addition to a number bug fixes, this release includes three [new structured facts](#new-structured-facts): [`os`](#structured-fact-os), [`processors`](#structured-fact-processors), and [`system_uptime`](#structured-fact-systemuptime). No facts have been removed or deprecated.

### New Structured Facts

Facter 2.2.0 ships with several new [structured facts](fact_overview.html#writing-structured-facts). These facts combine information from a
number of different flat facts into a single hash. The old facts **are still available** in the same form as before, so you don't *need* to
change your existing manifests for compatibility reasons.

#### Structured Fact: `os`

This fact takes the form of a hash incorporating the following facts:

* `operatingsystem`
* `operatingsystemmajrelease`
* `operatingsystemrelease`
* `osfamily`
* `lsbdistcodename`
* `lsbdistdescription`
* `lsbdistid`
* `lsbdistrelease`
* `lsbmajdistrelease`
* `lsbrelease`

Here's an example of what the new `os` fact looks like:

{% highlight ruby %}
{  "osfamily"        => "Debian",
   "operatingsystem" => "Debian",
   "release" => {
         "major" => 1,
         "minor" => 2,
         "patch" => 3,
         "full"  => "1.2.3" },
    "lsb" => {
         "distid"          => "Debian",
         "distcodename"    => "wheezy", 
         "distdescription" => "Debian GNU/Linux 7.4 (wheezy)",
         "distrelease"     => "1.2.3",
         "majdistrelease"  => "1" }
}
{% endhighlight %}

Related issue:

- [FACT-614: Create structured operating system fact](https://tickets.puppetlabs.com/browse/FACT-614)

#### Structured Fact: `system_uptime`

The new `system_uptime` fact is a hash that incorporates the following flat facts:

* `uptime_seconds`
* `uptimes_hours`
* `uptime_days`
* `uptime`

Here's an example of what the new `system_uptime` fact looks like:

{% highlight ruby %}
{"seconds"=>609351, "hours"=>169, "days"=>7, "uptime"=>"7 days"}
{% endhighlight %}

Related issue:

- [FACT-612: Create structured uptime fact](https://tickets.puppetlabs.com/browse/FACT-612)

#### Structured Fact: `processors`

The new `processors` (note the plural) fact is a hash that incorporates the following flat facts:

* `processor`
* `processorcount`
* `physicalprocessorcount`
* `processorspeed`
* `processor{NUMBER}`

Here's an example of what the new `processors` fact looks like:

{% highlight ruby %}
{ "models"=> [ "Processor0"=>"Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz", 
               "Processor1"=>"Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz"], 
 "count"=>2,
 "physicalcount"=>2,
 "speed"=>"2.40 GHz" }
 {% endhighlight %}

Related issue:

- [FACT-613: Create structured processor fact](https://tickets.puppetlabs.com/browse/FACT-613)

### Platform-Specific Fixes

[FACT-547: Limit the output of prtdiag on Solaris](https://tickets.puppetlabs.com/browse/FACT-547)

Limits the output of `prtdiag` (only used on Solaris) to 10 lines. This provides a minor performance benefit on Solaris boxes.

[FACT-595: Unbreak {is_,}virtual fact for OpenBSD when running on KVM](https://tickets.puppetlabs.com/browse/FACT-595)

Previously, the `is_virtual` and `virtual` facts did not correctly recognize KVM virtualization of OpenBSD (and possibly other operating sytems). This release improves the detection logic for KVM, which fixes the bug.

[FACT-651: faulty detection of KVM on SunOS hosts](https://tickets.puppetlabs.com/browse/FACT-651)

Improves the `virtual` fact's logic for detecting KVM virtualization under SunOS.

[FACT-621: Add OpenBSD support for 'partitions' fact](https://tickets.puppetlabs.com/browse/FACT-621)

This release improves the `partitions` fact to support OpenBSD systems.

[FACT-629: EC2 facts should ignore proxy](https://tickets.puppetlabs.com/browse/FACT-629)

The `ec2_` facts are gathered by making an HTTP call to the EC2 API's metadata endpoint, which is directly accessible from all EC2 instances. If an HTTP proxy was configured, previous versions would attempt to use it to reach the EC2 API server, which probably isn't a good idea. This release skips the proxy when making the request to the EC2 metadata endpoint.

[FACT-659: Partitions fact does not correctly parse the filesystem attribute under Linux](https://tickets.puppetlabs.com/browse/FACT-659)

This bug in the `partitions` fact prevented filesystem attributes from being properly parsed under Linux. This release fixes the bug.

### Packaging Fixes

[FACT-467: Puppet 3 on Debian ARM](https://tickets.puppetlabs.com/browse/FACT-467)

Previously, a packaging dependency on dmidecode made it impossible to install Facter 2 (and by extension, later versions of Puppet) on
ARM platforms (including the Raspberry Pi). This release ensures that installation won't fail just because dmidecode is unavailable.

[FACT-597: Facter needs a package dependency on net-tools on RHEL7 for ifconfig](https://tickets.puppetlabs.com/browse/FACT-597)

Red Hat Enterprise Linux 7 doesn't include `ifconfig` as part of the minimal install, but it's required for a number of networking facts. This release adds a dependency for the `net-tools` package on RHEL 7, which includes `ifconfig`.

### Miscellaneous Fixes

[FACT-627: Boolean facts not printed with facter -p if fact value is false](https://tickets.puppetlabs.com/browse/FACT-627)

Facter 2 added support for non-string facts, including booleans. However, a bug in previous Facter 2 releases would cause `facter -p` to skip facts that returned a literal `false` value. This release fixes the bug.
