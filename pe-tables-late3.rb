#!/usr/bin/env ruby

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

json_file = File.expand_path(ARGV[0])
version_info = JSON.load(File.read(json_file))

agent_stuff = [
#   "Puppet Agent",
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
  "Apache",
  "LibAPR",
  "Passenger"
#   "Nginx"
]

# our_versions = [
#   '3.8.1',
#   '3.8.0',
#   '3.7.2',
#   '3.7.1',
#   '3.7.0'
# ]

our_versions = version_info.keys.select {|v|
  v =~ /^3\.[78]/
}.sort.reverse

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
