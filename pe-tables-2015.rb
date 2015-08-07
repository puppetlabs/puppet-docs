#!/usr/bin/env ruby

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

pe_json = File.expand_path(ARGV[0])
agent_json = File.expand_path(ARGV[1])
version_info = JSON.load(File.read(pe_json))
agent_info = JSON.load(File.read(agent_json))

agent_stuff = [
  "Puppet Agent",
  "Puppet",
  "Facter",
  "Hiera",
  "MCollective",
  "Ruby",
  "OpenSSL"
]

server_stuff = [
  "Puppet Server",
  "PuppetDB",
  "r10k",
  "Razor Server",
  "Razor Libs",
  "PostgreSQL",
  "Java",
  "ActiveMQ",
#   "Apache",
#   "LibAPR",
#   "Passenger",
  "Nginx"
]

our_versions = version_info.keys.select {|v|
  v =~ /^2015/
}.sort.reverse

# Merge info from puppet-agent package into PE version info!

our_versions.each {|pe_version|
  # Remember that we have to handle multiple agent versions. So...
  agent_versions = version_info[pe_version]['Puppet Agent'] # it's a hash. '1.2.2' => ['os-1', 'os-2']
  agent_versions.each {|agent_version, os_list|
    agent_contents = agent_info[agent_version] # it's a hash. 'Component' => '4.2.2'
    agent_contents.each {|component, component_version|
      # set version_info[pe_version][component][component_verision] to os_list, but be conservative
      # in case there's something there already.
      version_info[pe_version][component] ||= {}
      version_info[pe_version][component][component_version] ||= []
      version_info[pe_version][component][component_version].concat(os_list)
    }
  }
}

# First, software on agents / all nodes.

agent_header = ['PE Version'].concat(agent_stuff)
agent_body = VersionTables::PE::make_table_body(our_versions, agent_stuff, version_info)

# Then, server-side software.

server_header = ['PE Version'].concat(server_stuff)
server_body = VersionTables::PE::make_table_body(our_versions, server_stuff, version_info)

# now make tables

print "### Agent Components (On All Nodes)\n\n"
print VersionTables::table_from_header_and_array_of_body_rows(agent_header, agent_body)
print "### Server Components\n\n"
print VersionTables::table_from_header_and_array_of_body_rows(server_header, server_body)

# done
