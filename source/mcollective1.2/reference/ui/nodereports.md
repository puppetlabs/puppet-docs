---
layout: default
title: Node Reports
disqus: true
canonical: "/mcollective/reference/ui/nodereports.html"
---
[Subcollectives]: ../basic/subcollectives.html

# {{page.title}}

 * TOC Placeholder
 {:toc}

As we have all facts, classes and agents for nodes we can do some custom reporting on all of these.

The _mc inventory_ tool is a generic node and network reporting tool, it has basic scripting abilities.

**Note: This is an emerging feature, the scripting language is likely to change**

## Node View
To obtain a full inventory for a given node you can run _mco inventory_ like this:

{% highlight console %}
 % mco inventory your.node.com
 Inventory for your.node.com:


   Server Statistics:
                   Start Time: Mon Sep 13 18:24:46 +0100 2010
                  Config File: /etc/mcollective/server.cfg
                   Process ID: 5197
               Total Messages: 62
      Messages Passed Filters: 62
            Messages Filtered: 0
                 Replies Sent: 61
         Total Processor Time: 0.18 seconds
                  System Time: 0.01 seconds

    Agents:
       discovery       echo            nrpe
       package         process         puppetd
       rpctest         service

    Configuration Management Classes:
       aliases                        apache
       <snip>

    Facts:
       architecture => i386
       country => de
       culturemotd => 1
       customer => rip
       diskdrives => xvda
       <snip>
{% endhighlight %}

This gives you a good idea of all the details available for a node.

## Collective List

As of version _1.1.3_ we have a concept of [Subcollectives] and you can use
the inventory application to get a quick report on all known collectives:

{% highlight console %}
$ mc inventory --list-collectives

 * [ ===================================== ] 52 / 52

   Collective                     Nodes
   ==========                     =====
   za_collective                  2
   us_collective                  7
   uk_collective                  19
   de_collective                  24
   eu_collective                  45
   mcollective                    52

                     Total nodes: 52

{% endhighlight %}

## Collective Map

You can also create a DOT format graph of your collective:

{% highlight console %}
$ mc inventory --collective-graph collective.dot

Retrieving collective info....
Graph of 52 nodes has been written to collective.dot
{% endhighlight %}

The graph will be a simple dot graph that can be viewed with Graphviz, Gephi or
other compatible software.

## Custom Reports

**NOTE: This feature will only be in version 0.4.8**

You can create little scriptlets and pass them into *mco inventory* with the *--script* option.

You have the following data available to your reports:

| Variable | Description |
|----------|-------------|
|time|The time the report was started, normal Ruby Time object|
|identity|The sender id|
|facts|A hash of facts|
|agents|An array of agents|
|classes|An array of CF Classes|

### printf style reports

Lets say you now need a report of all your IBM hardware listing hostname, serial number and product name you can write a scriptlet like this:

{% highlight ruby linenos %}
inventory do
    format "%s:\t\t%s\t\t%s"

    fields { [ identity, facts["serialnumber"], facts["productname"] ] }
end
{% endhighlight %}

And if saved as _inventory.mc_ run it like this:

{% highlight console %}
 % mco inventory -W "productname=/IBM|BladeCenter/" --script inventory.mc
 xx12:           99xxx21         BladeCenter HS22 -[7870B3G]-
 xx9:            99xxx46         BladeCenter HS22 -[7870B3G]-
 xx10:           99xxx29         BladeCenter HS22 -[7870B3G]-
 yy1:            KDxxxFR         IBM System x3655 -[79855AY]-
 xx5:            99xxx85         IBM eServer BladeCenter HS21 -[8853GLG]-
 <snip>
{% endhighlight %}

We'll add more capabilities in the future, for now you can access *facts* as a hash, *agents* and *classes* as arrays as well as *identity* as a string.


### Perl format style reports
To use this you need to install the *formatr* gem, once that's installed you can create a report scriptlet like below:

{% highlight ruby linenos %}
formatted_inventory do
    page_length 20

    page_heading <<TOP

            Node Report @<<<<<<<<<<<<<<<<<<<<<<<<<
                        time

Hostname:         Customer:     Distribution:
-------------------------------------------------------------------------
TOP

    page_body <<BODY

@<<<<<<<<<<<<<<<< @<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
identity,    facts["customer"], facts["lsbdistdescription"]
                                @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                facts["processor0"]
BODY
end
{% endhighlight %}

Here we create a paged report - 20 nodes per page - with a heading section and a 2 line report per node with identity, customer, distribution and processor.

The output looks like this:

{% highlight console %}
 % mco inventory -W "/dev_server/" --script inventory.mc

             Node Report Sun Aug 01 10:30:57 +0100

 Hostname:         Customer:     Distribution:
 -------------------------------------------------------------------------

 dev1.one.net      rip           CentOS release 5.5 (Final)
                                 AMD Athlon(tm) 64 X2 Dual Core Processor

 dev1.two.net      xxxxxxx       CentOS release 5.5 (Final)
                                 AMD Athlon(tm) 64 X2 Dual Core Processor
{% endhighlight %}

Writing these reports are pretty ugly I freely admit, however it avoids designing our own reporting engine and it's pretty good for kicking out simple reports.  You can see the *perlform* man page for details of the reporting layouts, ours is pretty close to that thanks to Formatr
