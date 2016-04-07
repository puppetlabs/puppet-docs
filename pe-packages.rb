#!/usr/bin/env ruby

require 'git'
require 'pathname'
require 'json'
require 'pp'
require 'yaml'

pe_packages_dir = Pathname.new(File.expand_path(__FILE__)).parent
@enterprise_dist_dir = (pe_packages_dir + 'enterprise-dist')
config_file = pe_packages_dir + 'config.yaml'

config = YAML.load(config_file.read)
includes = config['pe']['include'] || {}
excludes = config['pe']['exclude'] || []

if !Dir.exist?(@enterprise_dist_dir + '.git')
  Git.clone('git@github.com:puppetlabs/enterprise-dist.git', @enterprise_dist_dir)
end

@pe_repo = Git.open(@enterprise_dist_dir)
@pe_repo.fetch

@package_name_variations = {

'Puppet' => [
  'pe-puppet',
  'pup-puppet',
  'puppet-enterprise-nxos-1-i386',
  'puppet-enterprise-nxos-1-x86_64'
],

'Puppet Agent' => [
  'puppet-agent'
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

'MCollective' => [
  'pe-mcollective',
  'pup-mcollective'
],

'Razor Server' => [
  'pe-razor-server'
],

'Razor Libs' => [
  'pe-razor-libs'
],

'r10k' => [
  'pe-r10k'
],

'Ruby' => [
  'pe-ruby',
  'pup-ruby'
],

'Nginx' => [
  'pe-nginx'
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
]

}


autodetected_versions = @pe_repo.tags.map {|tag| tag.name}.select {|name|
  (name =~ /^\d{4}/ or name =~ /^3\.8/) and name !~ /-/
}

versions_and_commits = Hash[ autodetected_versions.map {|name| [name, name]} ]
excludes.each do |tag|
  versions_and_commits.delete(tag)
end
versions_and_commits.merge!(includes)

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
    # Skip never-shipped network device OSes.
    # https://tickets.puppetlabs.com/browse/DOC-2645
    if platform == "nxos-1-x86_64" || platform == "cumulus-1.5-powerpc" || platform == "nxos-1-i386"
      next
    end

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

historical_packages = versions_and_commits.reduce( {} ) do |result, (name, commit)|
  result[name] = packages_json_to_versions_sorted_by_platform( load_package_json(commit) )
  result
end
# results in something like
# { '3.2.0' => { 'Puppet' => { '3.7.1-1' => ['debian-6-amd6', '...'], '3.7.1-4' => ['...', '...'] } }

puts JSON.dump(historical_packages)

