---
layout: default
title: Writing SimpleRPC Clients
disqus: true
canonical: "/mcollective/simplerpc/clients.html"
---
[SimpleRPCIntroduction]: index.html
[WritingAgents]: agents.html
[RPCUtil]: /mcollective1.2/reference/plugins/rpcutil.html
[WritingAgentsScreenCast]: http://mcollective.blip.tv/file/3808928/
[RubyMixin]: http://juixe.com/techknow/index.php/2006/06/15/mixins-in-ruby/
[OptionParser]: http://github.com/puppetlabs/marionette-collective/blob/master/lib/mcollective1.2/optionparser.rb
[AppPlugin]: ../reference/plugins/application.html

# {{page.title}}

 * a list for the toc
 {:toc}

As pointed out in the [SimpleRPCIntroduction] page you can use the _mco rpc_ CLI
to call agents and it will do it's best to print results in a sane way.  When
this is not enough you can write your own clients.

Simple RPC clients can do most of what a normal [client][WritingAgents] can do
but it makes a lot of things much easier if you stick to the Simple RPC
conventions.

This guide shows how to write standalone scripts to interact with your
collective.  Since version 1.1.1 there is a single executable system.  You can
apply most of the techniques documented here to writing plugins for that
application system.  See the full reference for the plugin system
[here][AppPlugin].  You should try to write your general agent CLIs using
this plugin system rather than the stand alone scripts detailed below as that
promote a unified interface that behave in a consistant manner.

We've recorded a [tutorial that will give you a quick look at what is involved
in writing agents and a very simple client][WritingAgentsScreenCast].

We'll walk through building a ever more complex example of Hello World here.

## The Basic Client
The client is mostly a bunch of helper methods that you use as a [Ruby
Mixin][RubyMixin] in your own code, it provides:

 * Standard command line option parsing with help output
 * Ability to add your own command line options
 * Simple access to agents and actions
 * Tools to help you print results
 * Tools to print stats
 * Tools to construct your own filters
 * While retaining full power of _MCollective::Client_ if you need the additional feature sets
 * And being as simple or as complex to match your level of code proficiency

We'll write a client for the _Helloworld_ agent that you saw in the
[SimpleRPCIntroduction].

## Call an Agent and print the result
A basic hello world client can be seen below:

{% highlight ruby linenos %}
#!/usr/bin/ruby

require 'mcollective'

include MCollective::RPC

mc = rpcclient("helloworld")

printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")

printrpcstats

mc.disconnect
{% endhighlight %}

Save this into _hello.rb_ and run it with _--help_, you should see the standard basic help including filters for discovery.

If you've set up the Agent and run the client you should see something along these lines:

{% highlight ruby %}
$ hello.rb

Finished processing 44 hosts in 375.57 ms
{% endhighlight %}

While it ran you would have seen a little progress bar and then just the summary line.  The idea is that if you're talking to a 1000 machine there's no point in seeing a thousand _OK_, you only want to see what failed and this is exactly what happens here, you're only seeing errors.

If you run it with _--verbose_ you'll see a line of text for every host and also a larger summary of results.

I'll explain each major line in the code below then add some more features from there:

{% highlight ruby %}
include MCollective::RPC

mc = rpcclient("helloworld")
{% endhighlight %}

The first line pulls in the various helper functions that we provide, this is the Mixin we mentioned earlier.

We then create a new client to the agent "helloworld" that you access through the _mc_ variable.

{% highlight ruby %}
printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")

printrpcstats
{% endhighlight %}

To call a specific action you simply have to do _mc.echo_ this calls the _echo_ action, we pass a _:msg_ parameter into it with the string we want echo'd back.  The parameters will differ from action to action.  It returns a simple array of the results that you can print any way you want, we'll show that later.

_printrpc_ and _printrpcstats_ are functions used to print the results and stats respectively.

{% highlight ruby %}
mc.disconnect
{% endhighlight %}

This cleanly disconnects the client from the middleware, some middleware tools like ActiveMQ will log confusing exceptions if you do not do this.  It's good form to always disconnect but isn't strictly required.

## Adjusting the output

### Verbosely displaying results
As you see there's no indication that discovery is happening and as pointed out we do not display results that are ok, you can force verbosity as below on individual requests:

{% highlight ruby %}
mc = rpcclient("helloworld")

mc.discover :verbose => true

printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC"), :verbose => true
{% endhighlight %}

Here we've added a _:verbose_ flag and we've specifically called the discover method.  Usually you don't need to call discover it will do it on demand.  Doing it this way you'll always see the line:

{% highlight console %}
Determining the amount of hosts matching filter for 2 seconds .... 44
{% endhighlight %}

Passing verbose to _printrpc_ forces it to print all the results, failures or not.

If you just wanted to force verbose on for all client interactions, do:

{% highlight ruby %}
mc = rpcclient("helloworld")
mc.verbose = true

printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")
{% endhighlight %}

In this case everything will be verbose, regardless of command line options.

### Disabling the progress indicator
You can disable the twirling progress indicator easily:

{% highlight ruby %}
mc = rpcclient("helloworld")
mc.progress = false
{% endhighlight %}

Now whenever you call an action you will not see the progress indicator.

### Saving the reports in variables without printing
As of version *0.4.5* you can retrieve the stats from the clients and also get text of reports without printing them:

{% highlight ruby %}
stats = mc.echo(:msg => "Welcome to MCollective Simple RPC").stats

report = stats.report
{% endhighlight %}

_report_ will now have the text that would have been displayed by 'printrpcstats' you can also use _no_response_report_ to get report text for just the list of hosts that didnt respond.

If you didn't want to just print the results out to STDOUT you can also get them back as just text:

{% highlight ruby %}
report = rpcresults mc.echo(:msg => "Welcome to MCollective Simple RPC")
{% endhighlight %}


## Applying filters programatically
You can pass filters on the command line using the normal _--with-`*`_ options but you can also do it programatically.  Here's a new version of the client that only calls machines with the configuration management class _/dev_server/_ and the fact _country=uk_

{% highlight ruby %}
mc = rpcclient("helloworld")

mc.class_filter /dev_server/
mc.fact_filter "country", "uk"

printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")
{% endhighlight %}

You can set other filters like _agent`_`filter_ and _identity`_`filter_.

As of version 1.1.0 the fact_filter method supports a few other forms in adition to above:

{% highlight ruby %}
mc.fact_filter "country=uk"
mc.fact_filter "physicalprocessorcount", "4", ">="
{% endhighlight %}

This will limit it to all machines in the UK with more than 3 processors.

## Resetting filters to empty
If while using the client you wish to reset the filters to an empty set of filters - containing only the agent name that you're busy addressing you can do it as follows:

{% highlight ruby %}
mc = rpcclient("helloworld")

mc.class_filter /dev_server/

mc.reset_filter
{% endhighlight %}

After this code snippet the filter will only have an agent filter of _helloworld_ set.

## Forcing Rediscovery
By default it will only do discovery once per script and then re-use the results, you can though force rediscovery if you had to adjust filters mid run for example.

{% highlight ruby %}
mc = rpcclient("helloworld")

mc.class_filter /dev_server/
printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")

mc.reset

mc.fact_filter "country", "uk"
printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")
{% endhighlight %}

Here we make one _echo_ call - which would do a discovery - we then reset the client, adjust filters and call it again.  The 2nd call would do a new discovery and have new client lists etc.

## Only sending requests to a subset of discovered nodes
By default all nodes that get discovered will get the request.  This isn't always desirable maybe you want to deploy only to a random subset of hosts or maybe you have a service exposed over MCollective that you want to treat as a HA service and so only speak with one host that provides the functionality.

You can limit the hosts to talk to either using a number or a percentage, the code below shows both:

{%highlight ruby %}
mc = rpcclient("helloworld")

mc.limit_targets = "10%"
printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")
{% endhighlight %}

This will pick 10% of the discovered hosts - or 1 if 10% is less than 1 - and only target those nodes with your request.  You can also set it to an integer.

This functionality is only available from version _1.0.0_ and newer.

## Gaining access to the full MCollective::Client
If you wanted to work with the Client directly as in [WritingAgents] after perhaps setting up some queries or gathering data first you can gain access to the client, you might also need access to the options array that was parsed out from the command line and any subsequent filters that you added.

{% highlight ruby %}
mc = rpcclient("helloworld")

client = mc.client
options = mc.options
{% endhighlight %}

The first call will set up the CLI option parsing, create clients etc, you can then just grab the client and options and go on as per [WritingAgents].  This is a much quicker way to write full power clients, by just by short-circuiting the options parsing etc.

## Dealing with the results directly
The biggest reason that you'd write custom clients is probably if you wanted to do custom processing of the results, there are 2 options to do it.

<a name="Results_and_Exceptions"> </a>

### Results and Exceptions
Results have a set structure and depending on how you access the results you will either get Exceptions or result codes.

|Status Code|Description|Exception Class|
|-----------|-----------|---------------|
|0|OK| |
|1|OK, failed.  All the data parsed ok, we have a action matching the request but the requested action could not be completed.|RPCAborted|
|2|Unknown action|UnknownRPCAction|
|3|Missing data|MissingRPCData|
|4|Invalid data|InvalidRPCData|
|5|Other error|UnknownRPCError|

Just note these now, I'll reference them later down.

### Simple RPC style results
Simple RPC provides a trimmed down version of results from the basic Client library.  You'd choose to use this if you just want to do simple things or maybe you're just learning Ruby.  You'll get to process the results _after_ the call is either done or timed out completely.

This is an important difference between the two approaches, in one you can parse the results as it comes in, in the other you will only get results after processing is done.  This would be the main driving facter for choosing one over the other.

Here's an example that will print out results in a custom way.

{% highlight ruby %}
mc.echo(:msg => "hello world").each do |resp|
   printf("%-40s: %s\n", resp[:sender], resp[:data])
end
{% endhighlight %}

This will produce a result something like this:

{% highlight console %}
dev1.you.net                          : hello world
dev2.you.net                          : hello world
dev3.you.net                          : hello world
{% endhighlight %}

The _each_ in the above code just loops through the array of results.  Results are an array of Hashes, the data you got for above has the following structure:

{% highlight console %}
[{:statusmsg=>"OK",
 :sender=>"dev1.your.net",
 :data=>"hello world",
 :statuscode=>0},
{:statusmsg=>"OK",
 :sender=>"dev2.your.net",
 :data=>"hello world",
 :statuscode=>0}]
{% endhighlight %}

The _:statuscode_ matches the table above so you can make decisions based on each result's status.

### Gaining access to MCollective::Client#req results
You can get access to each result in real time, in this case you will need to handle the exceptions in the table above and you'll get a different style of result set.  The result set will be exactly as from the full blown client.

In this mode there will be no progress indicator, you'll deal with results as and when they come in not after the fact as in the previous example.

{% highlight ruby %}
mc.echo(:msg => "hello world") do |resp|
   begin
      printf("%-40s: %s\n", resp[:senderid], resp[:body][:data])
   rescue RPCError => e
      puts "The RPC agent returned an error: #{e}"
   end
end
{% endhighlight %}

The output will be the same as above

In this mode the results you get will be like this:

{% highlight ruby %}
{:msgtarget=>"/topic/mcollective.helloworld.reply",
 :senderid=>"dev2.your.net",
 :msgtime=>1261696663,
 :hash=>"2d37daf690c4bcef5b5380b1e0c55f0c",
 :body=>{:statusmsg=>"OK", :statuscode=>0, :data=>"hello world"},
 :requestid=>"2884afb0b52cb38ea4d4a3146d18ef5f",
 :senderagent=>"helloworld"}
{% endhighlight %}

Note how here we need to catch the exceptions, just handing _:statuscode_ will not be enough as the RPC client will raise exceptions - all descendant from _RPCError_ so you can easily catch just those.

As of version 1.1.1 you can additionally gain access to a SimpleRPC style result in addition to the more complex native client results:

{% highlight ruby %}
mc.echo(:msg => "hello world") do |resp, simpleresp|
   begin
      printf("%-40s: %s\n", simpleresp[:sender], simpleresp[:data])
   rescue RPCError => e
      puts "The RPC agent returned an error: #{e}"
   end
end
{% endhighlight %}

You can still use printrpc to print these style of results and gain advantage of the DDL and so forth:

{% highlight ruby %}
mc.echo(:msg => "hello world") do |resp, simpleresp|
   begin
      printrpc simpleresp
   rescue RPCError => e
      puts "The RPC agent returned an error: #{e}"
   end
end
{% endhighlight %}

You will need to handle exceptions yourself but you have a simpler result set to deal with

## Adding custom command line options
You can look at the _mco rpc_ script for a big sample, here I am just adding a simple _--msg_ option to our script so you can customize the message that will be sent and received.

{% highlight ruby linenos %}
#!/usr/bin/ruby

require 'mcollective'

include MCollective::RPC

options = rpcoptions do |parser, options|
   parser.define_head "Generic Echo Client"
   parser.banner = "Usage: hello [options] [filters] --msg MSG"

   parser.on('-m', '--msg MSG', 'Message to pass') do |v|
      options[:msg] = v
   end
end

unless options.include?(:msg)
   puts("You need to specify a message with --msg")
   exit! 1
end

mc = rpcclient("helloworld", :options => options)

mc.echo(:msg => options[:msg]).each do |resp|
   printf("%-40s: %s\n", resp[:sender], resp[:data])
end
{% endhighlight %}

This version of the code should be run like this:

{% highlight console %}
% test.rb --msg foo
dev1.you.net                          : foo
dev2.you.net                          : foo
dev3.you.net                          : foo
{% endhighlight %}

Documentation for the Options Parser can be found [in it's code][OptionParser].

And finally if you add options as above rather than try to parse it yourself you will get help integration for free:

{% highlight console %}
% hello.rb --help
Usage: hello [options] [filters] --msg MSG
Generic Echo Client
    -m, --msg MSG                    Message to pass

Common Options
    -c, --config FILE                Load configuratuion from file rather than default
        --dt SECONDS                 Timeout for doing discovery
        --discovery-timeout
    -t, --timeout SECONDS            Timeout for calling remote agents
    -q, --quiet                      Do not be verbose
    -v, --verbose                    Be verbose
    -h, --help                       Display this screen

Host Filters
        --wf, --with-fact fact=val   Match hosts with a certain fact
        --wc, --with-class CLASS     Match hosts with a certain configuration management class
        --wa, --with-agent AGENT     Match hosts with a certain agent
        --wi, --with-identity IDENT  Match hosts with a certain configured identity
{% endhighlight %}

## Disabling command line parsing and supplying your options programatically

Sometimes, perhaps when embedding an MCollective client into another tool like Puppet, you do not want MCollective to do any command line parsing as there might be conflicting command line options etc.

This can be achieved by supplying an options hash to the SimpleRPC client:

{% highlight ruby %}
include MCollective::RPC

options =  MCollective::Util.default_options

client = rpcclient("test", {:options => options})
{% endhighlight %}

This will create a RPC client for the agent test without any options parsing at all.

To set options like discovery timeout and so forth you will need use either the client utilities or manipulate the hash upfront, the client utility methods is the best.   The code below sets the discovery timeout in a way that does not require you to know any internal structures or the content of the options hash.

{% highlight ruby %}
options =  MCollective::Util.default_options

client = rpcclient("test", {:options => options})
client.discovery_timeout = 4
{% endhighlight %}

Using this method of creating custom options hashes mean we can make internal changes to MCollective without affecting your code in the future.

## Sending SimpleRPC requests without discovery and blocking

Usually this section will not apply to you.  The client libraries support sending a request without waiting for a reply.  This could be useful if you want to clean yum caches but don't really care if it actually happens everywhere.

You will loose these abilities:

 * Knowing if your request was received by any agents
 * Any stats about processing times etc
 * Any information about the success or failure of your request

The above should make it clear already that this is a limited use case, it's essentially a broadcast request with no feedback loop.

The code below will send a request to the _runonce_ action for an agent _puppetd_, once the request is dispatched I will have no idea if it got handled etc, my code will just continue onwards.

{% highlight ruby %}
p = rpcclient("puppetd")

p.identity_filter "your.box.com"
reqid = p.runonce(:forcerun => true, :process_results => false)
{% endhighlight %}

This will honor any attached filters set either programatically or through the command line, it will send the request but will
just not handle any responses.  All it will do is return the request id.

## Doing your own discovery
For web applications you'd probably use cached copied of Registration data to do discovery rather than wait for MC to do discovery between each request.

To do this, you'll need to construct a filter and a list of expected hosts and then do a custom call:

{% highlight ruby %}
puppet = rpcclient("puppetd")

printrpc puppet.custom_request("runonce", {:forcerun => true}, "your.box.com", {"identity" => "your.box.com"})
{% endhighlight %}

This will do a call with exactly the same stats, block and other semantics as a normal call like:

{% highlight ruby %}
printrpc puppet.runonce(:forcerun => true)
{% endhighlight %}

But instead of doing any discovery it will use the host list and filter you supplied in the call.

## The _rpcutil_ Helper Agent

A helper agent called [_rpcutil_][RPCUtil] is included from version _0.4.9_ onward that helps you gather stats, inventory etc about the running daemon.
