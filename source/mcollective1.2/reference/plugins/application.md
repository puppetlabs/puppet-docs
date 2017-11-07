---
layout: default
title: Single Executable Application Plugin
disqus: true
canonical: "/mcollective/reference/plugins/application.html"
---
[Clients]: ../../simplerpc/clients.html

# {{page.title}}

 * a list for the toc
 {:toc}

## Overview
The Marionette Collective 1.1.1 and newer supports a single executable - called
mco - and have a plugin type called application that lets you create
applications for this single executable.

In the past we tended to write small standalone scripts to interact with
MCollective, this had a number of issues:

 * Large number of executables in _/usr/sbin_
 * Applications behave inconsistently wrt to error handling and reporting
 * Doscovering new applications difficult since they are all over the filesystem
 * Installation and packaging of plugins is complex

We've attempted to address these concerns by creating a single point of access
for all applications - the _mco_ script - with unified help, error reporting and
option parsing.

Below you can see the single executable system in use:

{% highlight console %}
$ mco
The Marionette Collective version 1.1.1

/usr/bin/mco: command (options)

Known commands: rpc filemgr inventory facts ping find help
{% endhighlight %}

{% highlight console %}
$ mco help
The Marionette Collection version 1.1.1

  facts           Reports on usage for a specific fact
  filemgr         Generic File Manager Client
  find            Find hosts matching criteria
  help            Application list and RPC agent help
  inventory       Shows an inventory for a given node
  ping            Ping all nodes
  rpc             Generic RPC agent client application
{% endhighlight %}

{% highlight console %}
$ mco rpc package status package=zsh
Determining the amount of hosts matching filter for 2 seconds .... 51

 * [ ============================================================> ] 51 / 51


 test.com:
    Properties:
       {:provider=>:yum,
	:release=>"3.el5",
	:arch=>"x86_64",
	:version=>"4.2.6",
	:epoch=>"0",
	:name=>"zsh",
	:ensure=>"4.2.6-3.el5"}
{% endhighlight %}

These applications are equivelant to the old mc-rpc and similar applications but without the problem of lots of files in _/usr/sbin_.

## Basic Application
Applications goes in _libdir/mcollective/application/echo.rb_, the one below is a simple application that speaks to a hypothetical _echo_ agent.

{% highlight ruby %}
class MCollective::Application::Echo<MCollective::Application
   description "Reports on usage for a specific fact"

   option :message,
          :description    => "Message to send",
          :arguments      => ["-m", "--message MESSAGE"],
          :type           => String,
          :required       => true

   def main
      mc = rpcclient("echo")

      printrpc mc.echo(:msg => configuration[:message], :options => options)

      printrpcstats

      mc.disconnect
   end
end
{% endhighlight %}

Here's the application we wrote in action:

{% highlight console %}
$ mco echo
The message option is mandatory

Please run with --help for detailed help
{% endhighlight %}

{% highlight console %}
$ mco echo -m test

 * [ ============================================================> ] 1 / 1


example.com
   Message: test
      Time: Mon Jan 31 21:27:03 +0000 2011


Finished processing 1 / 1 hosts in 68.53 ms
{% endhighlight %}

Most of the techniques documented in SimpleRPC [Clients] can be reused here, we've just simplified a lot of the common used patterns like CLI arguments and incorporated it all in a single framework.

## Reference

### Usage Messages

To add custom usage messages to your application we can add lines like this:

{% highlight ruby %}
class MCollective::Application::Echo<MCollective::Application
   description "Reports on usage for a specific fact"

   usage "mco echo [options] --message message"
end
{% endhighlight %}

You can add several of these messages by just adding multiple such lines

### Application Options

A standard options hash is available simply as options you can manipulate it and pass it into the RPC Client like normal. See the SimpleRPC [Clients] reference for more on this

### CLI Argument Parsing

There are several options available to assist in parsing CLI arguments. The most basic option is:

{% highlight ruby %}
class MCollective::Application::Echo<MCollective::Application
   option :message,
          :description    => "Message to send",
          :arguments      => ["-m", "--message MESSAGE"]
end
{% endhighlight %}

In this case if the user used either _-m message_ or _--message message_ on the CLI the desired message would be in _configuration`[`:message`]`_

#### Required Arguments
You can require that a certain parameter is always passed:

{% highlight ruby %}
option :message,
  :description    => "Message to send",
  :arguments      => ["-m", "--message MESSAGE"],
  :required       => true
{% endhighlight %}

#### Argument data types
CLI arguments can be forced to a specific type, we also have some additional special types that the default ruby option parser cant handle on its own.

You can force data to be of type String, Fixnum etc:

{% highlight ruby %}
option :count,
  :description    => "Count",
  :arguments      => ["--count MESSAGE"],
  :type           => Fixnum
{% endhighlight %}

You can force a argument to be boolean:

{% highlight ruby %}
option :detail,
  :description    => "Detailed view",
  :arguments      => ["--detail"],
  :type           => :bool
{% endhighlight %}

If you have an argument that can be called many times you can force that to build an array:

{% highlight ruby %}
option :args,
  :description    => "Arguments",
  :arguments      => ["--argument ARG"],
  :type           => :array
{% endhighlight %}

Here if you supplied multiple arguments _configuration`[`:args`]`_ will be an array with all the options supplied.

#### Argument validation
You can validate input passed on the CLI:

{% highlight ruby %}
option :count,
  :description    => "Count",
  :arguments      => ["--count MESSAGE"],
  :type           => Fixnum,
  :validate       => Proc.new {|val| val < 10 ? true : "The message count has to be below 10" }
{% endhighlight %}

Should the supplied value be 10 or more a error message will be displayed.

#### Post argument parsing hook
Right after all arguments are parsed you can have a hook in your program called, this hook could perhaps parse the remaining data on _ARGV_ after option parsing is complete.

{% highlight ruby %}
class MCollective::Application::Echo<MCollective::Application
   description "Reports on usage for a specific fact"

   def post_option_parser(configuration)
      unless ARGV.empty?
         configuration[:message] = ARGV.shift
      else
         STDERR.puts "Please specify a message on the command line"
         exit! 1
      end
   end

   def main
      # use configuration[:message] here to access the message
   end
end
{% endhighlight %}

#### Validating configuration
After the options are parsed and the post hook is called you can validate the contents of the configuration:

{% highlight ruby %}
class MCollective::Application::Echo<MCollective::Application
   description "Reports on usage for a specific fact"

   # parse the first argument as a message
   def post_option_parser(configuration)
      configuration[:message] = ARGV.shift unless ARGV.empty?
   end

   # stop the application if we didnt receive a message
   def validate_configuration(configuration)
      raise "Need to supply a message on the command line" unless configuration.include?(:message)
   end

   def main
      # use configuration[:message] here to access the message
   end
end
{% endhighlight %}


