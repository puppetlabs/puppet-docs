#!/usr/bin/env ruby
# Requires json file as an argument

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

json_file = File.expand_path(ARGV[0])
version_info = JSON.load(File.read(json_file))

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
    version_info[version][component]
  }
  [version].concat(component_versions)
}

html_table = VersionTables.table_from_header_and_array_of_body_rows(header, body)

puts html_table
