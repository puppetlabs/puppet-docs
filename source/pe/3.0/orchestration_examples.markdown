---
layout: default
title: "PE 3.0 » Orchestration » More Examples"
---

Examples
-----

### Ping

The `ping` action of the rpcutil plugin is wrapped to be available at
a higher level than the `mco ping` command. This command returns a list
of all the nodes and their network latencies.  In a typical Puppet
Enterprise deployment, latencies for issuing an orchestration
action are less than half a second:

    peadmin@puppetmaster:~$ mco ping
    puppetmaster.example.com               time=135.94 ms
    agent.example.com                      time=136.55 ms
    ---- ping statistics ----
    2 replies max: 136.55 min: 135.94 avg: 136.25

### Find

The `find` action of the rpcutil plugin is wrapped to be available at
a higher level than the `mco find` command. This command returns a list
of all the nodes in the network:

    peadmin@puppetmaster:~$ mco find
    puppetmaster.example.com
    agent.example.com

### Inventory

The `inventory` action of the rpcutil plugin is wrapped to be
available at a higher level than the `mco inventory` command. This
command returns facts and classes, among other information:

    peadmin@puppetmaster:~$ mco inventory agent.example.com
    Inventory for agent.example.com:
     Server Statistics:
       Version: 1.2.1
       Start Time: Mon Nov 14 15:25:33 -0800 2011
       Config File: /etc/puppetlabs/mcollective/server.cfg
       Collectives: mcollective
       Main Collective: mcollective
       Process ID: 5553
       Total Messages: 86
       Messages Passed Filters: 74
       Messages Filtered: 12
       Replies Sent: 73
       Total Processor Time: 1.34 seconds
       System Time: 0.59 seconds
     Agents:
       discovery       package         puppetd
       puppetral       rpcutil         service
     Configuration Management Classes:
       default                        helloworld
       helloworld                     pe_accounts
       pe_accounts                    pe_accounts::data
       pe_accounts::groups            pe_compliance
       pe_compliance                  pe_compliance::agent
       pe_mcollective                 pe_mcollective
       pe_mcollective::metadata       pe_mcollective::plugins
       settings
    Facts:
       architecture => i386
       augeasversion => 0.7.2
       ...

### Puppetd

The puppetd plugin orchestrates Puppet itself across the
deployment. This plugin is capable of kicking off Puppet
configuration runs on each node in the deployment all at the same
time, on a subset of the deployment using filtering, or using a
maximum concurrency level. The maximum concurrency feature is
particularly noteworthy as it allows the execution of a
configuration run on all nodes in the population, but sets an upper
limit on the number of nodes that are performing their run at any
given time, thus mitigating the network load and resource demands
on the puppet master. This example performs a configuration run on
all nodes, but only one node at a time:

    peadmin@puppetmaster:~$ mco puppetd runall 1
    Tue Nov 15 11:17:11 -0800 2011> Running all machines with a concurrency of 1
    Tue Nov 15 11:17:11 -0800 2011> Discovering hosts to run
    Tue Nov 15 11:17:13 -0800 2011> Found 2 hosts
    Tue Nov 15 11:17:13 -0800 2011> Running agent.example.com, concurrency is 0
    Tue Nov 15 11:17:14 -0800 2011> agent.example.com schedule status: OK
    Tue Nov 15 11:17:15 -0800 2011> Currently 1 nodes running; waiting
    Tue Nov 15 11:17:21 -0800 2011> Running puppetmaster.example.com, concurrency is 0
    Tue Nov 15 11:17:22 -0800 2011> puppetmaster.example.com schedule status: OK
    Finished processing 1 / 1 hosts in 98.98 ms

Note, the "1 / 1 hosts" is an indication that one host was actually
performing the orchestration of the Puppet configuration run.  This
does not mean only one host in the deployment performed the
configuration run.  The message "Found 2 hosts" indicates that two
nodes carried out this action.

Once finished with the Puppet configuration run, the `status` action
can be used to see the last Puppet configuration run for each node
in the deployment.

    peadmin@puppetmaster:~$ mco puppetd status
    [ =============================================> ] 2 / 2
    agent.example.com  Enabled, not running, last run 10 seconds ago
    puppetmaster.example.com  Enabled, not running, last run 2 seconds ago

    Finished processing 2 / 2 hosts in 105.29 ms

### PuppetRAL

The puppetral plugin provides a command line tool to work with any
resource Puppet is capable of managing.  A common use case for the
puppetral plugin is to execute arbitrary commands on the deployment
using the exec resource. This example creates a new file on all
nodes in the deployment:

    peadmin@puppetmaster:~$ mco rpc puppetral \
    create type=exec title="/bin/bash -c 'echo Hello > /tmp/hello'"
    Determining the amount of hosts matching filter for 2 seconds .... 2

    [ =================================================> ] 2 / 2

    agent.example.com
    Status: Resource was created
    Resource:
      {"exported"=>false,
       "title"=>"/bin/bash -c 'echo Hello > /tmp/hello'",
       "parameters"=>{:returns=>:notrun},
       "tags"=>["exec"],
       "type"=>"Exec"}

     puppetmaster.example.com
     Status: Resource was created
     Resource:
       {"exported"=>false,
        "title"=>"/bin/bash -c 'echo Hello > /tmp/hello'",
        "parameters"=>{:returns=>:notrun},
        "tags"=>["exec"],
        "type"=>"Exec"}

     Finished processing 2 / 2 hosts in 249.21 ms

The creation of this file can be verified with the `find` action:

     peadmin@puppetmaster:~$ mco rpc puppetral find type=file title=/tmp/hello

     Determining the amount of hosts matching filter for 2 seconds .... 2

     [ ================================================> ] 2 / 2

     agent.example.com
       exported: false
       managed: false
       title: /tmp/hello
       parameters:
         {:ctime=>Tue Nov 15 11:32:10 -0800 2011,
          :type=>"file",
          :ensure=>:file,
          :group=>0,
          :owner=>0,
          :mtime=>Tue Nov 15 11:32:10 -0800 2011,
          :mode=>"644",
          :content=>"{md5}09f7e02f1290be211da707a266f153b3"}
      tags: ["file"]
      type: File

     puppetmaster.example.com
       managed: false
       exported: false
       title: /tmp/hello
       parameters:
         {:ctime=>Tue Nov 15 11:32:10 -0800 2011,
          :type=>"file",
          :group=>0,
          :ensure=>:file,
          :owner=>0,
          :mtime=>Tue Nov 15 11:32:10 -0800 2011,
          :mode=>"644",
          :content=>"{md5}09f7e02f1290be211da707a266f153b3"}
       tags: ["file"]
       type: File

     Finished processing 2 / 2 hosts in 166.12 ms

The puppetral plugin can manage any resource Puppet itself is
capable of managing. In particular, user, group, host, and
package resources are exposed directly in the console's live management page.

### Service

Puppet agent will automatically restart a service it manages when related
resources are changed, but sometimes services need to be restarted outside of a normal Puppet
configuration run. The `mco service` command can be used in these cases.
This example restarts the SSH daemon on all
nodes running RedHat:

    peadmin@puppetmaster:~$ mco service sshd restart -W osfamily=RedHat
    [ ==================================================> ] 2/ 2
    ---- service summary ----
    Nodes: 2 / 2
    Statuses: started=2
    Elapsed Time: 1.45 s

The status of the restarted services can be shown with:

    peadmin@puppetmaster:~$ mco service sshd status -W osfamily=RedHat
    [ ==================================================> ] 2 / 2
    puppetmaster.example.com               status=running
    agent.example.com                      status=running
    ---- service summary ----
    Nodes: 2 / 2
    Statuses: started=2
    Elapsed Time: 0.26 s

### Package

Similar to the service plugin, the `package` plugin manages software
packages outside of a normal Puppet configuration run. The
following is the trimmed output from running the
`checkupdates` action:

    peadmin@puppetmaster:~$ mco rpc package checkupdates -W fqdn=agent.example.com
    Determining the amount of hosts matching filter for 2 seconds .... 1
     * [ ============================================================> ] 1 / 1
    agent.example.com
       Outdated Packages: [{:package=>"glibc.i686", :version=>"2.5-65.el5_7.1", :repo=>"base_local"},
                           {:package=>"nscd.i386", :version=>"2.5-65.el5_7.1", :repo=>"base_local"},
                           {:package=>"ntp.i386",
                            :version=>"4.2.2p1-15.el5.centos.1",
                            :repo=>"base_local"},
                           {:package=>"openssh.i386", :version=>"4.3p2-72.el5_7.5", :repo=>"base_local"},
                           {:package=>"openssh-clients.i386",
                            :version=>"4.3p2-72.el5_7.5",
                            :repo=>"base_local"},
                           {:package=>"openssh-server.i386",
                            :version=>"4.3p2-72.el5_7.5",
                            :repo=>"base_local"}]
                  Output:
    glibc.i686                       2.5-65.el5_7.1                       base_local
    nscd.i386                        2.5-65.el5_7.1                       base_local
    ntp.i386                         4.2.2p1-15.el5.centos.1              base_local
    openssh.i386                     4.3p2-72.el5_7.5                     base_local
    openssh-clients.i386             4.3p2-72.el5_7.5                     base_local
    openssh-server.i386              4.3p2-72.el5_7.5                     base_local
               Exit Code: 100
         Package Manager: yum

    Finished processing 1 / 1 hosts in 409.14 ms

### Controller

The `mco controller` command manages the underlying MCollective
infrastructure. This can be used to load plugins obtained outside
of Puppet Enterprise or custom written for the deployment. This
example reloads all plugins across the Puppet Enterprise
deployment:

     peadmin@puppetmaster:~$ mco controller reload_agents
     Determining the amount of hosts matching filter for 2 seconds .... 2
     agent.example.com> reloaded all agents
     puppetmaster.example.com> reloaded all agents
     Finished processing 2 / 2 hosts in 137.86 ms
