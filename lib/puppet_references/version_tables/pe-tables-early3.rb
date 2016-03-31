#!/usr/bin/env ruby

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

project_dir = Pathname.new(File.expand_path(__FILE__)).parent
pe_json = project_dir + 'pe.json'

version_info = JSON.load(File.read(pe_json))

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
#   "Puppet Server",
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

our_versions = [
  '3.3.2',
  '3.3.1',
  '3.3.0',
  '3.2.3',
  '3.2.2',
  '3.2.1',
  '3.2.0'
]

# First, software on agents / all nodes.

agent_header = ['PE Version'].concat(agent_stuff)
agent_body = VersionTables::PE::make_table_body(our_versions, agent_stuff, version_info)

# Then, server-side software.

server_header = ['PE Version'].concat(server_stuff)
server_body = VersionTables::PE::make_table_body(our_versions, server_stuff, version_info)

# now make tables

print "### Agent components (on all nodes)\n\n"
print VersionTables::table_from_header_and_array_of_body_rows(agent_header, agent_body)
print "### Server components\n\n"
print VersionTables::table_from_header_and_array_of_body_rows(server_header, server_body)

# done
