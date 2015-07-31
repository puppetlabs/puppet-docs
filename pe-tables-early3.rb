#!/usr/bin/env ruby

require 'json'
require 'pathname'
require 'pp'
require './version_tables.rb'

json_file = File.expand_path(ARGV[0])
version_info = JSON.load(File.read(json_file))

pl_software = [
  "Puppet",
#   "Puppet Agent",
#   "Puppet Server",
  "Facter",
  "Hiera",
  "PuppetDB",
  "Mcollective",
  "Razor Server",
  "Razor Libs"
]

third_party = [
  "Ruby",
  "Apache",
#   "Nginx",
  "ActiveMQ",
  "PostgreSQL",
  "Passenger",
  "OpenSSL",
  "Java",
  "LibAPR"
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

# First, Puppet Labs software.

pl_header = ['PE Version'].concat(pl_software)
pl_body = VersionTables::PE::make_table_body(our_versions, pl_software, version_info)

# Then, third-party software.

third_header = ['PE Version'].concat(third_party)
third_body = VersionTables::PE::make_table_body(our_versions, third_party, version_info)

# now make tables

print "### Puppet Labs Software\n\n"
print VersionTables::table_from_header_and_array_of_body_rows(pl_header, pl_body)
print "### Third-Party Software\n\n"
print VersionTables::table_from_header_and_array_of_body_rows(third_header, third_body)

# done
