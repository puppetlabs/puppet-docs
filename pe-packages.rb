#!/usr/bin/env ruby

require 'json'
require 'pp'

packagedata = JSON.load( File.read( './packages.json' ) )
# this is like { platformname: { packagename: { version: version, md5: md5 }, packagename: {...} }, platformname: {......} }

package_name_variations = {

'Puppet' => [
  'pe-puppet',
  'pup-puppet',
  'pe-puppetserver-common'
],

'Facter' => [
  'pe-facter',
  'pup-facter'
],

'Hiera' => [
  'pe-hiera',
  'pup-hiera'
],

'Mcollective' => [
  'pe-mcollective',
  'pe-mcollective-client',
  'pe-mcollective-common',
  'pup-mcollective'
],


'NXOS agent' => [
  'puppet-enterprise-nxos-1-i386',
  'puppet-enterprise-nxos-1-x86_64'
],


'PuppetDB' => [
  'pe-puppetdb',
  'pe-puppetdb-terminus'
],

'Puppet Server' => [
  'pe-puppetserver'
],

'Razor server' => [
  'pe-razor-server'
],

'Razor libs' => [
  'pe-razor-libs'
],


'Ruby' => [
  'pe-ruby',
  'pup-ruby'
],

'Apache' => [
  'pe-httpd',
  'pe-httpd-mpm-event',
  'pe-httpd-mpm-itk',
  'pe-httpd-mpm-prefork',
  'pe-httpd-mpm-worker',
  'pe-httpd-prefork-dev',
  'pe-httpd-threaded-dev'
],

'ActiveMQ' => [
  'pe-activemq'
],


'PostgreSQL' => [
  'pe-postgresql',
  'pe-postgresql-contrib',
  'pe-postgresql-devel',
  'pe-postgresql-server'
],


'Passenger' => [
  'pe-passenger'
],

'MySQL' => [
],


'OpenSSL' => [
  'pe-openssl',
  'pup-openssl'
],

'Java' => [
  'pe-java'
],

'LibAPR' => [
  'pe-libapr',
  'pe-libaprutil'
]

}


# puts packagedata.keys
platforms = packagedata.keys.sort
# puts packagedata.values.collect {|hsh| hsh.keys}
all_packages = packagedata.values.collect {|distro_hash| distro_hash.keys}.flatten.uniq.sort

# for each package, add all versions to the normalized name of that package. don't sweat distros right now.

pe371 = {}

packagedata.each do | platform, platform_hash |
  platform_hash.each do | package_name, package_data |
    we_care = package_name_variations.detect {|k,v| v.include?(package_name)}
    if we_care
      common_name = we_care[0]
      pe371[common_name] ||= []
      pe371[common_name] << package_data['version']
      pe371[common_name].uniq!
    end
  end
end

pp pe371

# top_row = ['Platform ↓ / Packages →'] + all_packages
# # array of equal-length arrays:
# table_rows = platforms.reduce( [top_row] ) {|all_rows, platform|
#   this_row = [platform] + all_packages.collect {|package|
#     packagedata[platform][package] ? packagedata[platform][package]['version'] : 'n/a'
#   }
#   all_rows << this_row
# }
#
# # pp table_rows
#
# table_body = table_rows.reduce('') {|html, row|
#   html << "<tr>\n  <td>"
#   html << row.join("</td>\n  <td>")
#   html << "</td>\n</tr>\n"
# }
#
# puts "<table>\n" << table_body << "</table>\n"