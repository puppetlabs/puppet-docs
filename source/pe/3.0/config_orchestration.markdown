---
layout: default
title: "PE 3.0 » Configuration » Orchestration"
---

available console vars:

$::activemq_heap_mb
default = 512

does this belong in the performance/resource usage page of config section?

$::mcollective_registerinterval
default  = 600

$::activemq_brokers
investigate the format and invocation; should be comma-sep'd list, but it looks like a different class invocation may be necessary to scale this?

$::mcollective_enable_stomp_ssl
default - true

$::fact_stomp_server
comma-sep list ok. you can configure this?? it's set by the installer...

$::fact_stomp_port

$::stomp_password

need to also describe:

- actionpolicy files (/etc/puppetlabs/mcollective/policies/<agent>.policy) http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/AuthorizationActionPolicy

- link to installing new actions

- plugin.d stuff  http://docs.puppetlabs.com/mcollective/configure/server.html#plugin-config-directory-optional

- scaling activemq servers? classes to apply, vars to set, etc.

