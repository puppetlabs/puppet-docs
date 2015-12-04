#!/usr/bin/env ruby
# Requires agent.json file

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

project_dir = Pathname.new(File.expand_path(__FILE__)).parent
agent_json = project_dir + 'agent.json'
version_info = JSON.load(File.read(agent_json))

components = [
  'Puppet',
  'Facter',
  'Hiera',
  'MCollective',
  'Ruby',
  'OpenSSL'
]

our_versions = version_info.keys.select{|v| v =~ /^1\./}.sort.reverse

header = ['puppet-agent'].concat(components)

body = our_versions.map {|version| # Make a row for each version
  component_versions = components.map {|component| # read from the version info
    VersionTables.link_release_notes_if_applicable(component, version_info[version][component])
  }
  linked_agent_version = VersionTables.link_release_notes_if_applicable('Puppet Agent', version)
  [linked_agent_version].concat(component_versions)
}

html_table = VersionTables.table_from_header_and_array_of_body_rows(header, body)

puts html_table
