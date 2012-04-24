---
layout: default
title: Puppet Internals
---

Puppet Internals - How It Works
================================

The goal of this document is to describe how a manifest you write
in Puppet gets converted to work being done on the system. This
process is relatively complex, but you seldom need to know many of
the details; this document only exists for those who are pushing
the boundaries of what Puppet can do or who don't understand why
they are seeing a particular error. It can also help those who are
hoping to extend Puppet beyond its current abilities.

* * * 

## High Level

When looked at coarsely, Puppet has three main phases of execution
-- compiling, instantiation, and configuration.

### Compiling

Here is where we convert from a text-based manifest into a
node-specific specification. Any code not meant for the host in
question is ignored, and any code that is meant for that host is
fully interpolated, meaning that variables are expanded and all of
the results are literal strings.

The only connection between the compiling phase and the library of
Puppet resource types is that all resulting resource specifications
are verified that the referenced type is valid and that all
specified attributes are valid for that type. There is no value
validation at this point.

In a networked setup, this phase happens entirely on the server.
The output of this phase is a collection of very simplistic
resources that closely resemble basic hashes.

### Instantiation

This phase converts the simple hashes and arrays into Puppet
library objects. Because this phase requires so much information
about the client in order to work correctly (e.g., what type of
packaging is used, what type of services, etc.), this phase happens
entirely on the client.

The conversion from the simpler format into literal Puppet objects
allows those objects to do greater validation on the inputs, and
this is where most of the input validation takes place. If you
specified a valid attribute but an invalid value, this is where you
will find it out, meaning that you will find it out when the config
is instantiated on the client, not (unfortunately) on the server.

The output of this phase is the machine's entire configuration in
memory and in a form capable of modifying the local system.

### Configuration

This is where Puppet actually modifies the system. Each of resource
instance compares its specified state to the state on the machine
and make any modifications that are necessary. If the machine
exactly matches the specified configuration, then no work is done.

The output of this phase is a correctly configured machine, in one
pass.

## Lower Level

These three high level phases can each be broken down into more
steps.

### Compile Phase 1: Parsing

Inputs:
Manifests written in the Puppet language

Outputs:
Parse trees (instances of AST objects)

Entry:
Puppet::Parser::Parser#parse

At this point, all Puppet manifests start out as text documents,
and it's the parser's job to understand those documents. The parser
(defined in parser/grammar.ra and parser/lexer.rb) does very little
work -- it converts from text to a format that maps directly back
to the text, building parse trees that are essentially equivalent
to the text itself. The only validation that takes place here is
syntactic.

This phase takes place immediately for all uses of Puppet. Whether
you are using nodes or no nodes, whether you are using the
standalone puppet interpreter or the client/server system, parsing
happens as soon as Puppet starts.

### Compile Phase 2: Interpreting

Inputs:
Parse trees (instances of AST objects) and client information
(collection of facts output by Facter)

Outputs:
Trees of TransObject and TransBucket instances (from
transportable.rb)

Entry:
Puppet::Parser::AST#evaluate

Exit:
Puppet::Parser::Scope#to\_trans

Most configurations will rely on client information to make
decisions. When the Puppet client starts, it loads the
[Facter](http://puppetlabs.com/puppet/related-projects/facter/) library,
collects all of the facts that it can, and passes those facts to
the interpreter. When you use Puppet over a network, these facts
are passed over the network to the server and the server uses them
to compile the client's configuration.

This step of passing information to the server enables the server
to make decisions about the client based on things like operating
system and hardware architecture, and it also enables the server to
insert information about the client into the configuration,
information like IP address and MAC address.

The interpreter combines the parse trees and the client information
into a tree of simple transportable objects which maps roughly to
the configuration as defined in the manifests -- it is still a
tree, but it is a tree of classes and the resources contained in
those classes.

#### Nodes vs. No Nodes

When you use Puppet, you have the option of using node resources or
not. If you do not use node resources, then the entire
configuration is interpreted every time a client connects, from the
top of the parse tree down. In this case, you must have some kind
of explicit selection mechanism for specifying which code goes with
which node.

If you do use nodes, though, the interpreter precompiles everything
except the node-specific code. When a node connects, the
interpreter looks for the code associated with that node name
(retrieved from the Facter facts) and compiles just that bit on
demand.

### Configuration Transport

Inputs:
Transportable objects

Outputs:
Transportable objects

Entry:
Puppet::Network::Server::Master#getconfig

Exit:
Puppet::Network::Client::Master#getconfig

If you are using the stand-alone puppet executable, there is no
configuration transport because the client and server are in the
same process. If you are using the networked puppetd client and
puppetmasterd server, though, the configuration must be sent to the
client once it is entirely compiled.

Puppet currently converts the Transportable objects to
[YAML](http://www.yaml.org/), which it then CGI-escapes and sends
over the wire using XMLRPC over HTTPS. The client receives the
configuration, unescapes it, caches it to disk in case the server
is not available on the next run, and then uses YAML to convert it
back to normal Ruby Transportable objects.

### Instantiation Phase

Inputs:
Transportable objects

Outputs:
Puppet::Type instances

Entry:
Puppet::Network::Client::Master#run

Exit:
Puppet::Transaction#initialize

To create Puppet library objects (all of which are instances of
Puppet::Type subclasses), to\_trans is called on the top-level
transportable object. All container objects get converted to
Puppet::Type::Component instances, and all normal objects get
converted into the appropriate Puppet resource type instance.

This is where all input validation takes place and often where
values get converted into more usable forms. For instance,
filesystems always return user IDs, not user names, so Puppet
objects convert them appropriately. (Incidentally, sometimes Puppet
is creating the user that it's chowning a file to, so whenever
possible it ignores validation errors until the last minute).

Once all of the resources are built in a graph-like tree of
components and resources, this tree is converted to a
[GRATR](http://gratr.rubyforge.org/) graph. The graph is then
passed to a new transaction instance.

### Configuration Phase

Inputs:
GRATR graph

Outputs:
Transaction report

Entry:
Puppet::Transaction#evaluate

Exit:
Puppet::Transaction#generate\_report

This is the phase in which all of the work is done, tightly
controlled by a transaction.

#### Resource Generation

Some resources manage other resource instances, such as recursive
file operations. During this phase, any statically generatable
resources are generated. These generated resources are then added
to the resource graphs.

#### Relationships

The next stage of the configuration process builds a graph to model
resource dependencies. One of the goals of the Puppet language is
to make file order matter as little as possible; this means that a
Puppet resource needs to be able to require other resources listed
later in the manifest, which means that the required resource will
be instantiated after the requiring resource. This dependency graph
is then merged with the original resource graph to build a complete
graph of all resources and all of their relationships.

#### Evaluation

The transaction does a topological sort on the final relationship
graph and iterates over the resulting list, evaluating each
resource in turn. Each out-of-sync property on each resource
results in a Puppet::StateChange object, which the transaction uses
to tightly control what happens to the resource and when, and also
to guarantee that logs are provided.

#### Reporting

As the transaction progresses, it collects logs and metrics on what
it does. At the end of evaluation, it turns this information into a
report, which it sends to the server (if requested).

## Conclusion

That's the entire flow of how a Puppet manifest becomes a complete
configuration. There is more to the Puppet system, such as
FileBuckets, but those are more support staff rather than the main
attraction.
