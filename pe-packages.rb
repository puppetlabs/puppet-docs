#!/usr/bin/env ruby

require 'git'
require 'pathname'
require 'json'
require 'pp'

pe_packages_dir = Pathname.new(File.expand_path(__FILE__)).parent
@enterprise_dist_dir = (pe_packages_dir + 'enterprise-dist')

if !Dir.exist?(@enterprise_dist_dir + '.git')
  Git.clone('git@github.com:puppetlabs/enterprise-dist.git', @enterprise_dist_dir)
end

@pe_repo = Git.open(@enterprise_dist_dir)

@package_name_variations = {

'Puppet' => [
  'pe-puppet',
  'pup-puppet'
],

'Puppet Server' => [
  'pe-puppetserver'
],

'Facter' => [
  'pe-facter',
  'pup-facter'
],

'Hiera' => [
  'pe-hiera',
  'pup-hiera'
],

'PuppetDB' => [
  'pe-puppetdb'
],

'Mcollective' => [
  'pe-mcollective',
  'pup-mcollective'
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
  'pe-httpd'
],

'ActiveMQ' => [
  'pe-activemq'
],

'PostgreSQL' => [
  'pe-postgresql'
],

'Passenger' => [
  'pe-passenger'
],

'OpenSSL' => [
  'pe-openssl',
  'pup-openssl'
],

'Java' => [
  'pe-java'
],

'LibAPR' => [
  'pe-libapr'
],

'NXOS agent' => [
  'puppet-enterprise-nxos-1-i386',
  'puppet-enterprise-nxos-1-x86_64'
]

}

versions_of_interest_old = [
'3.2.0',
'3.2.1',
'3.2.2',
'3.2.3',
'3.3.0',
'3.3.1',
'3.3.2'
]

versions_of_interest_new = [
'3.7.0',
'3.7.1',
'3.7.2',
'3.8.0',
'3.8.1'
]

versions_of_interest = versions_of_interest_new

@pe_repo.fetch

# this is like { platformname: { packagename: { version: version, md5: md5 }, packagename: {...} }, platformname: {......} }
def load_package_json(version)
  @pe_repo.checkout(version)
  JSON.load( File.read( @enterprise_dist_dir + 'packages.json' ) )
end

def normalize_version_number(number, name = '')
  # There's a special case in here for a slightly mangled Ruby version on Solaris.
  normalized_number = number.sub(/^1.9.3-p484/, '1.9.3.484').split(/\.?(-|pe|pup|sles|el)/)[0]
  if (name != "Ruby" and name != "OpenSSL")
    # Reduce everything else to three digits.
    normalized_number = normalized_number.split('.')[0..2].join('.')
  end
  normalized_number
end

def packages_json_to_versions_sorted_by_platform(packagedata)
  result = {}
  packagedata.each do | platform, platform_hash |
    platform_hash.each do | package_name, package_data |
      we_care = @package_name_variations.detect {|k,v| v.include?(package_name)}
      if we_care
        common_name = we_care[0]
        normalized_version = normalize_version_number(package_data['version'], common_name)
        result[common_name] ||= {}
        result[common_name][normalized_version] ||= []
        result[common_name][normalized_version] << platform
      end
    end
  end

  result
end

historical_packages = versions_of_interest.reduce( {} ) do |result, version|
  result[version] = packages_json_to_versions_sorted_by_platform( load_package_json(version) )
  result
end
# results in something like
# { '3.2.0' => { 'Puppet' => { '3.7.1-1' => ['debian-6-amd6', '...'], '3.7.1-4' => ['...', '...'] } }



def abbr_for_given_version(version, platforms)
  # an individual version w/ associated platforms
  '<abbr title="' << platforms.join(', ') << '">' <<
    version <<
  '</abbr>'
end

def all_abbrs_for_component(component, vers_to_platforms)
  # a cell of versions
  vers_to_platforms.sort {|x,y| y[0] <=> x[0]}.map {|pkg_ver, platforms|
    abbr_for_given_version(pkg_ver, platforms)
  }.join("<br>")
end

header_row = ["Pkg. / Ver."].concat( versions_of_interest )
other_rows = @package_name_variations.keys.map {|common_name|
  # Versions of this component per PE version (Cells in row after the first cell)
  component_versions_per_pe_version = versions_of_interest.map {|pe_version|
    # a cell of versions
    if historical_packages[pe_version][common_name]
      all_abbrs_for_component(common_name, historical_packages[pe_version][common_name])
    else
      ""
    end
  }
  # a row
  if component_versions_per_pe_version.uniq == ['']
    nil # for compact, below.
  else
    component_name_string = '<abbr title="' << @package_name_variations[common_name].join(', ') << '">' << common_name << '</abbr>'
    [component_name_string].concat(component_versions_per_pe_version)
  end
}.compact


# now make a table

html_table =  <<EOT
<table>
  <thead>
    <tr>
      <th>#{header_row.join('</th> <th>')}</th>
    </tr>
  </thead>

  <tbody>
    <tr>#{other_rows.map {|row| "<td>" << row.join("</td> <td>") << "</td>"}.join("</tr>\n    <tr>")}</tr>
  </tbody>
</table>

EOT

puts html_table
# done