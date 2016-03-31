#!/usr/bin/env ruby

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

project_dir = Pathname.new(File.expand_path(__FILE__)).parent
pe_json = project_dir + 'pe.json'
agent_json = project_dir + 'agent.json'

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


# this_pe_version_info is version_info[<PE VERSION>].
# name_of_vanagon_package is, e.g., 'Puppet Agent'.
# vanagon_data is the full dump of version info for that vanagon project (slurped in from json).
def merge_vanagon_info!(this_pe_version_info, name_of_vanagon_package, vanagon_data)
  # Remember that we might have to handle multiple agent/client-tools versions per PE release. So...
  versions_and_operating_systems = this_pe_version_info[name_of_vanagon_package] # it's a hash. '1.2.2' => ['os-1', 'os-2']
  versions_and_operating_systems.each {|vanagon_version, os_list|
    vanagon_contents = vanagon_data[vanagon_version] # it's a hash. 'Component' => '4.2.2'
    vanagon_contents.each {|component, component_version|
      # set version_info[pe_version][component][component_verision] to os_list, but be conservative
      # in case there's something there already.
      this_pe_version_info[component] ||= {}
      this_pe_version_info[component][component_version] ||= []
      this_pe_version_info[component][component_version].concat(os_list)
    }
  }
end

# Merge info from puppet-agent and client tools packages into PE version info!
our_versions.each {|pe_version|
  merge_vanagon_info!( version_info[pe_version], 'Puppet Agent', agent_info )
}

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
